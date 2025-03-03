#ifndef AT_TOOLS_AOE_H
#defsym AT_TOOLS_AOE_H

/*
    Advanced Tactics

    Incoming AOE system
*/

#include "2da_constants_h"
#include "spell_constants_h"
#include "monster_constants_h"

/* Advanced Tactics */
#include "at_tools_storage_h"
#include "at_tools_log_h"

const string AT_ARRAY_INCOMING_AOE = "at_incoming_aoe";
const string AT_ARRAY_AOE = "at_aoe";

struct aoe {
    object oCaster;
    object oTarget;
    int nAbility;
    int nDuration;
    int nTime;
    location lTarget;
    float fParam1;
    float fParam2;
};

int _AT_IsAOEValid(struct aoe AOE);

int _AT_IsHostileAOE(int nAbility);
float _AT_GetAOEParam1(int nAbility);
float _AT_GetAOEParam2(int nAbility);
int _AT_GetAOEDuration(int nAbility);

int _AT_NoAllyInAOE(object oTarget, int nAbility);
struct aoe _AT_GetAOEOnCreature(object oCreature);
location _AT_GetAvoidAOELocation(object oCreature, struct aoe AOE);

void _AT_StoreAOE(string sTag, struct aoe AOE);
void _AT_SwapAOE(object oCaster);
void _AT_RemoveAOE(string sTag, object oCaster);

struct aoe _AT_GetAOEFromEffect(effect eEffect);
struct aoe _AT_GetAOEFromEvent(event ev);
void _AT_PrintAOE(string sTag);



int _AT_IsAOEValid(struct aoe AOE)
{
    return IsObjectValid(AOE.oCaster);
}

int _AT_IsHostileAOE(int nAbility)
{
    /* AF_ABILITY_INFERNO // 10002
       AF_ABILITY_EARTHQUAKE // 11116
       AF_ABILITY_BLIZZARD // 13000
       AF_ABILITY_TEMPEST // 14002
       AF_ABILITY_STORM_OF_THE_CENTURY // 14004
       AF_ABILITY_DEATH_CLOUD // 15003
    */
    if (GetM2DAInt(TABLE_AI_ABILITY_COND, "HostileAOE", nAbility) == 1)
        return TRUE;

    switch(nAbility)
    {
        case AF_ABILITY_FLAME_BLAST: // 10001
        case AF_ABILITY_FIREBALL: // 10003
        case AF_ABILITY_BLOOD_WOUND: // 10702
        case AF_ABILITY_GREASE: // 11113
        case AF_ABILITY_CONE_OF_COLD: // 13002
        case AF_ABILITY_SHOCK: // 14000
        case AF_ABILITY_ARCHDEMON_VORTEX: // 90000
        {
            return TRUE;
        }
    }

    return FALSE;
}

float _AT_GetAOEParam1(int nAbility)
{
    float nAOEParam = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", nAbility);

    if  (nAOEParam > 0.0f)
        return nAOEParam;

    int nAOE = 0;

    switch(nAbility)
    {
        /*10002*/case AF_ABILITY_INFERNO:              nAOE = INFERNO_AOE;              break;
        /*11113*/case AF_ABILITY_GREASE:               nAOE = GREASE_AOE;               break;
        /*11116*/case AF_ABILITY_EARTHQUAKE:           nAOE = EARTHQUAKE_AOE;           break;
        /*13000*/case AF_ABILITY_BLIZZARD:             nAOE = BLIZZARD_AOE;             break;
        /*14002*/case AF_ABILITY_TEMPEST:              nAOE = TEMPEST_AOE;              break;
        /*14004*/case AF_ABILITY_STORM_OF_THE_CENTURY: nAOE = STORM_OF_THE_CENTURY_AOE; break;
        /*15003*/case AF_ABILITY_DEATH_CLOUD:          nAOE = DEATH_CLOUD_AOE;          break;
        /*90000*/case AF_ABILITY_ARCHDEMON_VORTEX:     nAOE = ARHCDMEON_VORTEX_AOE;     break;
    }

    return GetM2DAFloat(TABLE_VFX_PERSISTENT, "RADIUS", nAOE);
}

