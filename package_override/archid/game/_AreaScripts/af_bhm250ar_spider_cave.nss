#include "af_utility_h"

/**
* Script for Area List: bhm250ar_spider_cave
*
* Contains the following areas:
*   bhm250ar_spider_cave (Storage Caves)
*
*/
void main() {

    object oArea=GetArea(OBJECT_SELF);
    string sAreaTag=GetTag(oArea);
                              
    if (sAreaTag == "bhm250ar_spider_cave") {   
        if (!AF_IsModuleFlagSet(AF_DAOAREA3_FLAG, AF_DAOAREA3_BHM250AR)) {

            // Deep Mushrooms
            CreateObject(OBJECT_TYPE_PLACEABLE, R"genip_herb_deepmush1.utp", Location(oArea, Vector(-6.58635,-94.841,-0.0596612), 0.0));

            AF_SetModuleFlag(AF_DAOAREA3_FLAG, AF_DAOAREA3_BHM250AR);
        }
    }
}