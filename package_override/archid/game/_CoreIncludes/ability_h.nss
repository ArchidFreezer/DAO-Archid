// ----------------------------------------------------------------------------
// ability_h - Ability System Functions
// ----------------------------------------------------------------------------
/*
    General Purpose functions dealing with the ability/talent/spell system,
    including, but not limited to:

    - Calculating and Subtracting Ability Costs
    - Invoking and rerouting Spellscript events
    - Wrappers for dealing with Upkeep Effects applied by Abilities

*/
// ----------------------------------------------------------------------------
// Owner: Georg Zoeller
// ----------------------------------------------------------------------------
#include "effects_h"
#include "2da_constants_h"
#include "config_h"
#include "events_h"
#include "items_h"
#include "sys_resistances_h"

const int ABILITY_RESIST_RESULT_FAILURE = 0;

const int ABILITY_COST_TYPE_NONE    = 0;
const int ABILITY_COST_TYPE_HEALTH  = 1;
const int ABILITY_COST_TYPE_MANA    = 2;
const int ABILITY_COST_TYPE_STAMINA = 4;

// abi flags
const int ABILITY_FLAG_RANGED_WEAPON      = 1;  /*0x01*/

// free:
//
const int ABILITY_FLAG_END_ON_OUT_OF_MANA = 64; /*0x40*/
const int ABILITY_FLAG_DISPELLABLE = 128;       /*0x80*/
const int ABILITY_FLAG_CURABLE = 256;           /*0x100*/


// flanking constants
const float ABILITY_FLANK_SIZE_BACK = 60.0f;
const float ABILITY_FLANK_SIZE_BACK2 = 45.0f;
const float ABILITY_FLANK_SIZE_SIDE = 60.0f;
const float ABILITY_FLANK_SIZE_LARGE_SIDE = 90.0f;
const float ABILITY_FLANK_SIZE_FRONT = 130.f;
const float ABILITY_FLANK_FACING_BACK_LEFT = -135.0f;
const float ABILITY_FLANK_FACING_BACK_RIGHT = 135.0f;
const float ABILITY_FLANK_FACING_BACK_LEFT2 = -160.0f;
const float ABILITY_FLANK_FACING_BACK_RIGHT2 = 160.0f;
const float ABILITY_FLANK_FACING_LEFT = -60.0f;
const float ABILITY_FLANK_FACING_RIGHT = 60.0f;
const float ABILITY_FLANK_FACING_LARGE_RIGHT = 45.0f;
const float ABILITY_FLANK_FACING_LARGE_LEFT = -45.0f;
const float ABILITY_FLANK_FACING_FRONT = 0.0f;



/**
* @brief Returns the TABLE_* constants for 2da lookups for a specific abiltiy
*
* Talents, Spells, Skills and Items use different 2das, even tho they have the
* same structure. This function returns the constant for use with the GetM2DA*
* functions
*
* @param nAbilityType ABILITY_TYPE_* constant
*
* @returns TABLE_* constant
*
* @author   Georg Zoeller
*
**/
int Ability_GetAbilityTable(int nAbilityType);
int Ability_GetAbilityTable(int nAbilityType)
{
    // Which 2DA to read the data from
    int n2DA = TABLE_ABILITIES_TALENTS;

    if (nAbilityType == ABILITY_TYPE_SPELL)
    {
        n2DA = TABLE_ABILITIES_SPELLS;
    }

    return n2DA;
}


/**
* @brief Returns TRUE if the specified ability is a blood magic ability
*
* Used by the spell cost functions to determine whether or not to cast
* from health or mana/stamina
*
* @param nAbilityType ABILITY_TYPE_* constant
*
* @returns TRUE or False
*
* @author   Georg Zoeller
*
**/
int Ability_IsBloodMagic(object oCaster);
int Ability_IsBloodMagic(object oCaster)
{
/*
    return  ( nAbility == ABILITY_SPELL_BLOOD_WOUND ||
              nAbility == ABILITY_SPELL_BLOOD_CONTROL ||
              nAbility == ABILITY_SPELL_BLOOD_MAGIC ||
              nAbility == ABILITY_SPELL_BLOOD_SACRIFICE);
*/

    return IsModalAbilityActive(oCaster, ABILITY_SPELL_BLOOD_MAGIC);
}


/**
* @brief returns the cost (mana or stamina) of using an ability
*
* Note: nAbility = ABILITY_TYPE_INVALID will cause a lookup in the 2da
* This function is duplicated within the game executable. Any change made to this function will
* result in GUI glitches and other bugs. Sorry.
*
*
* @param oCaster        The creature to deactivate the ability on
* @param nAbility       The modal ability to deactivate
* @param nAbilityType   The ability type of the modal ability.
*
*
* @returns TRUE if the ability was terminated successfully
*
* @author   Georg Zoeller
*
**/
float Ability_GetAbilityCost(object oCaster, int nAbility, int nAbilityType = ABILITY_TYPE_INVALID, int bUpkeep = FALSE);
float Ability_GetAbilityCost(object oCaster, int nAbility, int nAbilityType = ABILITY_TYPE_INVALID, int bUpkeep = FALSE)
{
    //This function is duplicated within the game executable. Any change made to this function will
    //result in GUI glitches and other bugs. Sorry.
    if (nAbilityType == ABILITY_TYPE_INVALID)
    {
        nAbilityType = Ability_GetAbilityType(nAbility);
    }
    string sCol = bUpkeep?"costupkeep":"cost";


    float fCost = GetM2DAFloat(TABLE_ABILITIES_SPELLS, sCol, nAbility);


    if (nAbilityType != ABILITY_TYPE_ITEM)
    {
        if (fCost >0.0f)
        {

            float fModifier = 1.0;

            #ifdef DEBUG
            Log_Trace( LOG_CHANNEL_COMBAT_ABILITY, "Ability_GetAbilityCost", "Initial Cost:"+ToString(fCost) );
            #endif

            if (!bUpkeep)
            {
                //This function is duplicated within the game executable. Any change made to this function will
                //result in GUI glitches and other bugs. Sorry.
                fModifier +=  GetCreatureProperty(oCaster, PROPERTY_ATTRIBUTE_FATIGUE)*0.01f;
                fCost = FloatToInt(fCost*fModifier+0.5) * 1.0;

            }

            if (fCost > 0.0f)
            {
                float fDiffMod = Diff_GetAbilityUseMod(oCaster);
                fCost *= (1.0 / fDiffMod);

                #ifdef DEBUG
                Log_Trace( LOG_CHANNEL_COMBAT_ABILITY, "Ability_GetAbilityCost", "Difficulty Mod : * "+ToString(fDiffMod) );
                #endif
            }

            #ifdef DEBUG
            Log_Trace( LOG_CHANNEL_COMBAT_ABILITY, "Ability_GetAbilityCost", "Calculating: "+ToString(fCost)+"*(1+("+ToString(GetCreatureProperty(oCaster, 41))+"*0.01))"  );
            Log_Trace( LOG_CHANNEL_COMBAT_ABILITY, "Ability_GetAbilityCost", "New Cost:"+ToString(fCost) );
            #endif
        }
    }

    return fCost;
}








