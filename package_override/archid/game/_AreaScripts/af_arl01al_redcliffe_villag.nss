#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: arl01al_redcliffe_village
*
* Contains the following areas:
*   arl100ar_redcliffe_village (Redcliffe Village)
*   arl110ar_chantry           (Village Chantry)
*   arl120ar_blacksmith        (Blacksmith's Store)
*   arl130ar_dwyns_home        (Dwyn's Home)
*   arl140ar_kaitlyn_home      (Kaitlyn's Home - Main Floor)
*   arl141ar_kaitlyn_upstairs  (Kaitlyn's Home - Second Floor)
*   arl150ar_tavern            (Tavern)
*   arl160ar_wilhelms_cottage  (Wilhelm's Cottage)
*   arl170ar_general_store     (General Store)
*   arl180ar_generic_cottage   (House)
*   arl190ar_windmill          (Windmill)
*
*/
void main() {

    /* arl100ar (Redcliffe Village) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL100AR)) {

        // Respec Raven
        location lSpawn = Location(GetArea(GetMainControlled()), Vector(264.82, 311.54, 1.59), 70.0);
        object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
        SetPosition(oRaven, Vector(265.3, 311.74, 3.59), FALSE);

        AF_SetModuleFlag(AF_DAOAREA1_FLAG, AF_DAOAREA1_ARL100AR);
    }

    /* arl120ar (Blacksmith's Store) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL120AR)) {

        // Owens upgraded store sells Farsong
        object oContainer = GetObjectByTag("store_arl120cr_owen_extra");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"gen_im_wep_rng_lbw_fsn.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL120AR);
    }

    /* arl170ar (General Store) - Run once */
    if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL170AR)) {

        // Add Feastday Scented Soap
        object oContainer = GetObjectByTag("arl170ip_dwarven_chest");
        if (IsObjectValid(oContainer)) {
            CreateItemOnObject(R"val_im_gift_soap.uti", oContainer, 1, "", TRUE);
        }

        AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL170AR);
    }
}