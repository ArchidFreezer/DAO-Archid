#include "sys_rewards_h"

void main() {
    event ev = GetCurrentEvent();
    object oKiller = GetEventObject(ev, 0);

    if (IsPartyMember(OBJECT_SELF) || IsPartyMember(oKiller) || GetLocalInt(OBJECT_SELF, "CREATURE_SPAWN_DEAD") || !IsObjectValid(oKiller)) {
        return;
    }
    
    object oHero = GetHero();
    if (IsObjectHostile(OBJECT_SELF, oHero))
        RewardXPParty(0, XP_TYPE_COMBAT, OBJECT_SELF, oHero);
    // if this creature is a combatant, pass the event to the treasure function
    if (GetCombatantType(OBJECT_SELF) != CREATURE_TYPE_NON_COMBATANT)
        HandleEvent(ev, R"sys_treasure.ncs");
}