/**
* @brief Returns if an ability uses the Ranged Weapon shoot anim as cast anim.
*
* @author georg;
*/
int Abilty_IsUsingRangedWeaponAnim(int nAbility);
int Abilty_IsUsingRangedWeaponAnim(int nAbility)
{
    int nFlag =GetM2DAInt(TABLE_ABILITIES_SPELLS,"flags",nAbility);
    return ((nFlag & ABILITY_FLAG_RANGED_WEAPON) ==  ABILITY_FLAG_RANGED_WEAPON);
}

/**
* @brief Performs an ability cost check to see if an ability can be used.
*
* Returns TRUE if the caster has enough mana or stamina (depending on ability type)
* to use (used in ability_core)
*
* @param oCaster      The caster using the ability
* @param nAbility     The ability being used
* @param nAbilityType The ability type of that ability
* @param oItem        The Item consumed to use the ability/spell (Optional)
*
* @returns  TRUE (enough), FALSE (not enough)
* @author   Georg Zoeller
*
**/
int Ability_CostCheck(object oCaster, int nAbility, int nAbilityType, object oItem = OBJECT_INVALID )
{
    int bModal = Ability_IsModalAbility(nAbility);
    float fCost = Ability_GetAbilityCost (oCaster, nAbility, nAbilityType, bModal);
    float fMana;
    if (bModal)
    {
           fMana = GetCreatureProperty(oCaster, PROPERTY_DEPLETABLE_MANA_STAMINA,PROPERTY_VALUE_TOTAL);
           // You can use modal abilities when you have more mana available
           // than upkeep cost and at least 1 point of mana
           return fMana >= fCost && fMana >= 1.0f;
    }


    int nNumItems;
    int bRet = TRUE;





    // if the ability consumes an item, there is no cost
    if (nAbilityType == ABILITY_TYPE_ITEM && IsObjectValid(oItem))
    {
        return (GetItemStackSize(oItem) > 0);
    }

    // only abilities and spells cost...
    else if (nAbilityType == ABILITY_TYPE_SPELL || nAbilityType == ABILITY_TYPE_TALENT )
    {

        // Shapeshifted characters cast their abilties for free.
        if (IsShapeShifted(oCaster))
        {
            return TRUE;
        }

       // blood magic doesn't use mana or stamina, it uses health and the caster can very much
       // kill himself, so we don't subtract any damage here...
       if (!Ability_IsBloodMagic(oCaster))
       {
            fMana = GetCreatureProperty(oCaster, PROPERTY_DEPLETABLE_MANA_STAMINA,PROPERTY_VALUE_CURRENT);

            if (fMana < fCost || fMana <1.0f )
            {
                bRet =  FALSE;
            }

       }



       #ifdef DEBUG
       Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.CostCheck","AbilityUse Cost: " + FloatToString(fCost) + ", Have:" + FloatToString(fMana));
       #endif

    }

    return bRet;
}





/**
* @brief Performs an ability cost check to see if an ability can be used.
*
* Returns TRUE if the caster has enough mana or stamina (depending on ability type)
* to use (used in ability_core)
*
* @param oCaster      The caster using the ability
* @param nAbility     The ability being used
* @param nAbilityType The ability type of that ability
*
* @returns  TRUE (enough), FALSE (not enough)
* @author   Georg Zoeller
*
**/
int Ability_GetAbilityTargetType(int nAbility, int nAbilityType);
int Ability_GetAbilityTargetType(int nAbility, int nAbilityType)
{
    int n2DA = Ability_GetAbilityTable(nAbilityType);
    int nTargetType = GetM2DAInt(n2DA, "TargetType", nAbility);
    return nTargetType;
}



float Ability_AdjustDuration(object oThis, float fDuration)
{
    // Georg: Good place to add spell extension talents
    return fDuration;
}


void Ability_RemoveAbilityEffectsByCreator(object oCreator, int nAbility);
void Ability_RemoveAbilityEffectsByCreator(object oCreator, int nAbility)
{

    RemoveEffectsByCreator(oCreator, nAbility);

}


/**
* @brief Utility Function for the use in spellscripts.
*
* If you think you need to change this functions, talk to Georg.
*
* @author   Georg Zoeller
**/
int Ability_GetSpellscriptPendingEventResult();
int Ability_GetSpellscriptPendingEventResult()
{

    int nRet = GetLocalInt(GetModule(),HANDLE_EVENT_RETURN);
    return nRet;
}




