#include "events_h"
#include "af_extradogslot_h"
#include "af_nohelmet_h"
#include "af_respec_h"
#include "af_spellshaping_h"
#include "af_utility_h"
#include "talmud_storage_h"

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    // We will watch for every event type and if the one we need
    // appears we will handle it as a special case. We will ignore the rest
    // of the events
    switch ( nEventType )  {
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The module loads from a save game. This event can fire more than
        //       once for a single module or game instance.
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_MODULE_LOAD: {
            AF_NoHelmetBookAdd();
            AF_CheckAlistairRose();
            AF_SpellShapingCheckConfig();
            AF_ExtraDogSlotCheckConfig();
            TalStorage_ModuleLoad();
            break;
        }
        case EVENT_TYPE_MODULE_PRESAVE: {
            TalStorage_ModulePresave();
            break;
        }
        case EVENT_TYPE_GUI_OPENED: {

            int nGUIID = GetEventInteger(ev, 0); // ID number of the GUI that was opened
            switch (nGUIID) {
                case GUI_INVENTORY: {
                    AF_NoHelmetShowInventory(); // No helmet mod
                    AF_ExtraDogSlotGiveDogWhistle();
                    break;
                }
            }
            break;
        }
        case EVENT_TYPE_GAMEMODE_CHANGE: {

            int nNewGameMode = GetEventInteger(ev, 0); // New Game Mode (GM_* constant)
            int nOldGameMode = GetEventInteger(ev, 1); // Old Game Mode (GM_* constant)

            switch(nOldGameMode) {
                case GM_GUI:
                    AF_NoHelmetLeaveGUI(); // No helmet mod
                    break;
                case GM_COMBAT:
                    AF_LogDebug("END OF COMBAT detected");
                    AF_CheckDogSlot();
                    break;
                case GM_LOADING:
                    AF_ExtraDogSlotLoadingInit();
                    if (nNewGameMode == GM_EXPLORE) TalStorage_ModuleLoad();
                    break;
            }
            break;
        }
        ////////////////////////////////////////////////////////////////////////
        // Sent by: af_eds_include_h : deactivate_DogSlot
        // When: User uses ITEM_DOG_WHISTLE, but dog is already attached
        //       to someone. We end effect and tell dog to run away.
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_DOG_RAN_AWAY: {
            AF_LogDebug("EVENT_DOG_RAN_AWAY receieved", AF_LOGGROUP_EDS);
            if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED))
                WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
            break;
        }
        case EVENT_TYPE_DOG_MAKE_CLICKABLE: {
            AF_LogDebug("EVENT_MAKE_DOG_CLICKABLE received", AF_LOGGROUP_EDS);
            object oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);
            WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
            WR_SetObjectActive(oDog,TRUE);
            break;
        }
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine (May have been relayed through af_item_eds_dog_whistle)
        // When: User uses item with ITEM_UNIQUE_POWER activation associated
        //       OR ITEM_DOG_WHISTLE associated.
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_UNIQUE_POWER: {
            AF_LogDebug("EVENT_TYPE_UNIQUE_POWER", AF_LOGGROUP_EDS);
            AF_HandleDogWhistle(ev);
            break;
        }
        case EVENT_TYPE_CREATURE_ENTERS_DIALOGUE: {
            // Remove dog when begin conversation with sloth demon in mage tower.
            object oCreature = GetEventObject(ev, 0);
            // AF_LogDebug("EVENT_TYPE_CREATURE_ENTERS_DIALOGUE [" +  GetTag(oCreature) + "]");
            if ("cir230cr_sloth_demon" == GetTag(oCreature)) AF_RemoveDog(TRUE);
            break;
        }
        case EVENT_TYPE_POPUP_RESULT: {
            // Cycle through all the popup event listeners until one handles the event
            // Each listener should return TRUE or FALSE based on whether it handled the event on not
            if (AF_RespecPopupEventHandler(ev)) {
                break;
            } else if (AF_ExtraDogSlotPopupEventHandler(ev)) {
                break;
            }

            break;
        }
        case EVENT_TYPE_PARTYPICKER_CLOSED: {
            AF_ExtraDogSlotPartyPicker();
        }
        default:
            break;
    }
}
