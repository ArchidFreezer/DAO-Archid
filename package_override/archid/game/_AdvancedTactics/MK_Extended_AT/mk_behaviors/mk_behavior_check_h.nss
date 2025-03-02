#ifndef MK_BEHAVIOR_M2DA_H
#defsym MK_BEHAVIOR_M2DA_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "ai_constants_h"
#include "core_h"
#include "2da_constants_h"

#include "mk_to_string_h"
#include "mk_test_framework_h"
#include "mk_logger_h"

//==============================================================================
//                              CONSTANTS
//==============================================================================
const string MK_BEHAVIOR_MELEE_ATTACK_RANGE = "MeleeAttackRange";
const string MK_BEHAVIOR_CAN_PICK_NEW_TARGET = "CanPickNewTarget";
const string MK_BEHAVIOR_MOVE_TO = "MoveTo";

//==============================================================================
//                          DECLARATIONS
//==============================================================================
//******************************************************************************
struct PartyRange
{
    int nTargetType;
    int nRangeId;
};

int MK_IsPartyRangeValid(struct PartyRange partyRange);
struct PartyRange MK_BehaviorCheck_PartyRange(string sBehaviorType);
struct PartyRange MK_BehaviorCheck_SwitchMelee();
struct PartyRange MK_BehaviorCheck_SwitchRanged();
struct PartyRange MK_BehaviorCheck_MeleeAttackRange();

int MK_BehaviorCheck_CanAttack();
int MK_BehaviorCheck_CanPickNewTarget();
int MK_BehaviorCheck_MoveTo();

//==============================================================================
//                          DEFINITIONS
//==============================================================================
//******************************************************************************
int MK_IsPartyRangeValid(struct PartyRange partyRange)
{
    MK_PushToCallStackTrace("MK_IsPartyRangeValid");
    int bResult;

    if (partyRange.nTargetType > 0 && partyRange.nRangeId > 0)
    {
        bResult = TRUE;
    }
    else if (partyRange.nTargetType == TARGET_TYPE_INVALID && partyRange.nRangeId == MK_RANGE_ID_INVALID)
    {
        bResult = FALSE;
    }
    else
    {
        bResult = FALSE;
        string sMsg = "PartyRange is Invalid: nTargetType = " + IntToString(partyRange.nTargetType) +
                      " nRangeId = " + IntToString(partyRange.nRangeId);
        MK_Logger(sMsg, MK_LOG_LEVEL_ERROR);
    }

    MK_RemoveLastFromCallStackTrace();
    return bResult;
}

//******************************************************************************
struct PartyRange MK_BehaviorCheck_PartyRange(string sBehaviorType)
{
    int nBehavior = GetAIBehavior(OBJECT_SELF);
    string sLabel = GetM2DAString(TABLE_AI_BEHAVIORS, "Label", nBehavior);
    int nValue = GetM2DAInt(TABLE_AI_BEHAVIORS, sBehaviorType, nBehavior);

    struct PartyRange result;
    result.nTargetType = nValue & 0xFF;
    result.nRangeId = (nValue >> 8) & 0xFF;

    //MK_PrintToLog("ParserPartyRange("+IntToString(nValue)+") = " + TargetTypeIdToString(result.nTargetType) + " / " + IntToString(result.nRangeId));
    return result;
}

//******************************************************************************
struct PartyRange MK_BehaviorCheck_SwitchMelee()
{
    return MK_BehaviorCheck_PartyRange(AI_BEHAVIOR_PREFER_MELEE);
}

//******************************************************************************
struct PartyRange MK_BehaviorCheck_SwitchRanged()
{
    return MK_BehaviorCheck_PartyRange(AI_BEHAVIOR_PREFER_RANGE);
}

//******************************************************************************
struct PartyRange MK_BehaviorCheck_MeleeAttackRange()
{
    return MK_BehaviorCheck_PartyRange(MK_BEHAVIOR_MELEE_ATTACK_RANGE);
}

//******************************************************************************
int  MK_BehaviorCheck_CanAttack()
{
    return AI_BehaviorCheck(AI_BEHAVIOR_DEFAULT_ATTACK);
}

//******************************************************************************
int MK_BehaviorCheck_CanPickNewTarget()
{
    return AI_BehaviorCheck(MK_BEHAVIOR_CAN_PICK_NEW_TARGET);
}

//******************************************************************************
int MK_BehaviorCheck_MoveTo()
{
    return AI_BehaviorCheck(MK_BEHAVIOR_MOVE_TO);
}

//==============================================================================
//                            UNIT TESTS
//==============================================================================
//******************************************************************************
void UnitTest_PartyRangeParser()
{
    int MK_BEHAVIOR_DEFAULT = 0;   
    int MK_BEHAVIOR_PASSIVE = 1;
    int MK_BEHAVIOR_DEFENSIVE = 2;
    
    PrintUnitTestHeader("UnitTest_PartyRangeParser");
    struct PartyRange partyRange;

    SetAIBehavior(OBJECT_SELF, MK_BEHAVIOR_PASSIVE);
    partyRange = MK_BehaviorCheck_SwitchMelee();
    AssertInt(partyRange.nTargetType, 0);
    AssertInt(partyRange.nRangeId, 0);

    partyRange = MK_BehaviorCheck_SwitchRanged();
    AssertInt(partyRange.nTargetType, 0);
    AssertInt(partyRange.nRangeId, 0);

    partyRange = MK_BehaviorCheck_MeleeAttackRange();
    AssertInt(partyRange.nTargetType, 0);
    AssertInt(partyRange.nRangeId, 0);

    SetAIBehavior(OBJECT_SELF, MK_BEHAVIOR_DEFAULT);
    partyRange = MK_BehaviorCheck_SwitchMelee();
    AssertInt(partyRange.nTargetType, 0);
    AssertInt(partyRange.nRangeId, 0);

    partyRange = MK_BehaviorCheck_SwitchRanged();
    AssertInt(partyRange.nTargetType, 0);
    AssertInt(partyRange.nRangeId, 0);

    partyRange = MK_BehaviorCheck_MeleeAttackRange();
    AssertInt(partyRange.nTargetType, MK_TARGET_TYPE_TEAM_MEMBER);
    AssertInt(partyRange.nRangeId, MK_RANGE_ID_MEDIUM);

    SetAIBehavior(OBJECT_SELF, MK_BEHAVIOR_DEFENSIVE);
    partyRange = MK_BehaviorCheck_SwitchMelee();
    AssertInt(partyRange.nTargetType, MK_TARGET_TYPE_TEAM_MEMBER);
    AssertInt(partyRange.nRangeId, MK_RANGE_ID_DOUBLE_SHORT);

    partyRange = MK_BehaviorCheck_SwitchRanged();
    AssertInt(partyRange.nTargetType, MK_TARGET_TYPE_TEAM_MEMBER);
    AssertInt(partyRange.nRangeId, MK_RANGE_ID_MEDIUM);

    partyRange = MK_BehaviorCheck_MeleeAttackRange();
    AssertInt(partyRange.nTargetType, MK_TARGET_TYPE_TEAM_MEMBER);
    AssertInt(partyRange.nRangeId, MK_RANGE_ID_MEDIUM);
}

//******************************************************************************
//void main(){UnitTest_PartyRangeParser();}
#endif