/**
* @brief Utility Function for the use in spellscripts. Talk to georg if needed.
*
* @author   Georg Zoeller
**/
void Ability_SetSpellscriptPendingEventResult(int nResult);
void Ability_SetSpellscriptPendingEventResult(int nResult)
{

    int nRet = Ability_GetSpellscriptPendingEventResult();
    SetLocalInt(GetModule(),HANDLE_EVENT_RETURN,nResult);
}




/**
* @brief Special version of HandleEvent for use by Ability_DoRunSpellScript
*
*                 ** Utility Function, do not call elsewhere **
*
* @param ev           The event to message to the spellscript
* @param sFile        2da to run
*
* @returns  COMMAND_RESULT_* constant if event is EventSpellScriptPending:
*
* @author   Georg Zoeller
*
**/
int _Ability_HandleEvent(event ev, resource rResource)
{

    // this populates with the default value
    Ability_SetSpellscriptPendingEventResult(COMMAND_RESULT_SUCCESS);

    HandleEvent(ev, rResource);

    int nRet = Ability_GetSpellscriptPendingEventResult();

    return nRet;

}



/**
* @brief Handles running an ability spellscript listed in the prop
*
* @param ev           The event to message to the spellscript
* @param nAbility     The Ability ID (ABILITY_*)
* @param nAbilityType The type of the ability
*
* @returns  COMMAND_RESULT_* constant if event is EventSpellScriptPending:
*
* @author   Georg Zoeller
*
**/
int Ability_DoRunSpellScript(event ev, int nAbility, int nAbilityType);
int Ability_DoRunSpellScript(event ev, int nAbility, int nAbilityType)
{



    int n2DA = Ability_GetAbilityTable(nAbilityType);

    resource rResource = GetM2DAResource(n2DA,"SpellScript",nAbility);
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.DoRunSpellScript","running spellscript for ability: " + IntToString(nAbility) + " type=" + IntToString(nAbilityType));
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.DoRunSpellScript","spell script = " + ResourceToString(rResource));
    #endif

    if (rResource != "")
    {
        int nRet =  _Ability_HandleEvent(ev, rResource);

        return nRet;

    }
    else
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.DoRunSpellScript","ability_core: running spellscript failed, no 2da entry", OBJECT_INVALID, LOG_SEVERITY_CRITICAL);
        #endif
    }

    return COMMAND_RESULT_INVALID; // 2FALSE;
}




/**
* @brief Applies the upkeep effect for a specific spell to the caster
*
* Note eEffect is always applied to oTarget and oCaster!
*
* @param oCaster            The creature using the ability
* @param nAbility           The ability / spell that has been used
* @param oTarget            The Target for eEffect  (default: caster)
* @param eEffect            The beneficial effect to be upkept
* @param bPartywide         Whether the whole party is affected
*
* @author   Georg Zoeller
*
*/

void _ApplyUpkeepEffect(object oCaster, effect eEffect, int nAbility, object oTarget, int bPartyWide)
{
    if (bPartyWide && IsFollower(oCaster))
    {
        ApplyEffectOnParty(EFFECT_DURATION_TYPE_PERMANENT,eEffect,0.0,oCaster,nAbility,TRUE,FALSE);
    }
    else
    {
        // -------------------------------------------------------------------------
        // Apply the beneficial effect to the caster
        // -------------------------------------------------------------------------
        ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eEffect, oCaster, 0.0f, oCaster, nAbility);


        // -------------------------------------------------------------------------
        // If oTarget is not identical with oCaster, apply beneficial effect as well
        // -------------------------------------------------------------------------
        if (oTarget != oCaster)
        {
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eEffect, oTarget, 0.0f, oCaster, nAbility);
        }
    }
}


void Ability_ApplyUpkeepEffects(object oCaster, int nAbility, effect [] eEffects, object oTarget = OBJECT_INVALID, int bPartywide = FALSE );
void Ability_ApplyUpkeepEffects(object oCaster, int nAbility, effect [] eEffects, object oTarget = OBJECT_INVALID, int bPartywide = FALSE )
{

    float fCost = Ability_GetAbilityCost(oCaster,nAbility,GetAbilityType(nAbility), TRUE ) * -1.0;

    if (!IsObjectValid(oTarget))
    {
        oTarget = oCaster;
    }

    int nCount = GetArraySize(eEffects);
    int i;

    for (i = 0; i < nCount; i++)
    {
        _ApplyUpkeepEffect( oCaster, eEffects[i], nAbility, oTarget, bPartywide);
    }

    // -------------------------------------------------------------------------
    // Spells cost mana, talents cost stamina
    // -------------------------------------------------------------------------
    effect eUpkeep = EffectUpkeep(UPKEEP_TYPE_MANASTAMINA , fCost, nAbility, oTarget, bPartywide);

    // -------------------------------------------------------------------------
    // Upkeep effects are permanent until the effect is removed.
    // they also set the ui icon toggle inside the effect based on the
    // ability id
    // -------------------------------------------------------------------------

    ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eUpkeep, oCaster, 0.0f, oCaster, nAbility);
}




void Ability_ApplyUpkeepEffect(object oCaster, int nAbility, effect eEffect, object oTarget = OBJECT_INVALID, int bPartywide = FALSE );
void Ability_ApplyUpkeepEffect(object oCaster, int nAbility, effect eEffect, object oTarget = OBJECT_INVALID, int bPartywide = FALSE )
{

    float fCost = Ability_GetAbilityCost(oCaster,nAbility,ABILITY_TYPE_INVALID, TRUE) * -1.0;


    if (!IsObjectValid(oTarget))
    {
        oTarget = oCaster;
    }


    _ApplyUpkeepEffect( oCaster, eEffect, nAbility, oTarget, bPartywide);


    // ---------------------------------------------------------------------
    // Spells cost mana, talents cost stamina
    // ---------------------------------------------------------------------
    effect eUpkeep = EffectUpkeep(UPKEEP_TYPE_MANASTAMINA , fCost, nAbility, oTarget, bPartywide);

    // ---------------------------------------------------------------------
    // Upkeep effects are permanent until the effect is removed.
    // they also set the ui icon toggle inside the effect based on the
    // ability id
    // ---------------------------------------------------------------------


    ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eUpkeep, oCaster, 0.0f, oCaster, nAbility);

}