float _AT_GetAOEParam2(int nAbility)
{
    return GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param2", nAbility);
}

int _AT_GetAOEDuration(int nAbility)
{
    /* Instant AOE : 1 second */
    float fDuration = 1.0f;

    switch(nAbility)
    {
        /*10002*/case AF_ABILITY_INFERNO:              fDuration = INFERNO_DURATION;              break;
        /*11113*/case AF_ABILITY_GREASE:               fDuration = GREASE_DURATION;               break;
        /*11116*/case AF_ABILITY_EARTHQUAKE:           fDuration = EARTHQUAKE_DURATION;           break;
        /*13000*/case AF_ABILITY_BLIZZARD:             fDuration = BLIZZARD_DURATION;             break;
        /*14002*/case AF_ABILITY_TEMPEST:              fDuration = TEMPEST_DURATION;              break;
        /*14004*/case AF_ABILITY_STORM_OF_THE_CENTURY: fDuration = STORM_OF_THE_CENTURY_DURATION; break;
        /*15003*/case AF_ABILITY_DEATH_CLOUD:          fDuration = DEATH_CLOUD_DURATION;          break;
        /*90000*/case AF_ABILITY_ARCHDEMON_VORTEX:     fDuration = ARCHDEMON_VORTEX_DURATION;     break;
    }

    return FloatToInt(fDuration);
}

int _AT_NoAllyInAOE(object oTarget, int nAbility)
{
    if (_AT_IsHostileAOE(nAbility) != TRUE)
        return TRUE;

    float fParam1 = _AT_GetAOEParam1(nAbility);
    float fParam2 = _AT_GetAOEParam2(nAbility);

    object[] oCreatures;

    if (fParam2 == 0.0f)
        oCreatures = GetObjectsInShape(OBJECT_TYPE_PARTY, SHAPE_SPHERE, GetLocation(oTarget), fParam1, 0.0f, 0.0f, TRUE);
    else
        oCreatures = GetObjectsInShape(OBJECT_TYPE_PARTY, SHAPE_CONE, GetLocation(oTarget), fParam1, fParam2, 0.0f, TRUE);

    if (GetArraySize(oCreatures) > 0)
        return FALSE;

    return TRUE;
}

struct aoe _AT_GetAOEOnCreature(object oCreature)
{
    effect[] eEffects = _AT_GetStorageEffects(AT_ARRAY_AOE);
    int nSize = GetArraySize(eEffects);

    struct aoe AOE;

    location lCreature = GetLocation(oCreature);
    location lTarget;

    object[] oCreatures;
    int nCreaturesSize;
    int j;

    int nTime = GetLowResTimer() / 1000;

    int i;
    for (i = 0; i < nSize; i++)
    {
        AOE = _AT_GetAOEFromEffect(eEffects[i]);

        if ((nTime - AOE.nTime) >= AOE.nDuration)
        {
            _AT_RemoveAOE(AT_ARRAY_AOE, AOE.oCaster);
            continue;
        }

        if (AOE.oTarget != oCreature)
        {
            if (IsObjectValid(AOE.oTarget) == TRUE)
                lTarget = GetLocation(AOE.oTarget);
            else
                lTarget = AOE.lTarget;

            if (AOE.fParam2 == 0.0f)
            {
                if (GetDistanceBetweenLocations(lCreature, lTarget) <= AOE.fParam1)
                    return AOE;
            }
            else
            {
                oCreatures = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_CONE, lTarget, AOE.fParam1, AOE.fParam2, 0.0f, TRUE);

                nCreaturesSize = GetArraySize(oCreatures);

                for (j = 0; j < nCreaturesSize; j++)
                {
                    if (oCreatures[j] == oCreature)
                        return AOE;
                }
            }
        }
    }

    eEffects = _AT_GetStorageEffects(AT_ARRAY_INCOMING_AOE);
    nSize = GetArraySize(eEffects);

    for (i = 0; i < nSize; i++)
    {
        AOE = _AT_GetAOEFromEffect(eEffects[i]);

        if (AOE.oTarget != oCreature)
        {
            if (IsObjectValid(AOE.oTarget) == TRUE)
                lTarget = GetLocation(AOE.oTarget);
            else
                lTarget = AOE.lTarget;

            if (AOE.fParam2 == 0.0f)
            {
                if (GetDistanceBetweenLocations(lCreature, lTarget) <= AOE.fParam1)
                    return AOE;
            }
            else
            {
                oCreatures = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_CONE, lTarget, AOE.fParam1, AOE.fParam2, 0.0f, TRUE);

                nCreaturesSize = GetArraySize(oCreatures);

                for (j = 0; j < nCreaturesSize; j++)
                {
                    if (oCreatures[j] == oCreature)
                        return AOE;
                }
            }
        }
    }

    struct aoe NullAOE;
    return NullAOE;
}

