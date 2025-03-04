#include "af_utility_h"

/**
* Script for Area List: orz06al_orzammar_mines
*
* Contains the following areas:
*   orz510ar_caridins_cross  (Caridin's Cross)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "arl100ar_redcliffe_village") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ510AR)) {

            // Add DLC item Reaper's Cudgel
            object oContainer = GetObjectByTag("orz510ip_drifters_cache", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_gib_wep_mac_dao.uti", oContainer, 1, "", TRUE);
            }

            // No Outsiders in Orzammar
            // Equip ambusher who used to be non-dwarf with berserker gear
            object oTarget = GetObjectByTag("orz510cr_ambusher_1");
            if (IsObjectValid(oTarget)) LoadItemsFromTemplate(oTarget, "orz510cr_ambusher");

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-159.624,-57.7068,0.465045), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(-210.533,-98.7832,0.339684), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush3.utp", Location(oArea, Vector(163.533,-257.926,0.151949), 180.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush2.utp", Location(oArea, Vector(35.1716,-208.414,0.00457937), -90.0));

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ510AR);
        }
    }
}