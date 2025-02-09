#include "af_toggle_modals_h"

/*
* Called after the EVENT_TYPE_AFTER_DEATH standard processing
*
* Used by:
*   Dain's Apply party buffs to new members
*/
void main() {
    event ev = GetCurrentEvent();

    // Apply party buffs to new members
    // The toggle modals processing send an EVENT_TYPE_INVALID event internally after a slight delay so catch that here
    if (GetEventType(ev) == EVENT_TYPE_INVALID) {
        int nAbi = GetEventInteger(ev, 0);
        if (nAbi > 0) {
           AF_ReactivateAbility(nAbi);
            return;
        }
    }

    object[] arParty = GetPartyList(GetHero());
    int i, nPartySize = GetArraySize(arParty);
    for (i = 0; i < nPartySize; i++) {
        AF_ToggleAllAbilities(arParty[i]);
    }
    
}