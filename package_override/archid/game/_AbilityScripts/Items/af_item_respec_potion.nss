#include "events_h"
#include "wrappers_h"
#include "af_respec_h"
#include "af_utility_h"



void main() {
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
            object oCharacter = stEvent.oCaster;
            object[] aPartyList = GetPartyList();

            // Store the ID of this character in a module variable
            int i;
            for ( i = 0; i < GetArraySize(aPartyList); i++) {
                if ( oCharacter == aPartyList[i] ) {
                    SetLocalInt(GetModule(), AF_VAR_CHAR_RESPEC, i);
                    break;
                }
            }

            // Set the plot flag to indicate our intention of respeccing
            AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_RESPEC_USE);

            // Show a confirmation dialog box to the player
            ShowPopup(6610089, AF_POPUP_RESPEC_CHAR, oCharacter);

            break;

        } // ! EVENT_TYPE_SPELLSCRIPT_CAST

    } // ! switch

} // ! main