#include "2da_constants_h"

void main() {
    event ev = GetCurrentEvent();

    object oTestCreator = GetEventObject(ev, 1);
    int nGender = GetCreatureGender(oTestCreator);

    if (GetFollowerState(oTestCreator) != FOLLOWER_STATE_INVALID) {
        if (nGender == GENDER_MALE)
            SetCanUseItem(oTestCreator, 1);
        else
            SetCanUseItem(oTestCreator, 0);
    } else {
        SetCanUseItem(oTestCreator, 1);
    }
}