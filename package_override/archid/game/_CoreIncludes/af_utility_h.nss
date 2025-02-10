/**
* Contains functions that are called forom more than one script
*
* These are functions that typically too small to warrant a script file of their own
*/
#include "placeable_h"
#include "2da_constants_h"

/**
* @brief Adds rune slots to items that should have them but don't
*
* @param oItem  Item to check
*/
void AF_CheckRuneSlots(object oItem) {
    int nBaseType = GetBaseItemType(oItem);
    if (nBaseType > 0 && GetLocalInt(oItem, "ITEM_RUNE_ENABLED") == 0 && (GetM2DAInt(TABLE_ITEMS, "EquippableSlots", nBaseType) & 243) > 0 && GetM2DAInt(TABLE_ITEMS, "RuneCount", nBaseType) > -100) {
        SetLocalInt(oItem, "ITEM_RUNE_ENABLED", 1);
        // # of slots depends on material, so change it to force game engine to update item
        int nMat = GetItemMaterialType(oItem);
        SetItemMaterialType(oItem, 0);
        SetItemMaterialType(oItem, nMat);
    }
}

/**
* @brief If out of combat party memeber with highest disarm skill attempt disarm actions
*
* This is exepected to be called from the event handler
*
* @param ev The EVENT_TYPE_USE event that
*
* @return TRUE if the function handles the event; FALSE otherwise
*/
int AF_PartyDisarm(event ev) {
    int nEvent = GetEventType(ev);
    object oUser = GetEventCreator(ev);
    int nAction = GetPlaceableAction(OBJECT_SELF);
    if (nAction != PLACEABLE_ACTION_DISARM || GetGameMode() != GM_EXPLORE || !(IsFollower(oUser)) || !GetObjectActive(OBJECT_SELF)) {
        return FALSE;
    }

    int bCanUnlock = FALSE;
    int bOwned = FALSE;
    int nTargetScore = GetTrapDisarmDifficulty(OBJECT_SELF);

    float fPlayerScore = 0.0;
    object[] arParty = GetPartyList(oUser);
    int nSize = GetArraySize(arParty);
    int i;
    for (i = 0; i < nSize; i++) {
        if (Trap_GetOwner(OBJECT_SELF) == arParty[i]) {
            bOwned = TRUE;
        } else if (HasAbility(arParty[i], ABILITY_TALENT_HIDDEN_ROGUE)) {
            bCanUnlock = TRUE;
            fPlayerScore = MaxF(fPlayerScore, GetDisableDeviceLevel(arParty[i]));
        }
    }

    int nActionResult = FALSE;
    if (bOwned) {
        nActionResult = TRUE;
    } else if (bCanUnlock) {
        nActionResult = FloatToInt(fPlayerScore) >= nTargetScore;
    }

    if (nActionResult) {
        // Can only disarm a trap once.
        if (!GetLocalInt(OBJECT_SELF, PLC_DO_ONCE_A)) {
            SetLocalInt(OBJECT_SELF, PLC_DO_ONCE_A, TRUE);
            // Slight delay to account for disarm animation.
            Trap_SignalDisarmEvent(OBJECT_SELF, oUser, 0.1f);
        }
    } else {
        UI_DisplayMessage(oUser, nTargetScore >= DEVICE_DIFFICULTY_IMPOSSIBLE ? UI_MESSAGE_DISARM_NOT_POSSIBLE : TRAP_DISARM_FAILED);
        Trap_SignalTeam(OBJECT_SELF);
        PlaySound(OBJECT_SELF, SOUND_TRAP_DISARM_FAILURE);
    }

    SetPlaceableActionResult(OBJECT_SELF, nAction, nActionResult); 
    
    return TRUE;
}

