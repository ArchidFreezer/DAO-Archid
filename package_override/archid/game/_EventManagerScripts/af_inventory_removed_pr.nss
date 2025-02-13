#include "wrappers_h"
#include "approval_h"
#include "af_utility_h"
/**
*
* Runs before the standard EVENT_TYPE_INVENTORY_REMOVED handling scripts
*
*/
void main() {
  event ev = GetCurrentEvent();
  int nEventType = GetEventType(ev); //extract event type from current event

  object oNewOwner = GetEventCreator(ev); // new owner of the item, OBJECT_INVALID if item is being destroyed on object
  int bImmediate = GetEventInteger(ev, 0); // If 0, the event is queued. If 1, it is processed immediately.
  object oItem = GetEventObject(ev, 0); // item being removed

  //Bug fix: Fixes prank incorrectly setting disposition to neutral when it should be warm or friendly
  if (AF_IsItemPrank(oItem)) {
    object [] arPool = GetPartyPoolList();
    int nSize = GetArraySize(arPool);     
    int i;
    for(i = 0; i < nSize; i++) { 
      // Assign warm first for edge cases where Approval_ChangeApproval() fails to change disposition to Friendly
      AF_SetFollowerWarm(arPool[i]);
    }
  }
}
