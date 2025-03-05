/**
* Contains functions that are typically called from more than one script or are niche
* but too small to warrant a script file of their own
*/
#include "approval_h"
#include "placeable_h"
#include "plt_genpt_alistair_main"
#include "plt_genpt_alistair_defined"
#include "2da_constants_h"
#include "af_constants_h"
#include "af_log_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================

// Party functions
object AF_GetPartyMemberByTag(string sTag);
object AF_GetPartyPoolMemberByTag(string sTag);
int AF_RemoveParyMember(object oMember);
void AF_SetFollowerWarm(object oFollower);
int AF_IsSummon(object oCreature);

// Generic
int AF_Range(int iVal, int iMax, int iMin = 0);

// Item functions
int AF_IsItemPrank(object oItem);
void AF_CheckRuneSlots(object oItem);

// Bit mask functions
void AF_SetModuleFlag(string sVar, int nFlag, int bSet = TRUE);
int AF_IsModuleFlagSet(string sVar, int nFlag);
int AF_GetPartyMemberMask(object oCreature);

// Niche
void AF_CheckAlistairRose();
void AF_AwakeningSpecFix();
void AF_StockMerchant(object oMerchant, resource rItem, int iMax = 100, int iMin = 0, int iIncludeParty = TRUE);


//==============================================================================
//                          DEFINITIONS
//==============================================================================
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

/**
* @brief Gets whether the item is prank
*
* @param    oItem item to check if it is a prank
*
* @return   TRUE if the item is a prank; FALSE otherwise
*/
int AF_IsItemPrank(object oItem) {
    int nRet = FALSE;
    if (IsObjectValid(oItem)) {
        nRet = (GetTag(oItem) == "val_im_gift_sermon" ||
                GetTag(oItem) == "val_im_gift_chant" ||
                GetTag(oItem) == "val_im_gift_skull" ||
                GetTag(oItem) == "val_im_gift_pigeon" ||
                GetTag(oItem) == "val_im_gift_boots" ||
                GetTag(oItem) == "val_im_gift_chastity" ||
                GetTag(oItem) == "val_im_gift_stick" ||
                GetTag(oItem) == "val_im_gift_soap" ||
                GetTag(oItem) == "val_im_gift_mask");
    }
    return nRet;
}

/**
* @brief Sets the follower approval to Warm
*
* @param    oFollower follower whose approval should be changed
*/
void AF_SetFollowerWarm(object oFollower) {
    int nFollower = Approval_GetFollowerIndex(oFollower);
    if (IsObjectValid(oFollower)) {
        int bApproval = GetFollowerApproval(oFollower);
        if (bApproval > APP_RANGE_WARM) {
            int nStringRef = GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "StringRef", APP_RANGE_WARM);
            SetFollowerApprovalDescription(oFollower, nStringRef);
            Approval_ChangeApproval(nFollower, 0);
        }
    }
}

/**
* @brief Fix extra specialization point importing into Awakening
*
* If the hero already has 3 specialisations when being importing into Awakenign they should not be given another
*/
void AF_AwakeningSpecFix() {
    object oChar = GetHero();
    int iCount = 0;

    if (GetLevel(oChar) >= 22) {
        if (HasAbility(oChar, 4012) || HasAbility(oChar, 4013) || HasAbility(oChar, 4014)) iCount += 1;
        if (HasAbility(oChar, 4015) || HasAbility(oChar, 4016) || HasAbility(oChar, 4017)) iCount += 1;
        if (HasAbility(oChar, 4018) || HasAbility(oChar, 4019) || HasAbility(oChar, 4029)) iCount += 1;
        if (HasAbility(oChar, 4025) || HasAbility(oChar, 4021) || HasAbility(oChar, 4030)) iCount += 1;
        if (HasAbility(oChar, 401000) || HasAbility(oChar, 401002) || HasAbility(oChar, 401004)) iCount += 1;
        if (HasAbility(oChar, 401001) || HasAbility(oChar, 401003) || HasAbility(oChar, 401005)) iCount += 1;

        if (iCount >=3) SetCreatureProperty(oChar, AF_CRE_PROPERTY_SIMPLE_SPECIALIZATION_POINTS, 0.0f, PROPERTY_VALUE_TOTAL);
        else if (iCount ==2) SetCreatureProperty(oChar, AF_CRE_PROPERTY_SIMPLE_SPECIALIZATION_POINTS, 1.0f, PROPERTY_VALUE_TOTAL);
        else if (iCount ==1) SetCreatureProperty(oChar, AF_CRE_PROPERTY_SIMPLE_SPECIALIZATION_POINTS, 2.0f, PROPERTY_VALUE_TOTAL);
        else SetCreatureProperty(oChar, AF_CRE_PROPERTY_SIMPLE_SPECIALIZATION_POINTS, 3.0f, PROPERTY_VALUE_TOTAL);

    }
}

