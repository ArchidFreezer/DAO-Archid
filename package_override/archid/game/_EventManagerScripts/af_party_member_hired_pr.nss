#include "af_follower_specs_h"
            
/*
* Called after the EVENT_TYPE_PARTY_MEMBER_HIRED standard processing
*
* Used by:
*   Dain's Follower specialisation points
*/
void main() {
    AF_CheckFollowerSpec(OBJECT_SELF);
}