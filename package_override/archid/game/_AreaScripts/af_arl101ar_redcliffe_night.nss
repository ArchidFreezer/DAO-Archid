#include "af_respec_h"
#include "af_utility_h"

/**
* Script for Area List: arl101ar_redcliffe_night
*
* Contains the following areas:
*   arl101ar_redcliffe_night (Redcliffe Village Night)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);

    if (sAreaTag == "arl101ar_redcliffe_night") {
        if (!AF_IsModuleFlagSet(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL101AR)) {

            // Respec Raven
            location lSpawn = Location(oArea, Vector(264.82, 311.54, 1.59), 70.0);
            object oRaven    = CreateObject(OBJECT_TYPE_CREATURE, AF_CRR_RESPEC_RAVEN, lSpawn);
            SetPosition(oRaven, Vector(265.3, 311.74, 3.59), FALSE);

            AF_SetModuleFlag(AF_DAOAREA2_FLAG, AF_DAOAREA2_ARL101AR);
        }
    }
}