#include "af_respec_h"
#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE01AL)) {
        object oContainer;

        // Alistair's Oath
        object oAlistair = GetObjectByTag("gen00fl_alistair");
        if (!IsFollower(oAlistair) && !IsObjectValid(GetItemInEquipSlot(INVENTORY_SLOT_NECK, oAlistair))) {
            CreateItemOnObject(R"gen_im_acc_amu_war.uti", oAlistair);
            object oItem = GetItemPossessedBy(oAlistair, "gen_im_acc_amu_war");
            RemoveItemProperty(oItem, 10018);
            AddItemProperty(oItem, 6030, 1);
            EquipItem(oAlistair, oItem);
        }
        
        // Respec Raven - On the floor behind the fire next to Duncan
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(562.17, 498.52, -0.49), -92.5);
        object oTest    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE01AL);
    }
}