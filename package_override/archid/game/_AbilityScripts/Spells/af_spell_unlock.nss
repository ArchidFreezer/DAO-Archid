#include "abi_templates"
#include "spell_constants_h"
#include "placeable_h"
#include "af_ability_h"
#include "af_log_h"

// This must match the row in the logging_ m2da table
const int AF_LOGGROUP_UNLOCK_SPELL = 7;

// String references
const int AF_STR_MAGIC_UNLOCK_FAIL = 6610143;
const int AF_STR_MAGIC_UNLOCK_INVALID = 6610144;
const int AF_STR_MAGIC_UNLOCK_INVALID_PLACEABLE_TYPE = 6610145;
const int AF_STR_MAGIC_UNLOCK_TARGET_UNLOCKED = 6610146;
                                         
// The base unlock level of the spell
const float SPELL_UNLOCK_1_POWER = 10.0f;
const float SPELL_UNLOCK_2_POWER = 20.0f;
const float SPELL_UNLOCK_3_POWER = 30.0f;
                                     
// The modifier that is applied to the casters spellpower
const float SPELL_UNLOCK_1_SP_MOD = 0.4f;
const float SPELL_UNLOCK_2_SP_MOD = 0.5f;
const float SPELL_UNLOCK_3_SP_MOD = 0.75f;

// The maximum amount that the casters spellpower may add
const int SPELL_UNLOCK_1_SP_CAP = 10;
const int SPELL_UNLOCK_2_SP_CAP = 20;
const int SPELL_UNLOCK_3_SP_CAP = 30;
                                                         
/**
 * @brief Attempt to unlock the container using the spell
 *
 * @param ev     The event messaged to the spellscript
 **/
void _HandleImpact(struct EventSpellScriptImpactStruct stEvent) {

    object oTarget = stEvent.oTarget;
    object oCaster = stEvent.oCaster;
    float fSpellpower = GetCreatureProperty(oCaster, PROPERTY_ATTRIBUTE_SPELLPOWER, PROPERTY_VALUE_TOTAL);

    AF_LogDebug("EVENT_TYPE_SPELLSCRIPT_IMPACT - Handling impact", AF_LOGGROUP_UNLOCK_SPELL);

    // make sure there is a location, just in case
    if (IsObjectValid(oTarget))
        stEvent.lTarget = GetLocation(oTarget);
    else
        return;

    // Get the lock difficulty
    float fCasterLevel;
    switch (stEvent.nAbility) {
        case AF_ABILITY_SPELL_UNLOCK_1: {
            float fWorkingSpellpower = fSpellpower * SPELL_UNLOCK_1_SP_MOD;
            fCasterLevel = SPELL_UNLOCK_1_POWER + Min(SPELL_UNLOCK_1_SP_CAP, FloatToInt(fWorkingSpellpower)); // This gives a max value of 20 - Very Easy Locks
            AF_LogDebug("SPELL_UNLOCK_1 - Caster level: " + FloatToString(fCasterLevel, 3, 2) + " (" + FloatToString(fWorkingSpellpower, 3, 2) + ")", AF_LOGGROUP_UNLOCK_SPELL);
            break;
        }
        case AF_ABILITY_SPELL_UNLOCK_2: {
            float fWorkingSpellpower = fSpellpower * SPELL_UNLOCK_2_SP_MOD;
            fCasterLevel = SPELL_UNLOCK_2_POWER + Min(SPELL_UNLOCK_2_SP_CAP, FloatToInt(fWorkingSpellpower)); // This gives a max value of 40 - Medium Locks
            AF_LogDebug("SPELL_UNLOCK_2 - Caster level: " + FloatToString(fCasterLevel, 3, 2) + " (" + FloatToString(fWorkingSpellpower, 3, 2) + ")", AF_LOGGROUP_UNLOCK_SPELL);
            break;
        }
        case AF_ABILITY_SPELL_UNLOCK_3: {
            float fWorkingSpellpower = fSpellpower * SPELL_UNLOCK_3_SP_MOD;
            fCasterLevel = SPELL_UNLOCK_3_POWER + Min(SPELL_UNLOCK_3_SP_CAP, FloatToInt(fWorkingSpellpower)); // This gives a max value of 60 - Very Hard Locks
            AF_LogDebug("SPELL_UNLOCK_3 - Caster level: " + FloatToString(fCasterLevel, 3, 2) + " (" + FloatToString(fWorkingSpellpower, 3, 2) + ")", AF_LOGGROUP_UNLOCK_SPELL);
            break;
        }
    }
                   
    int nActionResult;
    float fLockLevel = IntToFloat(GetPlaceablePickLockLevel(oTarget));
    AF_LogDebug("SPELL_UNLOCK - Lock level: " + FloatToString(fLockLevel, 3, 0), AF_LOGGROUP_UNLOCK_SPELL);
    if (fCasterLevel >= fLockLevel) {
        AF_LogInfo("Unlock success", AF_LOGGROUP_UNLOCK_SPELL);
        nActionResult = TRUE;
        UI_DisplayMessage(oTarget, UI_MESSAGE_UNLOCKED);
        PlaySound(oTarget, GetM2DAString(TABLE_PLACEABLE_TYPES, "PickLockSuccess", GetAppearanceType(oTarget)));
    } else {
        AF_LogInfo("Unlock fail", AF_LOGGROUP_UNLOCK_SPELL);
        nActionResult = FALSE;
        DisplayFloatyMessage(oTarget, GetStringByStringId(AF_STR_MAGIC_UNLOCK_FAIL));
        PlaySound(oTarget, GetM2DAString(TABLE_PLACEABLE_TYPES, "PickLockFailure", GetAppearanceType(oTarget)));
    }
    event evResult = Event(nActionResult ? EVENT_TYPE_UNLOCKED : EVENT_TYPE_UNLOCK_FAILED);
    evResult = SetEventObject(evResult, 0, oCaster);
    SignalEvent(oTarget, evResult); 
    
    SetPlaceableActionResult(oTarget, PLACEABLE_ACTION_UNLOCK, nActionResult);

}

