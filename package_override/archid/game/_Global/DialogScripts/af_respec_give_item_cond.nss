#include "sys_achievements_h"
#include "af_respec_h"
#include "af_utility_h"

/**
* Dialog conditional
* The dialog line associated with this script will only be shown if the player does not already have a respec potion
*/

int StartingConditional()
{
    object oCharacter = GetMainControlled();
    int nParam = GetConversationEntryParameter();
    int nReturn = FALSE;
    
    AF_LogDebug("   Dialog condition script param: " + IntToString(nParam), AF_LOGGROUP_RESPEC);

    switch (nParam) {
        case DLG_PARAM_POTION: {
            nReturn = !CountItemsByTag(oCharacter, AF_ITM_RESPEC_POTION);
            break;    
        }
        case DLG_PARAM_ASSASSIN: {
            nReturn = !GetHasAchievementByID(SPEC_ROGUE_ASSASSIN);
            break;      
        }
        case DLG_PARAM_BARD: {
            nReturn = !GetHasAchievementByID(SPEC_ROGUE_BARD);
            break;  
        }
        case DLG_PARAM_BERSERKER: {
            nReturn = !GetHasAchievementByID(SPEC_WARRIOR_BERSERKER);
            break;       
        }
        case DLG_PARAM_RANGER: {
            nReturn = !GetHasAchievementByID(SPEC_ROGUE_RANGER);
            break;    
        }
        case DLG_PARAM_SHAPESHIFTER: {
            nReturn = !GetHasAchievementByID(SPEC_WIZARD_SHAPESHIFTER);
            break;          
        }
        case DLG_PARAM_SPIRITHEALER: {
            nReturn = !GetHasAchievementByID(SPEC_WIZARD_SPIRITHEALER);
            break;          
        }
        case DLG_PARAM_TEMPLAR: {
            nReturn = !GetHasAchievementByID(SPEC_WARRIOR_TEMPLAR);
            break;     
        }
        case DLG_PARAM_MAGE: {
            nReturn = (!GetHasAchievementByID(SPEC_WIZARD_SHAPESHIFTER) && !GetHasAchievementByID(SPEC_WIZARD_SPIRITHEALER));
            break;     
        }
        case DLG_PARAM_ROGUE: {
            nReturn = (!GetHasAchievementByID(SPEC_ROGUE_ASSASSIN) && !GetHasAchievementByID(SPEC_ROGUE_BARD) && !GetHasAchievementByID(SPEC_ROGUE_RANGER));
            break;     
        }
        case DLG_PARAM_WARRIOR: {
            nReturn = (!GetHasAchievementByID(SPEC_WARRIOR_BERSERKER) && !GetHasAchievementByID(SPEC_WARRIOR_TEMPLAR));
            break;
        }
        case DLG_PARAM_ANY: {
            nReturn = (!GetHasAchievementByID(SPEC_WIZARD_SHAPESHIFTER) && !GetHasAchievementByID(SPEC_WIZARD_SPIRITHEALER) &&
                       !GetHasAchievementByID(SPEC_ROGUE_ASSASSIN) && !GetHasAchievementByID(SPEC_ROGUE_BARD) && !GetHasAchievementByID(SPEC_ROGUE_RANGER) &&
                       !GetHasAchievementByID(SPEC_WARRIOR_BERSERKER) && !GetHasAchievementByID(SPEC_WARRIOR_TEMPLAR));
            break;     
        }
    }
    return nReturn;
}