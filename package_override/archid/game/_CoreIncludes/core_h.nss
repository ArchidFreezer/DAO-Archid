//------------------------------------------------------------------------------
//  core_h.nss
//------------------------------------------------------------------------------
//  Include file containing definitions for low level functions independent of
//  specific systems.
//
//  This file may never include any other files with the exception of log_h
//  or constant files functions in this file usually do not carry a prefix
//
//  Please talk to Georg before using any of these functions or making any
//  changes.
//------------------------------------------------------------------------------
//  2006/11/27 - Owner: Georg Zoeller
//------------------------------------------------------------------------------

#include "log_h"
#include "effect_constants_h"
#include "2da_data_h"
#include "core_difficulty_h" 
#include "af_ability_h"
#include "af_option_h"

const float AI_MELEE_RANGE = 3.5; // Any target within this range is considered a melee target
const int   DA_LEVEL_CAP   = 25;  // Dragon Age level cap. Note: This is one of several values that control this (including max_val on properties.xls!)

const int PROPERTY_SIMPLE_AI_BEHAVIOR = 18;
const int AI_BEHAVIOR_DEFAULT = 0;

// -----------------------------------------------------------------------------
// Basic combat system confiration
// -----------------------------------------------------------------------------
const float COMBAT_CRITICAL_DAMAGE_MODIFIER = 1.5f; // critical hits increase damage by up to this factor.
const float COMBAT_DEFAULT_UNARMED_DAMAGE = 3.0f;   // basic unarmed damage
const float COMBAT_ARMOR_RANDOM_ELEMENT = 0.3f;     // How much of armor value is randomized when reducing incoming damage (default: 30%)
const float UNARMED_ATTRIBUTE_BONUS_FACTOR = 1.25;


// Weapon Timings
const float BASE_TIMING_DUAL_WEAPONS  = 1.5;
const float BASE_TIMING_WEAPON_SHIELD = 2.0;
const float BASE_TIMING_TWO_HANDED    = 2.5;

const float REGENERATION_STAMINA_COMBAT_DEFAULT = 1.0f;       // was .5
const float REGENERATION_STAMINA_COMBAT_NULL = -1.0f;
const float REGENERATION_STAMINA_COMBAT_DEGENERATION = -2.0f;

const float REGENERATION_STAMINA_EXPLORE_DEFAULT = 17.5f;     // was 10
const float REGENERATION_STAMINA_EXPLORE_NULL = -17.5f;
const float REGENERATION_STAMINA_EXPLORE_DEGENERATION = -20.0f;

const float REGENERATION_HEALTH_COMBAT_DEFAULT = 0.0f;
const float REGENERATION_HEALTH_EXPLORE_DEFAULT = 10.0f;


// Hand definitions
const int HAND_MAIN     =   0;
const int HAND_OFFHAND = 1;
const int HAND_BOTH    = 3;


// -----------------------------------------------------------------------------




const resource INVALID_RESOURCE = R"";

// Generic compare Results for Compare* functions
const int COMPARE_RESULT_HIGHER =  1;
const int COMPARE_RESULT_EQUAL  = -1;
const int COMPARE_RESULT_LOWER  =  0;




// Placeable State Controller types
const string PLC_STATE_CNT_BRIDGE = "StateCnt_Bridge";
const string PLC_STATE_CNT_AREA_TRANSITION = "StateCnt_AreaTransition";
const string PLC_STATE_CNT_FURNITURE = "StateCnt_Furniture";
const string PLC_STATE_CNT_INFORMATIONAL = "StateCnt_Informational";
const string PLC_STATE_CNT_AOE = "StateCnt_AOE";
const string PLC_STATE_CNT_FLIPCOVER = "StateCnt_FlipCover";
const string PLC_STATE_CNT_TRAP_TRIGGER = "StateCnt_Trap_Trigger";
const string PLC_STATE_CNT_NON_SELECTABLE_TRAP = "StateCnt_NonSelectable_Trap";
const string PLC_STATE_CNT_SELECTABLE_TRAP = "StateCnt_Selectable_Trap";
const string PLC_STATE_CNT_PUZZLE = "StateCnt_Puzzle";
const string PLC_STATE_CNT_CAGE = "StateCnt_Cage";
const string PLC_STATE_CNT_BODYBAG = "StateCnt_Bodybag";
const string PLC_STATE_CNT_CONTAINER_STATIC = "StateCnt_Container_Static";
const string PLC_STATE_CNT_CONTAINER = "StateCnt_Container";
const string PLC_STATE_CNT_TRIGGER = "StateCnt_Trigger";
const string PLC_STATE_CNT_DOOR = "StateCnt_Door";


// used as artifical delimiter for GetNearest* functions in some spells.
const int MAX_GETNEAREST_OBJECTS = 30;

// Rules stuff
const int MIN_ATTRIBUTE_VALUE = 1;



const float RULES_ATTRIBUTE_MODIFIER = 10.0f;

const int CREATURE_RULES_FLAG_DYING             = 0x00000002;
const int CREATURE_RULES_FLAG_DOT               = 0x00000004;
const int CREATURE_RULES_FLAG_AI_OFF            = 0x00000008;
const int CREATURE_RULES_FLAG_AI_NO_ABILITIES   = 0x00000010;
const int CREATURE_RULES_FLAG_NO_COOLDOWN       = 0x00000020;
const int CREATURE_RULES_FLAG_NO_RESISTANCE     = 0x00000040;
const int CREATURE_RULES_FLAG_FORCE_COMBAT_0    = 0x00000080; // bit0 of combat result force
const int CREATURE_RULES_FLAG_FORCE_COMBAT_1    = 0x00000100; // bit1 of combat result force

const int APR_RULES_FLAG_CONSTRUCT              = 0x00000002;


const int AREA_FLAG_IS_FADE                     = 0x00000001;


const int WEAPON_WIELD_TWO_HANDED_MELEE = 3;

// Body bag stuff
const string BODY_BAG_TAG = "gen_ip_bodybag";


void _LogDamage(string msg, object oTarget = OBJECT_INVALID)
{
    Log_Trace(LOG_CHANNEL_COMBAT_DAMAGE,"combat_damage",msg, oTarget);
}



/**
* @brief (core_h)Sets a CREATURE_FLAG_* flag (boolean persistent variable) on a creature
*
* Flags are used by various game systems and should always be set through
* this function.
*
* @param oCreature The creature to set the flag on
* @param nFlag     CREATURE_FLAG_* to set.
* @param bSet      whether to set or to clear the flag.
*
* @returns  TRUE or FALSE
*
* @author Georg Zoeller
**/
void SetCreatureFlag(object oCreature, int nFlag, int bSet = TRUE);
void SetCreatureFlag(object oCreature, int nFlag, int bSet = TRUE)
{
    int nVal = GetLocalInt(oCreature, CREATURE_RULES_FLAG0);

    int nOld= nVal;

    if (bSet)
    {
        nVal |= nFlag;
    }
    else
    {
        nVal &= ~nFlag;
    }

    //Log_Trace(LOG_CHANNEL_SYSTEMS, "core_h.SetCreatureFlag", "Flag: " + IntToHexString(nFlag) + " Was: " + IntToHexString(nOld) + " Is: " + IntToHexString(nVal) ,oCreature);

    SetLocalInt(oCreature,CREATURE_RULES_FLAG0,nVal);
}
int IsShapeShifted(object oCreature)
{
    return GetHasEffects(oCreature, EFFECT_TYPE_SHAPECHANGE);
}


/**
* @brief (core_h)-----------------------------------------------------------------------------
* Force a specific combat result on a creature or pass -1 to clear
*
* @param nResult: The automatic combat result the creature will generate until
*                 this function is called with a different parameter
*
* Allowed results:
*      COMBAT_RESULT_MISS
*      COMBAT_RESULT_CRITICALHIT
*      COMBAT_RESULT_DEATHBLOW
*      -1
* @author: georg
* -----------------------------------------------------------------------------
**/
void SetForcedCombatResult(object oCreature, int nResult = -1);
void SetForcedCombatResult(object oCreature, int nResult = -1)
{
    if (nResult == COMBAT_RESULT_DEATHBLOW)
    {
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_0);
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_1);
    }
    else if (nResult == COMBAT_RESULT_MISS)
    {
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_0);
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_1, FALSE);
    }
    else if (nResult ==  COMBAT_RESULT_CRITICALHIT)
    {
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_0, FALSE);
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_1);
    }
    else if (nResult == -1)
    {
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_0, FALSE);
        SetCreatureFlag(oCreature, CREATURE_RULES_FLAG_FORCE_COMBAT_1, FALSE);
    }
}

// -----------------------------------------------------------------------------
// Return if a forced combat result was set on the creature
// -----------------------------------------------------------------------------
int GetForcedCombatResult(object oCreature);
int GetForcedCombatResult(object oCreature)
{
    // bitmask as follows:
    // 0 1 = miss
    // 1 0 = crit
    // 1 1 = deathblow

    int nVal  = GetLocalInt(oCreature, CREATURE_RULES_FLAG0) ;
    int nMask = (CREATURE_RULES_FLAG_FORCE_COMBAT_0 | CREATURE_RULES_FLAG_FORCE_COMBAT_1);
    int nResult = (nVal & nMask);


    if (nResult == nMask)
    {
        return COMBAT_RESULT_DEATHBLOW;
    }
    if (nResult == CREATURE_RULES_FLAG_FORCE_COMBAT_0)
    {
        return COMBAT_RESULT_MISS;
    }
    else if (nResult == CREATURE_RULES_FLAG_FORCE_COMBAT_1)
    {
        return COMBAT_RESULT_CRITICALHIT;
    }
    else
    {
        return -1;
    }
}



const int CRITICAL_MODIFIER_MELEE  = PROPERTY_ATTRIBUTE_MELEE_CRIT_MODIFIER;
const int CRITICAL_MODIFIER_MAGIC  = PROPERTY_ATTRIBUTE_MAGIC_CRIT_MODIFIER;
const int CRITICAL_MODIFIER_RANGED = PROPERTY_ATTRIBUTE_RANGED_CRIT_MODIFIER;


/** ----------------------------------------------------------------------------
* @brief (core_h) Return whether a command is of higher priority than the current
*                 command
*
* D E P R E C A T E D
*
* @param oObject      The object that holds the current command
* @param cNewCommand  The new command that is tested
*
* @returns  TRUE if cNewCommand has higher priority, FALSE if not
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
int IsNewCommandHigherPriority(object oObject, command cNewCommand);
int IsNewCommandHigherPriority(object oObject, command cNewCommand)
{
    int bNewIsHigher            = FALSE;
    command cCurrent            = GetCurrentCommand(oObject);
    int nNewCommandPriority     = GetCommandPriority(cNewCommand);
    int nCurrentCommandPriority = GetCommandPriority(cCurrent);
    int nNewCommandType         = GetCommandType(cNewCommand);
    int nCurrentCommandType     = GetCommandType(cCurrent);

/*    Log_Rules("Rules_IsNewCommandHigherPriority: current command: <" +
               IntToString(nCurrentCommandType) + "> new command: <" +
               IntToString(nNewCommandType) + ">", LOG_LEVEL_DEBUG, oObject);*/

    if(nNewCommandPriority == COMMAND_PRIORITY_INVALID)
    {
/*        Log_Rules("Rules_IsNewCommandHigherPriority: invalid priority for NEW command!",
                  LOG_LEVEL_ERROR, oObject);*/
    }
    else if(nCurrentCommandPriority == COMMAND_PRIORITY_INVALID)
    {
 /*       Log_Rules("Rules_IsNewCommandHigherPriority: invalid priority for CURRENT command! (creature doing nothing?)",
                   LOG_LEVEL_ERROR, oObject);*/

        return TRUE; // creature might just not doing anything at the moment - ok to interrupt
    }
    else // valid priorities for new and current commands
    {
        if(nNewCommandPriority > nCurrentCommandPriority)
        {
            // the new command is eligible to kick the current command out of the queue
            /* Log_Rules("Rules_IsNewCommandHigherPriority: new command is higher priority",
                       LOG_LEVEL_DEBUG, oObject);*/

            return TRUE;
        }
        else
        {
/*            Log_Rules("Rules_IsNewCommandHigherPriority: new command is NOT higher priority",
                       LOG_LEVEL_DEBUG, oObject);*/
        }

    }
    return FALSE;
}

/** ----------------------------------------------------------------------------
* @brief (core_h) Compares two values and returns a result constant
*
* @param nA An integer to compare (A)
* @param nB An integer to compare it to (B)
*
* @returns  - A >  B : COMPARE_RESULT_HIGHER
*           - A == B : COMPARE_RESULT_EQUAL
*           - A <  B : COMPARE_RESULT_LOWER
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
int CompareInt (int nA, int nB);
int CompareInt (int nA, int nB)
{
    if (nA > nB)
    {
        return COMPARE_RESULT_HIGHER;
    }
    else if (nA == nB)
    {
        return COMPARE_RESULT_EQUAL;
    }
    else
    {
        return COMPARE_RESULT_LOWER;
    }
}


/** ----------------------------------------------------------------------------
* @brief (core_h) Compares two float values and returns a result constant
*
* @param nA A float to compare (A)
* @param nB A float to compare it to (B)
*
* @returns  - A >  B : COMPARE_RESULT_HIGHER
*           - A == B : COMPARE_RESULT_EQUAL
*           - A <  B : COMPARE_RESULT_LOWER
*
* @author Georg Zoeller
*  --------------------------------------------------------------------------**/
int CompareFloat (float fA, float fB);
int CompareFloat (float fA, float fB)
{
    if (fA > fB)
    {
        return COMPARE_RESULT_HIGHER;
    }
    else if (fA == fB)
    {
        return COMPARE_RESULT_EQUAL;
    }
    else
    {
        return COMPARE_RESULT_LOWER;
    }
}

