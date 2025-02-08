#include "var_constants_h"
#include "sys_itemsets_h"
#include "af_follower_specs_h"

/*
* Called after the EVENT_TYPE_PARTY_MEMBER_HIRED standard processing
*
* Used by:
*   Dain's Follower specialisation points          
*   Dain's Item sets on party change
*/
void main() {
    AF_CheckFollowerSpec(OBJECT_SELF);
    if (GetLocalInt(OBJECT_SELF, FOLLOWER_SCALED)) ItemSet_Update(OBJECT_SELF);
}