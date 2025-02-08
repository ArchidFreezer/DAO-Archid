#include "af_eventmanager_h"
#include "events_h"
#include "sys_stealth_h"
   
/*
* Overrides the standard EVENT_TYPE_CAST_AT event
*
*
* Used by:
*   Dain's Abilities apply impact threat
*   Dain's Friendly abilities drop stealth
*/
void main() {
    struct EventOnCastAtParamStruct stEvent = GetEventOnCastAtParams(GetCurrentEvent());
               
    // We only handle the event for creatures
    if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE) {
        EventManager_ReleaseLock();
        return;
    }

    // We only want to affect hostile events and the bHostile flag isn't reliable
    // If this is not a hostile event then eat it as we don't want the standard code to run as it can break stealth
    if (!IsObjectHostile(OBJECT_SELF, stEvent.oCaster)) {
        return;
    }

    if (stEvent.bHostile)
    {
        if(!IsPerceiving(OBJECT_SELF, stEvent.oCaster))
        {
            WR_TriggerPerception(OBJECT_SELF, stEvent.oCaster);
            WR_TriggerPerception(stEvent.oCaster, OBJECT_SELF);
        }
        // Default handler adds impact threat here. The cast at event is inconsistently called, though, so in lieu of
        // overriding every ability we nuke it here and apply it instead via the ability cast impact event
    }
}