/**
* @brief Returns whether or not an ability is a modal ability
*
* @param oAttacker          The Attacking Creature
* @param oTarget            The attacked creature
*
* @author   Georg Zoeller

**/
int Ability_IsModalAbility(int nAbility);
int Ability_IsModalAbility(int nAbility)
{
    return GetM2DAInt(TABLE_ABILITIES_SPELLS,"usetype",nAbility) == 2;

}




/**
* @brief (core_h)Returns the state of a creature flag
*
* A creature flag (CREATURE_FLAG_*) is a persistent boolean variable
*
* @param oCreature The creature to check
*
* @returns  TRUE or FALSE state of the flag.
*
* @author Georg Zoeller
*/
int GetCreatureFlag(object oCreature, int nFlag);
int GetCreatureFlag(object oCreature, int nFlag)
{
    int nVal  = GetLocalInt(oCreature, CREATURE_RULES_FLAG0) ;

    //Log_Trace(LOG_CHANNEL_SYSTEMS, "core_h.GetCreatureFlag","Flag: " + IntToHexString(nFlag) + " Value: " + IntToHexString(nVal) + " Result: " + IntToString(( (nVal  & nFlag ) == nFlag)),oCreature);

    return ( (nVal  & nFlag ) == nFlag);
}

int GetAreaId(object oArea)
{
    return GetLocalInt(oArea, "AREA_ID");
}

/**
* @brief (core_h)Returns the state of an area flag.
*
* AREA_FLAGs are static and defined in area_data.xls
*
* @returns  TRUE or FALSE state of the flag.
*
* @author Georg Zoeller
*/
int GetAreaFlag    (object oArea, int nFlag)
{

    int nAreaId = GetAreaId(oArea);
    int nVal  = GetM2DAInt(225,"AreaFlags", nAreaId);

    return ( (nVal  & nFlag ) == nFlag);
}



/**
* @brief (core_h)Returns creature appearance flags (from apr_base)
*
* @param oCreature The creature to check
*
* @returns  TRUE or FALSE state of the flag.
*
* @author Georg Zoeller
*/
int GetCreatureAppearanceFlag(object oCreature, int nFlag);
int GetCreatureAppearanceFlag(object oCreature, int nFlag)
{
    int nVal  = GetM2DAInt(TABLE_APPEARANCE,"AprRulesFlags", GetAppearanceType(oCreature));
    return ( (nVal  & nFlag ) == nFlag);
}






/**
* @brief (core_h)Returns TRUE if a creature is currently dying or has been dealt a deathblow
*
* @param oCreature The creature to check
*
* @returns  TRUE or FALSE
*
* @author Georg Zoeller
**/
int IsDying(object oCreature = OBJECT_SELF);
int IsDying(object oCreature = OBJECT_SELF)
{

    // Death effect is present even before the creature is considered fully dead.
    int bRet = HasDeathEffect(oCreature,TRUE);
    //int bRet = GetCreatureFlag(oCreature, CREATURE_RULES_FLAG_DYING);

    #ifdef DEBUG
    if (bRet)
         Log_Trace(LOG_CHANNEL_SYSTEMS,"core_h.GetCreatureFlag","IsDying TRUE",oCreature);
    #endif

    return ( bRet  );


}






/** ----------------------------------------------------------------------------
* @brief (core_h) Check if the creature is 'disabled' (negative effect)
*
* @param oCreature The creature to set the flag on
*
* @returns  TRUE or FALSE
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
int IsDisabled(object oCreature = OBJECT_SELF, int bGroundCheck = FALSE);
int IsDisabled(object oCreature = OBJECT_SELF, int bGroundCheck = FALSE)
{

   /* effect [] effectsArray = GetEffects(oCreature, EFFECT_TYPE_KNOCKDOWN);
    effect eCurrentEffect;
    int nSize = GetArraySize(effectsArray);*/

    return (FALSE/*nSize>0*/);

}


int IsInjuryEffect(effect e)
{

    int nId = GetEffectAbilityID(e);
    return (nId>INJURY_ABILITY_EFFECT_ID && nId < INJURY_ABILITY_EFFECT_ID + INJURY_MAX_DEFINES);

}

/** ----------------------------------------------------------------------------
* @brief (core_h) Remove all effects from a creature
*
* @param oCreature The creature to clear all effects off
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
void Effects_RemoveAllEffects(object oCreature, int bIgnoreInjuries = TRUE, int bDeath = FALSE);
void Effects_RemoveAllEffects(object oCreature, int bIgnoreInjuries = TRUE, int bDeath = FALSE)
{


    effect [] effectsArray = GetEffects(oCreature);
    effect eCurrentEffect;
    int nId ;
    int nSize = GetArraySize(effectsArray);
    int i;
    for(i = 0; i < nSize; i++)
    {

        eCurrentEffect = effectsArray[i];

        if (!IsInjuryEffect(eCurrentEffect) || !bIgnoreInjuries)
        {
            if (!bDeath || GetM2DAInt(TABLE_EFFECTS,"IgnoreDeath", GetEffectType(eCurrentEffect)) == 0)
            {
                #ifdef DEBUG
                LogTrace(LOG_CHANNEL_TEMP, Log_GetEffectNameById(GetEffectType(eCurrentEffect)));
                #endif
                RemoveEffect(oCreature, eCurrentEffect);
            }
        }
    }
}

void Effects_RemoveEffectByType(object oCreature, int nEffectType)
{
    RemoveEffectsByParameters(oCreature, nEffectType);
}


void RemoveStackingEffects(object oTarget, object oCaster, int nAbility);
void RemoveStackingEffects(object oTarget, object oCaster, int nAbility)
{

    effect[] thisEffects = GetEffects(oTarget, EFFECT_TYPE_INVALID, nAbility);
    int nSize = GetArraySize(thisEffects);
    int i = 0;
    for (i = 0; i < nSize; i++)
    {
        effect e = thisEffects[i];
        if (IsEffectValid(e) == TRUE)
        {
            // -----------------------------------------------------------------
            // Georg: Ok, this is a bit obscure:
            //        If the executing context for an effect is an Area Of Effect Object
            //        we can assume (safely) that it should only be removed if the
            //        creator of the effect is identical to the caster.
            //
            //        The reason this check is needed is to allow multiple, overlapping
            //        effects by the same ability - from different casters (such as
            //        two enemies casting blizzard on the party.
            //
            //        The check ensures that when one of the spells times out
            //        the effect of the second spell stay on the target and thus
            //        avoids desynchronizing AoEs from their effects.
            // -----------------------------------------------------------------
            if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREAOFEFFECTOBJECT)
            {
                if (oCaster == GetEffectCreator(e) || !IsObjectValid(GetEffectCreator(e)) )
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("RemoveStackingEffects",e,"removing stacking effect", oTarget);
                    #endif
                    RemoveEffect(oTarget, e);

                }
                else
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("RemoveStackingEffects",e,"NOT removing stacking effect from AoE due to not matching creator " + ToString(oCaster) + " " + ToString(GetEffectCreator(e)), oTarget);
                    #endif
                }
            }
            else
            {
                #ifdef DEBUG
                Log_Trace_Effects("RemoveStackingEffects",e,"removing stacking effect", oTarget);
                #endif
                RemoveEffect(oTarget, e);
            }
        }
    }
}



void RemoveStackingEffectsFromParty(object oCaster, int nAbility);
void RemoveStackingEffectsFromParty(object oCaster, int nAbility)
{
    object[] arParty = GetPartyList();

    int nSize = GetArraySize(arParty);
    int i = 0;

    for (i = 0; i < nSize; i++)
    {
        RemoveStackingEffects(arParty[i], oCaster, nAbility);
    }
}

/**-----------------------------------------------------------------------------
*@brief Gets the VFX_* constant representing the kind of the visual effect.
*
* @param eVFX   The visual effect.
* @returns      The visual effect ID (VFX_*) of the visual effect
*               or VFX_INVALID if the visual effect is invalid.
*
* @author       dsitar
*-----------------------------------------------------------------------------*/
int GetVisualEffectID(effect eVFX);
int GetVisualEffectID(effect eVFX)
{
    if (GetEffectType(eVFX) == EFFECT_TYPE_VISUAL_EFFECT)
        return GetEffectInteger(eVFX, 0);
    return VFX_INVALID;
}


/**-----------------------------------------------------------------------------
* @brief Removes a specific visual effect from an object.
*
* @param oTarget The object to remove the visual effect from.
* @param nVfxID  The visual effect ID to remove (VFX_*).
*
* @author        dsitar
*-----------------------------------------------------------------------------*/
void RemoveVisualEffect(object oTarget, int nVfxID);
void RemoveVisualEffect(object oTarget, int nVfxID)
{
    effect[] aEffects = GetEffects(oTarget, EFFECT_TYPE_VISUAL_EFFECT);
    int nEffects = GetArraySize(aEffects);
    int i;
    for (i = 0; i < nEffects; i++)
    {
        if (GetVisualEffectID(aEffects[i]) == nVfxID)
        {
            RemoveEffect(oTarget, aEffects[i]);
        }
    }
}

/**-----------------------------------------------------------------------------
* @brief Removes multiple visual effects from an object.
*
* @param oTarget The object to remove the visual effect from.
* @param aVfxID  Array of visual effect IDs to remove (VFX_*).
*
* @author        dsitar
*-----------------------------------------------------------------------------*/
void RemoveVisualEffects(object oTarget, int[] aVfxID);
void RemoveVisualEffects(object oTarget, int[] aVfxID)
{
    effect[] aEffects = GetEffects(oTarget, EFFECT_TYPE_VISUAL_EFFECT);
    int nEffects = GetArraySize(aEffects);
    int nVfxIDs  = GetArraySize(aVfxID);
    int i, j;
    for (i = 0; i < nEffects; i++)
    {
        for (j = 0; j < nVfxIDs; j++)
        {
            if (GetVisualEffectID(aEffects[i]) == aVfxID[j])
            {
                RemoveEffect(oTarget, aEffects[i]);
            }
        }
    }
}


/** ----------------------------------------------------------------------------
* @brief (core_h) Wrapper for ApplyEffectOnObject.
*
* @param nDurationType can be EFFECT_DURATION_TYPE_PERMANENT EFFECT_DURATION_TYPE_INSTANTANEOUS or EFFECT_DURATION_TYPE_TEMPORARY.
* @param Effect the effect to be applied
* @param oTarget the target of the effect
* @param fDuration  this value needs to be set only when nDurationType is EFFECT_DURATION_TYPE_TEMPORARY
* @param oCreator effect creator
* @param nAbilityId The ability ID of the effect (Important for dispelling!!!)
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
void ApplyEffectOnObject (int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f, object oCreator = OBJECT_SELF, int nAbilityId = 0)
{



    // -------------------------------------------------------------------------
    // For stun specifically, we apply a marking effect for 15 secs
    // that degrades incoming stun effects to 1/4 of their potency
    // -------------------------------------------------------------------------
    if (GetEffectType(eEffect) == EFFECT_TYPE_STUN)
    {
         if (nDurationType == EFFECT_DURATION_TYPE_TEMPORARY)
         {
            if (GetHasEffects(oTarget, EFFECT_TYPE_RECENTLY_STUNNED,0))
            {
                fDuration *= 0.25;
            }
            else
            {
                    Engine_ApplyEffectOnObject (nDurationType,
                                        Effect(EFFECT_TYPE_RECENTLY_STUNNED),
                                        oTarget,
                                        15.0 ,
                                        oCreator ,
                                        0 /*invisible*/ );
            }
        }
    }


    Engine_ApplyEffectOnObject (nDurationType,
                            eEffect,
                            oTarget,
                            fDuration ,
                            oCreator ,
                            nAbilityId );



    #ifdef DEBUG
    Log_Trace_Effects("core_h.ApplyEffectOnObject", eEffect, ToString(fDuration), oTarget, nDurationType, nAbilityId);
    #endif
}


/** ----------------------------------------------------------------------------
* @brief (core_h) Wrapper for ApplyEffectOnObject on the Party.
*
* @param nDurationType can be EFFECT_DURATION_TYPE_PERMANENT EFFECT_DURATION_TYPE_INSTANTANEOUS or EFFECT_DURATION_TYPE_TEMPORARY.
* @param Effect the effect to be applied
* @param oTarget the target of the effect
* @param fDuration  this value needs to be set only when nDurationType is EFFECT_DURATION_TYPE_TEMPORARY
* @param oCreator effect creator
* @param nAbilityId The ability ID of the effect (Important for dispelling!!!)
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
void ApplyEffectOnParty (int nDurationType, effect eEffect, float fDuration = 0.0f, object oCreator = OBJECT_SELF, int nAbilityId = 0, int bIncludeSummons = TRUE, int bExcludeCreator = FALSE)
{

    // Georg: Move this function into the engine for performance reasons

    Engine_ApplyEffectOnParty(nDurationType,eEffect,fDuration,oCreator,nAbilityId,bExcludeCreator);
}




/*
* @brief (core_h) Clamp an Integer value to nMin / nMax
*
* @param nVal The value
* @param nMin The bottom
* @param nMax The ceiling
*
* @returns  integer capped by ceiling and bottom
*
* @author Georg Zoeller
*/
int ClampInt(int nVal, int nMin, int nMax);
int ClampInt(int nVal, int nMin, int nMax)
{
    return ((nVal) < (nMin) ? (nMin) : (nVal) > (nMax) ? (nMax) : (nVal)) ;
}


/*
   @brief Returns the greater value of f1 and f2

   @param f1, f2 - floats

   @returns the greater value of both
*/

int Max(int n1, int n2);
int Max(int n1, int n2)
{
    return ( (n1>n2) ? n1: n2);
}


/*
   @brief Returns the greater value of f1 and f2

   @param f1, f2 - floats

   @returns the greater value of both
*/

