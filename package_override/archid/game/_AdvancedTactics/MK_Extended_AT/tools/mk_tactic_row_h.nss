#ifndef MK_AI_TACTIC_ROW_H
#defsym MK_AI_TACTIC_ROW_H

//==============================================================================
//                              INCLUDES
//==============================================================================
// Core
#include "2da_constants_h"
#include "ai_constants_h"
#include "ai_main_h_2"  

// Advanced Tactics
#include "at_tools_ai_h" 

// MkBot
#include "mk_to_string_h"

//==============================================================================
//                              CONSTANTS
//==============================================================================
const int MK_TACTIC_ROW_ERROR_NONE                = 0;
const int MK_TACTIC_ROW_ERROR_EMPTY_TACTIC        = 1;
const int MK_TACTIC_ROW_ERROR_TACTIC_DISABLED     = 2;
const int MK_TACTIC_ROW_ERROR_ACTOR_INACTIVE      = 3;
const int MK_TACTIC_ROW_ERROR_ACTOR_CONFUSED      = 4;
const int MK_TACTIC_ROW_ERROR_INVALID_TARGET_TYPE = 5;
const int MK_TACTIC_ROW_ERROR_COMMAND_UNUSABLE    = 6;

//==============================================================================
//                          STRUCT DECLARATIONS
//==============================================================================
struct TacticRow
{
    int nTacticID;
    int nTargetTypeID;
    int nBaseConditionID;
    int nSubConditionID;
    int nConditionParameter1;
    int nConditionParameter2;
    int nCommandID;
    int nSubCommandID;
    int nCommandTargetType;
    string sAbilitySourceItem;
    int nError;
};

//==============================================================================
//                          DEFINITIONS
//==============================================================================
struct TacticRow TacticRowConstructor()
{
    struct TacticRow tTactic;

    tTactic.nTacticID              = -1;
    tTactic.nTargetTypeID          = TARGET_TYPE_INVALID;
    tTactic.nBaseConditionID       = 0;
    tTactic.nSubConditionID        = 0;
    tTactic.nConditionParameter1   = 0;
    tTactic.nConditionParameter2   = 0;
    tTactic.nCommandID             = AI_COMMAND_INVALID;
    tTactic.nSubCommandID          = ABILITY_INVALID;
    tTactic.nCommandTargetType     = TARGET_TYPE_INVALID;
    tTactic.sAbilitySourceItem     = "";
    tTactic.nError                 = MK_TACTIC_ROW_ERROR_NONE;

    return tTactic;
}

struct TacticRow EmptyTactic()
{
    struct TacticRow tEmptyTactic = TacticRowConstructor();
    tEmptyTactic.nError = MK_TACTIC_ROW_ERROR_EMPTY_TACTIC;
    return tEmptyTactic;
}

int IsTacticEmpty(struct TacticRow tTactic)
{
    return tTactic.nError == MK_TACTIC_ROW_ERROR_EMPTY_TACTIC;
}

int IsTacticRowValid(struct TacticRow tTactic)
{
    return tTactic.nError == MK_TACTIC_ROW_ERROR_NONE;
}

string TacticRowErrorToString(struct TacticRow tTactic)
{
    switch (tTactic.nError)
    {
        case MK_TACTIC_ROW_ERROR_NONE:
            return "MK_TACTIC_ROW_ERROR_NONE";
        case MK_TACTIC_ROW_ERROR_TACTIC_DISABLED:
            return "MK_TACTIC_ROW_ERROR_TACTIC_DISABLED";
        case MK_TACTIC_ROW_ERROR_ACTOR_INACTIVE:
            return "MK_TACTIC_ROW_ERROR_ACTOR_INACTIVE";
        case MK_TACTIC_ROW_ERROR_ACTOR_CONFUSED:
            return "MK_TACTIC_ROW_ERROR_ACTOR_CONFUSED";
        case MK_TACTIC_ROW_ERROR_INVALID_TARGET_TYPE:
            return "MK_TACTIC_ROW_ERROR_INVALID_TARGET_TYPE";
        case MK_TACTIC_ROW_ERROR_COMMAND_UNUSABLE:
            return "MK_TACTIC_ROW_ERROR_COMMAND_UNUSABLE";
        default:
            return "Unknown Error Code: " + IntToString(tTactic.nError);
    }

    return "[TacticRowErrorToString] ERROR";
}