/** ----------------------------------------------------------------------------
* @brief Subtracts the cost (mana or stamina) for using an ability from the caster.
*
* @param oCaster            The creature using the ability
* @param nAbility           The ability / spell that has been used
*
* @author   Georg Zoeller
*  --------------------------------------------------------------------------**/
void Ability_SubtractAbilityCost (object oCaster, int nAbility, object oItem = OBJECT_INVALID );
void Ability_SubtractAbilityCost (object oCaster, int nAbility, object oItem = OBJECT_INVALID )
{



    // -------------------------------------------------------------------------
    // get type and cost for the ability
    // -------------------------------------------------------------------------
    float fCost = Ability_GetAbilityCost(oCaster, nAbility) ;

    // -------------------------------------------------------------------------
    // Items don't cost
    // -------------------------------------------------------------------------
    if (GetAbilityType(nAbility) != ABILITY_TYPE_ITEM)
    {

        // ---------------------------------------------------------------------
        //  Shapeshifted abilities were once cast for free.
        // ---------------------------------------------------------------------
        // if (IsShapeShifted(oCaster))
        //          {
        //          return;
        //        }

        fCost = FloatToInt(fCost) * -1.0;

        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"Ability_h.SubtractAbilityCost", "Cost for Ability: " + FloatToString(fCost));
        #endif

        // ---------------------------------------------------------------------
        // is blood magic active?
        // ---------------------------------------------------------------------
        if (Ability_IsBloodMagic(oCaster))
        {
            // -----------------------------------------------------------------
            // if there is a cost to the spell
            // -----------------------------------------------------------------
            if (fCost < 0.0f)
            {
                int nBloodMagicVFX = 1519;
                float fMultiplier = 0.8f;
                if (GetHasEffects(oCaster, EFFECT_TYPE_BLOOD_MAGIC_BONUS) == TRUE)
                {
                    fMultiplier = 0.6f;
                }

                // negative multiplier because damage needs to be positive
                fCost = fabs(fCost* fMultiplier);

                DEBUG_PrintToScreen(ToString(fCost));

                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.SubtractAbilityCost","Blood Magic! Health " + FloatToString(fCost * fMultiplier) + " drained instead of Mana");
                #endif
                Effects_ApplyInstantEffectDamage(oCaster, oCaster, fCost, DAMAGE_TYPE_PLOT, DAMAGE_EFFECT_FLAG_UNRESISTABLE, nAbility, nBloodMagicVFX);
            }
        }
        else
        {
            Effect_InstantApplyEffectModifyManaStamina(oCaster, fCost);
        }

    }



    /*
    effect eCost = EffectModifyManaStamina(fCost);
    ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, eCost, oCaster, 0.0, oCaster);
    */
}

/** ----------------------------------------------------------------------------
* @brief Deactivates a modal ability
*
* Runs the spellscript for an ability with the DEACTIVE_MODAL_ABILITY event\
*
* @param oCaster        The creature to deactivate the ability on
* @param nAbility       The modal ability to deactivate
* @param nAbilityType   The ability type of the modal abiltiy
*
*
* @returns TRUE if the ability was terminated successfully
*
* @author   Georg Zoeller
*  -----------------------------------------------------------------------------
**/
int Ability_DeactivateModalAbility(object oCaster, int nAbility, int nAbilityType = ABILITY_TYPE_INVALID);
int Ability_DeactivateModalAbility(object oCaster, int nAbility, int nAbilityType = ABILITY_TYPE_INVALID)
{

    if (nAbilityType == ABILITY_TYPE_INVALID)
    {
        nAbilityType = Ability_GetAbilityType(nAbility);
    }

    if (IsModalAbilityActive(oCaster, nAbility))
    {

        #ifdef DEBUG
        Log_Rules(" ++++++Modal Ability  deactivated" );
        #endif

    // -----------------------------------------------------------------
    // Handle player requests to disable a modal ability
    // If the modal ability is running, send Deactivate event to the spellscript
    // -----------------------------------------------------------------
        event evDeactivate = EventSpellScriptDeactivate(oCaster,nAbility, nAbilityType);
        return Ability_DoRunSpellScript(evDeactivate,nAbility, nAbilityType);                // we don't care for the return value of this function

    }
    #ifdef DEBUG
    Log_Rules(" ++++++Modal Ability  not deactivated " );
    #endif
    return COMMAND_RESULT_SUCCESS;
}



/** ----------------------------------------------------------------------------
* @brief (deprectated) Resolves the effects of abilities that trigger 'OnHit'
*
* @param oAttacker          The Attacking Creature
* @param oTarget            The attacked creature
*
* @author   Georg Zoeller
*  -----------------------------------------------------------------------------
**/
void Ability_ResolveOnHitAbilities(object oAttacker, object oTarget);
void Ability_ResolveOnHitAbilities(object oAttacker, object oTarget)
{


}


float Ability_GetScaledEffectDuration(int nAbility, object oCaster, float fDuration)
{
    return fDuration;
}

int Ability_GetScaledDamage(int nAbility, object oCaster, int nDamage)
{

    return nDamage;
}

int Ability_GetScaledHeal(int nAbility, object oCaster, int nHeal)
{
    return nHeal;
}


int Ability_GetScaledCost(int nAbility, object oCaster, int nCost)
{

    return nCost;
}


void Ability_PreventAbilityEffectStacking(object oTarget,object oCaster,  int nAbility)
{
    RemoveStackingEffects(oTarget, oCaster, nAbility);
}






