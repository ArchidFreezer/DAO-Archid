#ifndef MK_CONDITION_GAME_MODE_H
#defsym MK_CONDITION_GAME_MODE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"
/* MkBot */
#include "mk_condition_ai_status_h"
#include "mk_party_member_index_h"
#include "mk_condition_any_h"
#include "mk_constants_h"
#include "mk_constants_ai_h"
/* Talmud Storage*/
#include "talmud_storage_h"


//==============================================================================
//                                CONSTANTS
//==============================================================================
const int  MK_COMBAT_STATUS_COMBAT_START = 1;
const int  MK_COMBAT_STATUS_STRATEGY_PERSONAL_SPECIAL = 2;
const int  MK_COMBAT_STATUS_STRATEGY_PERSONAL_STANDARD = 3;
const int  MK_COMBAT_STATUS_STRATEGY_PARTY_SPECIAL = 4;
const int  MK_COMBAT_STATUS_STRATEGY_PARTY_STANDARD = 5;
const int  MK_COMBAT_STATUS_ORDER = 6;

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object MK_Condition_GameMode(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMode, int nCase, int nExcludeSleepRoot = TRUE);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object MK_Condition_GameMode(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nMode, int nCase, int nExcludeSleepRoot )
{
    object oRet;
    switch( nTargetType )
    {
        case AI_TARGET_TYPE_SELF:
        {
            oRet = OBJECT_SELF;
            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        {
            oRet = _AT_AI_GetPartyTarget(nTargetType, nTacticID);
            break;
        }
    }
    if( nCase == 0 )//combat modes
    {
        if (GetGameMode() == nMode)
            return oRet;

    }else
    {
        int idx = MK_GetPartyMemberIndex();

        switch( nMode )
        {
            case MK_COMBAT_STATUS_COMBAT_START://combat start
            {
                int nCombatStarted = FetchIntFromArray(MK_COMBAT_START_TABLE, idx);
                if( GetGameMode() == GM_COMBAT && nCombatStarted == FALSE )
                {
                    StoreIntegerInArray(MK_COMBAT_START_TABLE, TRUE,idx);
                    return oRet;
                }
                break;
            }//personal strategies
            case MK_COMBAT_STATUS_STRATEGY_PERSONAL_SPECIAL:
            {
                int nIsSpecialPersonalStrategyActive = FetchIntFromArray(MK_CHANGE_STRATEGY_PERSONAL_TABLE, idx);
                if( nIsSpecialPersonalStrategyActive == TRUE)
                    return oRet;
                break;
            }
            case MK_COMBAT_STATUS_STRATEGY_PERSONAL_STANDARD:
            {
                int nIsSpecialPersonalStrategyActive = FetchIntFromArray(MK_CHANGE_STRATEGY_PERSONAL_TABLE, idx);
                if( nIsSpecialPersonalStrategyActive == FALSE )
                    return oRet;
                break;
            }//party strategies
            case MK_COMBAT_STATUS_STRATEGY_PARTY_SPECIAL:
            {
                int nIsSpecialPartyStrategyActive = FetchIntFromArray(MK_CHANGE_STRATEGY_PARTY_TABLE, 0);
                if( nIsSpecialPartyStrategyActive == TRUE )
                    return oRet;
                break;
            }
            case MK_COMBAT_STATUS_STRATEGY_PARTY_STANDARD:
            {
                int nIsSpecialPartyStrategyActive = FetchIntFromArray(MK_CHANGE_STRATEGY_PARTY_TABLE, 0);
                if( nIsSpecialPartyStrategyActive == FALSE )
                    return oRet;
                break;
            }//execute special order
            case MK_COMBAT_STATUS_ORDER:
            {
                int nIsOrderIssued = FetchIntFromArray(MK_ISSUE_ORDER_PARTY_TABLE, idx);
                if( nIsOrderIssued == TRUE )
                {
                    StoreIntegerInArray(MK_ISSUE_ORDER_PARTY_TABLE, FALSE, idx);
                    return oRet;
                }
                break;
            }
        }
    }

    return OBJECT_INVALID;

}
#endif