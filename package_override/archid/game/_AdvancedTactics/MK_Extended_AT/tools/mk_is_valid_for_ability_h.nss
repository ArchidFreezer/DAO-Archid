#ifndef MK_IS_VALID_FOR_ABILITY_H
#defsym MK_IS_VALID_FOR_ABILITY_H

#include "at_tools_conditions_h"
#include "mk_print_to_log_h"

/** @brief Checks whether given Party Member is valid for ability
*
* @param oTarget subject to check. Must be a Party Member
* @param nTacticCommand commmand to be executed on oTarget
* @param nTacticSubCommand subcommmand(e.g. ability) to be executed on oTarget
* @param nAbilityTargetType allowed target types for nTacticSubCommand
* @author MkBot
*/
int _MK_AI_IsFriendValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType)
{   
    DisplayFloatyMessage(OBJECT_SELF, "[_MK_AI_IsFriendValidForAbility] I am depreciated, please replace me. ");
    MK_PrintToLog("[_MK_AI_IsFriendValidForAbility] I am depreciated, please replace me. ");
    /*
    int nIsSelf         = oTarget == OBJECT_SELF;
    int nCanUseOnSelf   = (nAbilityTargetType & TARGET_TYPE_SELF) != 0;
    int nCanUseOnFriend = (nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE) != 0;

    #ifdef MK_DEBUG_CONDITIONS
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nIsSelf = " + IntToString(nIsSelf));
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nCanUseOnSelf = " + IntToString(nCanUseOnSelf));
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] nCanUseOnFriend = " + IntToString(nCanUseOnFriend));
    #endif

    int nRet = FALSE;
    if ( (nIsSelf && nCanUseOnSelf) || (!nIsSelf && nCanUseOnFriend))
        nRet = _AT_AI_IsTargetValidForAbility(oTarget, nTacticCommand, nTacticSubCommand);

    #ifdef MK_DEBUG_CONDITIONS
    MK_PrintToLog("[_MK_AI_IsPartyMemberValidForAbility] -> return " + IntToString(nRet));
    #endif
    */
    return nRet;
} // _MK_AI_IsFriendValidForAbility

#endif