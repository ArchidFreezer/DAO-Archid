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

/*    int bAchAssassin = GetHasAchievementByID(ACH_HAS_ASSASSIN);
    int bAchBerserker = GetHasAchievementByID(ACH_HAS_BERSERKER);
    int bAchChampion = GetHasAchievementByID(ACH_HAS_CHAMPION);
    int bAchDuelist = GetHasAchievementByID(ACH_HAS_DUELIST);
    int bAchRanger = GetHasAchievementByID(ACH_HAS_RANGER);
    int bAchReaver = GetHasAchievementByID(ACH_HAS_REAVER);
    int bAchTemplar = GetHasAchievementByID(ACH_HAS_TEMPLAR);
    int bAchArcaneWarrior = GetHasAchievementByID(ACH_HAS_ARCANEWARRIOR);
    int bAchBard = GetHasAchievementByID(ACH_HAS_BARD);
    int bAchBloodMage = GetHasAchievementByID(ACH_HAS_BLOODMAGE);
    int bAchShapeshifter = GetHasAchievementByID(ACH_HAS_SHAPESHIFTER);
    int bAchSpiritHealer = GetHasAchievementByID(ACH_HAS_SPIRITHEALER); */

    int bAchAssassin = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_ASSASSIN);
    int bAchBerserker = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_BERSERKER);
    int bAchChampion = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_CHAMPION);
    int bAchDuelist = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_DUELIST);
    int bAchRanger = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_RANGER);
    int bAchReaver = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_REAVER);
    int bAchTemplar = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_TEMPLAR);
    int bAchArcaneWarrior = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_ARCANEWARRIOR);
    int bAchBard = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_BARD);
    int bAchBloodMage = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_BLOODMAGE);
    int bAchShapeshifter = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_SHAPESHIFTER);
    int bAchSpiritHealer = WR_GetPlotFlag(PLT_GENPT_CORE_ACHIEVEMENTS, ACH_HAS_SPIRITHEALER);

    switch (nParam) {
        case DLG_PARAM_POTION: {
            nReturn = !CountItemsByTag(oCharacter, AF_ITM_RESPEC_POTION);
            break;
        }
        case DLG_PARAM_ASSASSIN: {
            nReturn = !bAchAssassin;
            break;
        }
        case DLG_PARAM_BARD: {
            nReturn = !bAchBard;
            break;
        }
        case DLG_PARAM_BERSERKER: {
            nReturn = !bAchBerserker;
            break;
        }
        case DLG_PARAM_RANGER: {
            nReturn = !bAchRanger;
            break;
        }
        case DLG_PARAM_SHAPESHIFTER: {
            nReturn = !bAchShapeshifter;
            break;
        }
        case DLG_PARAM_SPIRITHEALER: {
            nReturn = !bAchSpiritHealer;
            break;
        }
        case DLG_PARAM_TEMPLAR: {
            nReturn = !bAchTemplar;
            break;
        }
        case DLG_PARAM_MAGE: {
            nReturn = (!bAchShapeshifter || !bAchSpiritHealer);
            break;
        }
        case DLG_PARAM_ROGUE: {
            nReturn = (!bAchAssassin || !bAchBard || !bAchRanger);
            break;
        }
        case DLG_PARAM_WARRIOR: {
            nReturn = (!bAchBerserker || !bAchTemplar);
            break;
        }
        case DLG_PARAM_ANY: {
            nReturn = (!bAchShapeshifter || !bAchSpiritHealer ||
                       !bAchAssassin || !bAchBard || !bAchRanger ||
                       !bAchBerserker || !bAchTemplar);
            break;
        }
    }
    return nReturn;
}