string TacticRowToString(struct TacticRow tTactic)
{
    string sTactic = "";
    string[] arCols;
    int nColNum = 0;

    arCols[nColNum++] = IntToString(tTactic.nTacticID);
    arCols[nColNum++] = TargetTypeIdToString(tTactic.nTargetTypeID);
    arCols[nColNum++] = BaseConditionIdToString(tTactic.nBaseConditionID);
    arCols[nColNum++] = SubConditionIdToString(tTactic.nSubConditionID);
    arCols[nColNum++] = IntToString(tTactic.nConditionParameter1);
    arCols[nColNum++] = IntToString(tTactic.nConditionParameter2);
    arCols[nColNum++] = CommandTypeIdToString(tTactic.nCommandID);
    arCols[nColNum++] = AbilityIdToString(tTactic.nSubCommandID);
    arCols[nColNum++] = IntToString(tTactic.nCommandTargetType);

    arCols[nColNum++] = tTactic.sAbilitySourceItem;
    arCols[nColNum++] = TacticRowErrorToString(tTactic);

    return ArStringToCsv(arCols);
}

/** @brief Load Tactic Row of given Id either from GUI or from 2da  table.
* Basic validations are performed to check whether Tactic Row can be executed.
* If any test fails then error ID is stored in returned struct .nError field.
* Do not use data from Tactic Row if error occured - they are incomplete.
* @param nTacticID Id of row to be read
* @param nUseGUITables TRUE/FALSE : whether row should be read from GUI
* @param nPackageTable Id of 2da table to read Tactic Row from. It is used if nUseGUITables is FALSE
* @returns TacticRow struct
* @author MkBot
*/
struct TacticRow GetTacticRowFromTable(int nTacticID, int nUseGUITables, int nPackageTable)
{
    struct TacticRow tTactic = TacticRowConstructor();
    tTactic.nTacticID = nTacticID;

    //-------- This Tactic Row is disabled
    if (nUseGUITables && !IsTacticEnabled(OBJECT_SELF, nTacticID))
    {
        tTactic.nError = MK_TACTIC_ROW_ERROR_TACTIC_DISABLED;
        return tTactic;
    }

    //-------- Am I active?
    if (!GetObjectActive(OBJECT_SELF))
    {
        tTactic.nError = MK_TACTIC_ROW_ERROR_ACTOR_INACTIVE;
        return tTactic;
    }

    //-------- Load data from GUI or 2da table
    if (nUseGUITables)
    {
        tTactic.nTargetTypeID        = GetTacticTargetType(OBJECT_SELF, nTacticID);
        tTactic.nSubConditionID      = GetTacticCondition(OBJECT_SELF, nTacticID);
        tTactic.nCommandID           = GetTacticCommand(OBJECT_SELF, nTacticID);
        tTactic.nSubCommandID        = GetTacticCommandParam(OBJECT_SELF, nTacticID);
    }
    else
    {
        tTactic.nTargetTypeID   = GetHashedM2DAInt(nPackageTable, HASH_TARGETTYPE, nTacticID);
        tTactic.nSubConditionID = GetHashedM2DAInt(nPackageTable, HASH_CONDITION, nTacticID);
        tTactic.nCommandID      = GetHashedM2DAInt(nPackageTable, HASH_COMMAND, nTacticID);
        tTactic.nSubCommandID   = GetHashedM2DAInt(nPackageTable, HASH_SUBCOMMAND, nTacticID);
    }

