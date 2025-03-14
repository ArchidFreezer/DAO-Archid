// -----------------------------------------------------------------------------
// effect_dot_h.nss
// -----------------------------------------------------------------------------
/*
    Effect: Damage over Time


    */
// -----------------------------------------------------------------------------
// Owner: Georg Zoeller
// -----------------------------------------------------------------------------

#include "core_h"
#include "effect_constants_h"
#include "2da_constants_h"
#include "effect_damage_h"
#include "ui_h"

const float CREATURE_RULES_TICK_DELAY = 1.5f;

const float STAT_UPDATE_COMBAT = 2.0;


/** ----------------------------------------------------------------------------
* @brief Remove an array of effects from a target;
*
* @returns  # of removed effects
* @author   Georg Zoeller
*  -----------------------------------------------------------------------------
**/
int RemoveEffectArray(object oTarget, effect[] aEffects)
{
    int nSize = GetArraySize(aEffects);
    int i;
    for ( i =0; i < nSize; i++)
    {
        RemoveEffect(oTarget, aEffects[i]);
    }
    return nSize;
}



effect[] GetDotEffectByDamageType(object oCreature, int nDamageType= DAMAGE_TYPE_FIRE)
{
    effect[] ret;

    effect[] effects = GetEffects(oCreature, EFFECT_TYPE_DOT );
    int nSize = GetArraySize(effects);
    int i;
    int j=0;

    for (i=0; i < nSize; i++)
    {
        if (GetEffectInteger(effects[i],1) == nDamageType)
        {
            ret[j++] = effects[i];
        }
    }

   return ret;
}

int HasDotEffectOfType(object oCreature, int nDamageType)
{
    return GetArraySize(GetDotEffectByDamageType(oCreature, nDamageType));
}



void RemoveFireBasedEffects(object oCreature)
{
    effect[] effects =  GetDotEffectByDamageType(oCreature, DAMAGE_TYPE_FIRE);
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_EFFECTS,"effect_dot2_h._EffectDOT()","Removing" + ToString(GetArraySize(effects)));
    #endif
    RemoveEffectArray(oCreature, effects);
}


void RemoveColdBasedEffects(object oCreature)
{
    effect[] effects =  GetDotEffectByDamageType(oCreature, DAMAGE_TYPE_COLD);
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_EFFECTS,"effect_dot2_h._EffectDOT()","Removing" + ToString(GetArraySize(effects)));
    #endif
    RemoveEffectArray(oCreature, effects);


    // -------------------------------------------------------------------------
    // Handle non DOT types
    // -------------------------------------------------------------------------
    effect[] effects2 = GetEffects(oCreature, EFFECT_TYPE_PETRIFY);
    int nSize = GetArraySize(effects2);

    if (nSize)
    {
        int i;
        int nId = 0;
        for (i = 0; i < nSize; i++)
        {
            nId = GetEffectAbilityID(effects2[i]);
            if (nId  == ABILITY_SPELL_CONE_OF_COLD || nId == ABILITY_SPELL_WINTERS_GRASP || nId == MONSTER_PRIDE_DEMON_FROST_BLAST || nId == MONSTER_PRIDE_DEMON_FROST_BOLT) /*note: blizzard handles this internally, do not interfere*/
            {
                RemoveEffect(oCreature, effects2[i]);
            }
        }
    }


}


int _EffectDotGetNumberOfTicks(float fDuration) {
    return FloatToInt(fDuration / CREATURE_RULES_TICK_DELAY) + 1 /*there's an initial tick at the start*/;
}

// DOT tick heartbeat may already be going when a new DOT is applied and we have no way of knowing when the next one will be.
// It could be the next tick or approaching 1.5 seconds away. To guarantee all ticks we set the timer to the # of intervals
// plus slightly less than one more tick interval. Because there is a tick at the start this works out to the # of ticks minus
// the timer granularity. The clock ticks 64x a second thus we subtract 1/64th
float _EffectDotGetAdjustedDuration(float fDuration) {
    return AF_IsOptionEnabled(AF_OPT_FIX_DOT_DURATIONS) ? CREATURE_RULES_TICK_DELAY*_EffectDotGetNumberOfTicks(fDuration) - 1.0/64.0 : fDuration + 0.5*CREATURE_RULES_TICK_DELAY;
}

float _EffectDotGetDamagePerTick(float fTotalDamage, float fDuration)
{
    int nTicks = _EffectDotGetNumberOfTicks(fDuration);

    return (fTotalDamage / IntToFloat(nTicks)) ;
}

///////////////////////////////////////////////////////////////////////////////
//  EffectDOT
///////////////////////////////////////////////////////////////////////////////