int Min(int n1, int n2);
int Min(int n1, int n2)
{
    return ( (n1<n2) ? n1: n2);
}


/*
   @brief Returns the greater value of f1 and f2

   @param f1, f2 - floats

   @returns the greater value of both
*/

float MaxF(float f1, float f2);
float MaxF(float f1, float f2)
{
    return ( (f1>f2) ? f1 : f2);
}

/*
   @brief Returns the lesser value of f1 and f2

   @param f1, f2 - floats

   @returns the lesser value of both
*/
float MinF(float f1, float f2);
float MinF(float f1, float f2)
{
    return ( (f1<f2) ? f1 : f2);
}



/**
* @brief (core_h) Hack for GetObjectsInRadius
*
* @author Georg Zoeller
*
**/
object[] GetHostileObjectsInRadius(object oTarget, object oHostilityRef , int nObjectType = OBJECT_TYPE_ALL, float fRange = 10.0f)
{


    object[] arTemp = GetNearestObject(oTarget, nObjectType,20 ) ;

    object[] arRet;

    int nCount = GetArraySize(arTemp);
    int i;

    int c = 0;

    for (i = 0; i< nCount && GetDistanceBetweenLocations ( GetLocation ( arTemp[i]), GetLocation(oTarget)) <= fRange  ; i++)
    {

        if (IsObjectHostile(arTemp[i],oHostilityRef))
        {
            arRet[c] = arTemp[i];
            c++;
        }

    }

    if (IsObjectHostile(oTarget, oHostilityRef) == TRUE)
    {
        arRet[c] = oTarget;
    }


    return arRet;

}


// return the index of the first occurence of an integer in an integer array
int GetIntArrayIndex (int[] arArray, int nItem)
{
    int nSize = GetArraySize(arArray);
    int bFound;

    int i;
    for (i = 0; i < nSize && !bFound; i++)
    {
        bFound = (arArray[i] == nItem);
    }

    return (bFound ? i : -1) ;
}

// return the index of the first occurence of an integer in an integer array
int GetObjectArrayIndex (object[] arArray, object oItem)
{
    int nSize = GetArraySize(arArray);
    int bFound;

    int i;
    for (i = 0; i < nSize && !bFound; i++)
    {
        bFound = (arArray[i] == oItem);
    }

    return (bFound ? i : -1) ;
}





/**
* @brief (core_h) Returns the ability type as a ABILITY_TYPE_* constant
*
* @param nAbility   ability id (row number in ABI_BASE)
*
* @returns ABILITY_TYPE_* constant
*
* @author   Georg Zoeller
**/
int Ability_GetAbilityType(int nAbility);
int Ability_GetAbilityType(int nAbility)
{
    return GetM2DAInt(TABLE_ABILITIES_SPELLS,"AbilityType",nAbility);
}


int IsSpell(int nAbility)
{
    return Ability_GetAbilityType(nAbility) == ABILITY_TYPE_SPELL;
}


int IsTalent (int nAbility)
{
    return Ability_GetAbilityType(nAbility) == ABILITY_TYPE_TALENT;
}


int IsSkill(int nAbility)
{
    return Ability_GetAbilityType(nAbility) == ABILITY_TYPE_SKILL;
}


effect[] GetEffectsByAbilityId(object oObject, int nAbilityId)
{
    effect[] arrRet = GetEffects(oObject, EFFECT_TYPE_INVALID, nAbilityId);
    return arrRet;
}

/**
* @brief return the ITEM_TYPE_* of an item
*
* Returns the type an item belongs to (e.g. ITEM_TYPE_WEAPON_RANGED) from
* BITEM_base.xls, column "Type"
*
* @ param oItem - an Item
*
* @author Georg
**/
int GetItemType(object oItem);
int GetItemType(object oItem)
{
    int nBaseItemType = GetBaseItemType(oItem);

    int nType = GetM2DAInt(TABLE_ITEMS,"Type", nBaseItemType);

    return nType;
}


/**
*  @brief returns true if creature x is using a ranged weapon
*  @param oCreature the creature to thest
*  @param oItem an optional item to test (otherwise the main hand will be tested)
*  @param bExlcudeWand use to exclude wand (e.g. check specifically for box/xbow)
*  @author Georg
**/
int IsUsingRangedWeapon(object oCreature, object oItem = OBJECT_INVALID, int bExludeWand= FALSE);
int IsUsingRangedWeapon(object oCreature, object oItem = OBJECT_INVALID, int bExludeWand= FALSE)
{
    // Shapeshifting currently only supports melee weapons.
    if (IsShapeShifted(oCreature))
    {
        return FALSE;
    }

    if (!IsObjectValid(oItem))
    {
        oItem = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oCreature);
    }

    if (IsObjectValid(oItem))
    {

        return (GetItemType (oItem) == ITEM_TYPE_WEAPON_RANGED ||
                (!bExludeWand && GetItemType (oItem) == ITEM_TYPE_WEAPON_WAND));
    }

    return FALSE;
}

/**
*  @brief returns true if creature x is using a ranged weapon
*  @param oCreature the creature to thest
*  @param oItem an optional item to test (otherwise the main hand will be tested)
*  @author Georg
**/
int IsUsingShield(object oCreature, object oItem = OBJECT_INVALID);
int IsUsingShield(object oCreature, object oItem = OBJECT_INVALID)
{

    if (!IsObjectValid(oItem))
    {
        oItem = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND, oCreature);
    }

    if (IsObjectValid(oItem))
    {
        return (GetItemType (oItem) == ITEM_TYPE_SHIELD);
    }

    return FALSE;
}


int Is2HandItem(object oItem)
{
    return (GetM2DAInt(TABLE_ITEMS,"EquippableSlots",GetBaseItemType(oItem)) == 1);
}



/**
*  @brief returns true if creature x is using a melee weapon (or fists)
*  @param oCreature the creature to thest
*  @param oItem an optional item to test (otherwise the main hand will be tested)
*  @author Georg
**/
int IsUsingMeleeWeapon(object oCreature, object oItem = OBJECT_INVALID);
int IsUsingMeleeWeapon(object oCreature, object oItem = OBJECT_INVALID)
{

    if (!IsObjectValid(oItem))
    {
        oItem = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oCreature);
    }
    //Log_Trace(LOG_CHANNEL_TEMP, "IsUsingMeleeWeapon", "creature: " +  ToString(oCreature) + ", Weapon= " + ToString(oItem) + ", type: " + ToString(GetItemType(oItem)));
    if (IsObjectValid(oItem) && !IsShapeShifted(oCreature))
    {
        return (GetItemType (oItem) == ITEM_TYPE_WEAPON_MELEE);
    }
    else    // fists
    {
        return TRUE;
    }

    return FALSE;
}


/**
*  @brief Gets an object's current health
*  @sa    SetCurrentHealth
*  @author Georg
**/
float GetCurrentHealth(object oObject)
{

    float fHealth;

    int nObjectType = GetObjectType(oObject);
    if (nObjectType  == OBJECT_TYPE_PLACEABLE)
    {
        fHealth = IntToFloat(GetHealth(oObject));
    }
    else if (nObjectType == OBJECT_TYPE_CREATURE )
    {
        fHealth = GetCreatureProperty(oObject,PROPERTY_DEPLETABLE_HEALTH, PROPERTY_VALUE_CURRENT);
    }
    else
    {
        fHealth = IntToFloat(GetHealth(oObject));
    }


    return fHealth;
}

/**
*  @brief Set's an object's current health
*  @sa    GetCurrentHealth
*  @author Georg
**/
void SetCurrentHealth(object oObject, float fNewValue)
{

    if (IsObjectValid(oObject))
    {
        int nObjectType = GetObjectType(oObject);
        if (nObjectType  == OBJECT_TYPE_PLACEABLE)
        {
            SetPlaceableHealth(oObject, FloatToInt(fNewValue));
        }
        else if (nObjectType == OBJECT_TYPE_CREATURE )
        {
            SetCreatureProperty(oObject,PROPERTY_DEPLETABLE_HEALTH, fNewValue, PROPERTY_VALUE_CURRENT);
        }
        else
        {
            #ifdef DEBUG
            Warning("SetCurrentHealth called on object [" + GetTag(oObject) + "] " + "[type: " +IntToString(nObjectType)+ "] that is not a creature or placeable. Please contact Georg. Script:" + GetCurrentScriptName());
            #endif
        }
    }

}

/**
*  @brief Returns a creatures maximum health
*  @author Georg
**/
float GetMaxHealth(object oObject)
{
    int nObjectType = GetObjectType(oObject);
    if (nObjectType  == OBJECT_TYPE_PLACEABLE)
    {
        return IntToFloat(Deprecated_GetMaxHealth(oObject));
    }
    else if (nObjectType == OBJECT_TYPE_CREATURE )
    {
        return GetCreatureProperty(oObject,PROPERTY_DEPLETABLE_HEALTH, PROPERTY_VALUE_TOTAL);
    }
    else
    {
        #ifdef DEBUG
        Warning("GetCurrentHealth called on object [" + GetTag(oObject) + "] that is not a creature or placeable. Please contact Georg. Script:" + GetCurrentScriptName());
        #endif
        return 1.0f;
    }

}


float GetCreatureSpellPower(object oCreature)
{
    return GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_SPELLPOWER, PROPERTY_VALUE_TOTAL);
}

int GetLevel(object oCreature)
{
    #ifdef DEBUG
    LogTrace(LOG_CHANNEL_TEMP,"GetLevel: " + ToString(GetCreatureProperty(oCreature,PROPERTY_SIMPLE_LEVEL, PROPERTY_VALUE_TOTAL)));
    #endif
    return FloatToInt(GetCreatureProperty(oCreature,PROPERTY_SIMPLE_LEVEL, PROPERTY_VALUE_TOTAL));
}

int IsWounded(object oObject)
{

    return ( GetCurrentHealth(oObject) < GetMaxHealth(oObject));
}

/**
*  @brief Returns the a random Integer cast to float between 0 and nBase
*                                                                       \
*  optionally adds nAdd to the result.
*
*  @author Georg
**/
float RandomF(int nBase, int nAdd = 0);
float RandomF(int nBase, int nAdd = 0)
{
    return IntToFloat(Random(nBase)  + nAdd);
}

float GetCreatureAttackRating(object oCreature)
{
    return GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_ATTACK);
}

/**
*  @brief Returns the creature critical hit modifier used for combat
*
*  There are 3 different critical hit modifiers on a creature: Melee, Magic and
*  Ranged.
*
*  @param oCreature the creature to retrieve the stat from
*  @param nCritModifier A CRITICAL_MODIFIER_* constant as follows:
*                       CRITICAL_MODIFIER_MELEE
*                       CRITICAL_MODIFIER_MAGIC
*                       CRITICAL_MODIFIER_RANGED
*
*  @author Georg
**/
float GetCreatureCriticalHitModifier(object oCreature, int nCritModifier);
float GetCreatureCriticalHitModifier(object oCreature, int nCritModifier)
{
     float fRet = GetCreatureProperty(oCreature, nCritModifier, PROPERTY_VALUE_TOTAL);
     #ifdef DEBUG
     float fMod = GetCreatureProperty(oCreature, nCritModifier, PROPERTY_VALUE_MODIFIER );
     Log_Trace(LOG_CHANNEL_CHARACTER,"core_h.GetCreatureCriticalHitModifier","Prop (" + ToString(nCritModifier) + ") on " + GetTag(oCreature) + " is " + ToString(fRet) + " modifier is: " + ToString (fMod));
     #endif

    return fRet;
}




/**
*  @brief Returns a creatures defense rating. This does not exclude shields
*  @sa    GetCreatureShieldRating
*  @author Georg
**/
float GetCreatureDefense (object oCreature)
{
    float fRet = GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_DEFENSE);
     #ifdef DEBUG
    float fMod = GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_DEFENSE, PROPERTY_VALUE_MODIFIER );
    Log_Trace(LOG_CHANNEL_CHARACTER,"core_h.GetCreatureDefense","Defense on " + GetTag(oCreature) + " is " + ToString(fRet) + " modifier is: " + ToString (fMod));
    #endif

    return fRet;
}

/**
*  @brief Returns a creatures current mana/stamina
*  @sa    SetCurrentManaStamina
*  @author Georg
**/
float GetCurrentManaStamina(object oObject)
{
    return GetCreatureProperty(oObject,PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_CURRENT);
}




/**
*  @brief Small helper for dealing with random floats in some combat functions
*  @author Georg
**/
float RandFF(float fRange, float fStatic = 0.0f, int bDeterministic = FALSE)
{
    if (bDeterministic) /* used for UI display purposes)*/
    {
        return fRange * 0.5 + fStatic;
    }
    else
    {
        return RandomFloat()*fRange + fStatic;
    }
}


/**
*   @brief returns the time for the ranged aim loop delay
*
*   The ranged aim loop is used on bows and crossbows and controls the rate of
*   fire for the weapon by telling the engine how long to loop the aim animation
*   before releasing the projectile. This function calculates the lengths of
*   the aimloop for a particular character and weapon, which is later passed back
*   to the engine via SetAimLoop function in the CommandPending event.
*
*   @param oShooter The creature shooting the weapon
*   @param oWeapon  The ranged weapon used
*
*   @returns Calculated time of the aimloop, mininal 0.0f.
*
*   @author georg
*
**/
float GetCreatureRangedDrawSpeed(object oCreature, object oWeapon = OBJECT_INVALID)
{
    float fRet = 0.0f;

    // -- Get Total Draw Speed
    float fTotal  = GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_RANGED_AIM_SPEED, PROPERTY_VALUE_TOTAL);

    // -- Get Mod (for debug output only)
    float fMod    = GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_RANGED_AIM_SPEED, PROPERTY_VALUE_MODIFIER );

    // -- GetWeapon Draw Speed (can't be negative)
    float fWeapon = 0.0f;

    if (IsObjectValid(oWeapon))
    {
        fWeapon = MaxF(GetM2DAFloat(TABLE_ITEMSTATS, "BaseAimDelay", GetBaseItemType(oWeapon)), 0.0f);
    }

    fRet = fTotal + fWeapon;

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_CHARACTER,"core_h.GetCreatureRangedDrawSpeed","DrawSpeed on " + GetTag(oCreature) + " is " + ToString(fRet) + " modifier is: " + ToString(fMod) + " Weapon (" + ToString(oWeapon) + "):" + ToString(fWeapon));
    #endif

    return MaxF(fRet,0.0f);
}

