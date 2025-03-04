#include "af_utility_h"

/**
* Script for Area List: bdn02al_ruined_taig
*
* Contains the following areas:
*   bdn200ar_ruined_taig   (Ruined Thaig)
*   bdn210ar_thaig_chamber (Thaig Chambers)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "bdn200ar_ruined_taig") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDN200AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(-361.444,8.29197,4.39959), 0.0));
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(-476.43,-68.3062,-0.0392104), 90.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_BDN200AR);
        }
    }
}