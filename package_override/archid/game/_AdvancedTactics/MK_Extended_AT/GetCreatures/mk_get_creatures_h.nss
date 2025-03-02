//##############################################################################
#ifndef MK_GET_CREATURES_H
#defsym MK_GET_CREATURES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_party_member_index_h"
#include "mk_sort_creatures_h"

#include "mk_print_to_log_h"
#include "mk_test_framework_h"

/* Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                          CONSTANTS
//==============================================================================
//------------------------- SAVED SECONDARY TARGETS
const string MK_SAVED_SECONDARY_ENEMY_TABLE  = "mkSSET";
const string MK_SAVED_SECONDARY_FRIEND_TABLE = "mkSSFT";

const string MK_AI_VAR_SAVED_ENEMY  = "AI_CUSTOM_AI_VAR_OBJECT";//"MK_AI_SAVED_ENEMY";
const string MK_AI_VAR_SAVED_FRIEND = "MK_AI_SAVED_FRIEND";

//==============================================================================
//                          DECLARATIONS
//==============================================================================
object MK_SetSavedEnemy(object oTarget, object oPartyMember = OBJECT_SELF);
object MK_GetSavedEnemy(object oPartyMember = OBJECT_SELF);

object MK_SetSavedFriend(object oTarget, object oPartyMember = OBJECT_SELF);
object MK_GetSavedFriend(object oPartyMember = OBJECT_SELF);

//==============================================================================
//                          DEFINITIONS
//==============================================================================

/** @brief Store given creature as a Saved Enemy of a given Party Member
*
* Hostility of oTarget is not tested - it is up to you.
*
* @param oTarget creature to be stored
* @param oPartyMember Party Member to which storage oTarget will be saved
* @author MkBot
*/
void MK_SetSavedEnemy(object oTarget, object oPartyMember)
{
    SetLocalObject(oPartyMember, MK_AI_VAR_SAVED_ENEMY, oTarget);
    //int idx = MK_GetPartyMemberIndex(oPartyMember);
    //StoreObjectInArray(MK_SAVED_SECONDARY_ENEMY_TABLE, oTarget, idx);
} // SetSavedEnemy

/** @brief Load and return Saved Enemy of a given Party Member
*
* @param oPartyMember Party Member from which storage Secondary Target will be returned
* @author MkBot
*/
object MK_GetSavedEnemy(object oPartyMember)
{
    return GetLocalObject(oPartyMember, MK_AI_VAR_SAVED_ENEMY);
    //int idx = MK_GetPartyMemberIndex(oPartyMember);
    //return FetchObjectFromArray(MK_SAVED_SECONDARY_ENEMY_TABLE, idx);
} // GetSavedEnemy

/** @brief Store given creature as a Saved Friend of a given Party Member
*
* Friendliness of oTarget is not tested - it is up to you.
*
* @param oTarget creature to be stored
* @param oPartyMember Party Member to which storage oTarget will be saved
* @author MkBot
*/
void MK_SetSavedFriend(object oTarget, object oPartyMember)
{
    //SetLocalObject(oPartyMember, MK_AI_VAR_SAVED_FRIEND, oTarget);
    int idx = MK_GetPartyMemberIndex(oPartyMember);
    StoreObjectInArray(MK_SAVED_SECONDARY_FRIEND_TABLE, oTarget, idx);
} // SetSavedFriend

/** @brief Load and return Secondary Target of a given Party Member
*
* @param oPartyMember Party Member from which storage Secondary Target will be returned
* @author MkBot
*/
object MK_GetSavedFriend(object oPartyMember)
{
    //return GetLocalObject(oPartyMember, MK_AI_VAR_SAVED_FRIEND);
    int idx = MK_GetPartyMemberIndex(oPartyMember);
    return FetchObjectFromArray(MK_SAVED_SECONDARY_FRIEND_TABLE, idx);
} // GetSavedFriend