float GetAttributeModifier (object oCreature, int nAttribute);
float GetAttributeModifier (object oCreature, int nAttribute)
{

    float fValue = GetCreatureProperty(oCreature, nAttribute) - RULES_ATTRIBUTE_MODIFIER;

    return MaxF(fValue,0.0f);

}

/**
*   @brief returns if the creature can be deathblowed
*
*   @author georg
**/
int CanDeathBlow(object oCreature)
{
    return TRUE;// IsHumanoid(oCreature);
}

/**
*   @brief Returns a creature's core class (mage, rogue, warrior)
*
*   @author georg
**/
int GetCreatureCoreClass(object oCreature)
{
    int nCurrentClass = FloatToInt(GetCreatureProperty(oCreature, PROPERTY_SIMPLE_CURRENT_CLASS));

    int nCoreClass = GetM2DAInt(TABLE_RULES_CLASSES, "BaseClass", nCurrentClass);

    if(nCoreClass == 0) // the current is the core
        return nCurrentClass;
    else
        return nCoreClass;
}

/**
*   @brief Returns a creature's current class (bard, assassin etc')
*
*   @author yaron
**/
int GetCreatureCurrentClass(object oCreature)
{
    int nCurrentClass = FloatToInt(GetCreatureProperty(oCreature, PROPERTY_SIMPLE_CURRENT_CLASS));

    return nCurrentClass;
}



/**
*   @brief returns if the creature can be deathblowed
*
*   [core_h] Sets the requested combat state on all party members
*
*   @param bCombatState True to set combat state, false to unset
*
*   @author georg
**/
void SetCombatStateParty(int bCombatState);
void SetCombatStateParty(int bCombatState)
{
    object[] arrParty = GetPartyList(GetHero());
    int      nMemberCount = GetArraySize(arrParty);

    object oSubject;
    int iter;
    for (iter = 0; iter < nMemberCount; iter++)
    {
        oSubject=arrParty[iter];
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT,"core_h.SetCombatStateParty","Setting Combat State "  + ToString(bCombatState),arrParty[iter]);
        #endif
        if (GetCombatState(oSubject) != bCombatState)
       {
            SetCombatState(oSubject,bCombatState);
        }
    }

}

/**
*   @brief Returns whether or not a creature has a skill
*
*   [core_h] Returns true if a creature has nLevel ranks in a skill. To
*            test if a creature has any level/rank, just test for rank 1)
*
*            Note that this function relies on skill ranks  existing sequential
*            in abi_base.xls.
*
*   @param nSkill       ABILITY_SKILL_* constant
*   @param nSkill       Minimum skill ranks requrired to return true
*   @param oCreature    The creature to check.
*
*   @returns    True if creature has at least nLevel ranks in nSkill
*
*   @author georg
**/
int GetHasSkill(int nSkill, int nLevel = 1, object oCreature = OBJECT_SELF);
int GetHasSkill(int nSkill, int nLevel = 1, object oCreature = OBJECT_SELF)
{
   // -------------------------------------------------------------------------
   // Trap scripter error: invalid object passed in
   // -------------------------------------------------------------------------
   if (!IsObjectValid(oCreature))
   {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_DESIGN_SCRIPTERROR, "core_h.GetHasSkill","INVALID_OBJECT passed into function as oCreature",oCreature);
        #endif
        return FALSE;
   }



   // -------------------------------------------------------------------------
   // Trap scripter error: nLevel out of bounds
   // -------------------------------------------------------------------------
   if (nLevel > MAX_SKILL_RANKS )
   {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_DESIGN_SCRIPTERROR, "core_h.GetHasSkill","nLevel out of bounds:" + ToString(nLevel),oCreature);
        #endif
       nLevel = MAX_SKILL_RANKS;
   }
   else if (nLevel < 1)
   {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_DESIGN_SCRIPTERROR, "core_h.GetHasSkill","nLevel out of bounds:" + ToString(nLevel),oCreature);
        #endif
        nLevel = 1;
   }

   return (HasAbility(oCreature, (nSkill + (nLevel -1) )));

}

/**
*   @brief Returns whether the whole party has been wiped
*
*   [core_h] Returns true if all party members are dead.
*
*   @returns    True if all party members are dead.
*
*   @author georg
**/
int IsPartyDead();
int IsPartyDead()
{
    object[] partyMembers = GetPartyList();
    int nMembers = GetArraySize(partyMembers);
    int i;

    int bAllDead = TRUE;
    for (i = 0; i < nMembers; i++)
    {
        if (!IsDead(partyMembers[i]))
        {
             bAllDead = FALSE;
             break;
        }
    }
    return bAllDead;
}

/**
*   @brief returns proper tag for item based on it's resource
*
*   @author joshua
**/
string ResourceToTag(resource rResource);
string ResourceToTag(resource rResource)
{
    string sRes = ResourceToString(rResource);
    return SubString( sRes, 0, FindSubString(sRes, ".") );
}



/**
*   @brief Returns the experience points a party member has
*
*   @author georg
**/
int GetExperience(object oPartyMember);
int GetExperience(object oPartyMember)
{
    return FloatToInt(GetCreatureProperty(oPartyMember, PROPERTY_SIMPLE_EXPERIENCE));
}


/**
*   @brief Returns if a creature is immune to a specific effect type.
*
*   @author georg
**/
int IsImmuneToEffectType(object oCreature, int nEffectType) ;
int IsImmuneToEffectType(object oCreature, int nEffectType)
{
    // Shale's new Stone Will effects 
    if (GetHasEffects(oCreature, EFFECT_TYPE_INVALID, AF_ABILITY_STONE_WILL)) 
    {
        if (nEffectType == EFFECT_TYPE_KNOCKDOWN || nEffectType == EFFECT_TYPE_SLIP) // knockdown / slip immunity
        {
            return 1; // "Immune" message
        }
    }    
    
    // ABILITY_TALENT_INDOMITABLE grants immunity to knockdown and stun
    if (nEffectType == EFFECT_TYPE_KNOCKDOWN || nEffectType == EFFECT_TYPE_STUN || nEffectType == EFFECT_TYPE_SLIP)
    {
        if (IsModalAbilityActive(oCreature, ABILITY_TALENT_INDOMITABLE))
            return 3;

        if (IsModalAbilityActive(oCreature, 401100)) // GXA Spirit Warrior
            return 3;

        if ((nEffectType != EFFECT_TYPE_STUN) && IsModalAbilityActive(oCreature, 401200)) // GXA One With Nature
            return 3;

        // trait sturdy does this too.
        if (HasAbility(oCreature, ABILITY_TRAIT_STURDY))
            return 1;

        if (nEffectType == EFFECT_TYPE_KNOCKDOWN && HasAbility(oCreature, ABILITY_TALENT_SHIELD_EXPERTISE) && IsModalAbilityActive(oCreature, ABILITY_TALENT_SHIELD_WALL))
            return 3;

        if (HasAbility(oCreature,ABILITY_TALENT_EVASION) && Random(100)<20)
            return 3;
    }

    return GetM2DAInt(TABLE_EFFECT_IMMUNITIES, "e" + ToString(nEffectType),GetAppearanceType(oCreature));
}



/** @brief (core_h) Returns true if a creature is one of the 4 controllable party members.
*   This is a wrapper around IsFollower.
*/
int IsPartyMember(object oCreature)
{
    return IsFollower(oCreature);
}


/** @brief Converts degrees to radians.
*
* @param fDegrees - The value to convert.
* @returns The value of fDegrees in radians.
*
* @author dsitar
*/
float ToRadians(float fDegrees);
float ToRadians(float fDegrees)
{
    return (fDegrees * PI / 180.0f);
}

/** @brief Returns height of a creature based on its appearance.
*/
float GetHeight(object oCreature)
{
    return GetM2DAFloat(TABLE_APPEARANCE, (GetCreatureGender(oCreature) == GENDER_FEMALE ? "height_f" : "height"), GetAppearanceType(oCreature));
}


/** @brief  Replaces all occurences of a substring within a string.
*
* Not to be used for production scripts, please use for debug purposes only.
*
* @param    sString  The string to search.
* @param    sFind    The substring to find.
* @param    sReplace The string to replace occurences of substring sFind with.
* @returns           sString with all occurences of substring sFind replaced with sReplace.
*
* @author dsitar
*/
string ReplaceString(string sString, string sFind, string sReplace);
string ReplaceString(string sString, string sFind, string sReplace)
{
    string sResult = sString;
    int i = 0;
    while ((i = FindSubString(sResult, sFind, i)) != -1)
    {
        sResult = StringLeft(sResult, i) + sReplace + StringRight(sResult, GetStringLength(sResult) - GetStringLength(sFind) - i);
        i += GetStringLength(sReplace);
    }
    return sResult;
}


/** @brief Splits a given string into a string array based on a delimiter.
*
* Not to be used for production scripts, please use for debug purposes only.
*
* @param sString - The string to split.
* @param sSeparator - The delimiter string (can be more than 1 character in length).
* @returns The array of substrings.
*
* @author dsitar
*/
string[] SplitString(string sString, string sSeparator = " ");
string[] SplitString(string sString, string sSeparator = " ")
{
    string[]    aString;
    int         i    = 0;
    int         lpos = 0;
    int         pos  = FindSubString(sString, sSeparator);

    while (lpos != -1)
    {
        if (!IsStringEmpty(SubString(sString, lpos, pos-lpos)))
        {
            aString[i++] = SubString(sString, lpos, pos-lpos);
        }
        lpos = (pos == -1) ? -1 : pos + GetStringLength(sSeparator);
        pos  = FindSubString(sString, sSeparator, lpos);
    }
    return aString;
}


/** @brief Gets parameters to the 'runscript' console command as a string array.
*
*  Debug scripts should use this function to get the arguments of the 'runscript' console command.
*  Not for use in production scripts.
*
* @author dsitar
*/
string[] GetRunscriptArgs();
string[] GetRunscriptArgs()
{
    string sArg = GetLocalString(GetModule(), "RUNSCRIPT_VAR");
    SetLocalString(GetModule(), "RUNSCRIPT_VAR", "");
    return SplitString(sArg);
}

/** @brief Returns an array of floats representing the atmospheric conditions of a preset such as ATM_PRESET_DAY
*
* @param int nATMPreset - the ATM_PRESET_* constant to retrieve
* @returns An array of floats representing the atmospheric conditions of the preset.
*
* @author Craig Graff
*/
float[] GetAtmosphericConditions(int nATMPreset);
float[] GetAtmosphericConditions(int nATMPreset)
{
    float[] arValues;

    arValues[0] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_SUN_COLOR_RED, nATMPreset);
    arValues[1] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_SUN_COLOR_GREEN, nATMPreset);
    arValues[2] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_SUN_COLOR_BLUE, nATMPreset);
    arValues[3] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_SUN_INTENSITY, nATMPreset);
    arValues[4] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_TURBIDITY, nATMPreset);
    arValues[5] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_EARTH_REFLECTANCE, nATMPreset);
    arValues[6] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_MIE_MULTIPLIER, nATMPreset);
    arValues[7] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_RAYLEIGH_MULTIPLIER, nATMPreset);
    arValues[8] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_EARTHIN_SCATTER_POWER, nATMPreset);
    arValues[9] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_DISTANCE_MULTIPLIER, nATMPreset);
    arValues[10] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_HG, nATMPreset);
    arValues[11] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_ATMOSPHERE_ALPHA, nATMPreset);
    arValues[12] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_MOON_SCALE, nATMPreset);
    arValues[13] = GetM2DAFloat(TABLE_ATMOSPHERE, ATM_COLUMN_MOON_ALPHA, nATMPreset);

    return arValues;
}


/** @brief Returns an array of floats representing the cloud conditions of a preset such as ATM_PRESET_CLOUD_DEFAULT
*
* @param int nATMPreset - the ATM_PRESET_CLOUD* constant to retrieve
* @returns An array of floats representing the cloud conditions of the preset.
*
* @author Craig Graff
*/
float[] GetCloudConditions(int nATMCloudPreset);
float[] GetCloudConditions(int nATMCloudPreset)
{
    float[] arValues;

    arValues[0] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_COLOR_RED, nATMCloudPreset);
    arValues[1] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_COLOR_GREEN, nATMCloudPreset);
    arValues[2] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_COLOR_BLUE, nATMCloudPreset);
    arValues[3] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_DENSITY, nATMCloudPreset);
    arValues[4] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_SHARPNESS, nATMCloudPreset);
    arValues[5] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_DEPTH, nATMCloudPreset);
    arValues[6] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_RANGE_MULTIPLIER1, nATMCloudPreset);
    arValues[7] = GetM2DAFloat(TABLE_CLOUDS, ATM_COLUMN_CLOUD_RANGE_MULTIPLIER2, nATMCloudPreset);

    return arValues;
}

