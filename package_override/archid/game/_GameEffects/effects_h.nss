// -----------------------------------------------------------------------------
// Effect Includes
// -----------------------------------------------------------------------------
/*
    This is the top level include for the effects system. All other files related
    to this system can be found under \_Game Effects\.

    Include Hierarchy:

    Effects_h includes \Game_Effects\effect_*_h includes "Effects_constants_h"
        includes core_h


*/
// -----------------------------------------------------------------------------
// Owner: Georg Zoeller
// -----------------------------------------------------------------------------

#include "effect_constants_h"
#include "events_h"
//#include "wrappers_h"
#include "2da_constants_h"
#include "core_h"
#include "effect_charm_h"
#include "ai_threat_h"

// -----------------------------------------------------------------------------
// Effect Includes
// -----------------------------------------------------------------------------
#include "effect_damage_h"
#include "effect_death_h"
//#include "effect_armorpenetration_h"
#include "effect_resurrection_h"
#include "effect_heal_h"
//#include "effect_damageresistance_h"
#include "effect_modify_mana_stam_h"
#include "effect_knockdown_h"
#include "effect_modify_attribute_h"
#include "effect_disease_h"
#include "effect_upkeep_h"
#include "effect_dot2_h"
#include "effect_daze_h"
#include "effect_paralyze_h"
#include "effect_dispel_magic_h"
#include "effect_modify_critchance_h"
#include "effect_modify_property_h"
#include "effect_root_h"
#include "effect_ai_modifier_h"
#include "effect_visualeffect_h"
#include "effect_impact_h"
#include "effect_sleep_h"

#include "effect_screenshake_h"
#include "effect_regeneration_h"
#include "effect_stun_h"
#include "effect_conecasting_h"

#include "effect_addability"
#include "effect_stealth_h"
#include "effect_test_h"
#include "effect_heartbeat_h"
#include "effect_rec_knockdown_h"
#include "effect_lyrium_h"
#include "effect_wbomb_h"
#include "effect_summon_h"
#include "effect_polymorph"
#include "effect_feign_death_h"

#include "effect_enchantment_h"
#include "effect_confusion_h"
#include "effect_swarm_h"
#include "effect_mabari_dominance_h"

#include "af_ability_h"

effect EffectModifyMovementSpeed(float fPotency, int bHostile=FALSE)
{
    effect eSlow;
    if (bHostile)
    {
        eSlow    = Effect(EFFECT_TYPE_MOVEMENT_RATE_DEBUFF);
    }
    else
    {
        eSlow    = Effect(EFFECT_TYPE_MOVEMENT_RATE);
    }
    eSlow = SetEffectEngineFloat(eSlow, EFFECT_FLOAT_POTENCY, fPotency);
    return eSlow;
}



effect EffectLifeWard(float fHealth)
{
    effect eRet = Effect(EFFECT_TYPE_LIFE_WARD);
    eRet = SetEffectFloat(eRet, 0, fHealth);
    return eRet;
}


int Effects_HandleRemoveEffectLifeWard (effect eEffect)
{

    if (!IsDeadOrDying(OBJECT_SELF))
    {
        float fHealth = GetEffectFloat(eEffect,0);
        HealCreature(OBJECT_SELF, TRUE, fHealth);
    }

    return TRUE;
}



int IsEffectTypeHostile(int nEffectType)
{
    return (GetM2DAInt(TABLE_EFFECTS, "bConsiderHostile", nEffectType) !=0);
}



