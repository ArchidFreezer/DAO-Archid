#include "af_utility_h"

void main() {

     // Add Feastday Protective Cone
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_PROTECTIVE_CONE)) {
        object oContainer = GetObjectByTag("genip_chest_wood_1", 0);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_muzzle.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_PROTECTIVE_CONE);
        }
    }

     // Add Feastday Grey Warden Puppet
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_GREY_WARDEN_PUPPET)) {
        object oContainer = GetObjectByTag("genip_chest_wood_1", 4);
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_horse.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_GREY_WARDEN_PUPPET);
        }
    }
}