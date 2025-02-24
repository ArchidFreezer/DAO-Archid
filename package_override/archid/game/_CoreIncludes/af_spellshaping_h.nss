#include "ability_h"
#include "af_ability_h"

const int AF_SPELLSHAPING_WARNING_STRREFID = 6610100;
const int AF_LOGGROUP_SPELLSHAPING = 4;

/*
 * Checks if a target is protected by SpellShaping from the effects of a spell
 * oCaster - The person casting the spell
 * oTarget - The object to test whether it is protected by spell shaping
 *
 * Returns TRUE if the target is protected; FALSE otherwise
 */
int IsSpellShapingTarget(object oCaster, object oTarget) {
    // Both caster and target need to be valid and the caster must have spellshaping active
   if (!IsObjectValid(oCaster) || !IsObjectValid(oTarget) || !Ability_IsAbilityActive(oCaster, AF_ABILITY_SPELLSHAPING))
        return FALSE;

    // All higher level skills are passive upgrades so we can check in descending order.
    if (HasAbility(oCaster,AF_ABILITY_MASTER_SPELLSHAPING) && IsObjectHostile(oTarget,oCaster))
        return TRUE;
    else if (HasAbility(oCaster,AF_ABILITY_IMPROVED_SPELLSHAPING) && !IsPartyMember(oTarget))
        // Code for expert is the same as improved since expert only protects allies from damage and that is handled elsewhere.
        return TRUE;
    else if (oTarget != oCaster)
        return TRUE;
    else
        return FALSE;
}

/**
* @brief check that the event manager dependencies
*
* This function is called by the module event handler to ensure that the event manager config is valid.
* It shows a popup to the player if there is an issue detected
*
**/
void AF_SpellShapingCheckConfig() {
    string appStr = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_APPLY_EFFECT);
    string ablStr = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_ABILITY_CAST_IMPACT);

    if (appStr != "af_effectmanager" && ablStr != "af_eventmanager")
        ShowPopup(AF_SPELLSHAPING_WARNING_STRREFID, AF_POPUP_MESSAGE, OBJECT_INVALID, FALSE, 0);
}