//==============================================================================
//                            UNIT TESTS
//==============================================================================
int UnitTest_SavedFriend(object oFriend)
{
    PrintUnitTestHeader("UnitTest_SavedFriend");
    MK_SetSavedFriend(oFriend);
    object oSavedFriend = MK_GetSavedFriend();
    MK_PrintToLog("oFriend = " + ObjectToString(oFriend));
    MK_PrintToLog("oSavedFriend = " + ObjectToString(oSavedFriend));
    return AssertObjectEqual(oSavedFriend, oFriend);
}

int UnitTest_SavedEnemy(object oEnemy)
{
    PrintUnitTestHeader("UnitTest_SavedEnemy");
    MK_SetSavedEnemy(oEnemy);
    object oSavedEnemy = MK_GetSavedEnemy();
    MK_PrintToLog("oEnemy = " + ObjectToString(oEnemy));
    MK_PrintToLog("oSavedEnemy = " + ObjectToString(oSavedEnemy));
    return AssertObjectEqual(oSavedEnemy, oEnemy);
}

int TestSuite_SaveCreature()
{
    PrintTestSuiteHeader("TestSuite_SaveCreature");
    int nResult;

    nResult = UnitTest_SavedFriend(OBJECT_SELF);
    nResult = UnitTest_SavedFriend(OBJECT_INVALID) && nResult;
    nResult = UnitTest_SavedFriend(GetHero()) && nResult;

    nResult = UnitTest_SavedEnemy(OBJECT_SELF) && nResult;
    nResult = UnitTest_SavedEnemy(OBJECT_INVALID) && nResult;
    nResult = UnitTest_SavedEnemy(GetHero()) && nResult;

    PrintTestSuiteSummary("TestSuite_SaveCreature", nResult);
    return nResult;
}

//void main() {TestSuite_SaveCreature();}
//##############################################################################

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object[] _MK_AI_GetEnemiesFromTargetType(int nTargetType, int nCheckLiving = TRUE, int nCheckPerceived = TRUE);
object[] _MK_AI_GetEnemies(object oCreature = OBJECT_SELF, int nCheckLiving = TRUE, int nCheckPerceived = TRUE);
object[] _MK_AI_GetEnemiesAndAttackTarget(object oCreature = OBJECT_SELF, int nCheckLiving = TRUE, int nCheckPerceived = TRUE);
object[] _MK_AI_GetEnemiesSubroutine(object oCreature, int nCheckLiving, int nCheckPerceived, int nPreferCurrentTarget);

//==============================================================================
//                                DEFINITIONS
//==============================================================================

/** @brief Returns a list of valid hostile creatures.
*
* Returns array of valid creatures hostile towards OBJECT_SELF sorted by their distance
* (proximity) to the OBJECT_SELF. Result is filtered accordingly to provided nTargetType.
* Max number of returned cretures is defined in AT_MAX_ENEMIES_NEAREST
* constant. Current Target (if included) is returned as the first element of the
* array regardless the distance and does not count toward AT_MAX_ENEMIES_NEAREST
* limit.

* @param nTargetType - return only creatures belonging to this target type
* @param nCheckLiving - wheher to return only those enemies that are alive
* @param nCheckPerceived - wheher to return only those enemies that are on the Perception List of OBJECT_SELF
* @returns an array of creatures hostile towards OBJECT_SELF
* @author MkBot
*/
object[] _MK_AI_GetEnemiesFromTargetType(int nTargetType, int nCheckLiving, int nCheckPerceived)
{
    object[] arTargets;
    arTargets[0] = OBJECT_INVALID;

    switch (nTargetType)
    {
        case AI_TARGET_TYPE_ENEMY:
        {
            arTargets = _MK_AI_GetEnemiesAndAttackTarget(OBJECT_SELF, nCheckLiving, nCheckPerceived);

            break;
        }
        case AT_TARGET_TYPE_TARGET:
        {
            object oSelectedTarget = GetAttackTarget(OBJECT_SELF);
            if (_AT_AI_IsEnemyValid(oSelectedTarget, nCheckLiving, nCheckPerceived) == TRUE)
                arTargets[0] = oSelectedTarget;

            break;
        }
        case MK_TARGET_TYPE_SAVED_ENEMY:
        {
            object oSavedEnemy = MK_GetSavedEnemy();
            if (_AT_AI_IsEnemyValid(oSavedEnemy, nCheckLiving, nCheckPerceived) == TRUE)
                arTargets[0] = oSavedEnemy;

            break;
        }
        case AI_TARGET_TYPE_MOST_HATED:
        {
            object oMostHated = _AT_AI_Condition_GetMostHatedEnemy();
            if (_AT_AI_IsEnemyValid(oMostHated, nCheckLiving, nCheckPerceived) == TRUE)
                arTargets[0] = oMostHated;

            break;
        }
        default:
        {
            string sMsg = "Unknown Target Type = " + IntToString(nTargetType);
            MK_Error(MK_TACTIC_ID_INVALID, "_MK_AI_GetEnemiesFromTargetType", sMsg);

            break;
        }
    }
    return arTargets;
}

