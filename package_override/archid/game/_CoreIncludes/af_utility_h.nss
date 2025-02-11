/**
* Contains functions that are called forom more than one script
*
* These are functions that typically too small to warrant a script file of their own
*/
#include "placeable_h"
#include "2da_constants_h"
#include "af_constants_h"
#include "af_log_h"

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

/**
* @brief Sets a module flag (boolean persistent variable) on a creature
*
* Flags are used by various game systems and should always be set through this function.
*
* @param sVar   the module variable
* @param nFlag  flag to set.
* @param bSet   whether to set or to clear the flag.
*
**/
void AF_SetModuleFlag(string sVar, int nFlag, int bSet = TRUE) {
    int nVal = GetLocalInt(GetModule(), sVar);
    int nOld= nVal;

    if (bSet)
        nVal |= nFlag;
    else
        nVal &= ~nFlag;
    
    AF_LogDebug("AF_SetModuleFlag Variable: " + sVar + " Flag: " + IntToHexString(nFlag) + " Was: " + IntToHexString(nOld) + " Is: " + IntToHexString(nVal));
    
    SetLocalInt(GetModule(), sVar, nVal);
} 

/**
* @brief Returns the state of a module flag
*
* A module flag is a persistent boolean variable
*
* @param    sVar   the module variable to check
* @param    nFlag  the flag
*
* @returns  TRUE or FALSE state of the flag.
*/
int AF_IsModuleFlagSet(string sVar, int nFlag) {
    int nVal  = GetLocalInt(GetModule(), sVar);

    AF_LogDebug("AF_GetModuleFlag Variable: " + sVar + " Flag: " + IntToHexString(nFlag) + " Value: " + IntToHexString(nVal) + " Result: " + IntToString(( (nVal  & nFlag ) == nFlag)));

    return ( (nVal & nFlag ) == nFlag);
}
 
/**
* @brief Gets the hex flag mask for a party member
*
* @param    oCreature party member to get mask for
*
* @return   bitmask for the follower; -1 if the creature is not a valid party member
*/
int AF_GetPartyMemberMask(object oCreature) {
    string sTag = GetTag(oCreature);
    int nRet = 0;
    if (IsHero(oCreature)) nRet = AF_PARTY_FLAG_HERO;
    else if(sTag == GEN_FL_ALISTAIR) nRet = AF_PARTY_FLAG_ALISTAIR;
    else if(sTag == GEN_FL_DOG) nRet = AF_PARTY_FLAG_DOG;
    else if(sTag == GEN_FL_MORRIGAN) nRet = AF_PARTY_FLAG_MORRIGAN;
    else if(sTag == GEN_FL_WYNNE) nRet = AF_PARTY_FLAG_WYNNE;
    else if(sTag == GEN_FL_SHALE) nRet = AF_PARTY_FLAG_SHALE;
    else if(sTag == GEN_FL_STEN) nRet = AF_PARTY_FLAG_STEN;
    else if(sTag == GEN_FL_ZEVRAN) nRet = AF_PARTY_FLAG_ZEVRAIN;
    else if(sTag == GEN_FL_OGHREN) nRet = AF_PARTY_FLAG_OGHREN;
    else if(sTag == GEN_FL_LELIANA) nRet = AF_PARTY_FLAG_LELIANA;
    else if(sTag == GEN_FL_LOGHAIN) nRet = AF_PARTY_FLAG_LOGHAIN;

    return nRet;
}

