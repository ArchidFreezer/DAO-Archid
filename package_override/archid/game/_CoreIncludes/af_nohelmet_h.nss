#include "sys_itemsets_h"
#include "utility_h"
#include "af_log_h"
#include "af_utility_h"

// This must match the row in the logging_ m2da table
const int AF_LOGGROUP_NOHELMET = 2;

const resource AF_ITR_MISC_BOOK_NOHELMET      = R"af_im_qck_book_nohelmet.uti";
const string   AF_IT_MISC_BOOK_NOHELMET       = "af_im_qck_book_nohelmet";
const int      AF_POPUP_STREF_NOHELMET        = 6610003;

///////////////////////
// Add the the no helmet book to the hero inventory
//
void AF_NoHelmetBookAdd() {
    object oBook = GetObjectByTag(AF_IT_MISC_BOOK_NOHELMET);
    if (!IsObjectValid(oBook)) {
        AF_LogDebug("adding book", AF_LOGGROUP_NOHELMET);
        UT_AddItemToInventory(AF_ITR_MISC_BOOK_NOHELMET, 1);
    }
}

///////////////////////
// Show any helmet in the inventory screen
//
void AF_NoHelmetShowInventory() {
    AF_LogDebug("Showing inventory", AF_LOGGROUP_NOHELMET);
    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_SLOT_ACTIVE)) {
        // Swap helmets to make visible
        string oAreaStr = ObjectToString(GetArea(GetHero()));

        object[] oParty = GetPartyList();
        int nSize = GetArraySize(oParty);
        // Whenever the party size is 1, get from party pool instead
        if (nSize==1)  {
            oParty = GetPartyPoolList();
            nSize = GetArraySize(oParty);
        }

        int i;
        for (i = 0; i < nSize; i++) {
            object oMember = oParty[i];
            object oCloakHelm = GetItemInEquipSlot(8,oMember);
            // if there is a helmet in the cloak slot, move it to the helmet slot
            if (ObjectToString(oCloakHelm)!="-1") {
                // Try to kick out any helm in the helm slot
                UnequipItem(oMember,oCloakHelm);
                EquipItem(oMember,oCloakHelm,5);
            }
        }
        AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_SLOT_ACTIVE, TRUE);
    }
}

////////////////////
// Apply item set values when the helmet is not shown
//
void AF_NoHelmetItemSetUpdate(object oCreature) {

    AF_LogInfo("Item set update", AF_LOGGROUP_NOHELMET);

    // remove all flag effects
    effect[] eEffects = GetEffectsByAbilityId(oCreature, ABILITY_ITEM_SET);
    RemoveEffectArray(oCreature, eEffects);

    // get equipped items
    object[] oItems;
    oItems[0] = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oCreature);
    oItems[1] = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND, oCreature);
    oItems[2] = GetItemInEquipSlot(INVENTORY_SLOT_CHEST, oCreature);
    if (IsObjectValid(GetItemInEquipSlot(INVENTORY_SLOT_CLOAK, oCreature)))  {
        oItems[3] = GetItemInEquipSlot(INVENTORY_SLOT_CLOAK, oCreature);
    } else {
        oItems[3] = GetItemInEquipSlot(INVENTORY_SLOT_HEAD, oCreature);
    }
    oItems[4] = GetItemInEquipSlot(INVENTORY_SLOT_GLOVES, oCreature);
    oItems[5] = GetItemInEquipSlot(INVENTORY_SLOT_BOOTS, oCreature);
    oItems[6] = GetItemInEquipSlot(INVENTORY_SLOT_BELT, oCreature);
    oItems[7] = GetItemInEquipSlot(INVENTORY_SLOT_RING1, oCreature);
    oItems[8] = GetItemInEquipSlot(INVENTORY_SLOT_RING2, oCreature);
    oItems[9] = GetItemInEquipSlot(INVENTORY_SLOT_NECK, oCreature);
    oItems[10] = GetItemInEquipSlot(INVENTORY_SLOT_RANGEDAMMO, oCreature);
    oItems[11] = GetItemInEquipSlot(INVENTORY_SLOT_DOG_COLLAR, oCreature);
    oItems[12] = GetItemInEquipSlot(INVENTORY_SLOT_DOG_WARPAINT, oCreature);
    oItems[13] = GetItemInEquipSlot(INVENTORY_SLOT_SHALE_CHEST, oCreature); // shale armor
    oItems[14] = GetItemInEquipSlot(INVENTORY_SLOT_SHALE_RIGHTARM, oCreature); // shale weapon
    oItems[15] = GetItemInEquipSlot(INVENTORY_SLOT_CLOAK, oCreature);
    oItems[16] = GetItemInEquipSlot(INVENTORY_SLOT_BITE, oCreature);
    oItems[17] = GetItemInEquipSlot(INVENTORY_SLOT_SHALE_SHOULDERS, oCreature);
    oItems[18] = GetItemInEquipSlot(INVENTORY_SLOT_SHALE_LEFTARM, oCreature);

    // construct slot array
    int nSlotArray;
    int nMax = 19;
    int nCount = 0;
    int nCountValue = 1;
    for (nCount = 0; nCount < nMax; nCount++) {
        // if item in this slot is valid
        if (IsObjectValid(oItems[nCount])) nSlotArray += nCountValue;
        nCountValue *= 2;
    }

    AF_LogDebug("nSlotArray = " + ToString(nSlotArray), AF_LOGGROUP_NOHELMET);

    // if there are items equipped
    if (nSlotArray > 0) {
        // go through each item
        //nMax = 19;
        nCount = 0;
        nCountValue = 1;
        for (nCount = 0; nCount < nMax; nCount++) {
            // if this slot is in the slot array
            if ((nSlotArray & nCountValue) == nCountValue) {
                // get item set
                int nItemSet = GetLocalInt(oItems[nCount], ITEM_SET);
                if (nItemSet > 0) {
                    // get set array
                    int nSetArray = GetM2DAInt(TABLE_ITEM_SETS, "Slots", nItemSet);

                    // if contained within slot array
                    if ((nSlotArray & nSetArray) == nSetArray) {
                        // remove current slot from consideration
                        nSlotArray -= nCountValue;

                        // check each component item
                        int bValid = TRUE;
                        int nCount2Value = nCountValue * 2;
                        int nCount2;
                        for (nCount2 = nCount + 1; nCount2 < nMax; nCount2++) {
                            // if a valid item in the set
                            if ((nSetArray & nCount2Value) == nCount2Value) {
                                // if same set, subtract from slot array
                                if (GetLocalInt(oItems[nCount2], ITEM_SET) == nItemSet)
                                    nSlotArray -= nCount2Value;
                                else
                                    bValid = FALSE;
                            }

                            nCount2Value *= 2;

                            if (nCount2Value > nSetArray) nCount2 = nMax;
                        }

                        if (bValid) {
                            // if bValid TRUE, apply effect
                            ItemSet_SetEffectArray(oCreature, nItemSet);
                        }
                    } else {
                        // remove this slot
                        nSlotArray -= nCountValue;
                    }
                } else {
                    // remove this slot
                    nSlotArray -= nCountValue;
                }
            }

            // if there are no more items to examine
            if (nSlotArray <= 0)
            {
                nCount = nMax;
            }

            nCountValue *= 2;
        }
    }
}

