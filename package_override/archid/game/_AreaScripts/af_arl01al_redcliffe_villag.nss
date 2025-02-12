#include "af_utility_h"

void main() {

     // Add Feastday Scented Soap
    if (!AF_IsModuleFlagSet(AF_FEASTITEMS_FLAG, AF_FEAST_SCENTED_SOAP)) {
        object oContainer = GetObjectByTag("arl170ip_dwarven_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_soap.uti", oContainer, 1, "", TRUE);
            AF_SetModuleFlag(AF_FEASTITEMS_FLAG, AF_FEAST_SCENTED_SOAP);
        }
    }
}