effect _EffectDOT(float fTotalDamage, float fDuration, int nVfx = 0, int nDamageType = DAMAGE_TYPE_FIRE, int nImpactVfx= 0)
{

    if (fDuration < 1.0f)
    {
        Warning("_EffectDOT created with zero duration. This is a problem. Please inform georg. Script: " + GetCurrentScriptName());
        fDuration = 1.0f;
    }

    if (nVfx == 0)
    {
        switch (nDamageType)
        {
            case DAMAGE_TYPE_FIRE: nVfx = 10;  break;
            case DAMAGE_TYPE_ELECTRICITY: nVfx = 1005; break;
            case DAMAGE_TYPE_COLD: nVfx = 1008; break;
        }
    }

    float fDamagePerTick = _EffectDotGetDamagePerTick( fTotalDamage, fDuration);
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_EFFECTS,"effect_dot2_h._EffectDOT()","Dot Ctor:  Damage" + ToString(fTotalDamage) + " over " + ToString(fDuration) + ": "  + ToString(fDamagePerTick));
    #endif
    effect eEffect = Effect( EFFECT_TYPE_DOT );
    eEffect = SetEffectFloat(eEffect, 0, fDamagePerTick);

    // -------------------------------------------------------------------------
    // Sorry, crusts will not play on lowest graphics detail level
    // -------------------------------------------------------------------------
    if (GetGraphicsDetailLevel()>0)
    {
        eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_VFX, nVfx);
    }
    eEffect = SetEffectInteger(eEffect, 1, nDamageType);
    eEffect = SetEffectInteger(eEffect, 2, nImpactVfx);


    return eEffect;
}




///////////////////////////////////////////////////////////////////////////////
//  Effects_HandleApplyEffectDOT
///////////////////////////////////////////////////////////////////////////////
int Effects_HandleApplyEffectDOT(effect eEffect)
{
    int nDamageType = GetEffectInteger(eEffect,1);

    object oCreator = GetEffectCreator(eEffect);

    int bFF  = IsFriendlyFireParty(oCreator, OBJECT_SELF);

    if (bFF)
    {

        if ((GetGameDifficulty() == GAME_DIFFICULTY_CASUAL) && (nDamageType != DAMAGE_TYPE_PLOT))
        {
            // Still get benefits from cancelling out effects.

            int nDamageType = GetEffectInteger(eEffect,1);
            if (nDamageType == DAMAGE_TYPE_FIRE)
            {
                RemoveColdBasedEffects(OBJECT_SELF);
            }
            else if (nDamageType == DAMAGE_TYPE_COLD)
            {
                RemoveFireBasedEffects(OBJECT_SELF);
            }

            return FALSE;
        }




    }


    if (GetEffectFloat(eEffect,0) >= 1.0)
    {
        // we only support creature dots
        if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
        {
            if (!GetCreatureFlag(OBJECT_SELF,CREATURE_RULES_FLAG_DOT))
            {
                SetCreatureFlag(OBJECT_SELF,CREATURE_RULES_FLAG_DOT);
                DelayEvent(0.0f, OBJECT_SELF, Event(EVENT_TYPE_DOT_TICK)); /*first event is just postponed to the next frame*/
            }
        }
        else
        {
            #ifdef DEBUG
            Warning ("DOT Effect applied to non creature. Talk To georg!!! Source:" + GetCurrentScriptName() + " on " + ToString(OBJECT_SELF));
            #endif
            return FALSE;
        }
    }
    else
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_EFFECTS,"effect_dot2_h", "DoT cancelled as individual tick damage is below 1.0f threshold");
        #endif
        return FALSE;
    }



    // -------------------------------------------------------------------------
    // Dot Effects cancel each other out...
    // -------------------------------------------------------------------------
    if (nDamageType == DAMAGE_TYPE_FIRE)
    {
        RemoveColdBasedEffects(OBJECT_SELF);
    }
    else if (nDamageType == DAMAGE_TYPE_COLD)
    {
        RemoveFireBasedEffects(OBJECT_SELF);
    }
    else
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_EFFECTS,"Effects_HandleApplyEffectDOT","....");
        #endif
    }




    return TRUE;
}

///////////////////////////////////////////////////////////////////////////////
//  Effects_HandleRemoveEffectDOT
///////////////////////////////////////////////////////////////////////////////
int Effects_HandleRemoveEffectDOT(effect eEffect)
{
    return TRUE;
}


