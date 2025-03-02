/*
    Advanced Tactics pet tools

    Good luck if you read these lines :)
*/

#include "at_tools_constants_h"

#include "ability_summon_h"
#include "wrappers_h"

void AT_CleanAbilities(object oSummon)
{
    RemoveAbility(oSummon, MONSTER_SPIDER_OVERWHELM);
    RemoveAbility(oSummon, MONSTER_BEAR_OVERWHELM);
    RemoveAbility(oSummon, AT_ABILITY_DOG_MABARI_HOWL);
    RemoveAbility(oSummon, AT_ABILITY_DOG_OVERWHELM);
    RemoveAbility(oSummon, AT_ABILITY_DOG_CHARGE);
    RemoveAbility(oSummon, AT_ABILITY_DOG_GROWL);

    int nCoreClass = GetAppearanceType(oSummon);

    if (nCoreClass == 49)
        RemoveAbility(oSummon, AT_ABILITY_DOG_SHRED);

    if (nCoreClass == 9)
        RemoveAbility(oSummon, ABILITY_TALENT_MONSTER_BEAR_RAGE);
}

void AT_EnableTacticsPresetsForSummon(object oSummon)
{
    int nCoreClass = GetAppearanceType(oSummon);
    int nTotalPresetsNum = GetM2DARows(TABLE_TACTICS_USER_PRESETS);
    int j;
    int nForClass1, nForClass2, nForClass3;
    int nPresetTable;
    int nCurrentRow;
    for (j = 0; j < nTotalPresetsNum; j++)
    {
        nCurrentRow = GetM2DARowIdFromRowIndex(TABLE_TACTICS_USER_PRESETS, j);
        nPresetTable = GetM2DAInt(TABLE_TACTICS_USER_PRESETS, "TacticsTable", nCurrentRow);
        if (nPresetTable > 0)
        {
            nForClass1 = GetM2DAInt(TABLE_TACTICS_USER_PRESETS, "ValidForClass1", nCurrentRow);
            nForClass2 = GetM2DAInt(TABLE_TACTICS_USER_PRESETS, "ValidForClass2", nCurrentRow);
            nForClass3 = GetM2DAInt(TABLE_TACTICS_USER_PRESETS, "ValidForClass3", nCurrentRow);
            if ((nCoreClass == nForClass1)
            || (nCoreClass == nForClass2)
            || (nCoreClass == nForClass3))
            {
                AddTacticPresetID(oSummon, nCurrentRow);
                SetTacticPresetID(oSummon, nCurrentRow);
            }
        }
    }
}