/** @brief Returns an array of floats representing the fog conditions of a preset such as ATM_PRESET_FOG_DEFAULT
*
* @param int nATMPreset - the ATM_PRESET_FOG* constant to retrieve
* @returns An array of floats representing the fog conditions of the preset.
*
* @author Craig Graff
*/
float[] GetFogConditions(int nATMFogPreset);
float[] GetFogConditions(int nATMFogPreset)
{
    float[] arValues;

    arValues[0] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_COLOR_RED, nATMFogPreset);
    arValues[1] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_COLOR_GREEN, nATMFogPreset);
    arValues[2] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_COLOR_BLUE, nATMFogPreset);
    arValues[3] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_INTENSITY, nATMFogPreset);
    arValues[4] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_CAP, nATMFogPreset);
    arValues[5] = GetM2DAFloat(TABLE_FOG, ATM_COLUMN_FOG_VERTICAL_ZENITH, nATMFogPreset);

    return arValues;
}

/** @brief Sets the fog conditions equal to a preset such as ATM_PRESET_DAY
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param int ATMFogPreset - the ATM_PRESET_* constant to set conditions to
*
* @author Craig Graff
*/
void SetFogConditions(int nATMFogPreset);
void SetFogConditions(int nATMFogPreset)
{
    float[] arFog = GetFogConditions(nATMFogPreset);
    SetAtmosphereRGB(ATM_PARAM_FOG_COLOR,arFog[0],arFog[1],arFog[2]);
    SetAtmosphere(ATM_PARAM_FOG_INTENSITY,arFog[3]);
    SetAtmosphere(ATM_PARAM_FOG_CAP,arFog[4]);
    SetAtmosphere(ATM_PARAM_FOG_ZENITH,arFog[5]);
}

/** @brief Sets the cloud conditions equal to a preset such as ATM_PRESET_DAY
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param int nATMPreset - the ATM_PRESET_* constant to set conditions to
*
* @author Craig Graff
*/
void SetCloudConditions(int nATMCloudPreset);
void SetCloudConditions(int nATMCloudPreset)
{
    float[] arClouds = GetCloudConditions(nATMCloudPreset);
    SetAtmosphereRGB(ATM_PARAM_CLOUD_COLOR_RGB,arClouds[0],arClouds[1],arClouds[2]);
    SetAtmosphere(ATM_PARAM_CLOUD_DENSITY,arClouds[3]);
    SetAtmosphere(ATM_PARAM_CLOUD_SHARPNESS,arClouds[4]);
    SetAtmosphere(ATM_PARAM_CLOUD_DEPTH,arClouds[5]);
    SetAtmosphere(ATM_PARAM_CLOUD_RANGE_MULTIPLIER1,arClouds[6]);
    SetAtmosphere(ATM_PARAM_CLOUD_RANGE_MULTIPLIER2,arClouds[7]);
}

/** @brief Sets the cloud conditions equal to a preset such as ATM_PRESET_CLOUD_DEFAULT
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param int nATMPreset - the ATM_PRESET_* constant to set conditions to
*
* @author Craig Graff
*/
void SetAtmosphericConditions(int nATMPreset);
void SetAtmosphericConditions(int nATMPreset)
{
    float[] arAtm = GetAtmosphericConditions(nATMPreset);
    SetAtmosphereRGB(ATM_PARAM_SUN_COLOR_RGB,arAtm[0],arAtm[1],arAtm[2]);
    SetAtmosphere(ATM_PARAM_SUN_INTENSITY,arAtm[3]);
    SetAtmosphere(ATM_PARAM_TURBIDITY,arAtm[4]);
    SetAtmosphere(ATM_PARAM_EARTH_REFLECTANCE,arAtm[5]);
    SetAtmosphere(ATM_PARAM_MIE_MULTIPLIER,arAtm[6]);
    SetAtmosphere(ATM_PARAM_RAYLEIGH_MULTIPLIER,arAtm[7]);
    SetAtmosphere(ATM_PARAM_DISTANCE_MULTIPLIER,arAtm[9]);
    SetAtmosphere(ATM_PARAM_ATMOSPHERE_ALPHA,arAtm[11]);
    SetAtmosphere(ATM_PARAM_MOON_SCALE,arAtm[12]);
    SetAtmosphere(ATM_PARAM_MOON_ALPHA,arAtm[13]);
}
/** @brief Sets the fog conditions equal to custom values.
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param float[] arFog - the array of float values to set conditions to
*
* @author Craig Graff
*/
void SetFogConditionsCustom(float[] arFog);
void SetFogConditionsCustom(float[] arFog)
{
    SetAtmosphereRGB(ATM_PARAM_FOG_COLOR,arFog[0],arFog[1],arFog[2]);
    SetAtmosphere(ATM_PARAM_FOG_INTENSITY,arFog[3]);
    SetAtmosphere(ATM_PARAM_FOG_CAP,arFog[4]);
    SetAtmosphere(ATM_PARAM_FOG_ZENITH,arFog[5]);
}
/** @brief Sets the cloud conditions equal to custom values.
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param float[] arClouds - the array of float values to set conditions to
*
* @author Craig Graff
*/
void SetCloudConditionsCustom(float[] arClouds);
void SetCloudConditionsCustom(float[] arClouds)
{
    SetAtmosphereRGB(ATM_PARAM_CLOUD_COLOR_RGB,arClouds[0],arClouds[1],arClouds[2]);
    SetAtmosphere(ATM_PARAM_CLOUD_DENSITY,arClouds[3]);
    SetAtmosphere(ATM_PARAM_CLOUD_SHARPNESS,arClouds[4]);
    SetAtmosphere(ATM_PARAM_CLOUD_DEPTH,arClouds[5]);
    SetAtmosphere(ATM_PARAM_CLOUD_RANGE_MULTIPLIER1,arClouds[6]);
    SetAtmosphere(ATM_PARAM_CLOUD_RANGE_MULTIPLIER2,arClouds[7]);
}
/** @brief Sets the cloud conditions equal to custom values.
*
*   Values below ATM_ATMOSPHERE_INVALID_VALUE will not be applied.
*
* @param float[] arAtm - the array of float values to set conditions to
*
* @author Craig Graff
*/
void SetAtmosphericConditionsCustom(float[] arAtm);
void SetAtmosphericConditionsCustom(float[] arAtm)
{
    SetAtmosphereRGB(ATM_PARAM_SUN_COLOR_RGB,arAtm[0],arAtm[1],arAtm[2]);
    SetAtmosphere(ATM_PARAM_SUN_INTENSITY,arAtm[3]);
    SetAtmosphere(ATM_PARAM_TURBIDITY,arAtm[4]);
    SetAtmosphere(ATM_PARAM_EARTH_REFLECTANCE,arAtm[5]);
    SetAtmosphere(ATM_PARAM_MIE_MULTIPLIER,arAtm[6]);
    SetAtmosphere(ATM_PARAM_RAYLEIGH_MULTIPLIER,arAtm[7]);
    SetAtmosphere(ATM_PARAM_DISTANCE_MULTIPLIER,arAtm[9]);
    SetAtmosphere(ATM_PARAM_ATMOSPHERE_ALPHA,arAtm[11]);
    SetAtmosphere(ATM_PARAM_MOON_SCALE,arAtm[12]);
    SetAtmosphere(ATM_PARAM_MOON_ALPHA,arAtm[13]);
}

/** @brief runs the power operation.
*
*   runs the power operatio.
*
* @param nPower the number which we want the power of
* @param nPowerLevel the power level required
*
* @author Yaron
*/
int Power(int nPower, int nPowerLevel);
int Power(int nPower, int nPowerLevel)
{
    int i;
    int nRet = nPower;
    for(i = 2; i <= nPowerLevel; i++)
    {
        nRet *= nPower;
    }

    if(nPowerLevel == 0)
        return 1;
    else if(nPowerLevel == 1)
        return nPower;

    return nRet;
}



/**
* @brief (2da_data)  Returns the calculated cooldown to set after using an ability
*
* @returns float with cooldown in seconds
*
* @author   Georg Zoeller
**/
float Ability_GetCooldown(object oCaster, int nAbility);
float Ability_GetCooldown(object oCaster, int nAbility)
{
    float fBase =  GetAbilityBaseCooldown(nAbility);
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"Ability_GetCooldown","base cooldown: " + FloatToString(fBase));
    #endif
    return fBase;
}


/**
* @brief (2da_data)  Sets the cooldown for an ability
**
* @author   Georg Zoeller
**/
void Ability_SetCooldown(object oCaster, int nAbility, object oItem = OBJECT_INVALID, float fCooldown = 0.0f);
void Ability_SetCooldown(object oCaster, int nAbility, object oItem = OBJECT_INVALID, float fCooldown = 0.0f)
{

    string sItemTag = IsObjectValid(oItem)?GetTag(oItem):"";

    if (GetCreatureFlag(oCaster, CREATURE_RULES_FLAG_NO_COOLDOWN))
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.SetCoolDown","setting NO Cooldown due to flag set on creature");
        #endif
        return;
    }



    if (fCooldown == 0.0f)
    {
        fCooldown =  Ability_GetCooldown(oCaster, nAbility);
    }
    else if (fCooldown <0.0f)
    {
        fCooldown = fabs(fCooldown);
    }

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.SetCoolDown",Log_GetAbilityNameById(nAbility) + ": " + FloatToString(fCooldown));
    #endif

    SetCooldown(oCaster, nAbility, fCooldown, sItemTag);

}


void AddAbilityEx(object oTarget, int nAbility, int nQuickslot = 0)
{
    if (nAbility >0)
    {
        AddAbility(oTarget, nAbility);

        if (IsFollower(oTarget))
        {
            SetQuickslot(oTarget,nQuickslot, nAbility);
        }
    }
    else
    {
        #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_DESIGN_SCRIPTERROR,"ability_h.AddAbilityEx","Attempt to add invalid ability id (negative or 0) rejected");
        #endif

    }

}


int IsDeadOrDying(object oCreature)
{
    return (IsDead(oCreature) || IsDying(oCreature));
}

int IsInvalidDeadOrDying(object oCreature)
{
    return (!IsObjectValid(oCreature) || IsDead(oCreature) || IsDying(oCreature));
}


int IsSummoned(object oCreature)
{
     return GetLocalInt(oCreature,IS_SUMMONED_CREATURE);
}


/**
* @brief Returns the state controller table for the placeable
*
* @param oPlaceable the placeable
*
* @author   Yaron Jakobs

**/
string GetPlaceableStateCntTable(object oPlaceable);
string GetPlaceableStateCntTable(object oPlaceable)
{

    int nAppearanceType = GetAppearanceType(oPlaceable);
    return GetM2DAString(TABLE_PLACEABLE_TYPES,"StateController",nAppearanceType);
}

/**
* @brief Returns TRUE if the placeable is a trap trigger
*
* @param oPlaceable the placeable
*
* @author   Yaron Jakobs

**/
int IsTrapTrigger(object oPlaceable);
int IsTrapTrigger(object oPlaceable)
{

    return GetPlaceableStateCntTable(oPlaceable) == PLC_STATE_CNT_TRAP_TRIGGER;
}


void Party_SetFollowLeader( int bFollow)
{
    object[] aParty = GetPartyList();
    int nSize = GetArraySize(aParty);
    int i;

    for (i = 0; i < nSize; i++)
    {
        SetFollowPartyLeader(aParty[i], bFollow);
    }
}

// -----------------------------------------------------------------------------
// @brief Safe Wrapper for DestroyObject
//      Reason: There were accidents where creatures would deplete themselves
//              as Ammo because people were not paying attention....
// @author Georg
// -----------------------------------------------------------------------------
void Safe_Destroy_Object(object oObject, int nDelayMs = 0);
void Safe_Destroy_Object(object oObject, int nDelayMs = 0)
{
    int bDestroy = TRUE;

    if (IsPartyMember(oObject) || IsPlot(oObject) || IsImmortal(oObject) )
    {
        #ifdef DEBUG
        Warning("Destroy Object Call rejected by Safe_Destroy_Object from script" + GetCurrentScriptName() + " on " + ToString(oObject) + ". This is serious, please contact georg." );
        #endif
        bDestroy = FALSE;
    }

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_SYSTEMS,"core_h.SafeDestroyObject","Destroy:" + ToString(oObject) + " Result: " + ToString(bDestroy));
    #endif

    if (bDestroy)
    {
        DestroyObject(oObject,nDelayMs);
    }
}


int GetPlayerBackground(object oChar)
{
    return FloatToInt(GetCreatureProperty(oChar, PROPERTY_SIMPLE_BACKGROUND));

}

const int ABILITY_USE_TYPE_PASSIVE = 3;

int GetAbilityUseType(int nAbility)
{
    return GetM2DAInt(TABLE_ABILITIES_SPELLS,"usetype",nAbility);
}

int CanCreatureBleed(object oCreature)
{
    int nApp = GetAppearanceType(oCreature);

    return GetM2DAInt(TABLE_APPEARANCE, "bCanBleed", nApp);

}

object GetRandomPartyMember()
{
    object[] party = GetPartyList();
    return party[Random(GetArraySize(party))];

}

/**
* @brief Permanently increases a PROPERTY_ATTRIBUTE_* of the 6 core attributes by 1
*
* Meant for use by Ferret in a specific plot. Do not use for any other purpose!
*
* @param oCreature
* @param nAttribute - e.g. PROPERTY_ATTRIBUTE_WILLPOWR
*
* @author   Georg Zoeller.
*
**/
void IncreaseAttributeScore(object oCreature, int nAttribute)
{
    // props 1 - 6 are attributes
    if (nAttribute>0 && nAttribute <7)
    {
        float fValue = GetCreatureProperty(oCreature, nAttribute, PROPERTY_VALUE_BASE) + 1.0;
        SetCreatureProperty(oCreature, nAttribute,fValue);
    }
}




/**
* @brief Return the selected AI Behavior (idx into aibehaviors.xls)
* @param oCreature
* @author   Georg Zoeller.
**/
int GetAIBehavior(object oCreature)
{
    if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
    {
        return FloatToInt(GetCreatureProperty(oCreature,PROPERTY_SIMPLE_AI_BEHAVIOR));
    }
    else
    {
        return AI_BEHAVIOR_DEFAULT ;
    }
}

