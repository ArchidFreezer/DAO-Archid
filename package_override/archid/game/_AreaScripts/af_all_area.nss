#include "core_h"
#include "af_ability_h"

void main() {
    object[] arObjects = GetObjectsInArea(GetArea(GetHero()));
    int i, nSize = GetArraySize(arObjects);
    
    
    for (i = 0; i < nSize; i++) {
        object oObj = arObjects[i];
        if (GetObjectType(oObj) == OBJECT_TYPE_CREATURE) {
            // Deal with bad animations preventing monster abilities
            if (GetPackageAI(oObj) == 10050 && HasAbility(oObj, AF_ABILITY_MISDIRECTION_HEX)) {
                RemoveAbility(oObj, AF_ABILITY_MISDIRECTION_HEX);
                AddAbility(oObj, AF_ABILITY_MISDIRECTION_HEX_1);
            } else if (GetPackageAI(oObj) == 10029 && HasAbility(oObj, AF_ABILITY_MARK_OF_DEATH)) {
                RemoveAbility(oObj, AF_ABILITY_MARK_OF_DEATH);
                AddAbility(oObj, AF_ABILITY_MARK_OF_DEATH_1);
            }
            
            // Dain's DOT Stacking mod
            SetCreatureFlag(arObjects[i],CREATURE_RULES_FLAG_DOT,FALSE);
        }
    }
}