#include "effect_lucky_h"

void main() {
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);
    effect ef = GetCurrentEffect();

    switch (nEventType) {
        case EVENT_TYPE_APPLY_EFFECT: {
            Lucky_HandleApplyEffect(ef);
            break;
        }
        case EVENT_TYPE_REMOVE_EFFECT: {
            Lucky_HandleRemoveEffect(ef);
            break;
        }
    }
}