/**
* @brief Set selected AI Behavior (idx into aibehaviors.xls)
* @param oCreature
* @param value (index into aibehaviors.xls)
* @author   Georg Zoeller.
*
**/
void SetAIBehavior(object oCreature, int value)
{
    if (GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
    {
        if (value<0)
            value=0;
        SetCreatureProperty(oCreature,PROPERTY_SIMPLE_AI_BEHAVIOR, IntToFloat(value));
    }
}

/*
 * @brief The One and Only check to verify if a creature is a magic / mana user
 *        please use instead of checking for CLASS_WIZARD, which breaks for monster
 *        classes.
 *
 * @author georg
*/
int IsMagicUser(object oCreature)
{

    int nClass = GetCreatureCoreClass(oCreature);
    int bMagicUser = ((nClass == CLASS_WIZARD) ||
        (GetAppearanceType(oCreature) == 25 /* APPEARANCE_TYPE_ABOMINATION */) ||
            (GetM2DAInt(TABLE_RULES_CLASSES, "bUsesMana", nClass) == 1) );

    return bMagicUser;
}

/*
 * @brief Return true if a party member has enough XP to gain a level
 *
 * @author georg
 *
*/
int Chargen_CheckCanLevelUp(object oPartyMember);
int Chargen_CheckCanLevelUp(object oPartyMember)
{

    string sTag = GetTag(oPartyMember);

    // Sorry mouse, but you're out. You refuse to obey the normal rules of not leveling for party members,
    // so the gods of gaming have decided to hardcode your eternal mediocrity into this function as requested
    // by the imminent beta.
    if (sTag == "bhm600cr_mouse" || sTag == "bhm600cr_mouse_bear" || sTag == "bhm600cr_mouse_human")
    {
        return FALSE;
    }


    int nCurrentLevel = GetLevel(oPartyMember);
    if (nCurrentLevel >= GetMaxLevel())
    {
        Log_Trace( LOG_CHANNEL_REWARDS, "Chargen_CheckCanLevelUp", "nCurrentLevel >= DA_LEVEL_CAP. returning FALSE");
        return FALSE;
    }

    int nCurrentXP    = GetExperience(oPartyMember);
    int nXPNeededForNext = GetM2DAInt(TABLE_EXPERIENCE,"XP", (nCurrentLevel+1));

    #ifdef DEBUG
    Log_Trace( LOG_CHANNEL_REWARDS, "core_h.Chargen_CheckCanLevelUp", "returning " + ToString(nCurrentXP) + " (current) >=" + ToString(nXPNeededForNext) + " (needed for next)" );
    #endif

    return (nCurrentXP >= nXPNeededForNext);
}


/*
 * @brief Return true if a weapon is a two handed melee weapon (bitm_base lookup)
 *
 * @author georg
 *
*/
int IsMeleeWeapon2Handed(object oMeleeWeapon)
{
    int nBitm = GetBaseItemType(oMeleeWeapon);
    return (GetM2DAInt(TABLE_ITEMS,"WeaponWield",nBitm) == WEAPON_WIELD_TWO_HANDED_MELEE);
}


/*
 * @brief Brute force wrapper around the SetImmortal command to allow me to
 *        trace the use of this command.
 *
 *        If you encounter a creature that is set immortal but shouldn't be
 *        you can trace all calls to this function in context of the game session
 *        via the reports function on the SkyNet server.
 *
 * @author georg
 *
*/
void SetImmortal (object oObject, int bImmortal)
{
    #ifdef DEBUG
    Log_Trace( LOG_CHANNEL_REWARDS, GetCurrentScriptName() + "->core_h.SetImmortal", "Setting Immortal " + ToString(bImmortal) + " on " + ToString(oObject) );
    #endif

    // -------------------------------------------------------------------------
    // Track any use of Immortal on Party Members....
    // -------------------------------------------------------------------------
    if (LOG_ENABLED)
    {
        if (IsPartyMember(oObject) && bImmortal == TRUE)
        {
            TrackPCImmortal(oObject, bImmortal) ;
        }
    }
    Engine_SetImmortal(oObject, bImmortal);
}

/*
 * @brief Return TRUE if oPlaceable is a body bag (simple tag string compare)
 *
 * @author petert
 *
*/
int IsBodyBag(object oPlaceable);
int IsBodyBag(object oPlaceable)
{
    int bIsBodyBag = FALSE;

    string sTag = GetTag(oPlaceable);
    if (sTag == BODY_BAG_TAG)
    {
        bIsBodyBag = TRUE;
    }

    return bIsBodyBag;
}

// -----------------------------------------------------------------------------
// Attempt to get the body bad corresponding to oDeadCreature.
// this is not guarrenteed to work! If two creatures
// are piled up on each other, you may get the body bag
// of the other creature!
// -----------------------------------------------------------------------------
object GetBodyBag(object oDeadCreature);
object GetBodyBag(object oDeadCreature)
{

    object oBodyBag = OBJECT_INVALID;
    if (IsObjectValid(oDeadCreature) == TRUE)
    {
        if (IsDead(oDeadCreature) == TRUE)
        {
            object[] oBodyBags = GetNearestObjectByTag(oDeadCreature,BODY_BAG_TAG, OBJECT_TYPE_PLACEABLE,1);
            int nCount = GetArraySize(oBodyBags);
            if (nCount > 0)
            {
                oBodyBag = oBodyBags[0];
            }
        }
    }
    return oBodyBag;
}

/*
 * @brief Recalculate the number of tactics slots a creature should have based
 *        on level and skills
 *
 * @author yaron
 *
 */
void Chargen_SetNumTactics(object oChar)
{
    int nLevel = GetLevel(oChar);


    int nTacticsNum = GetM2DAInt(TABLE_EXPERIENCE,"Tactics",nLevel);

    if (HasAbility(oChar, ABILITY_SKILL_COMBAT_TACTICS_4))
        nTacticsNum +=6;
    else if (HasAbility(oChar, ABILITY_SKILL_COMBAT_TACTICS_3))
        nTacticsNum +=4;
    else if (HasAbility(oChar, ABILITY_SKILL_COMBAT_TACTICS_2))
        nTacticsNum +=2;
    else if (HasAbility(oChar, ABILITY_SKILL_COMBAT_TACTICS_1))
        nTacticsNum +=1;

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_CHARACTER,"Chargen_SetNumTactics","Number of tactics for creature " + IntToString(nTacticsNum));
    #endif

    int nSendNotification = (nLevel == 1 ? FALSE : TRUE);
    SetNumTactics(oChar, nTacticsNum, nSendNotification);

    // Set default tactic for player when first generated only
    if(IsHero(oChar) && nLevel == 1)
    {
        SetTacticEntry(oChar, 1, TRUE,3 /*AI_TARGET_TYPE_ENEMY*/, 31, 2 /*AI_COMMAND_ATTACK*/);
    }
}


/*
 * @brief Return if the player has unspent character advancement points.
 *        This controls the display of the levelup icon next to the portrait.
 *
 * @author georg
 */
int  Chargen_HasPointsToSpend(object oChar)
{
    float f = GetCreatureProperty(oChar, PROPERTY_SIMPLE_ATTRIBUTE_POINTS);
    f+= GetCreatureProperty(oChar, PROPERTY_SIMPLE_TALENT_POINTS);
    f+= GetCreatureProperty(oChar, PROPERTY_SIMPLE_SKILL_POINTS);

    // -------------------------------------------------------------------------
    // comment this line back in if you want a levelup icon when you gain a
    // spec point.
    // -------------------------------------------------------------------------
    //  f+= GetCreatureProperty(oChar, 38 /* SPEC_POINTS */);

    return f>0.0;
}


/*
 * @brief Scale the items available in a store to the level of the player
 *        Only happens once(or selectively)
 *
 *
 * @author patl
 */
void ScaleStoreItems(object oStore, int bReset = FALSE)
{
    // check for duplicate specialization books
    int nSpecialization;
    object [] oItems = GetItemsInInventory(oStore, GET_ITEMS_OPTION_ALL);
    int nSize = GetArraySize(oItems);
    int nCount = 0;
    string acvId;
    for (nCount = 0; nCount < nSize; nCount++)
    {
        nSpecialization = GetLocalInt(oItems[nCount], ITEM_SPECIALIZATION_FLAG);
        if (nSpecialization > 0)
        {
            acvId = GetM2DAString(TABLE_ACHIEVEMENTS, "AchievementID", nSpecialization);
            if (GetHasAchievement(acvId) == TRUE)
            {
                DestroyObject(oItems[nCount]);
            }
        }
    }

    // Remove backpack items from store if party's inventory size is already maximized.
    if (GetMaxInventorySize() >= 125)
    {
        RemoveItemsByTag(oStore, "gen_im_misc_backpack");
    }


    // Only scale the merchant the first time opened.
    if (GetLocalInt(oStore, "MERCHANT_IS_SCALED") && !bReset)
    {
        return;
    }

    SetLocalInt(oStore, "MERCHANT_IS_SCALED", 1);

//    oItems = GetItemsInInventory(oStore, GET_ITEMS_OPTION_ALL);
//    nSize = GetArraySize(oItems);

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_SYSTEMS, "ScaleStoreItems", "START, number of items: " + IntToString(nSize));
    #endif

    int nStoreBase = GetLocalInt(oStore, "MERCHANT_LEVEL_OVERRIDE");
    int nStoreLevel;
    if (nStoreLevel > 0)
    {
        nStoreLevel = nStoreBase;
    } else
    {
        nStoreLevel = GetLevel(GetHero());
    }
    int nStoreLevelModifier = GetLocalInt(oStore, "MERCHANT_LEVEL_MODIFIER");

    // modify and enforce range
    nStoreLevel += nStoreLevelModifier;
    nStoreLevel = Max(nStoreLevel, 1);
    nStoreLevel = Min(nStoreLevel, 45);

    int nItemType;
    int nMaterialProgression;
    int nRandomLevel;
    int nColumn;
    int nMaterial;
    float fHighChance = GetLocalFloat(oStore, "MERCHANT_HIGH_CHANCE");
    int nHighModifier = 3;

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"  Base Store Level  Scaling " + ToString(nStoreBase));
    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"  Store Level Modifier " + ToString(nStoreLevelModifier));
    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"  Store High Chance " + ToString(fHighChance));
    #endif

    nCount = 0;
    for (nCount = 0; nCount < nSize; nCount++)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"    Scaling " + GetTag(oItems[nCount]));
        #endif

        // if appropriate type (armor, shield, melee weapon, ranged weapon)
        nItemType = GetItemType(oItems[nCount]);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      nItemType = " + ToString(nItemType));
        #endif

        if ((nItemType == ITEM_TYPE_ARMOUR) || (nItemType == ITEM_TYPE_SHIELD) || (nItemType == ITEM_TYPE_WEAPON_MELEE) || (nItemType == ITEM_TYPE_WEAPON_RANGED))
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Item is scalable.");
            #endif

            // if not unique
            if (GetItemUnique(oItems[nCount]) == FALSE)
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Item is not unique.");
                #endif

                // get material progression
                nMaterialProgression = GetItemMaterialProgression(oItems[nCount]);

                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      nMaterialProgression = " + ToString(nMaterialProgression));
                #endif
                if (nMaterialProgression > 0)
                {
                    // find randomized level
                    nRandomLevel = nStoreLevel + Random(7) - 3;
                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Initial nRandomLevel = " + ToString(nRandomLevel));
                    #endif

                    if (RandomFloat() < fHighChance)
                    {
                        nRandomLevel += nHighModifier;
                        SetLocalInt(oItems[nCount], "ITEM_RUNE_ENABLED", 1);
                    }

                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Modified nRandomLevel = " + ToString(nRandomLevel));
                    #endif

                    nRandomLevel = Max(1, nRandomLevel);
                    nRandomLevel = Min(45, nRandomLevel);

                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Final nRandomLevel = " + ToString(nRandomLevel));
                    #endif

                    // find material column
                    nColumn = ((nRandomLevel - 1) / 3) + 1;


                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      nColumn = " + ToString(nColumn));
                    #endif


                    nColumn = Max(1, nColumn);
                    nColumn = Min(15, nColumn);

                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      Min-Max nColumn = " + ToString(nColumn));
                    #endif

                    // get material
                    nMaterial = GetM2DAInt(TABLE_MATERIAL, "Material" + ToString(nColumn), nMaterialProgression);

                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_LOOT, GetCurrentScriptName(),"      nMaterial = " + ToString(nMaterial));
                    #endif

                    // set material
                    SetItemMaterialType(oItems[nCount], nMaterial);
                }
            }
        }
    }
}


float GetWeaponAttributeBonusFactor(object oWeapon)
{

    if (!IsObjectValid(oWeapon))
    {
        // ---------------------------------------------------------------------
        // Unarmed
        // ---------------------------------------------------------------------
        return UNARMED_ATTRIBUTE_BONUS_FACTOR;
    }

    int nBase     = GetBaseItemType(oWeapon);
    float fFactor = GetItemStat(oWeapon,ITEM_STAT_ATTRIBUTE_MOD);


    return fFactor;
}


/*
 * @brief Calulcate attack damage bonus based on a number of parameters
 *        such as wield mode and talents
 *
 * @returns Damage bonsu
 *
 * @author georg
 */
