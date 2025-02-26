#include "core_h"
#include "utility_h"
#include "af_respec_h"

/*
* Dialog script to give an item to the hero
*/

void main()
{
    object oCharacter = GetMainControlled();

    int nParam = GetConversationEntryParameter();

    AF_LogDebug("   Dialog script param: " + IntToString(nParam), AF_LOGGROUP_RESPEC);

    switch (nParam) {
        case DLG_PARAM_POTION:
            UT_AddItemToInventory(AF_ITR_RESPEC_POTION, 1, oCharacter);
            break;
        case DLG_PARAM_ASSASSIN:
            UT_AddItemToInventory(R"gen_im_manual_assassin.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_ASSASSIN, TRUE);
            UnlockAchievementByID(ACH_HAS_ASSASSIN);
            break;
        case DLG_PARAM_BARD:
            UT_AddItemToInventory(R"gen_im_manual_bard.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_BARD, TRUE);
            UnlockAchievementByID(ACH_HAS_BARD);
            break;
        case DLG_PARAM_BERSERKER:
            UT_AddItemToInventory(R"gen_im_manual_berserker.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_BERSERKER, TRUE);
            UnlockAchievementByID(ACH_HAS_BERSERKER);
            break;
        case DLG_PARAM_RANGER:
            UT_AddItemToInventory(R"gen_im_manual_ranger.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_RANGER, TRUE);
            UnlockAchievementByID(ACH_HAS_RANGER);
            break;
        case DLG_PARAM_SHAPESHIFTER:
            UT_AddItemToInventory(R"gen_im_manual_shapeshifter.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_SHAPESHIFTER, TRUE);
            UnlockAchievementByID(ACH_HAS_SHAPESHIFTER);
            break;
        case DLG_PARAM_SPIRITHEALER:
            UT_AddItemToInventory(R"gen_im_manual_spirithealer.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_SPIRITHEALER, TRUE);
            UnlockAchievementByID(ACH_HAS_SPIRITHEALER);
            break;
        case DLG_PARAM_TEMPLAR:
            UT_AddItemToInventory(R"gen_im_manual_templar.uti", 1, oCharacter);
            WR_SetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_TEMPLAR, TRUE);
            UnlockAchievementByID(ACH_HAS_TEMPLAR);
            break;
    }
}