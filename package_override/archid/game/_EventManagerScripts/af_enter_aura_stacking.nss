#include "effect_constants_h"
#include "af_eventmanager_h"
#include "af_ability_h"

void main() {
    event ev = GetCurrentEvent();
    int nAbility = GetEventInteger(ev, 0);
    // Rock mastery is special (stone aura is too but you can't transistion areas with it active so...)
    if (nAbility == AF_ABILITY_ROCK_MASTERY)
        nAbility = AF_ABILITY_ROCK_MASTERY_EFFECT1;
    object oTarget = GetEventTarget(ev);
    object oCaster = GetEventCreator(ev);
    if (nAbility != 0 && oTarget != oCaster) {
        effect[] arEffects = GetEffects(oTarget, EFFECT_TYPE_INVALID, nAbility, oCaster);
        int nSize = GetArraySize(arEffects);
        int i;
        for (i = 0;i < nSize;i++) {
            effect ef = arEffects[i];
            if (GetEffectType(ef) != EFFECT_TYPE_AOE)
                RemoveEffect(oTarget, ef);
        }
    }
}