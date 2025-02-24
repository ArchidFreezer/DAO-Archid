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
    object oContainer = GetObjectByTag("bhhm600ip_healing_kits");
    object oBook = GetObjectByTag("gen_im_qck_book_attribute2");
    object oItem1 = GetObjectByTag("af_staff_barnstokkr");
/**    object oItem2 = GetObjectByTag("gen_im_gift_pwood");
    object oItem3 = GetObjectByTag(AF_IT_GLOVE_IVORY_TOWER);
    object oItem4 = GetObjectByTag(AF_IT_HELM_IVORY_TOWER);
    object oItem5 = GetObjectByTag(AF_IT_DAGG_NIGHTFALL_BLOOM);
    object oItem6 = GetObjectByTag(AF_IT_LSWORD_NIGHTFALL_BLOOM);
    object oItem7 = GetObjectByTag(AF_IT_SHIELD_NIGHTFALL_BLOOM); */

    // Only add the items if they don't already exist
    if (IsObjectValid(oContainer)) {
        if (!IsObjectValid(oBook)) CreateItemOnObject(R"gen_im_qck_book_attribute2.uti", oContainer, 10, "", TRUE);
        if (!IsObjectValid(oItem1)) CreateItemOnObject(R"af_staff_barnstokkr.uti", oContainer, 1, "", TRUE);
/*        if (!IsObjectValid(oItem2)) CreateItemOnObject(R"gen_im_gift_pwood.uti", oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem3)) CreateItemOnObject(AF_ITR_GLOVE_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem4)) CreateItemOnObject(AF_ITR_HELM_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem5)) CreateItemOnObject(AF_ITR_DAGG_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem6)) CreateItemOnObject(AF_ITR_LSWORD_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem7)) CreateItemOnObject(AF_ITR_SHIELD_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);    */
    }
}