/**
* @brief Give Alistairs Rose amulet if he has given the hero the rose plot item
*
*/
void AF_CheckAlistairRose() {
    // If we have already given the amulet then we won't give it again
    if (AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_ALISTAIR_ROSE)) return;

    // Alistair hasn't given the rose, then don't give the amulet
    if(!WR_GetPlotFlag(PLT_GENPT_ALISTAIR_MAIN, ALISTAIR_MAIN_GIVES_PC_ROSE)) return;

    // Alistair hasn't or isn't being romanced, so don't give the amulet
    if(!WR_GetPlotFlag(PLT_GENPT_ALISTAIR_DEFINED, ALISTAIR_DEFINED_ROMANCE_ACTIVE_OR_STILL_IN_LOVE)) return;

    // We have checked the condition so give the amulet
    UT_AddItemToInventory(R"af_alistair_rose.uti", 1);

    // Set the flag so we don;t give it again
    AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_ALISTAIR_ROSE);
}

/**
* @brief Get party pool member by their tag
*
* @param    sTag tag of the party member
* @return   object of the party pool member
*/
object AF_GetPartyPoolMemberByTag(string sTag) {
    AF_LogDebug("AF_GetPartyPoolMemberByTag Called");
    object [] arParty = GetPartyPoolList();
    int i;
    int nSize = GetArraySize(arParty);
    for(i = 0; i < nSize; i++) {
        if (sTag == GetTag(arParty[i])) return arParty[i];
    }
    return OBJECT_INVALID;
}

/**
* @brief Get party member by their tag
*
* @param    sTag tag of the party member
* @return   object of the party member
*/
object AF_GetPartyMemberByTag(string sTag) {
    AF_LogDebug("AF_GetPartyMemberByTag Called");
    object [] arParty = GetPartyList();
    int i;
    int nSize = GetArraySize(arParty);
    for(i = 0; i < nSize; i++) {
        if (sTag == GetTag(arParty[i])) return arParty[i];
    }
    return OBJECT_INVALID;
}

/**
* @brief Returns if a creature is a summon
*
* @param    oCreature creature to check
* @return   TRUE if the creature is a summon; FALSE otherwise
*/
int AF_IsSummon(object oCreature) {
    AF_LogDebug("eds_IsSummon called");

    // A different take. Instead of looking for a flag, we see if their
    // tag is one of the registered party members from the party_picker
    // 2DA file. We could also just compare to the tags of the
    // GetPartyPoolList array, but what if we have lost a companions (they
    // might have become diconnected).

    int nRows = GetM2DARows(TABLE_PARTY_PICKER);
    string sTag = GetTag(oCreature);
    int i;
    for (i = 0; i < nRows; i++) {
        if (GetM2DAString(TABLE_PARTY_PICKER,"Tag",i) == sTag) {
            AF_LogDebug("eds_IsSummon: Creature tag matches entry [" + ToString(i) + "]. Returning false");
            return FALSE;
        }
    }
    AF_LogDebug("eds_IsSummon: Creature tag did not match any party members. Returning true");
    return TRUE;
}

