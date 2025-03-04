#include "af_utility_h"

/**
* Script for Area List: drk500ar_fort
*
* Contains the following areas:
*   drk500ar_fort  (???) Darkspawn Chrinicles DLC
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "drk500ar_fort") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_DRK500AR)) {

            // Add DLC item Darkspawn Chronicles
            object oContainer = GetObjectByTag("drk_riordan", 0);
            if (IsObjectValid(oContainer)) {
                CreateItemOnObject(R"prc_im_wep_mel_lsw_drk_dao.uti", oContainer, 1, "", TRUE);
            }

            AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_DRK500AR);
        }
    }
}