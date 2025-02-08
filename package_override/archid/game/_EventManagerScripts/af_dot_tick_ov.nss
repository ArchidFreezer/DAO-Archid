#include "effect_dot2_h"

void main() {
    if (IsDead() || IsDying())
        SetCreatureFlag(OBJECT_SELF,CREATURE_RULES_FLAG_DOT,FALSE);
    else
        Effects_HandleCreatureDotTickEvent();
}