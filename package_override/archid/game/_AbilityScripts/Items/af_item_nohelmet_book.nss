#include "utility_h"
#include "events_h"
#include "wrappers_h"
#include "af_nohelmet_h"
#include "af_utility_h"

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch(nEventType) {
        // ---------------------------------------------------------------------
        // EVENT_TYPE_ABILITY_CAST_CAST
        // ---------------------------------------------------------------------
        // Fires for the moment of impact for every ability. This is where damage
        // should be applied, fireballs explode, enemies get poisoned etc'.
        // ---------------------------------------------------------------------
        case EVENT_TYPE_SPELLSCRIPT_CAST: {
            // Retrieve the character who used the item
            struct EventSpellScriptCastStruct stEvent = Events_GetEventSpellScriptCastParameters(ev);
            object oUser = stEvent.oCaster;

            string sUser = GetName(oUser);
            int iUniqueAction = 0;

            // Make sure using the potion or book
            // Cycle through all posible users
            if (IsHero(oUser)) {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_PLAYER)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_PLAYER, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_PLAYER, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Alistair") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ALISTAIR)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ALISTAIR, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ALISTAIR, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Leliana") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_LELIANA)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_LELIANA, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_LELIANA, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Loghain") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_LOGHAIN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_LOGHAIN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_LOGHAIN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Morrigan") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_MORRIGAN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_MORRIGAN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_MORRIGAN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Oghren") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_OGHREN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_OGHREN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_OGHREN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Sten") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_STEN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_STEN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_STEN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Wynne") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_WYNNE)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_WYNNE, FALSE );
                    iUniqueAction=1;
                } else{
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_WYNNE, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Zevran") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ZEVRAN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ZEVRAN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ZEVRAN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Anders") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_ANDERS)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ANDERS, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_ANDERS, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Velanna") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_VELANNA)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_VELANNA, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_VELANNA, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Sigrun") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_SIGRUN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_SIGRUN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_SIGRUN, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Mhairi") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_MHAIRI)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_MHAIRI, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_MHAIRI, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Nathaniel") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_NATHANIEL)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_NATHANIEL, FALSE );
                    iUniqueAction=1;
                } else{
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_NATHANIEL, TRUE );
                    iUniqueAction=2;
                }
            } else if (sUser=="Justice") {
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_JUSTICE)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_JUSTICE, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_JUSTICE, TRUE );
                    iUniqueAction=2;
                }
            } else { // Catch all other followers
                if (AF_IsModuleFlagSet(AF_NOHELM_FLAG, AF_NOHELM_UNKNOWN)) {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_UNKNOWN, FALSE );
                    iUniqueAction=1;
                } else {
                    AF_SetModuleFlag(AF_NOHELM_FLAG, AF_NOHELM_UNKNOWN, TRUE );
                    iUniqueAction=2;
                }
                sUser = "Unregistered Followers";
            }

            // Do the actions based on the flags
            // 1 is hide the helmet
            if (iUniqueAction == 1) {
                DisplayFloatyMessage(oUser,"Hiding Helmets on "+sUser,FLOATY_MESSAGE,0xffffff,5.0);
                object oCloakHelm = GetItemInEquipSlot(5,oUser);
                if (ObjectToString(oCloakHelm)!="-1") {
                    // Try to kick out any helm in the cloak slot
                    UnequipItem(oUser, oCloakHelm);
                    EquipItem(oUser, oCloakHelm, 8);
                    AF_NoHelmetItemSetUpdate(oUser);
                }
            } else if (iUniqueAction == 2) {
                DisplayFloatyMessage(oUser,"Showing Helmets on "+sUser,FLOATY_MESSAGE,0xffffff,5.0);
                object oCloakHelm = GetItemInEquipSlot(8,oUser);
                if (ObjectToString(oCloakHelm)!="-1") {
                    // Try to kick out any helm in the helm slot
                    UnequipItem(oUser, oCloakHelm);
                    EquipItem(oUser, oCloakHelm, 5);
                }
            }

//            UT_RemoveItemFromInventory(AF_ITR_MISC_BOOK_NOHELMET, 1, GetHero());
//            UT_AddItemToInventory(AF_ITR_MISC_BOOK_NOHELMET, 1);

            break;
        } // ! EVENT_TYPE_SPELLSCRIPT_CAST

    } // ! switch

} // ! main