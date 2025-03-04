#include "af_utility_h"

/**
* Script for Area List: orz03al_orzammar_nobles
*
* Contains the following areas:
*   orz300ar_nobles_quarter       (Orzammar Diamond Quarter)
*   orz310ar_shaperate            (Orzammar Shaperate)
*   orz330ar_harrowmonts_estate   (Harrowmont's Estate)
*   orz340ar_assembly             (Chamber of the Assembly)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "orz310ar_shaperate") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ310AR)) {

            // Add DLC item High Regard of House Dace
            object oContainer = GetObjectByTag("orz310ip_chest", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_gib_acc_amu_dao.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ310AR);
        }
    }
}