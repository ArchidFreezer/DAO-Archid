#include "2da_constants_h"
#include "effect_constants_h"
#include "af_eventmanager_h"
#include "af_ability_h"

void main()
{
    event ev = GetCurrentEvent();
    int nAbility = GetEventInteger(ev, 1);
    object oDamager = GetEventCreator(ev);

    // non-followers must use default script as on damaged events are common. creature_core will instead redirect the event
    if (GetWeaponStyle(oDamager) == WEAPONSTYLE_DUAL && HasAbility(oDamager, AF_ABILITY_DUAL_WEAPON_EXPERT)) {
        // Dain's Dual Weapon Expert fix
        if (IsFollower(OBJECT_SELF))
            HandleEvent(ev, R"af_rules_damaged.ncs");
        else
            HandleEvent(SetEventString(ev, 0, "af_rules_damaged"));
    } else if (GetHasEffects(OBJECT_SELF, EFFECT_TYPE_SLEEP, nAbility)) {
        // Dain's Monster abilities fix
        if (IsFollower(OBJECT_SELF))
            HandleEvent(ev, R"af_rules_damaged.ncs");
        else
            HandleEvent(SetEventString(ev, 0, "af_rules_damaged"));
    } else if (IsModalAbilityActive(oDamager, ABILITY_TALENT_SUPPRESSING_FIRE)) {
        // Dain's Suppressing Fire fix
        if (IsFollower(OBJECT_SELF))
            HandleEvent(ev, R"af_rules_damaged.ncs");
        else
            HandleEvent(SetEventString(ev, 0, "af_rules_damaged"));
    } else {
        EventManager_ReleaseLock();
    }
}