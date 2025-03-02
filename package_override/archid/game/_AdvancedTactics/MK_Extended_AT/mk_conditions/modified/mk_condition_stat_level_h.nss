#ifndef MK_CONDITION_GET_CREATURE_WITH_STAT_LEVEL_H
#defsym MK_CONDITION_GET_CREATURE_WITH_STAT_LEVEL_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "ai_conditions_h"
#include "spell_constants_h"
#include "talent_constants_h"

/* Advanced Tactics */
#include "at_tools_ai_constants_h"
#include "at_tools_aoe_h"
#include "at_tools_log_h"
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h" 

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_AI_Condition_GetCreatureWithHPLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHPLevel);
object _MK_AI_Condition_GetCreatureWithManaStaminaLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nManaStaminaLevel);
object _MK_AI_SubCondition_GetCreatureWithStatLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nStatType, int nStatLevel);
int MK_AI_HasStatLevel(object oCreature, int nStatType, int nStatLevel, int nAbsoluteValue = FALSE);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object _MK_AI_Condition_GetCreatureWithHPLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nHPLevel)
{
    return _MK_AI_SubCondition_GetCreatureWithStatLevel(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, AI_STAT_TYPE_HP, nHPLevel);
}

object _MK_AI_Condition_GetCreatureWithManaStaminaLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nManaStaminaLevel)
{
    return _MK_AI_SubCondition_GetCreatureWithStatLevel(nTacticCommand, nTacticSubCommand, nTargetType, nTacticID, nAbilityTargetType, AI_STAT_TYPE_MANA_OR_STAMINA, nManaStaminaLevel);
}

object _MK_AI_SubCondition_GetCreatureWithStatLevel(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nStatType, int nStatLevel)
{
    object[] arTargets;
    int nSize;
    int i;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        case AT_TARGET_TYPE_TARGET:
        case MK_TARGET_TYPE_SAVED_ENEMY:
        case AI_TARGET_TYPE_MOST_HATED:
        {
            arTargets = _MK_AI_GetEnemiesFromTargetType(nTargetType);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_AT_AI_IsEnemyValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  _MK_AI_IsSleepRoot(arTargets[i]) == FALSE
                &&  MK_AI_HasStatLevel(arTargets[i], nStatType, nStatLevel) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER:
        case AI_TARGET_TYPE_ALLY:
        case MK_TARGET_TYPE_TEAMMATE:
        case MK_TARGET_TYPE_TEAM_MEMBER:
        case AI_TARGET_TYPE_SELF:
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            arTargets = _MK_AI_GetFollowersFromTargetType(nTargetType, nTacticID);
            nSize = GetArraySize(arTargets);

            for (i = 0; i < nSize; i++)
            {
                if (_MK_AI_IsFriendValidForAbility(arTargets[i], nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE
                &&  MK_AI_HasStatLevel(arTargets[i], nStatType, nStatLevel) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_AI_SubCondition_GetCreatureWithStatLevel] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);
        }
    }

    return OBJECT_INVALID;
}


int MK_AI_HasStatLevel(object oCreature, int nStatType, int nStatLevel, int nAbsoluteValue)
{

    if( abs(nStatLevel) < 10 )
    {
        #ifdef MK_DEBUG_CONDITIONS
        MK_PrintToLog("[MK_AI_HasStatLevel] AbsoluteValue Check : nStatLevel = " + IntToString(nStatLevel));
        #endif

        float fCurrentStat;
        float fMaxStat;
        int nCurrentStatLevel;
        int nRet = FALSE;

        switch(nStatType)
        {
            case AI_STAT_TYPE_HP:
            {
                #ifdef MK_DEBUG_CONDITIONS
                MK_PrintToLog("[MK_AI_HasStatLevel] case: AI_STAT_TYPE_HP");
                #endif

                fCurrentStat = GetCurrentHealth(oCreature);
                fMaxStat = GetMaxHealth(oCreature);
                break;
            }
            case AI_STAT_TYPE_MANA_OR_STAMINA:
            {
                #ifdef MK_DEBUG_CONDITIONS
                MK_PrintToLog("[MK_AI_HasStatLevel] case: AI_STAT_TYPE_MANA_OR_STAMINA");
                #endif

                fCurrentStat = GetCreatureProperty(oCreature, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_CURRENT);
                fMaxStat = GetCreatureProperty(oCreature, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_TOTAL);
                effect[] arrUpkeepEffects = GetEffects(oCreature, EFFECT_TYPE_UPKEEP);
                int nSize = GetArraySize(arrUpkeepEffects);
                int i;
                for(i=0; i < nSize; i++)
                    fMaxStat = fMaxStat - GetEffectFloat(arrUpkeepEffects[i], 0); //Remove Upkeep Effect Influence

                #ifdef MK_DEBUG_CONDITIONS
                MK_PrintToLog("[MK_AI_HasStatLevel] fMaxStat = " + FloatToString(fMaxStat, 4, 0));
                #endif
                if(fMaxStat <= 0.0)
                {
                    string sMsg = "[MK_AI_HasStatLevel] ERROR : fMaxStat = <= 0";
                    DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);

                    #ifdef MK_DEBUG_CONDITIONS
                    MK_PrintToLog("[MK_AI_HasStatLevel] ERROR : fMaxStat = <= 0");
                    #endif

                    return FALSE;
                }
                break;
            }
        }

        if(nStatLevel <= 0) // Mana or stamina < Max - X
        {
            nStatLevel = abs(nStatLevel)*25 ;
            if( fCurrentStat < fMaxStat - IntToFloat(nStatLevel) )
                nRet = TRUE;

            #ifdef MK_DEBUG_CONDITIONS
            MK_PrintToLog("[MK_AI_HasStatLevel] Mana or stamina < Max - " + IntToString(nStatLevel));
            #endif
        }else // Mana or stamina > X
        {
            nStatLevel = nStatLevel*25;
            if( fCurrentStat > IntToFloat(nStatLevel) )
                nRet = TRUE;

            #ifdef MK_DEBUG_CONDITIONS
            MK_PrintToLog("[MK_AI_HasStatLevel] Mana or stamina > " + IntToString(nStatLevel));
            #endif
        }
        return nRet;

    }else
    {
        #ifdef MK_DEBUG_CONDITIONS
        MK_PrintToLog("[MK_AI_HasStatLevel] PercentageValue Check (_AI_HasStatLevel called) : nStatLevel = " + IntToString(nStatLevel));
        #endif
        return _AI_HasStatLevel(oCreature, nStatType, nStatLevel);
    }

}
#endif