// -----------------------------------------------------------------------------
// @brief Runs the DOT (causes damage)
//
// This is called from the DOT Event handler on the creatures and calculates
// and applies the damage for the passed in eEffect
//
// @param eEffect Effect of type EFFECT_TYPE_DOT
//
// @author Georg Zoeller
// -----------------------------------------------------------------------------
void Effects_HandleDotEffectTick(effect eEffect);
void Effects_HandleDotEffectTick(effect eEffect)
{

    // -------------------------------------------------------------------------
    // We don't ever tick these effects if we are not in an active game mode
    // e.g. dialog / conversation.
    // -------------------------------------------------------------------------
    int nGameMode = GetGameMode();
    if (nGameMode == GM_EXPLORE || nGameMode == GM_COMBAT)
    {
        float fDamage =  GetEffectFloat(eEffect,0);
        object oCreator = GetEffectCreator(eEffect);
        int nDamageType = GetEffectInteger(eEffect,1);
        int nImpactVfx =  GetEffectInteger(eEffect,2);

        if (nDamageType == DAMAGE_TYPE_FIRE)
        {
            RemoveColdBasedEffects(OBJECT_SELF);
        }
        else if (nDamageType == DAMAGE_TYPE_COLD)
        {
            RemoveFireBasedEffects(OBJECT_SELF);
        }

        int nAbilityId = GetEffectAbilityID(eEffect);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_EFFECTS,"effect_dot2_h.HandleTick()","Dot Ticking for: " + ToString(fDamage) + " id: " + ToString(nAbilityId) +" ImpVfx:" + ToString(nImpactVfx));
        #endif


        if (!DamageIsImmuneToType(OBJECT_SELF, nDamageType))
        {
            if ((GetHasEffects(OBJECT_SELF,EFFECT_TYPE_DAMAGE_WARD) == TRUE) && (nDamageType != DAMAGE_TYPE_PLOT))
            {
                // -------------------------------------------------------
                // Only message immunity if a PC is involved
                // -------------------------------------------------------
                if (IsPartyMember(OBJECT_SELF) || IsPartyMember(oCreator))
                {
                    UI_DisplayMessage(OBJECT_SELF, UI_MESSAGE_NO_EFFECT,"", GetColorByDamageType(nDamageType) );
                }
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT_DAMAGE,"effect_dot2_h", ToString(OBJECT_SELF) +" DAMAGE ZEROED because of DAMAGE_WARD_EFFECT") ;
                #endif
            } else
            {

                DEBUG_PrintToScreen("dt:" + ToString(nDamageType),6);
                Effects_ApplyInstantEffectDamage(OBJECT_SELF, oCreator, fDamage, nDamageType, DAMAGE_EFFECT_FLAG_UNRESISTABLE | DAMAGE_EFFECT_FLAG_FROM_DOT, nAbilityId, nImpactVfx);
            }
        }
        else
        {
              // -------------------------------------------------------
              // Only message immunity if a PC is involved
              // -------------------------------------------------------
              if (IsPartyMember(OBJECT_SELF) || IsPartyMember(oCreator))
              {
                  UI_DisplayMessage(OBJECT_SELF,  UI_MESSAGE_IMMUNE);
              }
        }

        // -------------------------------------------------------------------------
        // All Dot's kill stealth.
        // -------------------------------------------------------------------------
        DropStealth(OBJECT_SELF);
    }
}


// -----------------------------------------------------------------------------
// @brief DOT Event handler code called from creature_core and player_core
//
// This manages applying damage over time from all DOT effects.
//
// @param oCreature Creature that wants it's DOT effects processed
//
// @author Georg Zoeller
// -----------------------------------------------------------------------------
void Effects_HandleCreatureDotTickEvent(object oCreature = OBJECT_SELF);
void Effects_HandleCreatureDotTickEvent(object oCreature = OBJECT_SELF)
{
    effect[] effects = GetEffects(oCreature, EFFECT_TYPE_DOT);
    int nSize = GetArraySize(effects);
    int i;

    if (nSize == 0)
    {
        // ---------------------------------------------
        // Sync the flag to false if no DOTs are active
        // ---------------------------------------------
        SetCreatureFlag(oCreature,CREATURE_RULES_FLAG_DOT,FALSE);

        // ---------------------------------------------
        // We're not scheduling more ticks, so the HB dies here
        // ---------------------------------------------

    }
    else
    {
        for (i = 0; i < nSize; i++)
        {
            Effects_HandleDotEffectTick(effects[i]);
        }

        // ---------------------------------------------
        // Continue to tick...
        // ---------------------------------------------
        DelayEvent(CREATURE_RULES_TICK_DELAY, oCreature, Event(EVENT_TYPE_DOT_TICK));
        SetCreatureFlag(oCreature,CREATURE_RULES_FLAG_DOT);
    }
}


// -----------------------------------------------------------------------------
// Apply an affect DamageOverTime. Does factor in damage resistances.
// -----------------------------------------------------------------------------
void ApplyEffectDamageOverTime(object oTarget, object oCaster, int nAbility, float fTotalDamage, float fDuration, int nDamageType, int nCrustVfx = 0, int nImpactVfx = 0)
{
    float fDamage = GetModifiedDamage(oCaster, nDamageType, fTotalDamage);

    fDamage = ResistDamage(oCaster, oTarget, nAbility, fTotalDamage, nDamageType);

    effect eDot = _EffectDOT(fDamage, fDuration, nCrustVfx, nDamageType, nImpactVfx);

    if (nDamageType == DAMAGE_TYPE_FIRE)
    {
        int nAppearance = GetAppearanceType(oTarget);
        if (nAppearance == 65) // wild sylvan
        {
            eDot = SetEffectEngineInteger(eDot, EFFECT_INTEGER_VFX, 93092);
        }
    }

    //fduration is lengthened to allow the last tick to go through
    ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eDot, oTarget, _EffectDotGetAdjustedDuration(fDuration), oCaster, nAbility);
}