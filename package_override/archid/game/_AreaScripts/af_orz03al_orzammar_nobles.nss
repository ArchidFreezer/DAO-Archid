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

    /* orz310ar (Orzammar Shaperate) - run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ310AR)) {
        object oContainer;

        // Add DLC item High Regard of House Dace
        oContainer = GetObjectByTag("orz310ip_chest", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prc_im_gib_acc_amu_dao.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ORZ310AR);
    }
}