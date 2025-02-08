#include "effect_dot2_h"

void main() {
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    switch (nEventType) {
        case EVENT_TYPE_APPLY_EFFECT: {
            effect eEffect = GetCurrentEffect();
            int nRet = Effects_HandleApplyEffectDOT(eEffect);
            if (nRet) {
                // DOTs drop stealth
                SignalEventDropStealth(OBJECT_SELF);
            }
            SetIsCurrentEffectValid(nRet);

            break;
        }

        case EVENT_TYPE_REMOVE_EFFECT:
        {
            effect eEffect = GetCurrentEffect();
            Effects_HandleRemoveEffectDOT(eEffect);

            break;
        }
    }
}