#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: pre01al_kings_camp
*
* Contains the following areas:
*   pre100ar_kings_camp   (Ostagar)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "pre100ar_kings_camp") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE100AR)) {

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
            location lSpawn = Location(oArea, Vector(562.17, 498.52, -0.49), -92.5);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE100AR);
        }
    }
}