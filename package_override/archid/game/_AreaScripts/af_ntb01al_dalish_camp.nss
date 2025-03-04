#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: ntb01al_dalish_camp
*
* Contains the following areas:
*   ntb100ar_dalish_camp   (Dalish Camp)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "ntb100ar_dalish_camp") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB100AR)) {

            // Add DLC item Dalish Promise Ring
            object oContainer = GetObjectByTag("ntb100ip_lanaya_chest");
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prm000im_dalish_ring.uti", oContainer, 1, "", TRUE);
            }

            // Respec Raven - On the pile of wood next to the smith
            location lSpawn = Location(oArea, Vector(265.44, 247.93, 6.31), -80.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
            SetPosition(oRaven, Vector(264.74, 247.8, 7.85), FALSE);

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_NTB100AR);
        }
    }
}