/*
*  @brief Ability event filtering functions.
*
*  Performs some filtering on Ability Event Targets. Be very careful with this,
*  best don't touch if your name doesn't start with ge and doesn't end with org ;p
*
*  @author georg
*/
int Ability_IsValidAOETarget(object oTarget,object oCaster, int nAbility)
{
    int bReturn = TRUE;

    // For Now, return true for all placeables
    if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        return TRUE;
    }

    // Georg: This also prevents corpses from being affected by AoE objects.
    if (IsDead(oTarget) || IsDying(oTarget))
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, "ability_h.IsValidAoETarget","AOE Target ignored: dead or dying",oTarget);
        #endif
        return FALSE;
    }


    // non hostile opponents of a different. This isn't as clean as I want it to be, will have to revise later.
    if (!IsObjectHostile(oCaster, oTarget))
    {
        if (GetGroupId(oCaster) != GetGroupId(oTarget))
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, "ability_h.IsValidAoETarget","not hostile and in different group",oTarget);
            #endif
            return FALSE;
        }
    }

    return bReturn;
}

/*
*  @brief Ability event filtering functions.
*
*  Performs some filtering on Ability Event Targets
*
*  @author georg
*/
int Ability_IsAbilityTargetValid(object oTarget, int nAbility, int nTargetType)
{

    int bRet = TRUE;


    if (IsDead(oTarget))
    {
        if ( (nTargetType & TARGET_TYPE_BODY)  == TARGET_TYPE_BODY)
        {
            bRet = TRUE;
        }
        else
        {
            bRet = FALSE;
        }
    }


    if (IsDying(oTarget) && (nAbility != ABILITY_SPELL_REVIVAL))
    {
        bRet =  FALSE;
    }


    return bRet;


}


/** ----------------------------------------------------------------------------
* @brief (events__h) Wrapper for ApplyEffectOnObject on an array of Objects.
*
* @param nDurationType can be EFFECT_DURATION_TYPE_PERMANENT EFFECT_DURATION_TYPE_INSTANTANEOUS or EFFECT_DURATION_TYPE_TEMPORARY.
* @param Effect the effect to be applied
* @param arTarget the targets of the effect
* @param fDuration  this value needs to be set only when nDurationType is EFFECT_DURATION_TYPE_TEMPORARY
* @param oCreator effect creator
* @param nAbilityId The ability ID of the effect (Important for dispelling!!!)
* @param bSendAttackedEvent Whether to send an attacked event as well.
* @param bPreventStacking Prevent Stacking?.
*
* @author Georg Zoeller
*  ---------------------------------------------------------------------------**/
void Ability_ApplyEffectOnObjectArray(int nDurationType, effect eEffect,  object[] arTargets,  float fDuration = 0.0f,    object oCreator = OBJECT_SELF,int nAbilityId = 0, int bSendAttackedEvent = FALSE, int bPreventStacking = TRUE,  int bExcludeCreator = FALSE)
{
    int nCount = GetArraySize(arTargets);
    int i;
    for (i = 0; i < nCount ; i++)
    {
        if (!bExcludeCreator || arTargets[i] != oCreator)
        {
            RemoveStackingEffects(arTargets[i],oCreator, nAbilityId);
            ApplyEffectOnObject(nDurationType, eEffect ,arTargets[i],fDuration, oCreator, nAbilityId);

            if (bSendAttackedEvent)
            {
                SendEventOnCastAt(arTargets[i], oCreator ,nAbilityId ,TRUE);
            }
        }
    }
}


/** ----------------------------------------------------------------------------
* @brief (events__h) Wrapper for ApplyEffectOnObject on an array of Objects.
*
* @param nDurationType      - Will only accept EFFECT_DURATION_TYPE_TEMPORARY.
* @param eEffect            - The effect to be applied.
* @param arTarget           - The targets of the effect.
* @param fDurationMin       - Minimum duration of the effect.
* @param fDurationMax       - Maximum duration of the effect.
* @param oCreator           - The effect creator.
* @param nAbilityId         - The ability ID of the effect. (Important for dispelling!!!)
* @param bSendAttackedEvent - Whether to send an attacked event as well.
* @param bPreventStacking   - Prevent Stacking?
* @param bExcludeCreator    - Exclude creator?
*
* @author Georg Zoeller
*
* Modified 28/11/2007 by PeterT
*
* - Adjusted Ability_ApplyEffectOnObjectArray to make the duration random in a specified range.
*  ---------------------------------------------------------------------------**/
void Ability_ApplyRandomDurationEffectOnObjectArray(int nDurationType, effect eEffect, object[] arTargets, float fDurationMin = 0.0f, float fDurationMax = 0.0f, object oCreator = OBJECT_SELF, int nAbilityId = 0, int bSendAttackedEvent = FALSE, int bPreventStacking = TRUE, int bExcludeCreator = FALSE)
{
    if (nDurationType == EFFECT_DURATION_TYPE_TEMPORARY)
    {
        int nCount = GetArraySize(arTargets);
        float fDuration = 0.0f;
        int i;
        for (i = 0; i < nCount ; i++)
        {
            if (!bExcludeCreator || arTargets[i] != oCreator)
            {
                // determine random duration
                fDuration = (RandomFloat() * (fDurationMax - fDurationMin)) + fDurationMin;
                if (fDuration < fDurationMin) // lower bound
                {
                    fDuration = fDurationMin;
                }
                if (fDuration > fDurationMax) // upper bound
                {
                    fDuration = fDurationMax;
                }

                RemoveStackingEffects(arTargets[i], oCreator, nAbilityId);
                ApplyEffectOnObject(nDurationType, eEffect, arTargets[i], fDuration, oCreator, nAbilityId);

                if (bSendAttackedEvent)
                {
                    SendEventOnCastAt(arTargets[i], oCreator, nAbilityId, TRUE);
                }
            }
        }
    }
}



