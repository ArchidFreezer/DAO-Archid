#include "wrappers_h"
#include "af_constants_h"
#include "af_log_h"
#include "af_utility_h"

/**
* Script for Area List: bhm600ar_fade_harrowing
*
* Contains the following areas:
*   bhm600ar_fade_harrowing (The Fade)
*
*/
void main()
{
    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "bhm600ar_fade_harrowing") {
        object oContainer = GetObjectByTag("bhhm600ip_healing_kits");

        // Only add the items if they don't already exist
        if (IsObjectValid(oContainer)) {
/*            if (!IsObjectValid(GetObjectByTag("af_boot_lgt_sdh"))) CreateItemOnObject(R"af_boot_lgt_sdh.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_chest_lgt_sdh"))) CreateItemOnObject(R"af_chest_lgt_sdh.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_glove_lgt_sdh"))) CreateItemOnObject(R"af_glove_lgt_sdh.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_helm_lgt_sdh"))) CreateItemOnObject(R"af_helm_lgt_sdh.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_dagg_sdh_sunrise"))) CreateItemOnObject(R"af_dagg_sdh_sunrise.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_dagg_sdh_sunset"))) CreateItemOnObject(R"af_dagg_sdh_sunset.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_lsword_sdh_daybreak"))) CreateItemOnObject(R"af_lsword_sdh_daybreak.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_lsword_sdh_nightfall"))) CreateItemOnObject(R"af_lsword_sdh_nightfall.uti", oContainer, 1, "", TRUE);
            if (!IsObjectValid(GetObjectByTag("af_lbow_sdh"))) CreateItemOnObject(R"af_lbow_sdh.uti", oContainer, 1, "", TRUE); */
//            if (!IsObjectValid(GetObjectByTag("gen_im_qck_book_attribute2"))) CreateItemOnObject(R"gen_im_qck_book_attribute2.uti", oContainer, 10, "", TRUE);
        }
    }
}