// <Debug>
// -----------------------------------------------------------------------------
// This check is for preventing designers from applying an effect with a wrong
// duration type.
// -----------------------------------------------------------------------------
int _VerifyDurationType(effect eEffect, int nEffectType)
{

    string sCol;

    // -------------------------------------------------------------------------
    // Get the current duration type on the effect
    // -------------------------------------------------------------------------
    int nDuration = GetEffectDurationType(eEffect);


    // -------------------------------------------------------------------------
    // Determine which column in effects.xls we need to check to verify it
    // -------------------------------------------------------------------------
    switch (nDuration)
    {
      case  EFFECT_DURATION_TYPE_PERMANENT: sCol = "AllowPermanent"; break;
      case  EFFECT_DURATION_TYPE_INSTANT: sCol = "AllowInstant"; break;
      case  EFFECT_DURATION_TYPE_TEMPORARY: sCol = "AllowTemporary"; break;
    }


    // -------------------------------------------------------------------------
    // Check what the 2da says about the effect
    // -------------------------------------------------------------------------
    int nRet = GetM2DAInt(TABLE_EFFECTS,sCol,nEffectType);


    // -------------------------------------------------------------------------
    // If the 2da column value for the effect is not 1, we're in trouble
    // -------------------------------------------------------------------------
    if (nRet != 1)
    {
        #ifdef DEBUG
        string sEffect = GetM2DAString(TABLE_EFFECTS,"Label",nEffectType);
        Log_Systems("CRITICAL: - Effect " + sEffect + " applied with invalid (effects.xls) duration type " + IntToString(nDuration),LOG_LEVEL_CRITICAL);
        #endif
    }

    return (nRet == 1?TRUE:FALSE);

}
// </Debug>


