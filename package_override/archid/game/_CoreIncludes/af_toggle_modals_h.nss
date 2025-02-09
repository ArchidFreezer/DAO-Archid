#include "ability_h"

void AF_ReactivateAbility(int nAbility) {
    int nAbilityType = GetAbilityType(nAbility);
    event ev = Event(EVENT_TYPE_SPELLSCRIPT_IMPACT);
    ev = SetEventObject(ev, 0, OBJECT_SELF);
    ev = SetEventObject(ev, 1, OBJECT_SELF);
    ev = SetEventInteger(ev, 0, nAbility);
    ev = SetEventInteger(ev, 1, nAbilityType);
    ev = SetEventLocation(ev, 0, GetLocation(OBJECT_SELF));
    Ability_DoRunSpellScript(ev, nAbility, nAbilityType);
    SetCooldown(OBJECT_SELF, nAbility, 0.0f);
}

void _DeactivateAbility(object oCreature, int nAbility) {
    int nAbilityType = Ability_GetAbilityType(nAbility);
    event ev = EventSpellScriptDeactivate(oCreature, nAbility, nAbilityType);
    Ability_DoRunSpellScript(ev, nAbility, nAbilityType);
}

void _DelayReactivate(object oCreature, int nAbility) {
    event ev = SetEventInteger(Event(EVENT_TYPE_INVALID), 0, nAbility);
    DelayEvent(0.05, oCreature, ev, "reapply_buffs");
}

void _ToggleAbility(object oCreature, int nAbility) {
    if (HasAbility(oCreature, nAbility)) {
        if (IsModalAbilityActive(oCreature,nAbility)) {
            _DeactivateAbility(oCreature, nAbility);
            _DelayReactivate(oCreature, nAbility);
        }
    }
}

void AF_ToggleAllAbilities(object oCreature) {
    _ToggleAbility(oCreature, ABILITY_TALENT_CRY_OF_VALOR);
    _ToggleAbility(oCreature, ABILITY_TALENT_DEMORALIZE);
    _ToggleAbility(oCreature, ABILITY_SPELL_FROSTWALL);
    _ToggleAbility(oCreature, ABILITY_SPELL_MIND_FOCUS);
    _ToggleAbility(oCreature, ABILITY_SPELL_FLAMING_WEAPONS);
    _ToggleAbility(oCreature, ABILITY_SPELL_ARCANE_MIGHT);
}
