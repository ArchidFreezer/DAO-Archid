#include "af_eventmanager_h"
#include "af_ability_h"

void main()
{
    event ev = GetCurrentEvent();
    object oDamager = GetEventCreator(ev);

    if (GetWeaponStyle(oDamager) == WEAPONSTYLE_DUAL && HasAbility(oDamager, AF_ABILITY_DUAL_WEAPON_EXPERT)) {
        // non-followers must use default script as on damaged events are common. creature_core will instead redirect the event
        if (IsFollower(OBJECT_SELF))
            HandleEvent(ev, R"af_rules_damaged.ncs");
        else
            HandleEvent(SetEventString(ev, 0, "af_rules_damaged"));
    } else {
        EventManager_ReleaseLock();
    }
}