/** @brief Returns a list of hostile creatures
*
* Returns array of creatures hostile towards oCreature sorted by their distance
* (proximity) to the oCreature.
* Does not return all the enemies - number is defined in AT_MAX_ENEMIES_NEAREST
* constant.
*
* This function works the same way as _AT_AI_GetEnemies but allows oCreature
* to be passed as parameter (in _AT_AI_GetEnemies this is always OBJECT_SELF).
*
* @param oCreature - creature we search enemies for
* @param nCheckLiving - wheher to return only those enemies that are alive
* @param nCheckPerceived - wheher to return only those enemies that are on the Perception List of oCreature
* @returns an array of creatures hostile towards oCreature
* @author MkBot
*/
object[] _MK_AI_GetEnemies(object oCreature, int nCheckLiving, int nCheckPerceived)
{
    return _MK_AI_GetEnemiesSubroutine(oCreature, nCheckLiving, nCheckPerceived, FALSE);
} // _MK_AI_GetEnemies

/** @brief Returns an array of hostile creatures
*
* Returns array of creatures hostile towards oCreature sorted by their distance
* (proximity) to the oCreature. Current Target is returned as the first element
* of the array regardless the distance.
* Does not return all the enemies - number is defined in AT_MAX_ENEMIES_NEAREST
* constant.
*
* This function works the same way as _AT_AI_GetEnemies but allows oCreature
* to be passed as parameter (in _AT_AI_GetEnemies this is always OBJECT_SELF).
*
* @param oCreature - creature we search enemies for
* @param nCheckLiving - wheher to return only those enemies that are alive
* @param nCheckPerceived - wheher to return only those enemies that are on the Perception List of oCreature
* @returns an array of creatures hostile towards oCreature
* @author MkBot
*/
object[] _MK_AI_GetEnemiesAndAttackTarget(object oCreature, int nCheckLiving, int nCheckPerceived)
{
    return _MK_AI_GetEnemiesSubroutine(oCreature, nCheckLiving, nCheckPerceived, TRUE);
} // _MK_GetEnemiesAndAttackTarget


/** @brief *INTERNAL* - use _MK_AI_GetEnemies() or MK_GetEnemiesAndAttackTarget() instead.
*
* Returns array of creatures hostile towards oCreature sorted by their distance
* (proximity) to the oCreature. Current Target is returned as the first element
* of the array regardless the distance.
* Does not return all the enemies - number is defined in AT_MAX_ENEMIES_NEAREST
* constant. Current Target doesn't count to this limit.
*
* @param oCreature - creature we search enemies for
* @param nCheckLiving - whether to return only those enemies that are alive
* @param nCheckPerceived - whether to return only those enemies that are on the Perception List of oCreature
* @param nPreferCurrentTarget - whether to add current target at the beginning returned arrray
* @returns an array of creatures hostile towards oCreature
* @author MkBot
*/
object[] _MK_AI_GetEnemiesSubroutine(object oCreature, int nCheckLiving, int nCheckPerceived, int nPreferCurrentTarget)
{
    object[] arEnemies = GetNearestObjectByHostility(oCreature,
                                                     TRUE,
                                                     OBJECT_TYPE_CREATURE,
                                                     AT_MAX_ENEMIES_NEAREST,
                                                     nCheckLiving,
                                                     nCheckPerceived,
                                                     FALSE);

