#include "events_h"
#include "global_objects_h"
#include "af_log_h"

// This must match the row in the logging_ m2da table
const int AF_LOGGROUP_DOGGIFTS = 8;
    
void main() {
    event ev = GetCurrentEvent();

    // This event is called on the follower who receives the gift
    object oGift = GetEventObject(ev, 0);

    if(!IsObjectValid(oGift)) {
        AF_LogWarn("Invalid item gifted");
        return;
    }

    /**
    * Dog gift tweaks
    */
    string sFollower = GetTag(OBJECT_SELF);
    if (sFollower == GEN_FL_DOG) {
        float fNewVal;
        // Identify which gift this is and add the appropriate bonus
        string sGiftTag = GetTag(oGift);
        AF_LogInfo("Dog gift: " + sGiftTag, AF_LOGGROUP_DOGGIFTS);
        if (sGiftTag == "gen_im_gift_dogbone") {
            // Lamb Bone (+1 Constitution)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_CONSTITUTION, PROPERTY_VALUE_BASE) + 1.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Constitution", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_CONSTITUTION, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+1 Constitution");
        } else if (sGiftTag == "gen_im_gift_dogbone2") {
            // Ox Bone (+1 Strength)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_STRENGTH, PROPERTY_VALUE_BASE) + 1.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Strength", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_STRENGTH, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+1 Strength");
        } else if (sGiftTag == "gen_im_gift_dogbone3") {
            // Beef Bone (+2 Attack)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_ATTACK, PROPERTY_VALUE_BASE) + 2.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Attack", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_ATTACK, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+2 Attack");
        } else if (sGiftTag == "gen_im_gift_dogbone4") {
            // Large Bone (+2 Defence)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DEFENSE, PROPERTY_VALUE_BASE) + 2.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Defence", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DEFENSE, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+2 Defence");
        } else if (sGiftTag == "gen_im_gift_dogbone5") {
            // Veal Bone (+2% Dodge Chance)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DISPLACEMENT, PROPERTY_VALUE_BASE) + 2.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + "% Dodge Chance", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DISPLACEMENT, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+2% Dodge Chance");
        } else if (sGiftTag == "gen_im_gift_cake") {
            // Found Cake (+1 Willpower)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_WILLPOWER, PROPERTY_VALUE_BASE) + 1.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Willpower", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_WILLPOWER, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+1 Willpower");
        } else if (sGiftTag == "gen_im_gift_tyarn") {
            // Tangled Ball of Yarn (+1 Dexterity)
            fNewVal = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DEXTERITY, PROPERTY_VALUE_BASE) + 1.0f;
            AF_LogDebug("+" + FloatToString(fNewVal, 1, 0) + " Dexterity", AF_LOGGROUP_DOGGIFTS);
            SetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_DEXTERITY, fNewVal, PROPERTY_VALUE_BASE);
            DisplayFloatyMessage(OBJECT_SELF, "+1 Dexterity");
        }
    }
}