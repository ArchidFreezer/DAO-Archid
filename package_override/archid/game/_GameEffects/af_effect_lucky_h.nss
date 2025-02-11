#include "sys_resistances_h" 
#include "af_utility_h"

/**
* We need toensure that we are not removing the effects if we did not set them
* A module variable is used to track this for ach follower
*/                                                        

/**
* @brief Apply the effect
*
* @param    fPower the strength of the effect
* @param    oTarget the recipient of the effect; defaults to OBJECT_SELF
*/
void Lucky_UpdateProps(float fPower, object oTarget = OBJECT_SELF) {
    // Small increase to crit chance, evasion and spell resistance
    UpdateCreatureProperty(oTarget, PROPERTY_ATTRIBUTE_MELEE_CRIT_MODIFIER, fPower, PROPERTY_VALUE_MODIFIER);
    UpdateCreatureProperty(oTarget, PROPERTY_ATTRIBUTE_RANGED_CRIT_MODIFIER, fPower, PROPERTY_VALUE_MODIFIER);
    UpdateCreatureProperty(oTarget, PROPERTY_ATTRIBUTE_DISPLACEMENT, fPower, PROPERTY_VALUE_MODIFIER);
    UpdateCreatureProperty(oTarget, PROPERTY_ATTRIBUTE_SPELLRESISTANCE, fPower, PROPERTY_VALUE_MODIFIER);
}
/**
* @brief check if the effect has been set for this target
*
* @param    oTarget creature to check if  the effect has already been applied to
*/
int Lucky_IsEffectSet(object oTarget) {    
    return AF_IsModuleFlagSet(AF_PARTYFLAG_LUCKY, AF_GetPartyMemberMask(oTarget));
}

/**
* @brief Look to apply the lucky effect to a creature
*
* @param ef the effect to apply
* @param oTarget recipient of the effect
*/
void Lucky_HandleApplyEffect(effect ef, object oTarget = OBJECT_SELF) {
    // Only apply the effect once
    if (!Lucky_IsEffectSet(oTarget)) {
        float fPower = GetEffectFloat(ef, 0);
        Lucky_UpdateProps(fPower, oTarget);
        AF_SetModuleFlag(AF_PARTYFLAG_LUCKY, AF_GetPartyMemberMask(oTarget), TRUE);
        SetIsCurrentEffectValid();  
    }
}

/**
* @brief Look to remove the lucky effect from a creature
*
* @param ef the effect to remove
* @param oTarget creature to remove the effect from
*/
void Lucky_HandleRemoveEffect(effect ef, object oTarget = OBJECT_SELF) { 
    // Only remove the effect if we applied 
    if (Lucky_IsEffectSet(oTarget)) {
        float fPower = GetEffectFloat(ef, 0);
        Lucky_UpdateProps(fPower*-1.0, oTarget);
        AF_SetModuleFlag(AF_PARTYFLAG_LUCKY, AF_GetPartyMemberMask(oTarget), FALSE);
    }
}