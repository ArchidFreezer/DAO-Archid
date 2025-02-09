#include "2da_constants_h"
#include "config_h"
#include "core_h"
#include "af_ability_h"
#include "af_follower_specs_h"
#include "af_utility_h"

void main() {
    object[] arObjects = GetObjectsInArea(GetArea(GetHero()));

    int i;
    int nSize = GetArraySize(arObjects);
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

    // Dain's DLC Heartbeat fix
    string sName = GetName(GetModule());
    if (sName == "DAO_PRC_STR" || sName == "DAO_PRC_GIB") {
        InitHeartbeat(GetHero(), CONFIG_CONSTANT_HEARTBEAT_RATE);
    }


    object[] arParty = GetPartyPoolList();
    nSize = GetArraySize(arParty);
    for (i = 0; i < nSize; i++) {
        // Dain's Follower specialisation points
        AF_CheckFollowerSpec(arParty[i]);

        // Dain's Oghren Dwarven Resistance
        if (GetTag(arParty[i]) == "gen00fl_oghren" && !HasAbility(arParty[i], ABILITY_SKILL_DWARVEN_RESISTANCE))
            AddAbility(arParty[i], ABILITY_SKILL_DWARVEN_RESISTANCE);

        // Dain's Plus Heal
        SetCreatureProperty(arParty[i], 51, 100.0, PROPERTY_VALUE_BASE);

        // Dain's Reduce Hostility
        SetCreatureProperty(arParty[i], PROPERTY_SIMPLE_THREAT_DECREASE_RATE, 0.0, PROPERTY_VALUE_BASE);
        
        // Dain's Rune slots
        int nOpts = i ? GET_ITEMS_OPTION_EQUIPPED : GET_ITEMS_OPTION_ALL; // All items for hero , equipped for others
        object[] arItems = GetItemsInInventory(arParty[i], nOpts);
        int j, nItemSize = GetArraySize(arItems);
        for (j = 0; j < nItemSize; j++) {
            AF_CheckRuneSlots(arItems[j]);
        }
    
    }

    // Dain's Fix PC Crit Chance
    SetCreatureProperty(GetHero(), CRITICAL_MODIFIER_MELEE, 3.0, PROPERTY_VALUE_BASE);
    SetCreatureProperty(GetHero(), CRITICAL_MODIFIER_RANGED, 3.0, PROPERTY_VALUE_BASE);

}