float Combat_Damage_GetAttributeBonus(object oCreature, int nHand = HAND_MAIN, object oWeapon = OBJECT_INVALID, int bDeterministic = FALSE)
{
    int nAttribute = PROPERTY_ATTRIBUTE_STRENGTH;
    int nAttribute1 = 0;
    // -------------------------------------------------------------------------
    // some
    // -------------------------------------------------------------------------
    if (IsObjectValid(oWeapon))
    {
        int nBaseItemType = GetBaseItemType(oWeapon);
        if (nBaseItemType>0)
        {
            nAttribute = GetM2DAInt(TABLE_ITEMSTATS,"Attribute0",nBaseItemType);
            nAttribute1 = GetM2DAInt(TABLE_ITEMSTATS,"Attribute1",nBaseItemType);
        }
    }


    // -------------------------------------------------------------------------
    // Combat Magic: Using SpellPower (magic modifier) intead.
    // -------------------------------------------------------------------------
    if (IsModalAbilityActive(oCreature, ABILITY_SPELL_COMBAT_MAGIC))
    {
        nAttribute = PROPERTY_ATTRIBUTE_MAGIC;
    }

    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---
    // Lethality: If the talent is present and the attribute tested is strength
    // then change the attribute to cunning if cunning is higher than int
    // ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---
    else if (nAttribute == PROPERTY_ATTRIBUTE_STRENGTH && HasAbility(oCreature, ABILITY_TALENT_LETHALITY) )
    {
        if (GetAttributeModifier(oCreature, nAttribute) < GetAttributeModifier(oCreature, PROPERTY_ATTRIBUTE_INTELLIGENCE))
        {
            nAttribute = PROPERTY_ATTRIBUTE_INTELLIGENCE;
        }
    }



    float fDmg = 0.0f;

    if (nAttribute1 == 0)
    {
        fDmg = MaxF(0.0,GetAttributeModifier(oCreature,nAttribute));
    }
    else
    {
        fDmg = MaxF(0.0,(GetAttributeModifier(oCreature,nAttribute) + GetAttributeModifier(oCreature,nAttribute1)) /2.0f  ) ;

    }


    // Main hand attacks to 50-75% of att modifier
    if (nHand == HAND_MAIN)
    {
        if (GetWeaponStyle(oCreature) == WEAPONSTYLE_DUAL)
        {
            return RandFF(fDmg * 0.25, fDmg*0.25, bDeterministic);
        }
        else
        {
           return RandFF(fDmg * 0.25, fDmg*0.5, bDeterministic);
        }
    }
    else
    {
        // dual weapon training adds 1/4th of att modifier to damage / so does using a shield (offhand damage with shield is shield abilities only anyway)
        if (HasAbility(oCreature, ABILITY_TALENT_DUAL_WEAPON_TRAINING) || IsUsingShield(oCreature))
        {
            return RandFF(fDmg * 0.25, fDmg*0.25, bDeterministic);
        }
        else
        {
            return RandFF(fDmg * 0.25,0.0f, bDeterministic);
        }
    }
}

/*
 * @brief Calculate the attack duration value to be passed to the engine based
 *        on factors like wieldstyle, effects and stats
 *
 * @returns Attack duration value or 0.0 for default (anim controlled)
 *
 * @author georg
 */
float CalculateAttackTiming(object oAttacker, object oWeapon)
{
    // -------------------------------------------------------------------------
    // Without a weapon or if we are not a humanoid (which covers shapeshift)
    // we return 0.0, which translates to animation controlled timing in the
    // engine when passed into attack speed.
    // -------------------------------------------------------------------------
    if (IsObjectValid(oWeapon) && IsHumanoid(oAttacker))
    {

        float fSpeedMod = GetM2DAFloat(TABLE_ITEMSTATS,"dspeed",GetBaseItemType(oWeapon));

        // ---------------------------------------------------------------------
        // Calculate weapon speed.
        // ---------------------------------------------------------------------
        int nStyle = GetWeaponStyle(oAttacker);
        float fSpeed = 0.0f;

        switch (nStyle)
        {
            case WEAPONSTYLE_NONE:
                fSpeed = BASE_TIMING_WEAPON_SHIELD;
                break;
            case WEAPONSTYLE_DUAL:
                fSpeed = BASE_TIMING_DUAL_WEAPONS;
                break;
            case WEAPONSTYLE_SINGLE:
                fSpeed = BASE_TIMING_WEAPON_SHIELD;
                break;
            case WEAPONSTYLE_TWOHANDED:
                fSpeed = BASE_TIMING_TWO_HANDED;
                break;
        }


        // ---------------------------------------------------------------------
        // Only attacks that rely on timing can be modified
        // ---------------------------------------------------------------------
        if (fSpeed > 0.0f)
        {
            // -----------------------------------------------------------------
            // We're capping the actual values here to avoid animations breaking
            // down when played too fast or too slow.
            // -----------------------------------------------------------------
            float fSpeedEffects = MinF(1.5f, MaxF(0.5f, GetCreatureProperty(oAttacker, PROPERTY_ATTRIBUTE_ATTACK_SPEED_MODIFIER)));

            // -----------------------------------------------------------------
            // compatibility with some old savegames.
            // -----------------------------------------------------------------
            if (GetCreatureProperty(oAttacker, PROPERTY_ATTRIBUTE_ATTACK_SPEED_MODIFIER) < 0.5f)
            {
                  fSpeedEffects = 1.0f;
            }

            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT,"combat_performattack","weapon base speed :" + ToString(fSpeed)  + " mod:" + ToString(fSpeedMod) + " effects: " + ToString(fSpeedEffects) );
            #endif

            fSpeed+=(fSpeedMod);
            if (fSpeedEffects>0.0f)
            {
                fSpeed *= fSpeedEffects;
            }
            return fSpeed;
        }
    }
   return 0.0;
}



/*
 * @brief Retrieves a weapons base damage from the defined item stat.
 *
 * @returns weapon base damage
 *
 * @author georg
 */
float DmgGetWeaponBaseDamage(object oWeapon)
{
    if (!IsObjectValid(oWeapon))
    {
        return COMBAT_DEFAULT_UNARMED_DAMAGE;
    }
    float fBase =GetItemStat(oWeapon, ITEM_STAT_DAMAGE);
    return fBase;

}


/*
 * @brief Retrieves a weapons max damage from the defined item stat.
 *
 * @returns weapon max damage
 *
 * @author georg
 */
float DmgGetWeaponMaxDamage(object oWeapon)
{
    int nType = GetBaseItemType(oWeapon);

    if (!IsObjectValid(oWeapon))
    {
        return COMBAT_DEFAULT_UNARMED_DAMAGE * 1.5f;
    }

    float fMax = DmgGetWeaponBaseDamage(oWeapon) * MaxF(1.0, GetM2DAFloat(TABLE_ITEMSTATS,"DamageRange", nType));
    if (fMax == 0.0 && GetM2DAInt(TABLE_ITEMS,"Type",nType) == ITEM_TYPE_SHIELD)
        fMax = 5.0;

    return fMax;
}




/*
 * @brief Retrieves a weapons attack damage. This is randomized unless bForceMaxDamage is specificied.
 *
 * @returns Weapon damge of a single attack.
 *
 * @author georg
 */
float DmgGetWeaponDamage(object oWeapon, int bForceMaxDamage = FALSE)
{
    float fBase = DmgGetWeaponBaseDamage(oWeapon);
    float fMax = DmgGetWeaponMaxDamage(oWeapon);
    return bForceMaxDamage ? fMax : RandFF(fMax - fBase, fBase);
}



/*
 * @brief Retrieves weapon damage for the staff
 * @author georg
 */
float Combat_Damage_GetMageStaffDamage(object oAttacker, object oTarget, object oWeapon, int bDeterministic = FALSE)
{
    int nProjectileIndex = GetLocalInt(oWeapon,PROJECTILE_OVERRIDE);
    float fDamageBonus = 1.0 + GetM2DAFloat(TABLE_PROJECTILES,"DamageBonus",nProjectileIndex);

    float fArcaneFocus = 1.0;
    if (HasAbility(oAttacker, 200256)) /**ABILITY_SPELL_ARCANE_FOCUS*/
    {
        fArcaneFocus = 1.0 + (1.0/3.0);
    }

    float fSpellPowerComponent = (GetCreatureSpellPower(oAttacker) / 4.0f) * fArcaneFocus  * fDamageBonus;


    return DmgGetWeaponDamage(oWeapon,bDeterministic) + RandFF(fSpellPowerComponent * 0.25,fSpellPowerComponent * 0.75,bDeterministic)  ;

}

// @brief Calcluate weapon damage display values. See below for more info.
// @author Georg
float CalculateWeaponDamage(object oCreature, object oWeapon, int nHand = HAND_MAIN)
{
        // ---------------------------------------------------------------------
        // Staves have a different damage formula.
        // ---------------------------------------------------------------------
        if (GetBaseItemType(oWeapon) == BASE_ITEM_TYPE_STAFF)
        {
            return Combat_Damage_GetMageStaffDamage(oCreature, OBJECT_INVALID, oWeapon,TRUE) ;
        }

        // ---------------------------------------------------------------------
        // Generate a determinitic damage
        // ---------------------------------------------------------------------
        float fStat = DmgGetWeaponBaseDamage(oWeapon);
        float fMax = DmgGetWeaponMaxDamage(oWeapon);
        fStat = fStat + (( fMax - fStat) * 0.5);

        // ---------------------------------------------------------------------
        // Generate some timing values
        // ---------------------------------------------------------------------
        float fTiming = CalculateAttackTiming(oCreature, oWeapon);
        if (fTiming >0.0f)
        {
            fTiming = 1.0 / fTiming;
        }
        else
        {
            fTiming = 0.5f /* average base timing */;
        }


        // ---------------------------------------------------------------------
        // Add in attribute bonus and multiply with bonus factor based on
        // weapon type
        // ---------------------------------------------------------------------
        float fFactor =     GetWeaponAttributeBonusFactor(oWeapon);
        fStat += Combat_Damage_GetAttributeBonus(oCreature, nHand, oWeapon, TRUE) * fFactor;

        // ---------------------------------------------------------------------
        // This is mostly for debugging monsters, since damage scale is usually
        // set to 1.0 for player characters.
        // ---------------------------------------------------------------------
        float fDamageScale = GetM2DAFloat(Diff_GetAutoScaleTable(),"fDamageScale", GetCreatureRank(oCreature));
        if (fDamageScale >0.0)
        {
            fStat *= fDamageScale;
        }

        fStat +=   GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_DAMAGE_BONUS);

        // ---------------------------------------------------------------------
        // for non dual weapons, multiply with magic number to generate
        // a proportionally more correct display value.
        // ---------------------------------------------------------------------
        if (GetWeaponStyle(oCreature) == WEAPONSTYLE_TWOHANDED)
        {
            fStat *= (fTiming * 2.25);
        }
        else if (GetWeaponStyle(oCreature) != WEAPONSTYLE_DUAL)
        {
            fStat *= (fTiming * 2.0);
        }

        return fStat;
}


/* -----------------------------------------------------------------------------

    @brief Recalculates the damage number to display on the character sheet

    Damage is a complex mechanic with many contributing factors in DA.
    In order to provide the necessary feedback to the player, we need to
    create and display a damage stat on the character that approximates the
    damage potential of the character and reflects changes due to equipment.

    Note: Because damage is influenced by a number of factors not known at the
    time a player opens his UI (such as enemy resistances, armor, etc.) as well
    as randomized, it is not possible to just show a flat damage number.

    The main purpose of the number generated by this function is to give the player
    some number that is proportionally correct - meaning he can assess whether or not
    a weapon is an upgrade over another weapon, etc.

    The values in this function are generated by removing all non-deterministic
    factors for the player's damage - using maximum or average values where needed.

    We also include timing information to allow the player to assess the impact
    of abilities like haste and momentum as well as basic weapon style wieldspeeds
    on damage.

    Since the numbers generated by different styles are not immediately comparable,
    we are multiplying them with different magic numbers to generate output that
    makes sense on the character sheets and that matches the damage floaties the
    player will see when fighting an average opponent.

    Note: For the future - don't design too many non-deterministic elements into
    the rules system.

    This function is called in most places where a character's damage potential
    may change (ui_open and equipment change)

    @author Georg

   ---------------------------------------------------------------------------*/