// -----------------------------------------------------------------------------
// This handles rules_core.EVENT_TYPE_APPLY_EFFECT.
// -----------------------------------------------------------------------------
int Effects_HandleApplyEffect()
{
    effect eEffect = GetCurrentEffect();
    int nEffectType = GetEffectType(eEffect);
    int nReturnValue = -1;
    object oCreator = GetEffectCreator(eEffect);
    int nAbilityId = GetEffectAbilityID(eEffect);


    // <Debug>
    // -------------------------------------------------------------------------
    // If logging is enabled, we also verify that the effect we are trying to
    // apply here is applied with an allowed duration type. if not, fail it.
    // -------------------------------------------------------------------------
    /*if (LOG_ENABLED)
    {
        _VerifyDurationType(eEffect, nEffectType);
        SetIsCurrentEffectValid(FALSE);
        return FALSE;
    }*/
    //


     string sTypeName = Log_GetEffectNameById(nEffectType);

    #ifdef DEBUG
    Log_Trace_Effects("effects_h.HandleApplyEffect",eEffect, "", OBJECT_SELF);
    #endif

    //</Debug>

    // -------------------------------------------------------------------------
    // Dead creatures no longer accept any other effect except for resurrection || death!
    // -------------------------------------------------------------------------
    if (IsDead(OBJECT_SELF) &&( nEffectType != EFFECT_TYPE_RESURRECTION && nEffectType != EFFECT_TYPE_DEATH) )
    {
        #ifdef DEBUG
        Log_Trace_Effects("effects_h.HandleApplyEffect",eEffect, "EFFECT_REJECTED - target is dead" ,OBJECT_SELF);
        #endif

        nReturnValue = FALSE;
    }
    else
    {
        if ( GetObjectType(OBJECT_SELF) == OBJECT_TYPE_CREATURE)
        {

            int nMessage = UI_MESSAGE_IMMUNE;

            // -----------------------------------------------------------------
            //  Knockdown and stun end grab
            // -----------------------------------------------------------------
            if (nEffectType == EFFECT_TYPE_KNOCKDOWN || nEffectType == EFFECT_TYPE_STUN || nEffectType == EFFECT_TYPE_PARALYZE || nEffectType == EFFECT_TYPE_SLIP )
            {


                effect[] aGrab = GetEffects(OBJECT_SELF, EFFECT_TYPE_GRABBING, 0, OBJECT_SELF);
                if (RemoveEffectArray(OBJECT_SELF,aGrab)>0)
                {
                    #ifdef DEBUG
                     Log_Trace_Effects("effects_h.HandleApply",eEffect,"any grabbing effect removed by other effect!", OBJECT_SELF);
                    #endif
                    nMessage = UI_MESSAGE_GRAB_BROKEN;
                }
                else
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("effects_h.HandleApply",eEffect,"conecasting effect removed by stun!", OBJECT_SELF);
                    #endif
                    effect[] aCast = GetEffects(OBJECT_SELF, EFFECT_TYPE_CONECASTING, 0, OBJECT_SELF);
                    RemoveEffectArray(OBJECT_SELF,aCast);
                }


            }
            if (nEffectType == EFFECT_TYPE_GRABBED || nEffectType == EFFECT_TYPE_PARALYZE)
            {
                #ifdef DEBUG
                Log_Trace_Effects("effects_h.HandleApply",eEffect,"conecasting effect removed by grab or paralyze!", OBJECT_SELF);
                #endif
                effect[] aCast = GetEffects(OBJECT_SELF, EFFECT_TYPE_CONECASTING, 0, OBJECT_SELF);
                RemoveEffectArray(OBJECT_SELF,aCast);
            }

            // -----------------------------------------------------------------
            // Implementation for spell ward.
            // -----------------------------------------------------------------
            if (GetAbilityType(nAbilityId) == ABILITY_TYPE_SPELL)
            {
                if (GetHasEffects(OBJECT_SELF, EFFECT_TYPE_SPELL_WARD))
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("effects_h.HandleApply",eEffect,"spell effect not applied, creature has EFFECT_SPELL_WARD!", OBJECT_SELF);
                    #endif
                    ApplyEffectVisualEffect(oCreator, OBJECT_SELF, 1556, EFFECT_DURATION_TYPE_INSTANT, 0.0f, nAbilityId);
                    UI_DisplayMessage(OBJECT_SELF,UI_MESSAGE_SPELL_IMMUNITY);
                    nReturnValue =  FALSE;
                }
            }

            if (nReturnValue == -1)
            {
                int nImmune = IsImmuneToEffectType(OBJECT_SELF,nEffectType);
                if (nImmune>0 )
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("effects_h.HandleApply",eEffect,"effect not applied, creature immune!", OBJECT_SELF);
                    #endif
                    if (nImmune == 1)
                    {
                        UI_DisplayMessage(OBJECT_SELF,nMessage);
                    }
                    else if (nImmune == 3)
                    {
                        UI_DisplayMessage(OBJECT_SELF,UI_MESSAGE_RESISTED);
                    }

                    nReturnValue =  FALSE;
                }
            }
        }

        // ---------------------------------------------------------------------
        // Georg: Invalidate hostile effects per target
        // ---------------------------------------------------------------------
        if (nReturnValue != FALSE )
        {
            if (IsEffectTypeHostile(nEffectType))
            {
                if (IsHostileEffectAllowed(OBJECT_SELF,oCreator,nAbilityId) == FALSE)
                {
                    #ifdef DEBUG
                    Log_Trace_Effects("effects_h.HandleApply",eEffect,"hostile effect NOT applied - not allowed on target", OBJECT_SELF);
                    #endif
                    nReturnValue = FALSE;
                }
            }

        }


        if (GetM2DAInt (TABLE_EFFECTS,"SimpleEffect", nEffectType))
        {
            nReturnValue = TRUE;
        }
        
         // Shale's new Stone Will effects; immunity to knockback
        if (GetHasEffects(OBJECT_SELF, EFFECT_TYPE_INVALID, AF_ABILITY_STONE_WILL) && nEffectType == EFFECT_TYPE_KNOCKBACK)
        {
            // knockback alone has to be handled here because of SimpleEffect flag...
            UI_DisplayMessage(OBJECT_SELF, UI_MESSAGE_IMMUNE);
            nReturnValue = FALSE;
        }
    
        if (nReturnValue == -1)
        {

            switch (nEffectType)
            {
                case EFFECT_TYPE_NULL:
                case EFFECT_TYPE_HEAVY_IMPACT:
                case EFFECT_TYPE_LIFE_WARD:
                case EFFECT_TYPE_PETRIFY:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_DAMAGE:
                {
                    nReturnValue = Effects_HandleApplyEffectDamage(eEffect);
                    break;
                }

                case EFFECT_TYPE_DEATH:
                {
                    nReturnValue = Effects_HandleApplyEffectDeath(eEffect);
                    break;
                }




                case EFFECT_TYPE_RESURRECTION:
                {
                    nReturnValue = Effects_HandleApplyEffectResurrection(eEffect);
                    break;
                }
                case EFFECT_TYPE_MODIFYMANASTAMINA:
                {
                    nReturnValue = Effects_HandleApplyEffectModifyManaStamina(eEffect);
                    break;
                }
                case EFFECT_TYPE_HEALHEALTH:
                {
                    nReturnValue = Effects_HandleApplyEffectHeal(eEffect);
                    break;
                }
                case EFFECT_TYPE_ROOT:
                {
                    nReturnValue = Effects_HandleApplyEffectRoot(eEffect);
                    AI_Threat_ClearEnemiesThreatToMe(OBJECT_SELF);
                    break;
                }
                case EFFECT_TYPE_KNOCKDOWN:
                {
                    nReturnValue = Effects_HandleApplyEffectKnockdown(eEffect);
                    break;
                }
                case EFFECT_TYPE_MODIFYATTRIBUTE:
                {
                    nReturnValue = Effects_HandleApplyEffectModifyAttribute(eEffect);
                    break;
                }
               case EFFECT_TYPE_UPKEEP:
                {
                    nReturnValue = Effects_HandleApplyEffectUpkeep(eEffect);
                    break;
                }
               case EFFECT_TYPE_DOT:
                {
                    nReturnValue = Effects_HandleApplyEffectDOT(eEffect);
                    break;
                }
                case EFFECT_TYPE_DAZE:
                {
                    nReturnValue = Effects_HandleApplyEffectDaze(eEffect);
                    break;

                }
                case EFFECT_TYPE_DISEASE:
                {
                    nReturnValue = Effects_HandleApplyEffectDisease(eEffect);
                    break;

                }
                case EFFECT_TYPE_DISPEL_MAGIC:
                {
                    nReturnValue = Effects_HandleApplyEffectDispelMagic(eEffect);
                    break;
                }
                case EFFECT_TYPE_MODIFY_CRITCHANCE:
                {
                    nReturnValue = Effects_HandleApplyEffectModifyCritChance(eEffect);
                    break;
                }
                case EFFECT_TYPE_DECREASE_PROPERTY:
                case EFFECT_TYPE_MODIFY_PROPERTY:
                {
                    nReturnValue = Effects_HandleApplyEffectModifyProperty(eEffect);
                    break;
                }
                case EFFECT_TYPE_AI_MODIFIER:
                {
                    nReturnValue = Effects_HandleApplyEffectAIModifier(eEffect);
                    break;
                }
                case EFFECT_TYPE_ADDABILITY:
                {
                    nReturnValue = Effects_HandleApplyEffectAddAbility(eEffect);
                    break;
                }

                case EFFECT_TYPE_CONECASTING:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_ROOTING:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_GRABBING:
                case EFFECT_TYPE_GRABBED:
                case EFFECT_TYPE_OVERWHELMED:
                case EFFECT_TYPE_OVERWHELMING: /*intentional fallthrough*/
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_REGENERATION:
                {
                    nReturnValue = Effects_HandleApplyEffectRegeneration(eEffect);
                    break;
                }
                case EFFECT_TYPE_STUN:
                {
                    nReturnValue = Effects_HandleApplyEffectStun(eEffect);
                    break;
                }
                case EFFECT_TYPE_CONFUSION:
                {
                    nReturnValue = Effects_HandleApplyEffectConfusion(eEffect);
                    break;
                }
                case EFFECT_TYPE_CHARM:
                {
                    nReturnValue = Effects_HandleApplyEffectCharm(eEffect);
                    break;
                }

                case EFFECT_TYPE_SLEEP:
                case EFFECT_TYPE_SLEEP_PLOT:
                {
                    nReturnValue = Effects_HandleApplyEffectSleep(eEffect);
                    AI_Threat_ClearEnemiesThreatToMe(OBJECT_SELF);
                    break;
                }
                case EFFECT_TYPE_STEALTH:
                {
                    nReturnValue = Effects_HandleApplyEffectStealth(eEffect);
                    break;
                }
                case EFFECT_TYPE_TEST: // 11/15/07
                {
                    nReturnValue = Effects_HandleApplyEffectTest(eEffect);
                    break;
                }
                case EFFECT_TYPE_HEARTBEAT:
                {
                    nReturnValue = Effects_HandleApplyEffectHeartbeat(eEffect);
                    break;
                }
                case EFFECT_TYPE_RECURRING_KNOCKDOWN: // 05/12/07
                {
                    nReturnValue = Effects_HandleApplyEffectRecurringKnockdown(eEffect);
                    break;
                }
                case EFFECT_TYPE_WALKING_BOMB:
                {
                  nReturnValue = Effects_HandleApplyEffectWalkingBomb(eEffect);
                  AI_Threat_ClearEnemiesThreatToMe(OBJECT_SELF);
                  break;
                }
                case EFFECT_TYPE_SUMMON:
                {
                  nReturnValue = Effects_HandleApplyEffectSummon(eEffect);
                  break;
                }
                case EFFECT_TYPE_SHAPECHANGE:
                {
                    nReturnValue = Effects_HandleApplyEffectShapechange(eEffect);
                    break;
                }
                case EFFECT_TYPE_ENCHANTMENT:
                {
                    nReturnValue = Effects_HandleApplyEffectEnchantment(eEffect);
                    break;
                }
                case EFFECT_TYPE_LOCK_INVENTORY:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_LOCK_QUICKBAR:
                {
                    nReturnValue = TRUE;

                    break;
                }
                case EFFECT_TYPE_LOCK_CHARACTER:
                {
                    nReturnValue = TRUE;

                    break;
                }
                case EFFECT_TYPE_FEIGN_DEATH:
                {
                    nReturnValue = Effects_HandleApplyEffectFeignDeath(eEffect);
                    break;
                }


                case EFFECT_TYPE_SIMULATE_DEATH:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_FLANK_IMMUNITY:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_FEAR:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_MISDIRECTION_HEX:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_DEATH_HEX:
                {
                    nReturnValue = TRUE;
                    break;
                }

                case EFFECT_TYPE_CURSE_OF_MORTALITY:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_SLIP:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_SPELL_WARD:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_DAMAGE_WARD:
                {
                    nReturnValue = TRUE;
                    AI_Threat_ClearEnemiesThreatToMe(OBJECT_SELF);
                    break;
                }
                case EFFECT_TYPE_WYNNE_REMOVAL:
                {
                    nReturnValue = TRUE;
                    break;
                }
                case EFFECT_TYPE_SWARM:
                {
                  nReturnValue = Effects_HandleApplyEffectSwarm(eEffect);
                  break;
                }
                case EFFECT_TYPE_MABARI_DOMINANCE:
                {
                  nReturnValue = Effects_HandleApplyEffectMabariDominance(eEffect);
                  break;
                }



                /*switch*/

            } /* if nReturnValue == -1 */
        }
    } /*if*/


    // -------------------------------------------------------------------------
    // Notify if we forgot to handle an effect
    // -------------------------------------------------------------------------
    if (nReturnValue == -1)
    {
        #ifdef DEBUG
        Warning("EFFECT_NOT_HANDLED! " + Log_GetEffectNameById(nEffectType) + ".  + Contact Georg");
        Log_Trace_Scripting_Error("effects_h.HandleApplyEffect", "EFFECT_NOT_HANDLED! " + Log_GetEffectNameById(nEffectType) , OBJECT_SELF);
        #endif
        nReturnValue = FALSE;
    }

    // -------------------------------------------------------------------------
    // This notifies the engine on whether or not to go ahead with applying the
    // effect. If this is false, the engine will discard the effect, firing a
    // RemoveEffect event to rules_core, which will message it to Effects_HandleRemoveEffect
    // below
    // -------------------------------------------------------------------------
    if (nReturnValue == 0)
    {
        #ifdef DEBUG
        Log_Trace_Effects("effects_h.HandleApply",eEffect,"effect found not valid (FALSE reported back)", OBJECT_SELF);
        #endif
    }

    if (nReturnValue == TRUE)
    {
        // ---------------------------------------------------------------------
        // Certain effects kill stealth.
        // ---------------------------------------------------------------------
        if (GetM2DAInt(TABLE_EFFECTS,"bDropStealth",nEffectType))
        {
            SignalEventDropStealth(OBJECT_SELF);
        }

    }


    SetIsCurrentEffectValid(nReturnValue );
    return nReturnValue;
}