/**
 * @brief Check if the spell is possible against this target
 *
 * @param ev     The event messaged to the spellscript
 **/
int checkTargetIsValid(event ev) {

    object oTarget = GetEventObject(ev, 1);    int nLockLevel = GetPlaceablePickLockLevel(oTarget);

    int bTargetValid = TRUE;

    // We only deal with 3 types of locked objects: Door, Cage & Container
    string sStateTable = GetPlaceableStateCntTable(oTarget);
    if (sStateTable != PLC_STATE_CNT_CAGE && sStateTable != PLC_STATE_CNT_CONTAINER && sStateTable != PLC_STATE_CNT_DOOR) {
        AF_LogDebug("checkTarget - target incorrect type", AF_LOGGROUP_UNLOCK_SPELL);
        DisplayFloatyMessage(oTarget, GetStringByStringId(AF_STR_MAGIC_UNLOCK_INVALID_PLACEABLE_TYPE));
        bTargetValid = FALSE;
    } else if (sStateTable == PLC_STATE_CNT_CAGE && GetPlaceableState(oTarget) != PLC_STATE_CAGE_LOCKED ||
               sStateTable == PLC_STATE_CNT_CONTAINER && GetPlaceableState(oTarget) != PLC_STATE_CONTAINER_LOCKED ||
               sStateTable == PLC_STATE_CNT_DOOR && GetPlaceableState(oTarget) != PLC_STATE_DOOR_LOCKED) {
        AF_LogDebug("checkTarget - target already unlocked", AF_LOGGROUP_UNLOCK_SPELL);
        DisplayFloatyMessage(oTarget, GetStringByStringId(AF_STR_MAGIC_UNLOCK_TARGET_UNLOCKED));
        bTargetValid = FALSE;
    } else if (GetPlaceableKeyRequired(oTarget) || nLockLevel >= DEVICE_DIFFICULTY_IMPOSSIBLE) {
        AF_LogDebug("checkTarget - target cannot be unlocked", AF_LOGGROUP_UNLOCK_SPELL);
        DisplayFloatyMessage(oTarget, GetStringByStringId(AF_STR_MAGIC_UNLOCK_INVALID));
        bTargetValid = FALSE;
    } else {
        AF_LogDebug("checkTarget - target valid", AF_LOGGROUP_UNLOCK_SPELL);
    }

    return bTargetValid;
}

/* -------------------
 * Entry point for script
 */
void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch(nEventType) {
        case EVENT_TYPE_SPELLSCRIPT_PENDING: {
            AF_LogDebug("EVENT_TYPE_SPELLSCRIPT_PENDING", AF_LOGGROUP_UNLOCK_SPELL);
            Ability_SetSpellscriptPendingEventResult(checkTargetIsValid(ev) ? COMMAND_RESULT_SUCCESS : COMMAND_RESULT_INVALID);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_CAST: {
            AF_LogDebug("EVENT_TYPE_SPELLSCRIPT_CAST", AF_LOGGROUP_UNLOCK_SPELL);

            // Get a structure with the event parameters
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);

            // Hand this through to cast_impact
            SetAbilityResult(stEvent.oCaster, stEvent.nResistanceCheckResult);

            break;
        }

        case EVENT_TYPE_SPELLSCRIPT_IMPACT: {
            AF_LogDebug("EVENT_TYPE_SPELLSCRIPT_IMPACT", AF_LOGGROUP_UNLOCK_SPELL);

            // Get a structure with the event parameters
            struct EventSpellScriptImpactStruct stEvent = Events_GetEventSpellScriptImpactParameters(ev);

            // Handle impact
            _HandleImpact(stEvent);

            break;
        }
    }
}