/**
* @brief Determine whether or not all conditions for the current talent are met
*
* This is temporary, it will go into the engine at some point
* Check the use conditions for the ability, e.g. melee only
* Later this should be
* done mostly in the UI (e.g. don't even allow to use it)
* 0   None
* 1   Melee
* 2   Shield
* 4   Ranged
* 8   Behind Target
* 16  Mode active
*
*
* @author Georg
*/
int Ability_CheckUseConditions(object oCaster, object oTarget, int nAbility, object oItem = OBJECT_INVALID)
{

    string sItemTag = IsObjectValid(oItem)?GetTag(oItem):"";
    int nAbilityType = GetAbilityType(nAbility);

    int nCondition = GetM2DAInt(TABLE_ABILITIES_SPELLS, "conditions", nAbility);
    int bRet = TRUE;

    float fCooldown = GetRemainingCooldown(oCaster, nAbility,sItemTag );
    if (fCooldown>0.0f)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, "Ability_CheckUseConditions", "Trying to execute ability with cooldown " +ToString(fCooldown) + " remaining ability which is already active. FALSE.");
        #endif
        return FALSE;
    }
    else

    // If nAbility is modal and active already - do nothing
    if(IsModalAbilityActive(oCaster, nAbility))
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, "Ability_CheckUseConditions", "Trying to execute modal ability which is already active. FALSE.");
        #endif
        return FALSE;
    }


    // -------------------------------------------------------------------------
    // No conditions? bail right here
    // -------------------------------------------------------------------------
    if (nCondition == 0)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions","TRUE (no condition)");
        #endif
        return TRUE;
    }

    // -------------------------------------------------------------------------
    // CONDITION_MELEE_WEAPON - Caster needs a melee weapon in main hand
    // -------------------------------------------------------------------------
    if ((nCondition & 1) == 1)
    {

        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Melee: " + ((bRet)?"TRUE":"FALSE"));
        #endif
        bRet  = bRet &&   IsUsingMeleeWeapon(oCaster);

        if (!bRet)
        {
            return FALSE;
        }

    }

    // -------------------------------------------------------------------------
    // CONDITION_SHIELD - Caster needs a shield in the offhand
    // -------------------------------------------------------------------------
    if ((nCondition & 2) == 2)
    {
        bRet  = bRet && IsUsingShield(oCaster);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Shield: "+ ((bRet)?"TRUE":"FALSE"));
        #endif

        if (!bRet)
        {
            return FALSE;
        }

    }

   // -------------------------------------------------------------------------
    // CONDITION_RANGED_WEAPON - Caster needs a ranged weapon in main hand
    // -------------------------------------------------------------------------
    if ((nCondition & 4) == 4)
    {
        bRet = bRet && IsUsingRangedWeapon(oCaster);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Ranged: "+ ((bRet)?"TRUE":"FALSE"));
        #endif

        if (!bRet)
        {
            return FALSE;
        }

    }


    // -------------------------------------------------------------------------
    // CONDITION_BEHIND_TARGET - Caster needs to be located behind the target
    // -------------------------------------------------------------------------
    if ((nCondition & 8) == 8)
    {
        float fAngle = GetAngleBetweenObjects(oTarget, oCaster);

        bRet = bRet && (fAngle>=90.0f && fAngle <= 270.0f);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Back: "+ ((bRet)?"TRUE":"FALSE"));
        #endif

        if (!bRet)
        {
            return FALSE;
        }

    }

    // -------------------------------------------------------------------------
    // CONDITION_ACTIVE_MODAL_ABILITY - A specific modal ability needs to be active
    // -------------------------------------------------------------------------
    if ((nCondition & 16) == 16)
    {
        int nModalAbility = GetM2DAInt(TABLE_ABILITIES_TALENTS,"condition_mode",nAbility);
        if (nModalAbility != 0)
        {
            bRet = bRet && IsModalAbilityActive(oCaster,nModalAbility);
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Mode Active: "+ ((bRet)?"TRUE":"FALSE"));
            #endif
        }

        if (!bRet)
        {
            return FALSE;
        }

    }

    // -------------------------------------------------------------------------
    // CONDITION_TARGET_HUMANOID - Target is humanoid
    // -------------------------------------------------------------------------
    if ((nCondition & 32) == 32)
    {
        bRet = bRet && IsHumanoid(oTarget);

        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "IsHumanoid: "+ ((bRet)?"TRUE":"FALSE"));
        #endif

        if (!bRet)
        {
            return FALSE;
        }


    }

    // -------------------------------------------------------------------------
    // CONDITION_DUAL_WEAPONS
    // -------------------------------------------------------------------------
    if ((nCondition & 64) == 64)
    {
        bRet = bRet && GetWeaponStyle(oCaster) == WEAPONSTYLE_DUAL;
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "UsingDualWeapons: "+ ((bRet)?"TRUE":"FALSE"));
        #endif

        if (!bRet)
        {
            return FALSE;
        }
    }

    // -------------------------------------------------------------------------
    // CONDITION_DUAL_WEAPONS
    // -------------------------------------------------------------------------
    if ((nCondition & 128) == 128)
    {
        bRet = bRet && GetWeaponStyle(oCaster) == WEAPONSTYLE_TWOHANDED;
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", "Using2HWeapon: "+ ((bRet)?"TRUE":"FALSE"));
        #endif
        if (!bRet)
        {
            return FALSE;
        }

    }


    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"CheckUseConditions", (bRet)?"TRUE":"FALSE" + " condition: " + IntToHexString(nCondition));
    #endif

    return bRet;

}