    object[] arEnemiesFinal;
    int j = 0;
    // Add current target first
    if (nPreferCurrentTarget == TRUE)
    {
        if (_AT_AI_IsEnemyValid(GetAttackTarget(oCreature), nCheckLiving, nCheckPerceived) == TRUE)
            arEnemiesFinal[j++] = GetAttackTarget(oCreature);
    }

    // Add valid targets
    int i;
    int nSize = GetArraySize(arEnemies);
    for (i = 0; i < nSize; i++)
    {    
        if (nPreferCurrentTarget == TRUE && GetAttackTarget(oCreature) == arEnemies[i])
            continue;    
                        
        if (_AT_AI_IsEnemyValid(arEnemies[i], nCheckLiving, nCheckPerceived) == TRUE)
        {
            arEnemiesFinal[j] = arEnemies[i];
            j++;
        }
    }

    return arEnemiesFinal;
} // _MK_AI_GetEnemiesSubroutine

/**
* Self         -> OBJECT_SELF
* Party        -> all characters/creatures under players direct control
* PartyMember  -> each character/creature under players direct control.
*                 Party Members are listed in upper-left corner of the
*                 screen i.e. main character, choosen followers and summoned
*                 creatures
* Allies       -> Party Members exluding Self
* TeamMembers  -> Party Members excluding Summoned
* Teammates    -> Party Members excluding Self and Summoned
* Summoned     -> self explaining
*
* @author   MkBot
**/

//==============================================================================
//                          CONSTANTS
//==============================================================================
const int MK_GET_PER_FOLLOWER_FROM_TARGET_OBJECT = 1;
const int MK_GET_PER_FOLLOWER_FROM_CONDITION_OBJECT = 2;

//==============================================================================
//                          DECLARATIONS
//==============================================================================
object[] _MK_AI_GetFollowersFromTargetType(int nTargetType, int nTacticID, int nCheckLiving = TRUE, int nPerFollowerSource = MK_GET_PER_FOLLOWER_FROM_TARGET_OBJECT);
object[] MK_AI_GetFollowersInParty(int nIncludeSelf, int nIncludeSummoned,int nCheckLiving = TRUE, int nCheckPerceived = FALSE);
object[] _MK_AI_GetFollowersInParty(int nIncludeSelf, int nIncludeSummoned,int nCheckLiving = TRUE, int nCheckPerceived = FALSE);

//==============================================================================
//                          DEFINITIONS
//==============================================================================

/** @brief Return array of valid Followers filtered accordingly to nTargetType
*   OBJECT_SELF (if included) is stored in the first cell of the array.
*   @param nTargetType - target type to filter result
*   @param nTacticID - required to retrive proper target for AI_TARGET_TYPE_FOLLOWER
*   @param nCheckLiving - exclude dead and dying PartyMembers
*   @param nPerFollowerSource - MK_GET_PER_FOLLOWER_FROM_TARGET_OBJECT : AI_TARGET_TYPE_FOLLOWER taken from TacticTargetObject;  MK_GET_PER_FOLLOWER_FROM_CONDITION_OBJECT : AI_TARGET_TYPE_FOLLOWER taken from TacticConditionObject
*   @author MkBot
**/
object[] _MK_AI_GetFollowersFromTargetType(int nTargetType, int nTacticID, int nCheckLiving, int nPerFollowerSource)
{
    object[] arTargets;
    arTargets[0] = OBJECT_INVALID;