//////////////////////////
// Show/hide helmets as appropriate on leaving a GUI screen
//
void AF_NoHelmetLeaveGUI() {
    AF_LogDebug("Leaving GUI", AF_LOGGROUP_NOHELMET);
    // Test if helmets have been swapped
    if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_SLOT_ACTIVE)) {
        // hide the helmets if plot flag allows it
        string oAreaStr = ObjectToString(GetArea(GetHero()));

        object[] oParty = GetPartyList();
        int nSize = GetArraySize(oParty);
        // Whenever the party size is 1, get from party pool instead
        if (nSize==1) {
            oParty = GetPartyPoolList();
            nSize = GetArraySize(oParty);
        }


        int i;
        int iAllowSwap;
        string sUser;
        for (i = 0; i < nSize; i++) {
            object oMember = oParty[i];
            object oCloakHelm = GetItemInEquipSlot(5,oMember);
            iAllowSwap=0;
            sUser = GetName(oMember);

            // if there is a helmet in the helmet slot, move it to the cloak slot
            if (ObjectToString(oCloakHelm)!="-1") {
                // Allow swaps if character flags allow it
                if (IsHero(oMember)) {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_PLAYER)) iAllowSwap=1;
                } else if (sUser=="Alistair") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ALISTAIR)) iAllowSwap=1;
                } else if (sUser=="Leliana") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_LELIANA)) iAllowSwap=1;
                } else if (sUser=="Loghain") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_LOGHAIN)) iAllowSwap=1;
                } else if (sUser=="Morrigan") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_MORRIGAN)) iAllowSwap=1;
                } else if (sUser=="Oghren") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_OGHREN)) iAllowSwap=1;
                } else if (sUser=="Sten") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_STEN)) iAllowSwap=1;
                } else if (sUser=="Wynne") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_WYNNE)) iAllowSwap=1;
                } else if (sUser=="Zevran") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ZEVRAN)) iAllowSwap=1;
                } else if (sUser=="Anders") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ANDERS)) iAllowSwap=1;
                } else if (sUser=="Velanna") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_VELANNA)) iAllowSwap=1;
                } else if (sUser=="Sigrun") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_SIGRUN)) iAllowSwap=1;
                } else if (sUser=="Mhairi") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_MHAIRI)) iAllowSwap=1;
                } else if (sUser=="Nathaniel") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_NATHANIEL)) iAllowSwap=1;
                } else if (sUser=="Justice") {
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_JUSTICE)) iAllowSwap=1;
                } else {// Name is not one of above, so catch all unknown
                    if (!AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_UNKNOWN)) iAllowSwap=1;
                }

               if (iAllowSwap==1) {
                    // Try to kick out any helm in the helm slot
                    UnequipItem(oMember,oCloakHelm);
                    EquipItem(oMember,oCloakHelm,8);
                    // Module check to see if the item actually went into the cloak slot
                    object oCheckCloak = GetItemInEquipSlot(8,oMember);
                    if (ObjectToString(oCheckCloak)=="-1") {
                        // An error occured, the cloak slot is unusable
                        ShowPopup(AF_POPUP_STREF_NOHELMET,3);
                        // Put the helmet back on so as not to freak put the user
                        EquipItem(oMember,oCloakHelm,5);
                    } else {
                        // Item has been placed in the cloak slot, now run the custom item set handler
                        AF_NoHelmetItemSetUpdate(oMember);
                    }
                }
            }
        }
        AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_SLOT_ACTIVE, FALSE);
    }
}
