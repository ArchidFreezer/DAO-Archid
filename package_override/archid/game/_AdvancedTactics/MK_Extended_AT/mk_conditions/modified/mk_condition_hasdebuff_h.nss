#ifndef MK_CONDITION_HAS_DEBUFF_H
#defsym MK_CONDITION_HAS_DEBUFF_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_condition_most_hated_h"
#include "at_condition_hasdebuff_h"  

/* MkBot */
#include "mk_constants_h"
#include "mk_constants_ai_h"

#include "mk_get_creatures_h"
#include "mk_cond_tools_h"

#include "mk_print_to_log_h"
#include "log_effect_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _MK_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase);
int _MK_SubCondition_HasDebuff(object oTarget, int nCase);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
object _MK_Condition_HasDebuff(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nCase)
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
                &&  _MK_SubCondition_HasDebuff(arTargets[i], nCase) == TRUE)
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
                &&  _MK_SubCondition_HasDebuff(arTargets[i], nCase) == TRUE)
                    return arTargets[i];
            }

            break;
        }
        default:
        {
            string sMsg = "[_MK_Condition_HasDebuff] ERROR: Unknown Target Type = " + IntToString(nTargetType);
            DisplayFloatyMessage(OBJECT_SELF, sMsg, FLOATY_MESSAGE, 0xFF0000, 5.0);
            MK_PrintToLog(sMsg);

            break;
        }        
    }

    return OBJECT_INVALID;
}

int _MK_SubCondition_HasDebuff(object oTarget, int nCase)
{
    switch(nCase)
    {
        case 0://AT_ABILITY_WEAKNESS
        case 1://AT_ABILITY_VULNERABILITY_HEX or AT_ABILITY_AFFLICTION_HEX
        case 2://AT_ABILITY_DEATH_HEX
        case 3://AT_ABILITY_DISPEL_MAGIC
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: 0 or 1 or 2 or 3");
            #endif
            return _AT_SubCondition_HasDebuff(oTarget, nCase);
            break;
        }
        case 4://AT_ABILITY_MISDIRECTION_HEX
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_MISDIRECTION_HEX");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_MISDIRECTION_HEX);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 5://AT_ABILITY_CURSE_OF_MORTALITY
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_CURSE_OF_MORTALITY");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_CURSE_OF_MORTALITY);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 6://AT_ABILITY_WAKING_NIGHTMARE
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_WAKING_NIGHTMARE");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_WAKING_NIGHTMARE);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 7://AT_ABILITY_FORCE_FIELD
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_FORCE_FIELD");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_FORCE_FIELD);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 8://AT_ABILITY_CRUSHING_PRISON
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_CRUSHING_PRISON");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_CRUSHING_PRISON);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 9://AT_ABILITY_WALKING_BOMB or AT_ABILITY_VIRULENT_WALKING_BOMB
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_WALKING_BOMB or AT_ABILITY_VIRULENT_WALKING_BOMB");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_WALKING_BOMB);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_VIRULENT_WALKING_BOMB);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 10://AT_ABILITY_STINGING_SWARM
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_STINGING_SWARM");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_STINGING_SWARM);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }

        case 11://AT_ABILITY_BLOOD_CONTROL
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]: AT_ABILITY_BLOOD_CONTROL");
            #endif
            effect[] arEffects = GetEffectsByAbilityId(oTarget, AT_ABILITY_BLOOD_CONTROL);

            if (GetArraySize(arEffects) > 0)
            {
                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                #endif
                return TRUE;
            }

            break;
        }
        case 12://Affected by debuff worth to dispell
        {
            #ifdef MK_DEBUG
            MK_PrintToLog("[_MK_SubCondition_HasDebuff]:Affected by debuff worth to dispell");
            #endif
            effect[] arSpell = GetEffects(oTarget);
            int nSize = GetArraySize(arSpell);

            int nAbility;
            int nDebuff;

            int i;
            for (i = 0; i < nSize; i++)
            {
                nAbility = GetEffectAbilityID(arSpell[i]);

                #ifdef MK_DEBUG
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] Effect[" + IntToString(i) + "] = " + MK_EffectTypeToString(GetEffectType(arSpell[i])) );
                MK_PrintToLog("[_MK_SubCondition_HasDebuff] Effect[" + IntToString(i) + "] -> MagicalDebuf = " + IntToString(nDebuff) );
                #endif

                if( GetEffectType(arSpell[i]) == EFFECT_TYPE_VISUAL_EFFECT )
                    continue;

                nDebuff = GetM2DAInt(TABLE_AI_ABILITY_COND, "MagicalDebuf", nAbility);

                if(nDebuff == 1
                && nAbility != ABILITY_SPELL_DAZE
                && nAbility != AT_ABILITY_WEAKNESS
                && nAbility != AT_ABILITY_VULNERABILITY_HEX
                && nAbility != AT_ABILITY_AFFLICTION_HEX)
                {
                    #ifdef MK_DEBUG
                    MK_PrintToLog("[_MK_SubCondition_HasDebuff] return TRUE");
                    #endif
                    return TRUE;
                }
            }

            break;
        }
    }

    #ifdef MK_DEBUG
    MK_PrintToLog("[_MK_SubCondition_HasDebuff] return FALSE");
    #endif
    return FALSE;
}
#endif