    switch(nTargetType)
    {
        case MK_TARGET_TYPE_TEAMMATE: // i.e. Party Members excluding Self and Summoned
        {
            arTargets = _MK_AI_GetFollowersInParty(FALSE, FALSE, nCheckLiving, FALSE);
            break;
        }
        case MK_TARGET_TYPE_TEAM_MEMBER: // i.e. Party Members excluding Summoned
        {
            arTargets = _MK_AI_GetFollowersInParty(TRUE, FALSE, nCheckLiving, FALSE);
            break;
        }
        case AI_TARGET_TYPE_ALLY: // i.e. Party Members excluding Self
        {
            arTargets = _MK_AI_GetFollowersInParty(FALSE, TRUE, nCheckLiving, FALSE);
            break;
        }
        case MK_TARGET_TYPE_PARTY_MEMBER: // i.e. each character/creature under players direct control.
        {
            arTargets = _MK_AI_GetFollowersInParty(TRUE, TRUE, nCheckLiving, FALSE);
            break;
        }
        case MK_TARGET_TYPE_SAVED_FRIEND:
        {
            object oSavedFriend = MK_GetSavedFriend();
            if (_AT_AI_IsAllyValid(oSavedFriend, nCheckLiving, FALSE) == TRUE)
                arTargets[0] = oSavedFriend;
            break;
        }
        case AI_TARGET_TYPE_SELF:
        {
            arTargets[0] = OBJECT_SELF;
            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        {
            switch(nPerFollowerSource)
            {
                case MK_GET_PER_FOLLOWER_FROM_TARGET_OBJECT:
                {
                    object oTacticTargetObject = _AT_AI_GetPartyTarget(nTargetType, nTacticID);
                    if (_AT_AI_IsAllyValid(oTacticTargetObject, nCheckLiving, FALSE) == TRUE)
                        arTargets[0] = oTacticTargetObject;
                    break;
                }
                case MK_GET_PER_FOLLOWER_FROM_CONDITION_OBJECT:
                {
                    object oTacticConditionObject = _AT_AI_GetRelatedPartyTarget(nTargetType, nTacticID);
                    if (_AT_AI_IsAllyValid(oTacticConditionObject, nCheckLiving, FALSE) == TRUE)
                        arTargets[0] = oTacticConditionObject;
                    break;
                }
                default:
                {
                    string sMsg = "Unknown nPerFollowerSource = " + IntToString(nPerFollowerSource);
                    MK_Error(nTacticID, "_MK_AI_GetFollowersFromTargetType", sMsg);

                    break;
                }
            }
            break;
        }
        default:
        {
            string sMsg = "Unknown nTargetType = " + IntToString(nTargetType);
            MK_Error(nTacticID, "_MK_AI_GetFollowersFromTargetType", sMsg);

            break;
        }
    }

    return arTargets;
}

/** @brief Return array of valid Followers
*  OBJECT_SELF (if included) is stored in the first cell of the array.
*  @param nIncludeSelf
*  @param nIncludeSummoned
*  @param nCheckLiving - exclude dead and dying PartyMembers
*  @param nCheckPerceived
*  @author MkBot
**/
object[] _MK_AI_GetFollowersInParty(int nIncludeSelf, int nIncludeSummoned, int nCheckLiving, int nCheckPerceived )
{
    return MK_AI_GetFollowersInParty(nIncludeSelf, nIncludeSummoned, nCheckLiving, nCheckPerceived );
}

/** @brief Return array of valid Followers
*  OBJECT_SELF (if included) is stored in the first cell of the array.
*  @param nIncludeSelf
*  @param nIncludeSummoned
*  @param nCheckLiving - exclude dead and dying PartyMembers
*  @param nCheckPerceived
*  @author MkBot
**/
object[] MK_AI_GetFollowersInParty(int nIncludeSelf, int nIncludeSummoned, int nCheckLiving, int nCheckPerceived )
{
    object[] arPartyPool = GetPartyPoolList();
    int nSize = GetArraySize(arPartyPool);

    object[] arFollowersInParty;
    int size = 0;
    if (nIncludeSelf == TRUE)
    {
        arFollowersInParty[0] = OBJECT_SELF;
        size++;
    }
        
    int i;
    for (i = 0; i < nSize; i++)
    {
        if ( arPartyPool[i] == OBJECT_SELF )
            continue;

        if (!nIncludeSummoned && IsSummoned(arPartyPool[i]))
            continue;

        if (_AT_AI_IsAllyValid(arPartyPool[i], nCheckLiving, nCheckPerceived))
        {
            arFollowersInParty[size] = arPartyPool[i];
            size++;
        }
    }
    
    int nStartIndex = nIncludeSelf == TRUE ? 1:0; 
    int[] arSortBy;
    arSortBy[0] = MK_SORTBY_LOWEST_DISTANCE;
    InsertSort(arFollowersInParty, arSortBy, nStartIndex);
   
    return arFollowersInParty;
}

#endif