/**
*   @ Simple wrapper to use a modal ability on a creature
*
*   Makes a creature use a talent or ability. Will add ability to the creature if asked to
*   Ability Use command is added to the top of the action queue unless otherwise specified. This function is asynchronous
*   as it uses a command.
*   The command can still fail if the creature doesn't have the mana to use it, etc.
*
*   @param oCreature The creature using the ability
*   @param nAbility The ABILITY_* to use
*   @param oTarget The ability target (should be same as oCreature for modal talents
*   @param bAddIfNeeded Add the talent to the creature if it doesn't have it
*   @param bAddCommandToTop Whether or not to add the use ability command at the top or bottom of the action queue
*
*   @author Georg Zoeller
*
**/
void Ability_UseAbilityWrapper(object oCreature, int nAbility, object oTarget = OBJECT_SELF, int bAddIfNeeded = FALSE, int bAddCommandToTop = TRUE);
void Ability_UseAbilityWrapper(object oCreature, int nAbility, object oTarget = OBJECT_SELF, int bAddIfNeeded = FALSE, int bAddCommandToTop = TRUE)
{
    if (!HasAbility(oCreature, nAbility) && bAddIfNeeded)
    {
         AddAbility(oCreature, nAbility);
    }

    command cmdUse = CommandUseAbility(nAbility, oTarget);
    WR_AddCommand(oCreature, cmdUse, bAddCommandToTop);

}

/**
* @brief Checks if a specific ability is active on an object
*
* The check includes modal abilities and any other abilities with
* a duration (all buffs and de-buffs)
*
* @param oObject the object we are checking for the ability
* @param nAbilityID the ability we check if is active
* @returns TRUE if the ability is active, FALSE otherwise
*
* @author   Yaron Jakobs
*
**/
int Ability_IsAbilityActive(object oCreature, int nAbilityID);
int Ability_IsAbilityActive(object oCreature, int nAbilityID)
{
    int nActive = FALSE;
    effect[] thisEffects = GetEffects(oCreature, EFFECT_TYPE_INVALID, nAbilityID);
    int nSize = GetArraySize(thisEffects);

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY, "Ability_IsAbilityActive", "START, abilityID: " + IntToString(nAbilityID) + ", number of effects for this ability: " + IntToString(nSize), oCreature);
    #endif

    return (nSize >0 ? TRUE : FALSE);


}

int Ability_GetImpactLocationVfxId(int nAbility)
{
    return GetM2DAInt(TABLE_ABILITIES_SPELLS,"vfx_impact0",nAbility);
}

int Ability_GetImpactObjectVfxId(int nAbility)
{
    return GetM2DAInt(TABLE_ABILITIES_SPELLS,"vfx_impact1",nAbility);
}


void Ability_ApplyLocationImpactVFX(int nAbility, location lTarget)
{
    int nVfx = Ability_GetImpactLocationVfxId(nAbility);

    if (nVfx >0 /*ability has a vfx*/)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"ability_h.ApplyLocationImpactVF","ApplyVFX: " + ToString(nVfx));
        #endif
        Engine_ApplyEffectAtLocation(EFFECT_DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), lTarget,0.0f);
    }
}

void Ability_ApplyObjectImpactVFX(int nAbility, object oTarget)
{
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"Ability_ApplyObjectImpactVFX.ApplyLocationImpactVF",
        "Ability: " + IntToString(nAbility) + ", Target: " + GetTag(oTarget));
    #endif

    int nVfx = Ability_GetImpactObjectVfxId(nAbility);

    if (nVfx >0 /*ability has a vfx*/)
    {
        Log_Trace(LOG_CHANNEL_COMBAT_ABILITY,"Ability_ApplyObjectImpactVFX","ApplyVFX: " + ToString(nVfx));
        ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), oTarget,0.0f);
    }
}


int Ability_IsAoE(int nAbility)
{
    return (GetM2DAInt(TABLE_ABILITIES_SPELLS,"aoe_type",nAbility)>0);
}










/**
*   @ HandleEventOutOfMana
*
*   Handles the ability specific side of the out of mana event, mostly deactivating
*   continuously draining effects such as berserk.
*
*   @param oCreature The creature receiving the out of mana event
*
*   @author Georg Zoeller
*
**/
void Ability_HandleEventOutOfManaStamina(object oCreature);
void Ability_HandleEventOutOfManaStamina(object oCreature)
{
    effect [] aEffects = GetEffects(oCreature, EFFECT_TYPE_UPKEEP, 0, oCreature);
    int nSize = GetArraySize(aEffects);
    int i;
    int nType;
    int nId;
    for ( i = 0; i < nSize; i++)
    {
        nId = GetEffectAbilityID(aEffects[i]) ;
        nType = GetAbilityType(nId);

        if(nType == ABILITY_TYPE_SPELL || nType == ABILITY_TYPE_TALENT)
        {
            // -----------------------------------------------------------------
            // If the 'out of mana ends ability flag' is set, kill it.
            // -----------------------------------------------------------------
            int nFlag = GetM2DAInt(TABLE_ABILITIES_SPELLS,"flags",nId);
            if (( nFlag & ABILITY_FLAG_END_ON_OUT_OF_MANA) == ABILITY_FLAG_END_ON_OUT_OF_MANA )
            {
                RemoveEffect(oCreature,aEffects[i]);
            }
        }
    }
}


int Ability_CheckFlag( int nAbility, int nFlag)
{

    int nAbiFlags = GetM2DAInt(TABLE_ABILITIES_SPELLS,"Flags",nAbility);
    return ((nAbiFlags & nFlag) == nFlag);

}

/*
     @brief Utility function to remove all effects applied by abilities that have applied an effect
            of the given type.

     @author georg
*/
void _RemoveAbilitiesMatchingEffectType (object oTarget, int nType, int nExcludeAbility = 0)
{

    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_EFFECTS,"ability_h._RemoveAbilitiesMatchingEffectType","Removing all effects matching type " + ToString(nType) + " excluding " + ToString(nExcludeAbility));
    #endif

    effect[] effects = GetEffects(oTarget,nType);
    int i;
    int nId;
    int nSize = GetArraySize(effects);
    for (i=0; i<nSize; i++)
    {
        if (IsEffectValid(effects[i]))
        {
            nId = GetEffectAbilityID(effects[i]);
            if (nId != nExcludeAbility && nId !=0 /* we don't touch non ability effects */ )
            {
                RemoveEffectsByParameters(oTarget,EFFECT_TYPE_INVALID, nId);
            }
        }
    }


}

