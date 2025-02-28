#include "af_extradogslot_h"

void main() {

    event ev = GetCurrentEvent(); 
    
    // Extra dog slot
    AF_EDS_EventCommandPending(ev);
}