// -----------------------------------------------------------------------------
// This handles rules_core.EVENT_TYPE_REMOVE_EFFECT.
// -----------------------------------------------------------------------------
int Effects_HandleRemoveEffect()
{
    effect eEffect = GetCurrentEffect();
    int nEffectType = GetEffectType(eEffect);
    int nReturnValue = FALSE;


    #ifdef DEBUG
    Log_Trace_Effects("effects_h.HandleRemoveEffect",eEffect, "",  OBJECT_SELF);
    #endif

    if (GetM2DAInt (TABLE_EFFECTS,"SimpleEffect", nEffectType))
    {
        nReturnValue = TRUE;
    }

        if (nReturnValue == FALSE)
        {
        switch (nEffectType)
        {

              case EFFECT_TYPE_NULL:
                    {
                        nReturnValue = 1;
                        break;
                    }

            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_HEAVY_IMPACT:
            {
                nReturnValue = 1;        /*anim only effect, no need for handler*/
                break;
            }

            case EFFECT_TYPE_RESURRECTION:
            {
                nReturnValue = Effects_HandleRemoveEffectResurrection(eEffect);
                break;
            }
            case EFFECT_TYPE_DEATH:
            {
                nReturnValue = Effects_HandleRemoveEffectDeath(eEffect);
                break;
            }
            case EFFECT_TYPE_MODIFYMANASTAMINA:
            {
                nReturnValue = Effects_HandleRemoveEffectModifyManaStamina(eEffect);
                break;
            }
            case EFFECT_TYPE_HEALHEALTH:
            {
                nReturnValue = Effects_HandleRemoveEffectHeal(eEffect);
                break;
            }
            case EFFECT_TYPE_ROOT:
            {
                nReturnValue = Effects_HandleRemoveEffectRoot(eEffect);
                break;
            }
            case EFFECT_TYPE_KNOCKDOWN:
            {
                nReturnValue = Effects_HandleRemoveEffectKnockdown(eEffect);
                break;
            }
            case EFFECT_TYPE_MODIFYATTRIBUTE:
            {
                nReturnValue = Effects_HandleRemoveEffectModifyAttribute(eEffect);
                break;
            }
            case EFFECT_TYPE_UPKEEP:
            {
                nReturnValue = Effects_HandleRemoveEffectUpkeep(eEffect);
                break;
            }
            case EFFECT_TYPE_CHARM:
            {
                nReturnValue = Effects_HandleRemoveEffectCharm(eEffect);
                break;
            }
            case EFFECT_TYPE_CONFUSION:
            {
                nReturnValue = Effects_HandleRemoveEffectConfusion(eEffect);
                break;
            }
            case EFFECT_TYPE_DOT:
            {
                nReturnValue = Effects_HandleRemoveEffectDOT(eEffect);
                break;
            }
            case EFFECT_TYPE_DAZE:
            {
                nReturnValue = Effects_HandleRemoveEffectDaze(eEffect);
                break;
            }
            case EFFECT_TYPE_DISEASE:
            {
                nReturnValue = Effects_HandleRemoveEffectDisease(eEffect);
                break;
            }
            case EFFECT_TYPE_DISPEL_MAGIC:
            {
                nReturnValue = Effects_HandleRemoveEffectDispelMagic(eEffect);
                break;
            }
            case EFFECT_TYPE_MODIFY_CRITCHANCE:
            {
                nReturnValue = Effects_HandleRemoveEffectModifyCritChance(eEffect);
                break;
            }
            case EFFECT_TYPE_DECREASE_PROPERTY:
            case EFFECT_TYPE_MODIFY_PROPERTY:
            {
                nReturnValue = Effects_HandleRemoveEffectModifyProperty(eEffect);
                break;
             }
            case EFFECT_TYPE_LIFE_WARD:
            {
                nReturnValue = Effects_HandleRemoveEffectLifeWard(eEffect);
                break;
            }
            case EFFECT_TYPE_AI_MODIFIER:
            {
                nReturnValue = Effects_HandleRemoveEffectAIModifier(eEffect);
                break;
            }
            case EFFECT_TYPE_ADDABILITY:
            {
                nReturnValue = Effects_HandleRemoveEffectAddAbility(eEffect);
                break;
            }
            case EFFECT_TYPE_ROOTING:
            {
                   nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_GRABBING:
            case EFFECT_TYPE_OVERWHELMING: /*intentional fallthrough*/
            {
                 // Get target that was being grabbed
                 object oCreator = GetEffectCreator(eEffect);
                 object oTarget = GetEffectObject(eEffect, 1);
                 int nAbilityId = GetEffectAbilityID(eEffect);

                 // Remove all grabbing effect (there due this ogre grab)
                  effect[] aEffects = GetEffects(oTarget, nEffectType - 1, GetEffectAbilityID(eEffect), OBJECT_SELF);
                  RemoveEffectArray(oTarget, aEffects);
                  Ability_SetCooldown(oCreator, nAbilityId);

                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_GRABBED:
            case EFFECT_TYPE_OVERWHELMED:  /*intentional fallthrough*/
            {
                // -----------------------------------------------------------------
                // break grab if target dies
                // -----------------------------------------------------------------
                // Get target that was being grabbed
                  object oCreator = GetEffectCreator(eEffect);
                  int nAbilityId = GetEffectAbilityID(eEffect);

                 // Remove all grabbing effect (there due this ogre grab)
                  effect[] aEffects = GetEffects(oCreator,nEffectType + 1, nAbilityId, oCreator);
                  RemoveEffectArray(oCreator, aEffects);
                  nReturnValue = TRUE;

                break;
            }


             case EFFECT_TYPE_CONECASTING:
             {

                  nReturnValue = TRUE;
                break;
            }


            case EFFECT_TYPE_REGENERATION:
            {
                nReturnValue = Effects_HandleRemoveEffectRegeneration(eEffect);
                break;
            }
            case EFFECT_TYPE_STUN:
            {
                nReturnValue = Effects_HandleRemoveEffectStun(eEffect);
                break;
            }
             case EFFECT_TYPE_SLEEP:
             case EFFECT_TYPE_SLEEP_PLOT:
            {
                nReturnValue = Effects_HandleRemoveEffectSleep(eEffect);
                break;
            }
            case EFFECT_TYPE_STEALTH:
            {
                nReturnValue = Effects_HandleRemoveEffectStealth(eEffect);
                break;
            }
            case EFFECT_TYPE_TEST: // 15/11/07
            {
                nReturnValue = Effects_HandleRemoveEffectTest(eEffect);
                break;
            }
            case EFFECT_TYPE_HEARTBEAT:
            {
                nReturnValue = Effects_HandleRemoveEffectHeartbeat(eEffect);
                break;
            }
            case EFFECT_TYPE_RECURRING_KNOCKDOWN: // 05/12/07
            {
                nReturnValue = Effects_HandleRemoveEffectRecurringKnockdown(eEffect);
                break;
            }
            case EFFECT_TYPE_WALKING_BOMB:
            {
                nReturnValue = Effects_HandleRemoveEffectWalkingBomb(eEffect);
                break;
            }
            case EFFECT_TYPE_SUMMON:
            {
              nReturnValue = Effects_HandleRemoveEffectSummon(eEffect);
              break;
            }
            case EFFECT_TYPE_SHAPECHANGE:
            {
                nReturnValue = Effects_HandleRemoveEffectShapechange(eEffect);
                break;
            }
            case EFFECT_TYPE_ENCHANTMENT:
            {
                nReturnValue = Effects_HandleRemoveEffectEnchantment(eEffect);
                break;
            }
            case EFFECT_TYPE_LOCK_INVENTORY:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_LOCK_QUICKBAR:
            {
                nReturnValue = TRUE;

                break;
            }
            case EFFECT_TYPE_LOCK_CHARACTER:
            {
                nReturnValue = TRUE;

                break;
            }
            case EFFECT_TYPE_FEIGN_DEATH:
            {
                nReturnValue = Effects_HandleRemoveEffectFeignDeath(eEffect);
                break;
            }
            case EFFECT_TYPE_SIMULATE_DEATH:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_FLANK_IMMUNITY:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_FEAR:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_MISDIRECTION_HEX:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_DEATH_HEX:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_CURSE_OF_MORTALITY:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_SLIP:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_SPELL_WARD:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_DAMAGE_WARD:
            {
                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_WYNNE_REMOVAL:
            {
                int nAbility = GetEffectAbilityID(eEffect);
                if (IsModalAbilityActive(OBJECT_SELF, nAbility) == TRUE)
                {
                    Effects_RemoveUpkeepEffect(OBJECT_SELF, nAbility);

                    // add weakness effect
                    effect eEffect = EffectModifyProperty(PROPERTY_ATTRIBUTE_ATTACK, WYNNE_ATTACK_PENALTY,
                                                   PROPERTY_ATTRIBUTE_DEFENSE, WYNNE_DEFENSE_PENALTY);
                    eEffect = SetEffectEngineInteger(eEffect, EFFECT_INTEGER_VFX, WYNNE_WEAKNESS_VFX);
                    ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, OBJECT_SELF, WYNNE_WEAKNESS_DURATION, OBJECT_SELF, nAbility);
                    eEffect = EffectModifyMovementSpeed(WYNNE_SPEED_PENALTY);
                    ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, OBJECT_SELF, WYNNE_WEAKNESS_DURATION, OBJECT_SELF, nAbility);

                    // if trinket not present
                    if (IsObjectValid(GetItemPossessedBy(OBJECT_SELF, "gen_im_acc_amu_am11")) == FALSE)
                    {
                        eEffect = EffectStun();
                        ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eEffect, OBJECT_SELF, WYNNE_STUN_DURATION, OBJECT_SELF, nAbility);
                    }
                }

                nReturnValue = TRUE;
                break;
            }
            case EFFECT_TYPE_SWARM:
            {
                nReturnValue = Effects_HandleRemoveEffectSwarm(eEffect);
                break;
            }
            case EFFECT_TYPE_MABARI_DOMINANCE:
            {
                nReturnValue = Effects_HandleRemoveEffectMabariDominance(eEffect);
                break;
            }


        }
    }
    return nReturnValue;
}




