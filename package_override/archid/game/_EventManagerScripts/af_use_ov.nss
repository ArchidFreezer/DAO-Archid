#include "af_eventmanager_h"
#include "af_utility_h"
/*
* Overrides the standard EVENT_TYPE_USE event
*
*
* Used by:
*   Dain's Party skill for disarm
*/
void main() {
    event ev = GetCurrentEvent();   
    
    // Party disarm only attempts to handle the event if this is out of combat action to disarm a trap
    int nHandled = AF_PartyDisarm(ev); 
    
    if (!nHandled) {
        EventManager_ReleaseLock();
        return;
    }
}