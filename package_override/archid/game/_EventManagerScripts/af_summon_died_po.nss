#include "af_extradogslot_h"

void main() {

    event ev = GetCurrentEvent();

    // Extra dog slot
    AF_LogDebug("EVENT_TYPE_SUMMON_DIED CAUGHT for [" + GetTag(OBJECT_SELF) + "]", AF_LOGGROUP_EDS);
    AF_CheckDogSlot();
}