effect EffectEnchantment(int nType = 3000, int nPower = 1)
{
    effect eEffect = Effect( EFFECT_TYPE_ENCHANTMENT);
    eEffect = SetEffectInteger(eEffect, 0, nType);
    eEffect = SetEffectInteger(eEffect, 1, nPower);
    return eEffect;
}


void MakeCreatureGhost(object oCreature, int bGhost = 1)
{
    effect eGhost = Effect(EFFECT_TYPE_ALPHA);
    eGhost = SetEffectEngineFloat(eGhost, EFFECT_FLOAT_POTENCY, 0.5);
    //eGhost = SetEffectEngineInteger(eGhost, EFFECT_INTEGER_VFX, VFX_CRUST_GHOST);
    Engine_ApplyEffectOnObject(5, eGhost, oCreature, 0.0f,oCreature, 0);
    // Visual effect to make ghosts spiffier.
    effect eVFX = EffectVisualEffect(VFX_CRUST_GHOST);
    Engine_ApplyEffectOnObject(5, eVFX, oCreature, 0.0f,oCreature, 0);

}

void ExplosionAtLocation(location lLoc, int nVFX, float fMinDamage, float fMaxDamage, int nDamageType, float fRadius)
{
    // play explosion vfx at location
    effect eEffect = EffectVisualEffect(nVFX);
    Engine_ApplyEffectAtLocation(EFFECT_DURATION_TYPE_INSTANT, eEffect, lLoc, 0.0f);

    // get objects in radius
    object[] oTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE, SHAPE_SPHERE, lLoc, fRadius);

    float fDamage;

    // apply damage to objects in loop
    int nCount = 0;
    int nMax = GetArraySize(oTargets);
    for (nCount = 0; nCount < nMax; nCount++)
    {
        fDamage = (RandomFloat() * (fMaxDamage - fMinDamage)) + fMinDamage;
        eEffect = EffectDamage(fDamage, nDamageType);
        ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, eEffect, oTargets[nCount], 0.0f);
    }
}



/** ----------------------------------------------------------------------------
* @brief This removes any effect (and any additional effect of the same ability id)
*        from a creature as a result of a plot event, such as:
*
*        - UT_Jump
*        - Dialog Start
*
* @author   Georg Zoeller
*  -----------------------------------------------------------------------------
**/
void RemoveEffectsDueToPlotEvent(object oCreature)
{
    effect[] effects = GetEffects(oCreature);
    int i;
    int nSize = GetArraySize(effects);

    for (i=0;i<nSize;i++)
    {
        if (IsEffectValid(effects[i]))
        {
            int bCancel = GetM2DAInt(TABLE_EFFECTS,"CancelOnPlotEvent", GetEffectType(effects[i]));
            int id = GetEffectAbilityID(effects[i]);
            if (bCancel)
            {
                if (id == 0)
                {
                    RemoveEffect(oCreature, effects[i]);
                }
                else
                {
                    RemoveEffectsByParameters(oCreature, EFFECT_TYPE_INVALID, id);
                }
            }

        }
    }
}