location _AT_GetAvoidAOELocation(object oCreature, struct aoe AOE)
{
    object oArea = GetArea(oCreature);
    vector vPos = GetPosition(oCreature);
    vector vTarget;

    if (IsObjectValid(AOE.oTarget) == TRUE)
        vTarget = GetPosition(AOE.oTarget);
    else
        vTarget = GetPositionFromLocation(AOE.lTarget);

    vector vUnit = vPos - vTarget;
    vUnit = vUnit / GetVectorMagnitude(vUnit);

    location[] lLoc;

    if (AOE.fParam2 == 0.0f)
    {
        lLoc[0] = Location(oArea, vTarget + (AOE.fParam1 + 1.0f) * vUnit, 0.0f);
        lLoc[1] = Location(oArea, vTarget + (AOE.fParam1 + 1.0f) * Vector(vUnit.y, -vUnit.x, vUnit.z), 0.0f);
        lLoc[2] = Location(oArea, vTarget + (AOE.fParam1 + 1.0f) * Vector(-vUnit.y, vUnit.x, vUnit.z), 0.0f);
        lLoc[3] = Location(oArea, vTarget + (AOE.fParam1 + 1.0f) * Vector(-vUnit.y, -vUnit.x, vUnit.z), 0.0f);
    }
    else
    {
        lLoc[0] = Location(oArea, vTarget + (AOE.fParam2 + 2.0f) * 0.5f * vUnit, 0.0f);
        lLoc[1] = Location(oArea, vTarget + (AOE.fParam2 + 2.0f) * 0.5f * Vector(vUnit.y, -vUnit.x, vUnit.z), 0.0f);
        lLoc[2] = Location(oArea, vTarget + (AOE.fParam2 + 2.0f) * 0.5f * Vector(-vUnit.y, vUnit.x, vUnit.z), 0.0f);
        lLoc[3] = Location(oArea, vTarget + (AOE.fParam2 + 2.0f) * 0.5f * Vector(-vUnit.y, -vUnit.x, vUnit.z), 0.0f);
    }

    int i;
    for (i = 0; i < 4; i++)
    {
        if (IsLocationValid(lLoc[i]) == TRUE)
            return lLoc[i];
    }

    location lNullLoc;
    return lNullLoc;
}

void _AT_StoreAOE(string sTag, struct aoe AOE)
{
    effect eEffect = Effect(1);

    eEffect = SetEffectObject(eEffect, 0, AOE.oCaster);
    eEffect = SetEffectObject(eEffect, 1, AOE.oTarget);
    eEffect = SetEffectInteger(eEffect, 0, AOE.nAbility);
    eEffect = SetEffectInteger(eEffect, 1, AOE.nDuration);
    eEffect = SetEffectInteger(eEffect, 2, AOE.nTime);

    vector vTarget = GetPositionFromLocation(AOE.lTarget);

    if (IsObjectValid(AOE.oTarget) == TRUE)
        vTarget = GetPosition(AOE.oTarget);
    else
        vTarget = GetPositionFromLocation(AOE.lTarget);

    eEffect = SetEffectFloat(eEffect, 0, vTarget.x);
    eEffect = SetEffectFloat(eEffect, 1, vTarget.y);
    eEffect = SetEffectFloat(eEffect, 2, vTarget.z);

    eEffect = SetEffectFloat(eEffect, 3, AOE.fParam1);
    eEffect = SetEffectFloat(eEffect, 4, AOE.fParam2);

    _AT_AddStorageEffect(sTag, eEffect);
}