float _GetAverageDamage(object oCreature, object oWeapon) {

    if (GetBaseItemType(oWeapon) == BASE_ITEM_TYPE_STAFF) {
        if (GetHasEffects(oCreature, EFFECT_TYPE_SHAPECHANGE))
            oWeapon = OBJECT_INVALID;
        else
            return Combat_Damage_GetMageStaffDamage(oCreature, OBJECT_INVALID, oWeapon, TRUE);
    }

    int nHand = (GetItemEquipSlot(oWeapon) == INVENTORY_SLOT_OFFHAND) ? HAND_OFFHAND : HAND_MAIN;
    float fDamage = Combat_Damage_GetAttributeBonus(oCreature, nHand, oWeapon, TRUE) * GetWeaponAttributeBonusFactor(oWeapon);
    fDamage += IsObjectValid(oWeapon) ? 0.5 * (DmgGetWeaponBaseDamage(oWeapon) + DmgGetWeaponMaxDamage(oWeapon)) : COMBAT_DEFAULT_UNARMED_DAMAGE;

    // If including crits
    if (AF_IsOptionEnabled(AF_OPT_CRITS_IN_DAMAGE)) {
        int nCritMod = IsUsingRangedWeapon(oCreature, oWeapon) ? CRITICAL_MODIFIER_RANGED : CRITICAL_MODIFIER_MELEE;
        float fCritChance = GetCreatureProperty(oCreature, nCritMod, PROPERTY_VALUE_TOTAL);
        fCritChance += GetItemStat(oWeapon, ITEM_STAT_CRIT_CHANCE_MODIFIER);
        if (HasAbility(oCreature, ABILITY_TALENT_BRAVERY))
            fCritChance += 3.5 * Max(0,GetArraySize(GetCreaturesInMeleeRing(oCreature,0.0,359.99,TRUE,0))-2);

        int autoCrit = 0;
        autoCrit += IsModalAbilityActive(oCreature, ABILITY_SKILL_STEALTH_1);
        autoCrit += GetHasEffects(oCreature, EFFECT_TYPE_AUTOCRIT);
        int neverCrit = 0;
        neverCrit += IsModalAbilityActive(oCreature, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE);
        neverCrit += IsModalAbilityActive(oCreature, ABILITY_TALENT_RAPIDSHOT);
        if (autoCrit > 0 || neverCrit > 0) {
            if (AF_IsOptionEnabled(AF_OPT_NORMALISE_CRITS)) {
                if (autoCrit > neverCrit)
                    fCritChance = 100.0;
                else if (autoCrit < neverCrit)
                    fCritChance = 0.0;
            } else {
                if (autoCrit > 0 && neverCrit > 0)
                    fCritChance = 100.0 - fCritChance;
                else if (autoCrit > 0)
                    fCritChance = 100.0;
                else
                    fCritChance = 0.0;
            }
        }
        float fCritMod = COMBAT_CRITICAL_DAMAGE_MODIFIER + 0.01*GetCreatureProperty(oCreature, 54);
        fDamage *= 1 + MinF(1.0, MaxF(0.0, 0.01*fCritChance))*(fCritMod-1);
    }

    fDamage += GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_DAMAGE_BONUS);
    if (IsModalAbilityActive(oCreature, ABILITY_TALENT_BLOOD_FRENZY))
    {
        float fCur = GetCreatureProperty(oCreature, PROPERTY_DEPLETABLE_HEALTH, PROPERTY_VALUE_CURRENT);
        float fMax = GetCreatureProperty(oCreature, PROPERTY_DEPLETABLE_HEALTH, PROPERTY_VALUE_TOTAL);
        fDamage += (10.0 * MaxF(0.0, 1.0 - fCur/fMax));
    }
    fDamage = MaxF(1.0, fDamage);

    // on-hit effects
    if (AF_IsOptionEnabled(AF_OPT_ONHIT_IN_DAMAGE)) {
        int[] arProps = GetItemProperties(oWeapon, TRUE);
        int i, nSize = GetArraySize(arProps);
        for (i = 0; i < nSize; i++) {
            int nProp = arProps[i];
            if (GetM2DAInt(TABLE_ITEMPRPS, "Effect", nProp) == EFFECT_TYPE_DAMAGE) {
                int nPower = GetItemPropertyPower(oWeapon, nProp, TRUE);
                float fScale = GetM2DAFloat(TABLE_ITEMPRPS, "Float0", nProp);
                float fChance = GetM2DAFloat(TABLE_ITEMPRPS, "ProcChance", nProp);
                fDamage += nPower*fScale*fChance;
            }
        }
    }

    return fDamage;
}

float _GetAttackLoopDuration(object oCreature) {
    float fTime;
    object oMain = GetItemInEquipSlot(INVENTORY_SLOT_MAIN,oCreature);
    if (IsUsingRangedWeapon(oCreature, oMain)) {
        int nArmorType = GetBaseItemType(GetItemInEquipSlot(INVENTORY_SLOT_CHEST, oCreature));
        int bSlow = nArmorType == BASE_ITEM_TYPE_ARMOR_MASSIVE || nArmorType == BASE_ITEM_TYPE_ARMOR_SUPERMASSIVE;
        bSlow |= nArmorType == BASE_ITEM_TYPE_ARMOR_HEAVY && !HasAbility(oCreature, ABILITY_TALENT_MASTER_ARCHER);
        int nBaseItemType = GetBaseItemType(oMain);

        float fAimDuration = GetCreatureRangedDrawSpeed(OBJECT_SELF, oMain);
        float fAttackDuration = (nBaseItemType == BASE_ITEM_TYPE_STAFF) ? 0.3 : bSlow ? 1.5 : 0.8;
        float fResetDuration;
        switch (nBaseItemType) {
            case BASE_ITEM_TYPE_SHORTBOW:
            case BASE_ITEM_TYPE_LONGBOW:
            fResetDuration = 0.8;
            break;
            case 21 /* crossbow */:
            fResetDuration = 0.9;
            break;
            case BASE_ITEM_TYPE_STAFF:
            fResetDuration = 1.25;
            break;
        }
        fTime = fAimDuration + fAttackDuration + fResetDuration;
    } else {
        int nStyle = GetWeaponStyle(oCreature);
        if (nStyle == WEAPONSTYLE_DUAL) {
            object oOff = GetItemInEquipSlot(INVENTORY_SLOT_MAIN,oCreature);
            float fMainTime = BASE_TIMING_DUAL_WEAPONS + GetM2DAFloat(TABLE_ITEMSTATS,"dspeed",GetBaseItemType(oMain));
            float fOffTime = BASE_TIMING_DUAL_WEAPONS + GetM2DAFloat(TABLE_ITEMSTATS,"dspeed",GetBaseItemType(oOff));
            if (IsModalAbilityActive(oCreature, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE))
                fTime = AF_IsOptionEnabled(AF_OPT_DUAL_STRIKING_TIMING) ? 0.5 * (fMainTime + fOffTime) : fMainTime;
            else
                fTime = fMainTime + fOffTime;
        } else {
            fTime = GetM2DAFloat(TABLE_ITEMSTATS,"dspeed",GetBaseItemType(oMain));
            switch (nStyle) {
                case WEAPONSTYLE_NONE:
                case WEAPONSTYLE_SINGLE:
                fTime += BASE_TIMING_WEAPON_SHIELD;
                break;
                case WEAPONSTYLE_TWOHANDED:
                fTime += BASE_TIMING_TWO_HANDED;
                break;
            }
        }
    }
    return fTime;
}

void _CrappyDefaultDisplayDamage(object oCreature, int nSlot= INVENTORY_SLOT_INVALID)
{

    if (nSlot == INVENTORY_SLOT_INVALID || nSlot == INVENTORY_SLOT_MAIN)
    {
        object oMain = GetItemInEquipSlot(INVENTORY_SLOT_MAIN,oCreature);
        float fStat =1.0f;
        if (IsObjectValid(oMain))
        {
            if (GetHasEffects(oCreature, EFFECT_TYPE_SHAPECHANGE))
            {
                fStat = CalculateWeaponDamage(oCreature, OBJECT_INVALID);
            }
            else
            {
                fStat = CalculateWeaponDamage(oCreature, oMain);
            }
        }
        // ---------------------------------------------------------------------
        // Unarmed
        // ---------------------------------------------------------------------
        else
        {
            fStat = AF_IsOptionEnabled(AF_OPT_RUNE_STACKING) ? CalculateWeaponDamage(oCreature, OBJECT_INVALID) : DmgGetWeaponDamage(OBJECT_INVALID) +  Combat_Damage_GetAttributeBonus(oCreature, HAND_MAIN, OBJECT_INVALID, TRUE) + GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_DAMAGE_BONUS);
        }
        SetCreatureProperty(oCreature, 50, fStat);
    }


    if (nSlot == INVENTORY_SLOT_INVALID || nSlot == INVENTORY_SLOT_OFFHAND)
    {
        object oOffHand = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND,oCreature);

        // ---------------------------------------------------------------------
        // Armed
        // ---------------------------------------------------------------------
        if (IsObjectValid(oOffHand))
        {
            float fStat = 0.0f;

            if (GetWeaponStyle(oCreature) == WEAPONSTYLE_DUAL)

            {
                fStat = CalculateWeaponDamage(oCreature, oOffHand, HAND_OFFHAND);
            }

            // -----------------------------------------------------------------
            // If the offhand item doesn't have damage, it's not a weapon and
            // we should not display it.
            // -----------------------------------------------------------------
            if (fStat >0.0f)
            {

                float fDamageScale = GetM2DAFloat(TABLE_AUTOSCALE,"fDamageScale", GetCreatureRank(oCreature));
                SetCreatureProperty(oCreature, 49, fStat);
            }
            else
            {
                 SetCreatureProperty(oCreature, 49, -99.0f);
            }
        }
        // ---------------------------------------------------------------------
        // Unarmed
        // ---------------------------------------------------------------------
        else
        {
            if (oOffHand == OBJECT_INVALID)
            {
                SetCreatureProperty(oCreature, 49, -98.0f);
            }

            SetCreatureProperty(oCreature,49,-97.0f);
        }
    }

}

void RecalculateDisplayDamage(object oCreature, int nSlot = INVENTORY_SLOT_INVALID) {
    int nDisplayMode = AF_GetOptionValue(AF_OPT_INVENTORY_DAMAGE);
    // If DPS
    if (nDisplayMode == 2) {
        object oMain = GetItemInEquipSlot(INVENTORY_SLOT_MAIN,oCreature);
        object oOff = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND,oCreature);
        int nStyle = GetWeaponStyle(oCreature);
        float fDmg = _GetAverageDamage(oCreature, oMain);
        if (nStyle == WEAPONSTYLE_DUAL)
            fDmg += _GetAverageDamage(oCreature, oOff);

        float fTime = _GetAttackLoopDuration(oCreature);
        float fSpeedMod = 1.0;
        if (IsUsingMeleeWeapon(oCreature, oMain)) {
            fSpeedMod = GetCreatureProperty(oCreature, PROPERTY_ATTRIBUTE_ATTACK_SPEED_MODIFIER);
            fSpeedMod = (fSpeedMod < 0.5f) ? 1.0 : MinF(1.5, MaxF(0.5, fSpeedMod));
        }

        float fDps = fDmg/(fTime*fSpeedMod);
        SetCreatureProperty(oCreature, 50, fDps);
        SetCreatureProperty(oCreature, 49, -100.0);
    // Raw damage
    } else if (nDisplayMode == 1) {
        object oMain = GetItemInEquipSlot(INVENTORY_SLOT_MAIN,oCreature);
        SetCreatureProperty(oCreature, 50, _GetAverageDamage(oCreature, oMain));
        if (GetWeaponStyle(oCreature) == WEAPONSTYLE_DUAL) {
            object oOff = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND,oCreature);
            SetCreatureProperty(oCreature, 49, _GetAverageDamage(oCreature, oOff));
        } else {
            SetCreatureProperty(oCreature, 49, -100.0);
        }
    } else {
        _CrappyDefaultDisplayDamage(oCreature, nSlot);
    }
}

// @brief  Returns if an ability can be interrupted by damage
// @author Georg
int CanInterruptSpell(int nAbi)
{
    if (GetAbilityType(nAbi) == ABILITY_TYPE_SPELL)
    {
        //Only spells of speed>0 are interruptible
        return GetM2DAInt(TABLE_ABILITIES_SPELLS,"Speed",nAbi);
    }
    return FALSE;
}




float GetDisableDeviceLevel(object oCreature)
{
    float fPlayerScore = 0.0f;

    if (HasAbility(oCreature, ABILITY_TALENT_HIDDEN_ROGUE))
    {
        fPlayerScore = GetAttributeModifier(oCreature, PROPERTY_ATTRIBUTE_INTELLIGENCE);

        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_SYSTEMS_PLACEABLES, GetCurrentScriptName(), "Intelligence Modifier = " + ToString(fPlayerScore));
        #endif

        int nSkillLevel = 0;
        if (HasAbility(oCreature, ABILITY_SKILL_LOCKPICKING_4))
        {
            nSkillLevel = 4;
        } else if (HasAbility(oCreature, ABILITY_SKILL_LOCKPICKING_3))
        {
            nSkillLevel = 3;
        } else if (HasAbility(oCreature, ABILITY_SKILL_LOCKPICKING_2))
        {
            nSkillLevel = 2;
        } else if (HasAbility(oCreature, ABILITY_SKILL_LOCKPICKING_1))
        {
            nSkillLevel = 1;
        }
        fPlayerScore += (10.0f * nSkillLevel);

        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_SYSTEMS_PLACEABLES, GetCurrentScriptName(), "With Skill = " + ToString(fPlayerScore));
        #endif
    }
    return fPlayerScore;
}

// @brief Return if the creature is a boss rank creature
// @author Georg
int IsCreatureBossRank(object oCreature)
{
    return GetM2DAInt(TABLE_CREATURERANKS, "IsBoss", GetCreatureRank(oCreature));
}

// @brief Returns if a creature is of special rank (lieutenant+)
// @author georg
int IsCreatureSpecialRank(object oCreature)
{
    return GetM2DAInt(TABLE_CREATURERANKS,"IsSpecial", GetCreatureRank(oCreature));
}


// @brief  Retrieve the floaty color associated with a specific type of damage
// @author Georg
int GetColorByDamageType(int nDamageType)
{
    int nColor = 0;
    nColor = GetM2DAInt(TABLE_DAMAGETYPES,"Color", nDamageType);
    return nColor;
}

// @brief Certain areas do not allow exiting combat mode
// @author Yaron
int IsNoExploreArea()
{
    return GetTag(GetArea(GetPartyLeader())) == "cli220ar_fort_roof_1";
}

int IsArmorMassive(object oArmor)
{
    if (!IsObjectValid(oArmor))
    {
        return FALSE;
    }
    int nType = GetBaseItemType(oArmor);

    return (nType == BASE_ITEM_TYPE_ARMOR_MASSIVE || nType == BASE_ITEM_TYPE_ARMOR_SUPERMASSIVE);

}


 int IsArmorHeavyOrMassive(object oArmor)
{
    if (!IsObjectValid(oArmor))
    {
        return FALSE;
    }

    int nType = GetBaseItemType(oArmor);
    return (nType == BASE_ITEM_TYPE_ARMOR_HEAVY || nType == BASE_ITEM_TYPE_ARMOR_MASSIVE || nType == BASE_ITEM_TYPE_ARMOR_SUPERMASSIVE);

}

int IsUsingEP1Resources()
{
    return TRUE;
}