/**
* @brief remove a member from the party
*
* @param    oMember party member to remove
* @return   TRUE if the party member was removed; FALSE otherwise
*/
int AF_RemoveParyMember(object oMember) {
    if (FALSE == AF_IsSummon(oMember)) {
        string sTag = GetTag(oMember);
        int nParty;
        int nCamp;
        int nRecruited;

        if (GEN_FL_ALISTAIR == sTag) {
            nParty  = GEN_ALISTAIR_IN_PARTY;
            nCamp  = GEN_ALISTAIR_IN_CAMP;
            nRecruited = GEN_ALISTAIR_RECRUITED;
        } else if (GEN_FL_DOG == sTag) {
            nParty  = GEN_DOG_IN_PARTY;
            nCamp  = GEN_DOG_IN_CAMP;
            nRecruited = GEN_DOG_RECRUITED;
        } else if (GEN_FL_LELIANA == sTag) {
            nParty  = GEN_LELIANA_IN_PARTY;
            nCamp  = GEN_LELIANA_IN_CAMP;
            nRecruited = GEN_LELIANA_RECRUITED;
        } else if (GEN_FL_LOGHAIN == sTag) {
            nParty  = GEN_LOGHAIN_IN_PARTY;
            nCamp  = GEN_LOGHAIN_IN_CAMP;
            nRecruited = GEN_LOGHAIN_RECRUITED;
        } else if (GEN_FL_MORRIGAN == sTag) {
            nParty  = GEN_MORRIGAN_IN_PARTY;
            nCamp  = GEN_MORRIGAN_IN_CAMP;
            nRecruited = GEN_MORRIGAN_RECRUITED;
        } else if (GEN_FL_OGHREN == sTag) {
            nParty  = GEN_OGHREN_IN_PARTY;
            nCamp  = GEN_OGHREN_IN_CAMP;
            nRecruited = GEN_OGHREN_RECRUITED;
        } else if (GEN_FL_SHALE == sTag) {
            nParty  = GEN_SHALE_IN_PARTY;
            nCamp  = GEN_SHALE_IN_CAMP;
            nRecruited = GEN_SHALE_RECRUITED;
        } else if (GEN_FL_STEN == sTag) {
            nParty  = GEN_STEN_IN_PARTY;
            nCamp  = GEN_STEN_IN_CAMP;
            nRecruited = GEN_STEN_RECRUITED;
        } else if (GEN_FL_WYNNE == sTag) {
            nParty  = GEN_WYNNE_IN_PARTY;
            nCamp  = GEN_WYNNE_IN_CAMP;
            nRecruited = GEN_WYNNE_RECRUITED;
        } else if (GEN_FL_ZEVRAN == sTag) {
            nParty  = GEN_ZEVRAN_IN_PARTY;
            nCamp  = GEN_ZEVRAN_IN_CAMP;
            nRecruited = GEN_ZEVRAN_RECRUITED;
        }

        if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, nRecruited)) {
            if(WR_GetPlotFlag(PLT_GEN00PT_PARTY, nParty) == TRUE) {
                WR_SetPlotFlag(PLT_GEN00PT_PARTY, nCamp, TRUE, TRUE);
                return TRUE;
            }
        }
    }
    return FALSE;
}

/**
* @brief    Ensure the number provided is within a given range
*
* Takes a number and if it is outside the given min and max values will return the closest value within the range

* @return   Value that is within the range
*/
int AF_Range(int iVal, int iMax, int iMin = 0) {
    if (iVal < iMin) return iMin;
    else if (iVal > iMax) return iMax;
    else return iVal;
}

/**
* @brief    Stock a merchant with a number of an item
*
* Stocks a merchant store with an item, with the number in stock being within a given range, potentially including
* the number of items held by the party being taken into account.
*
* This is typically used for items where it is not desirable for the party to carry large numbers such as powerful
* arrows or bombs. This way there are always some available but the party can't carry hundreds. The check is not
* foolproof as a player may dump the items in a chest before visiting the store, but that is up to the player.
*
* @param oStore merchant whose stock should be updated
* @param rItem item to stock in the store
* @param iMax maximum number of items
* @param iMin minimum number of items
* @param iIncludeParty whether to include the number of items held by the party in the max number
*/
void AF_StockMerchant(object oStore, resource rItem, int iMax = 100, int iMin = 0, int iIncludeParty = TRUE) {

    int iCount = UT_CountItemInInventory(rItem ,oStore);
    object[] arParty = GetPartyPoolList();

    int i;
    int nSize = GetArraySize(arParty);

    for (i = 0; i < nSize; i++) {
        iCount += UT_CountItemInInventory(rItem ,arParty[i]);
        if (iCount >= iMax) break;
    }

    int iStock = AF_Range(iMax - iCount, iMax);
    if (iStock > 0) CreateItemOnObject(rItem, oStore, iStock, "", TRUE);
}