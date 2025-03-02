#include "mk_print_to_log_h"

#include "mk_cmd_invalid_h"
#include "mk_to_string_h"
#include "mk_range_h"
#include "mk_local_bool_h"
#include "mk_tactic_row_h"

void DisplayCombatSignal()
{
 //TODO DisplayCombatSignal()
}

//==============================================================================
//                          INCLUDES
//==============================================================================
#include "mk_get_creatures_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
int  MK_GetFollowerIndexInActiveParty(object oFollower);

//==============================================================================
//                          DEFINITIONS
//==============================================================================

/** @brief Return slot number in party list in upper left corner of the screen.
*
* @param oFollower - follower which inedx will be returned
* @returns - on success: zero based index of follower; on failure: -1
* @author MkBot
**/
int MK_GetFollowerIndexInActiveParty(object oFollower)
{
    object[] arActiveParty = GetPartyList();
    int nSize = GetArraySize(arActiveParty);
    int i;
    for (i = 0; i < nSize; i++)
    {
        if (arActiveParty[i] == oFollower)
            return i;
    }
    return -1;
}

//##############################################################################


//##############################################################################
#ifndef MK_AI_CONDITION_TOOLS_H
#defsym MK_AI_CONDITION_TOOLS_H

/** @brief Checks whether it is negated condition (eg. Not AI Status)
* @author MkBot
*/
int _MK_AI_IsNotCondition(int nTacticParameter)
{
    return (nTacticParameter > 0);
}

#endif
//##############################################################################
#ifndef MK_AI_IS_SLEEP_ROOT_H
#defsym MK_AI_IS_SLEEP_ROOT_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
/* MkBot */
#include "mk_constants_ai_h"

//==============================================================================
//                          DEFINITIONS
//==============================================================================
/** @brief Returns whether given creature is Sleeped or Rooted
*
* Sleep and Root effects are canceled once creature is attacked thus we generally
* want to skip them and choose some other creature. This function provides quick
* way to check Sleep and Root AI Status.
*
* @param oCreature - creature to check AI Status
* @author MkBot
*/
int _MK_AI_IsSleepRoot(object oCreature)
{
    int nRet = GetHasEffects(oCreature, EFFECT_TYPE_ROOT) || GetHasEffects(oCreature, EFFECT_TYPE_SLEEP);
    return nRet;
}

/** @brief DEPRECIATED
*
*/
int MK_IsSleepRoot(object oCreature)
{
    return _MK_AI_IsSleepRoot(oCreature);
} // MK_IsSleepRoot

#endif
//##############################################################################
#ifndef MK_IS_VALID_FOR_ABILITY_H
#defsym MK_IS_VALID_FOR_ABILITY_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "at_tools_conditions_h"
#include "mk_print_to_log_h"

/** @brief Checks whether given Party Member is valid for ability
* There is no check whether oTarget is firnedly! It is assumed that fiendly
* creatue is provided.
* @param oTarget subject to check. Must be a Party Member
* @param nTacticCommand commmand to be executed on oTarget
* @param nTacticSubCommand subcommmand(e.g. ability) to be executed on oTarget
* @param nAbilityTargetType allowed target types for nTacticSubCommand
* @author MkBot
*/
int _MK_AI_IsFriendValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType)
{
    int nTargetMask;

    nTargetMask = TARGET_TYPE_SELF | MK_TARGET_TYPE_TEAM_MEMBER |
                  MK_TARGET_TYPE_PARTY_MEMBER | MK_TARGET_TYPE_SAVED_FRIEND;
    int nCanUseOnSelf   = (nAbilityTargetType & nTargetMask) != 0;

    nTargetMask = TARGET_TYPE_FRIENDLY_CREATURE | MK_TARGET_TYPE_TEAM_MEMBER |
                  MK_TARGET_TYPE_TEAMMATE | MK_TARGET_TYPE_PARTY_MEMBER |
                  MK_TARGET_TYPE_SAVED_FRIEND;
    int nCanUseOnFriend = (nAbilityTargetType & nTargetMask) != 0;

    int nIsSelf = (oTarget == OBJECT_SELF);
    #ifdef MK_DEBUG_CONDITIONS
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nAbilityTargetType = " + IntToString(nAbilityTargetType));
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nIsSelf = " + IntToString(nIsSelf));
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nCanUseOnSelf = " + IntToString(nCanUseOnSelf));
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nCanUseOnFriend = " + IntToString(nCanUseOnFriend));
    #endif

    int nRet = TRUE;
    if ( (nIsSelf == TRUE && nCanUseOnSelf == TRUE) || (nIsSelf == FALSE && nCanUseOnFriend == TRUE))
    {
        #ifdef MK_DEBUG_CONDITIONS
        MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] (nIsSelf == TRUE && nCanUseOnSelf == TRUE) || (nIsSelf == FALSE && nCanUseOnFriend == TRUE)");
        #endif

        nRet = _AT_AI_IsTargetValidForAbility(oTarget, nTacticCommand, nTacticSubCommand);
    }
    #ifdef MK_DEBUG_CONDITIONS
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] -> return " + IntToString(nRet));
    #endif

    return nRet;
} // _MK_AI_IsFriendValidForAbility

#endif
//##############################################################################
#ifndef MK_IS_ATTACKED_ATTACK_TYPE_H
#defsym MK_IS_ATTACKED_ATTACK_TYPE_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_subcond_useattacktype_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
int _MK_AI_IsAttackedByAttackType(object oAttacker, object oTarget, int nAttackType);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
/** @brief
*
* @param oAttacker -
* @param oTarget -
* @param nAttackType -
* @author MkBot
*/
int _MK_AI_IsAttackedByAttackType(object oAttacker, object oTarget, int nAttackType)
{
    if (GetAttackTarget(oAttacker) == oTarget
    &&  _AT_AI_SubCondition_UsingAttackType(oAttacker, nAttackType) == TRUE)
    {
        if (nAttackType == AI_ATTACK_TYPE_MELEE)
        {
            //AI_MELEE_RANGE is not enough because:
            //1) using ability we may throw enemy outside melee range
            //2) we may be throwed out og melee range by enemy
            //3) archer/mage which is running out of enemy will be outside melee range
            if (GetDistanceBetween(oTarget, oAttacker) <= 2.0 * AI_MELEE_RANGE)
                return TRUE;
        }
        else
            return TRUE;
    }

    return FALSE;
}

#endif


