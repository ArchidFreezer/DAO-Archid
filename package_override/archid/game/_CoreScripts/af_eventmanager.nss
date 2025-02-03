/*
    Event Manager core script

    well, no comment, sorry
*/

#include "af_eventmanager_h"

void main() {
    EventManager_Broadcast(GetCurrentEvent());
}
