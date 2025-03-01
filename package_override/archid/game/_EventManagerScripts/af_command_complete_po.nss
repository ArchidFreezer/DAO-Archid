#include "af_ability_h"
#include "af_extradogslot_h"

void main() {

    event ev = GetCurrentEvent();

    // Extra dog slot
    AF_EDS_EventCommandComplete(ev);
    
    // Advanced Quickbar
    if (IsFollower(OBJECT_SELF) && !IsSummoned(OBJECT_SELF)) {
        if (!HasAbility(OBJECT_SELF, AF_ABILITY_NEXT_QUICKBAR)) AddAbility(OBJECT_SELF, AF_ABILITY_NEXT_QUICKBAR);
        if (!HasAbility(OBJECT_SELF, AF_ABILITY_PREVIOUS_QUICKBAR)) AddAbility(OBJECT_SELF, AF_ABILITY_PREVIOUS_QUICKBAR);
        if (!HasAbility(OBJECT_SELF, AF_ABILITY_GAME_PAUSED)) AddAbility(OBJECT_SELF, AF_ABILITY_GAME_PAUSED);
    }
    
}