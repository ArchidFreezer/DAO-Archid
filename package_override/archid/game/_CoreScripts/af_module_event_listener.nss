#include "events_h"
#include "af_nohelmet_h"
#include "af_respec_h"
#include "af_utility_h"

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
            break;
        }
        case EVENT_TYPE_GUI_OPENED: {

            int nGUIID = GetEventInteger(ev, 0); // ID number of the GUI that was opened
            switch (nGUIID) {
                case GUI_INVENTORY: {
                    AF_NoHelmetShowInventory(); // No helmet mod
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
            }
            break;
        }
        case EVENT_TYPE_POPUP_RESULT: {
            // Cycle through all the popup event listeners until one handles the event
            // Each listener should return TRUE or FALSE based on whether it handled the event on not
            if(AF_RespecPopupEventHandler(ev)) {
                break;
            }

            break;
        }
        default:
            break;
    }
}
