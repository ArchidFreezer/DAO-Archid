#include "wrappers_h"
#include "af_constants_h"
#include "af_log_h"
#include "af_utility_h"

void main()
{
    object oContainer = GetObjectByTag("bhhm600ip_healing_kits");
    object oStatBook = GetObjectByTag("gen_im_arm_hel_mag_app");
/*    object oItem1 = GetObjectByTag(AF_IT_ARM_IVORY_TOWER);
    object oItem2 = GetObjectByTag(AF_IT_BOOT_IVORY_TOWER);
    object oItem3 = GetObjectByTag(AF_IT_GLOVE_IVORY_TOWER);
    object oItem4 = GetObjectByTag(AF_IT_HELM_IVORY_TOWER);
    object oItem5 = GetObjectByTag(AF_IT_DAGG_NIGHTFALL_BLOOM);
    object oItem6 = GetObjectByTag(AF_IT_LSWORD_NIGHTFALL_BLOOM);
    object oItem7 = GetObjectByTag(AF_IT_SHIELD_NIGHTFALL_BLOOM); */

    // Only add the items if they don't already exist
    if (IsObjectValid(oContainer)) {
        if (!IsObjectValid(oStatBook)) CreateItemOnObject(R"gen_im_arm_hel_mag_app.uti", oContainer, 1, "", TRUE);
 /*       if (!IsObjectValid(oItem1)) CreateItemOnObject(AF_ITR_ARM_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem2)) CreateItemOnObject(AF_ITR_BOOT_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem3)) CreateItemOnObject(AF_ITR_GLOVE_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem4)) CreateItemOnObject(AF_ITR_HELM_IVORY_TOWER, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem5)) CreateItemOnObject(AF_ITR_DAGG_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem6)) CreateItemOnObject(AF_ITR_LSWORD_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);
        if (!IsObjectValid(oItem7)) CreateItemOnObject(AF_ITR_SHIELD_NIGHTFALL_BLOOM, oContainer, 1, "", TRUE);    */
    }
}