void _AT_SwapAOE(object oCaster)
{
    effect[] arEffects = _AT_GetStorageEffects(AT_ARRAY_INCOMING_AOE);
    int nSize = GetArraySize(arEffects);

    effect eEffect;

    int i;
    for (i = 0; i < nSize; i++)
    {
        eEffect = arEffects[i];

        if (GetEffectObject(arEffects[i], 0) == oCaster)
        {
            _AT_RemoveStorageEffect(eEffect);

            eEffect = SetEffectInteger(eEffect, 2, GetLowResTimer() / 1000);

            _AT_AddStorageEffect(AT_ARRAY_AOE, eEffect);

            break;
        }
    }
}

void _AT_RemoveAOE(string sTag, object oCaster)
{
    effect[] arEffects = _AT_GetStorageEffects(sTag);
    int nSize = GetArraySize(arEffects);

    int i;
    for (i = 0; i < nSize; i++)
    {
        if (GetEffectObject(arEffects[i], 0) == oCaster)
            _AT_RemoveStorageEffect(arEffects[i]);
    }
}

struct aoe _AT_GetAOEFromEffect(effect eEffect)
{
    struct aoe AOE;

    AOE.oCaster = GetEffectObject(eEffect, 0);
    AOE.oTarget = GetEffectObject(eEffect, 1);
    AOE.nAbility = GetEffectInteger(eEffect, 0);
    AOE.nDuration = GetEffectInteger(eEffect, 1);
    AOE.nTime = GetEffectInteger(eEffect, 2);

    location lLoc;

    if (IsObjectValid(AOE.oTarget) == TRUE)
        lLoc = GetLocation(AOE.oTarget);
    else
    {
        vector vPos;
        vPos.x = GetEffectFloat(eEffect, 0);
        vPos.y = GetEffectFloat(eEffect, 1);
        vPos.z = GetEffectFloat(eEffect, 2);

        lLoc = Location(GetArea(AOE.oCaster), vPos, 0.0f);
    }

    AOE.lTarget = lLoc;

    AOE.fParam1 = GetEffectFloat(eEffect, 3);
    AOE.fParam2 = GetEffectFloat(eEffect, 4);

    return AOE;
}

struct aoe _AT_GetAOEFromEvent(event ev)
{
    struct aoe AOE;

    AOE.oCaster = OBJECT_SELF;
    AOE.oTarget = GetEventObject(ev, 1);
    AOE.nAbility = GetEventInteger(ev, 1);
    AOE.nDuration = _AT_GetAOEDuration(AOE.nAbility);
    AOE.nTime = 0;

    location lLoc;

    if (IsObjectValid(AOE.oTarget) == TRUE)
        lLoc = GetLocation(AOE.oTarget); // not used
    else
        lLoc = GetEventLocation(ev, 0);

    AOE.lTarget = lLoc;

    AOE.fParam1 = _AT_GetAOEParam1(AOE.nAbility);
    AOE.fParam2 = _AT_GetAOEParam2(AOE.nAbility);

    return AOE;
}

void _AT_PrintAOE(string sTag)
{
    effect[] eEffects = _AT_GetStorageEffects(sTag);
    int nSize = GetArraySize(eEffects);

    struct aoe AOE;

    AT_Print("--- " + sTag + " ---");

    int i;
    for (i = 0; i < nSize; i++)
    {
        AOE = _AT_GetAOEFromEffect(eEffects[i]);
        AT_Print("    oCaster: " + GetName(AOE.oCaster));
        AT_Print("    oTarget: " + GetName(AOE.oTarget));
        AT_Print("    nAbility: " + IntToString(AOE.nAbility));
        AT_Print("    nDuration: " + IntToString(AOE.nDuration));
        AT_Print("    nTime: " + IntToString(AOE.nTime));
        AT_Print("    lTarget: " + VectorToString(GetPositionFromLocation(AOE.lTarget)));
        AT_Print("    fParam1: " + FloatToString(AOE.fParam1));
        AT_Print("    fParam2: " + FloatToString(AOE.fParam2));
    }
}

#endif