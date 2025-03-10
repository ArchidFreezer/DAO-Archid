#include "effects_h"
#include "sys_itemprops_h"

void main()
{
    event ev = GetCurrentEvent();
    int nOnHitEffectId = GetEventInteger(ev,0);

    // First determine proc chance. If no proc, no point in wasting cpu time on the rest
    int nForceProc = GetEventInteger(ev,2);
    if (nForceProc > 0 || RandomFloat() < GetM2DAFloat(TABLE_ITEMPRPS, "ProcChance", nOnHitEffectId)) {
        object oAttacker = GetEventCreator(ev);
        // check to see if the character is in a shapeshifted form
        // this prevents a rat from having a huge stack of damage floaties from equipment
        if (!IsShapeShifted(oAttacker)) {
            object oTarget = GetEventTarget(ev);
            // No care about dead targets or non creatures
            if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !IsDeadOrDying(oTarget)) {
                ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, EffectDispelMagic(), oTarget, 0.0f, oAttacker, 430050);
            }
        }
    }
}