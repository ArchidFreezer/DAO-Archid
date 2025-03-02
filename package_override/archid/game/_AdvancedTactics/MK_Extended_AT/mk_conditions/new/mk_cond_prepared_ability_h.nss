#ifndef MK_CONDITION_ABILITY_AVAILABLE_H
#defsym MK_CONDITION_ABILITY_AVAILABLE_H
//==============================================================================
//                              INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"

/* MkBot */
#include "mk_cond_tools_h"
#include "mk_constants_ai_h"
#include "mk_test_framework_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object MK_Condition_HasAbilityAvailable(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nParameter1, int nAbilityId);
int MK_HasAbilityAvailable(object oCreature, int nAbilityId);

//==============================================================================
//                               DEFINITIONS
//==============================================================================

/** @brief Checks whether oCreature is ready to use given ability 
*
* @param oCreature  - creature to test
* @param nAbilityId - see constants : AT_ABILITY_
* @returns          - TRUE or FALSE
* @author MkBot
**/
int MK_HasAbilityAvailable(object oCreature, int nAbilityId)
{
    
}
#endif
