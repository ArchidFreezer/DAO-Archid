#include "2da_constants_h"
#include "global_objects_h"
#include "var_constants_h"
#include "sys_itemsets_h"
#include "af_follower_specs_h"
#include "af_toggle_modals_h"

/*
* Called after the EVENT_TYPE_PARTY_MEMBER_HIRED standard processing
*
* Used by:
*   Dain's Follower specialisation points
*   Dain's Item sets on party change
*   Dain's Apply party buffs to new members
*   Dain's Dog inspiration
*/
void main() {
    event ev = GetCurrentEvent();

    AF_CheckFollowerSpec(OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, FOLLOWER_SCALED)) ItemSet_Update(OBJECT_SELF);

    // Apply party buffs to new members
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
    
    // Dog inspiration
    if (GetTag(OBJECT_SELF) == GEN_FL_DOG && GetLocalInt(OBJECT_SELF, FOLLOWER_SCALED)) {    
        for (i = 1; i <= 4; i++) {
            string sColumn = "bonus" + IntToString(i);
            int nAbility = GetM2DAInt(TABLE_APP_FOLLOWER_BONUSES, sColumn, 2);
            if(!HasAbility(OBJECT_SELF, nAbility)) AddAbility(OBJECT_SELF, nAbility);
        }
    }
    

}