int Ability_CanTriggerDWE(object oDamaged, object oAttacker, int nDamageType, int nAbility) {
    // Check attacker valid
    if (IsObjectValid(oAttacker) && IsCreatureSpecialRank(oAttacker) && (GetWeaponStyle(oAttacker) == WEAPONSTYLE_DUAL) && (HasAbility(oAttacker, ABILITY_TALENT_DUAL_WEAPON_EXPERT))) {
        // Check target valid
        if (CanCreatureBleed(oDamaged) && !GetHasEffects(oDamaged,EFFECT_TYPE_DOT,ABILITY_TALENT_DUAL_WEAPON_EXPERT) && oDamaged != oAttacker) {
            // Check ability valid
            return nAbility == 0 || ((GetM2DAInt(TABLE_ABILITIES_SPELLS,"conditions",nAbility) & 65) && nAbility != ABILITY_TALENT_DUAL_WEAPON_EXPERT);
        }
    }
    return FALSE;
}

void Ability_HandleOnDamageAbilities(object oDamaged, object oAttacker, float fDamage, int nDamageType, int nAbility)
{



    // -------------------------------------------------------------------------
    // All sleep is cancelled when damaged
    // -------------------------------------------------------------------------
    if (GetHasEffects(oDamaged, EFFECT_TYPE_SLEEP))
    {
        _RemoveAbilitiesMatchingEffectType(oDamaged,EFFECT_TYPE_SLEEP, nAbility);
    }

    // -------------------------------------------------------------------------
    // All root is cancelled when damaged
    // -------------------------------------------------------------------------
    if (GetHasEffects(oDamaged, EFFECT_TYPE_ROOT))
    {
        _RemoveAbilitiesMatchingEffectType(oDamaged,EFFECT_TYPE_ROOT, nAbility);
    }


    if (IsModalAbilityActive(oAttacker, ABILITY_TALENT_SUPPRESSING_FIRE)) {
        if (nAbility == 0 || (GetM2DAInt(TABLE_ABILITIES_SPELLS,"conditions",nAbility) & 4)) {
            effect eDebuff = EffectDecreaseProperty(PROPERTY_ATTRIBUTE_ATTACK, -7.5f);
            eDebuff = SetEffectEngineInteger(eDebuff, EFFECT_INTEGER_VFX, 90063);

            float fDur = MinF(GetRankAdjustedEffectDuration(oDamaged, 10.0f),15.0f);

            ApplyEffectVisualEffect(oAttacker, oDamaged,90002, EFFECT_DURATION_TYPE_INSTANT,0.0f);
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eDebuff, oDamaged, fDur, oAttacker, ABILITY_TALENT_SUPPRESSING_FIRE);
        }
    }



    // -------------------------------------------------------------------------
    // DUAL_WEAPON_EXPERT
    //
    // If the attacker has the DUAL_WEAPON_EXPERT talent, he may cause bleeding.
    // This is done by simulating a hit with a 'vicious' item property weapon.
    // A bit weird, but saves us the whole implementation of that feature.
    // -------------------------------------------------------------------------
    // That's what Bioware says anyway. I replaced with a manual implementation
    // as 'vicious' is buggy. Not exactly tedious, with its 3 lines of code.
    // -------------------------------------------------------------------------
    if (Ability_CanTriggerDWE(oDamaged, oAttacker, nDamageType, nAbility))
    {
        float fDur = MaxF(5.0f, 2.0f + IntToFloat(GetLevel(oAttacker))/5.0f);
        float fDam = 7.0f + IntToFloat(GetLevel(oAttacker));
        ApplyEffectDamageOverTime(oDamaged, oAttacker, ABILITY_TALENT_DUAL_WEAPON_EXPERT, fDam, fDur, DAMAGE_TYPE_PHYSICAL, 0, 1016);

        //event eOnHit= Event(EVENT_TYPE_ITEM_ONHIT);
        //eOnHit = SetEventCreator(eOnHit, oAttacker);
        //eOnHit = SetEventInteger(eOnHit,0, ITEM_PROPERTY_ONHIT_VICIOUS);
        //eOnHit = SetEventInteger(eOnHit,1, ((GetLevel(oAttacker)/5)+1) );
        //eOnHit = SetEventInteger(eOnHit,2, TRUE);
        //DelayEvent(0.0f, oDamaged, eOnHit);
    }
}

object [] Ability_GetTargetAllies(object oCaster)
{
    object [] arTargets;
    int nMaxAllies = GetLocalInt(GetModule(), ABILITY_ALLY_NUMBER);

    if(IsFollower(oCaster))
        arTargets = GetPartyList(oCaster);
    else // non party member
        arTargets = GetNearestObjectByGroup(oCaster, GetGroupId(oCaster), OBJECT_TYPE_CREATURE, nMaxAllies, TRUE, FALSE, TRUE);

    return arTargets;
}


void Ability_OnGameModeChange(int nNewGM, int nOldGM)
{
    if (nNewGM == GM_EXPLORE && nOldGM == GM_COMBAT) {
        object[] partyMembers = GetPartyList();
        int i, memberCount = GetArraySize(partyMembers);

        for (i = 0; i < memberCount; i++) {
            if (IsModalAbilityActive(partyMembers[i],ABILITY_TALENT_FEIGN_DEATH))
                Ability_DeactivateModalAbility(partyMembers[i],ABILITY_TALENT_FEIGN_DEATH);

            if (IsModalAbilityActive(partyMembers[i],ABILITY_TALENT_CAPTIVATE))
                Ability_DeactivateModalAbility(partyMembers[i],ABILITY_TALENT_CAPTIVATE);
        }
    }
}