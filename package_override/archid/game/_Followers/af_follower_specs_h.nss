#include "events_h"
/*
* Core code from Dain's Follower specialisation points fix
* Ensures that followers (Sten) get a second spec point at level 7
*/
int _CanSpecialise(object oCreature = OBJECT_SELF) {
    return IsHumanoid(oCreature) && !GetLocalInt(oCreature,IS_SUMMONED_CREATURE);
}

int _IsScaled(object oCreature = OBJECT_SELF) {
    return GetLocalInt(oCreature, FOLLOWER_SCALED) && !IsHero(oCreature);
}

int _MissingSpecPoints(object oCreature = OBJECT_SELF) {
    int i;
    int nSpecPoints = FloatToInt(-1.0*GetCreatureProperty(oCreature, 38));
    int nLevel = GetLevel(oCreature);
    for (i = 1; i <= nLevel; i++) {
        if (GetM2DAInt(TABLE_EXPERIENCE, "SpecPoint", i)) {
            nSpecPoints++;
        }
    }
    if (nSpecPoints <= 0) {
        return 0;
    }
    int nRows = GetM2DARows(TABLE_RULES_CLASSES);
    for (i = 0; i < nRows; i++) {
        int nRow = GetM2DARowIdFromRowIndex(TABLE_RULES_CLASSES, i);
        // Specialisations have base class set, all other classes don't
        if (GetM2DAInt(TABLE_RULES_CLASSES, "BaseClass", nRow)) {
            int nAbility = GetM2DAInt(TABLE_RULES_CLASSES, "StartingAbility1", nRow);
            if (HasAbility(oCreature, nAbility)) {
                nSpecPoints -= 1;
                if (nSpecPoints <= 0) {
                    return 0;
                }
            }
        }
    }
    return nSpecPoints;
}

void AF_CheckFollowerSpec(object oCreature = OBJECT_SELF) {
    if (_IsScaled(oCreature) && _CanSpecialise(oCreature)) {
        int nMissing = _MissingSpecPoints(oCreature);
        if (nMissing > 0) {
            float fPoints = GetCreatureProperty(oCreature, 38) + IntToFloat(nMissing);
            SetCreatureProperty(oCreature, 38, fPoints);
        }
    }
}