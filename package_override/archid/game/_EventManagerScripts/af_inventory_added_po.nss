#include "af_utility_h"

void main() {
    event ev = GetCurrentEvent();
    object oItem = GetEventObject(ev, 0);
    
    // Dain's Rune slots fix
    AF_CheckRuneSlots(oItem);
}