#include "af_utility_h"

void main() {

    /* Run one-time code */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE02AL)) {
        object oContainer;          
        
        // Add DLC item Feral Wolf Charm
        oContainer = GetObjectByTag("pre200ip_iron_chest2");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_wolf_charm.uti", oContainer, 1, "", TRUE);
        }                     
        
        // Add DLC item Lion's Paw
        oContainer = GetObjectByTag("litip_kor_trail_cache");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_lionspaw.uti", oContainer, 1, "", TRUE);
        }                      
        
        // Add DLC item Lucky Stone
        oContainer = GetObjectByTag("pre211ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"prm000im_luckystone.uti", oContainer, 1, "", TRUE);
        }                        
        
        // Add Feastday Alistair Doll
        oContainer = GetObjectByTag("pre211ip_chest_iron");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_doll.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_PRE02AL);
    }
}