    //-------- Confused(Waking Nightmare) cannot target [Self]
    if (GetHasEffects(OBJECT_SELF, EFFECT_TYPE_CONFUSION) && tTactic.nTargetTypeID == AI_TARGET_TYPE_SELF)
    {
        tTactic.nError = MK_TACTIC_ROW_ERROR_ACTOR_CONFUSED;
        return tTactic;
    }

    //--------------------------------------------------------------------------
    //      Determine [BaseCondition] for [SubCondition]
    //      Check whether [Target] is Valid for [BaseCondition]
    //      Comment:    User should not be allowed to choose invalid combination.
    //                  It can occur if you use bad written nPackageTable.
    //--------------------------------------------------------------------------
    tTactic.nBaseConditionID = GetHashedM2DAInt(TABLE_TACTICS_CONDITIONS, HASH_CONDITIONBASE, tTactic.nSubConditionID);

    int nTargetTypesForBaseCondition = GetHashedM2DAInt(TABLE_TACTICS_BASE_CONDITIONS, HASH_VALIDFORTARGET, tTactic.nBaseConditionID);
    int nTargetTypeBitField = GetHashedM2DAInt(TABLE_AI_TACTICS_TARGET_TYPE, HASH_TYPE, tTactic.nTargetTypeID);

    if ((nTargetTypeBitField & nTargetTypesForBaseCondition) == 0)
    {
        tTactic.nError = MK_TACTIC_ROW_ERROR_INVALID_TARGET_TYPE;
        return tTactic;
    }

    //-------- For chosen [SubCondition] load corresponding ConditionParameters
    tTactic.nConditionParameter1 = GetHashedM2DAInt(TABLE_TACTICS_CONDITIONS, HASH_CONDITIONPARAMETER, tTactic.nSubConditionID);
    tTactic.nConditionParameter2 = GetHashedM2DAInt(TABLE_TACTICS_CONDITIONS, HASH_CONDITIONPARAMETER2, tTactic.nSubConditionID);

    //--------------------------------------------------------------------------
    //  Advanced Tactics:
    //  The following function has been rewrited.
    //  We check if the command is usable, whatever your target is. It will
    //  check for cooldown, requirements etc...
    //  We don't need to lost time to check the condition if the action is not
    //  usable.
    //--------------------------------------------------------------------------
    if (_AT_AI_IsCommandValid(tTactic.nCommandID, tTactic.nSubCommandID, tTactic.nTargetTypeID) == FALSE)
    {
        tTactic.nError = MK_TACTIC_ROW_ERROR_COMMAND_UNUSABLE;
        return tTactic;
    }

    //--------------------------------------------------------------------------
    //  Advanced Tactics:
    //  To find a target for an ability, we need to check if this type of target
    //  is allowed for this ability.
    //  This test was not done in vanilla tactics.
    //--------------------------------------------------------------------------
    if ((tTactic.nCommandID == AI_COMMAND_USE_ABILITY) ||
        (tTactic.nCommandID == AI_COMMAND_ACTIVATE_MODE) ||
        (tTactic.nCommandID == AI_COMMAND_DEACTIVATE_MODE) ||
        (tTactic.nCommandID == AI_COMMAND_USE_ITEM))
    {
        int nAbilityType = Ability_GetAbilityType(tTactic.nSubCommandID);
        tTactic.nCommandTargetType = Ability_GetAbilityTargetType(tTactic.nSubCommandID, nAbilityType);
    }
    else if(tTactic.nCommandID == AI_COMMAND_ATTACK)
    {
        tTactic.nCommandTargetType = TARGET_TYPE_HOSTILE_CREATURE;
    }
    //-------- Get tag of item that grants the ability (e.g. Lesser Health Poultice)
    tTactic.sAbilitySourceItem  = GetTacticCommandItemTag(OBJECT_SELF, nTacticID);

    return tTactic;
}

//void main() {TacticRowToString(TacticRowConstructor());}
#endif