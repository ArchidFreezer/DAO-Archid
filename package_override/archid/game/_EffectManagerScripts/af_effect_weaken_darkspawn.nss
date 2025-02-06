#include "effect_constants_h"
#include "monster_constants_h"

const int WND_VFX = 6610000;
const int WND_PERSISTENT = 6610000;   // References a row in the persistent_af table

void main() {
    effect eEffect = GetCurrentEffect();
    object oCreator = GetEffectCreator(eEffect);
    event ev = GetCurrentEvent();
    switch (GetEventType(ev)) {
        case EVENT_TYPE_APPLY_EFFECT: {
            effect eAoE = EffectAreaOfEffect(WND_PERSISTENT, R"af_effect_wnd_aoe.ncs", WND_VFX);
            eAoE = SetEffectEngineFloat(eAoE, EFFECT_FLOAT_SCALE, 5.0);
            Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eAoE, OBJECT_SELF, 0.0, oCreator);
            SetIsCurrentEffectValid();
            break;
        }
        case EVENT_TYPE_REMOVE_EFFECT: {
            RemoveEffectsByParameters(OBJECT_SELF, EFFECT_TYPE_AOE, 0, oCreator);
            break;
        }
    }
}