#ifndef AT_CONDITION_SURROUNDED_BY_AT_LEAST_X_ENEMIES_H
#defsym AT_CONDITION_SURROUNDED_BY_AT_LEAST_X_ENEMIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Core */
#include "talent_constants_h"

#include "af_constants_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object _AT_AI_Condition_SurroundedByAtLeastXEnemies(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
//MkBot: Surrounded by no enemies fix
object _AT_AI_Condition_SurroundedByAtLeastXEnemies(int nTacticCommand, int nTacticSubCommand, int nTargetType, int nTacticID, int nAbilityTargetType, int nNumOfTargets)
{
    float fStart = 0.0f;
    float fEnd = 360.0f;
    float fRadius = AI_MELEE_RANGE;
    int nCheckLiving = TRUE;

    object oCenter;

    switch(nTargetType)
    {
        case AI_TARGET_TYPE_SELF:
        {
            oCenter = OBJECT_SELF;

            break;
        }
        case AI_TARGET_TYPE_HERO:
        case AI_TARGET_TYPE_FOLLOWER:
        case AI_TARGET_TYPE_MAIN_CONTROLLED:
        default:
        {
            oCenter = _AT_AI_GetPartyTarget(nTargetType, nTacticID);

            break;
        }
    }

    object[] arTargets;

    int nAppearance = GetAppearanceType(oCenter);

    if ((nAppearance == APP_TYPE_ARCHDEMON) || (nAppearance == APP_TYPE_HIGHDRAGON))
    {
        fRadius = MONSTER_MELEE_RANGE_HIGHDRAGON;
    }
    else
    {
        switch(nTacticSubCommand)
        {
            case ABILITY_TALENT_MONSTER_ARCANEHORROR_AOE:
            {
                fRadius = ARCANEHORROR_AOE_RADIUS;

                break;
            }
            case MONSTER_DRAGON_BREATH:
            {
                fStart = BREATH_ANGLE_START;
                fEnd = BREATH_ANGLE_END;

                break;
            }
            case AF_ABILITY_DUAL_WEAPON_SWEEP:
            {
                fStart = -90.0f;
                fEnd = 90.0f;

                break;
            }
            case AF_ABILITY_DEATH_SYPHON:
            case AF_ABILITY_DEATH_MAGIC:
            {
                fRadius = GetM2DAFloat(TABLE_VFX_PERSISTENT, "RADIUS", DEATH_MAGIC_AOE);
                nCheckLiving = FALSE;

                break;
            }
            case AF_ABILITY_MIASMA:
            {
                fRadius = GetM2DAFloat(TABLE_VFX_PERSISTENT, "RADIUS", MIASMA_AOE);

                break;
            }
            case AF_ABILITY_PAIN:
            {
                fRadius = GetM2DAFloat(TABLE_VFX_PERSISTENT, "RADIUS", PAIN_AOE);

                break;
            }
            case AF_ABILITY_WYNNE_SPECIAL:
            {
                int bTrinket = IsObjectValid(GetItemPossessedBy(oCenter, "gen_im_acc_amu_am11"));

                if (bTrinket)
                    fRadius = WYNNE_POST_TRINKET_RADIUS;
                else
                    fRadius = WYNNE_PRE_TRINKET_RADIUS;

                break;
            }
            case AF_ABILITY_DEVOUR:
            {
                nCheckLiving = FALSE;

                // No break here
            }
            default:
            {
                int nAoEType = GetM2DAInt(TABLE_ABILITIES_SPELLS, "aoe_type", nTacticSubCommand);
                if (nAoEType == 1)
                    fRadius = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", nTacticSubCommand);

                break;
            }
        }
    }

    if (fRadius <= AI_MELEE_RANGE)
        arTargets = GetCreaturesInMeleeRing(oCenter, fStart, fEnd, TRUE);
    else
        arTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oCenter), fRadius, 0.0f, 0.0f, nCheckLiving);

    int nSize = GetArraySize(arTargets);
    int nEnemiesCount = 0;
    int i;

    if (nCheckLiving)
    {
        for (i = 0; i < nSize; i++)
        {
            if ((arTargets[i] != oCenter)
            && (IsObjectHostile(oCenter, arTargets[i]) == TRUE))
                nEnemiesCount++;
        }
    }
    else
    {
        int nDecayBehaviour;

        for (i = 0; i < nSize; i++)
        {
            if (HasDeathEffect(arTargets[i], TRUE) == TRUE)
            {
                if (IsPlot(arTargets[i]) != TRUE)
                {
                    if (GetCanDiePermanently(arTargets[i]) == TRUE)
                    {
                        nAppearance = GetAppearanceType(arTargets[i]);
                        nDecayBehaviour = GetM2DAInt(TABLE_APPEARANCE, "DecayBehaviour", nAppearance);
                        if (nDecayBehaviour == 0)
                            nEnemiesCount++;
                    }
                }
            }
        }
    }

    //DEBUG
    //string msg = "nNumOfTargets=" + IntToString(nNumOfTargets);
    //DisplayFloatyMessage(oCenter, msg, FLOATY_MESSAGE, 0x888888, 5.0f);
    //msg = "nEnemiesCount=" + IntToString(nEnemiesCount);
    //DisplayFloatyMessage(oCenter, msg, FLOATY_MESSAGE, 0x888888, 5.0f);

    if( nNumOfTargets == 0 && nEnemiesCount > 0 )//MkBot: Surrounded by no enemies fix
    {
        return OBJECT_INVALID;
    }

    if (nEnemiesCount >= nNumOfTargets)
    {
        switch(nTargetType)
        {
            case AI_TARGET_TYPE_SELF:
            {
                if (_AT_AI_IsSelfValidForAbility(nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return OBJECT_SELF;

                break;
            }
            case AI_TARGET_TYPE_HERO:
            case AI_TARGET_TYPE_FOLLOWER:
            case AI_TARGET_TYPE_MAIN_CONTROLLED:
            default:
            {
                if (_AT_AI_IsAllyValidForAbility(oCenter, nTacticCommand, nTacticSubCommand, nAbilityTargetType) == TRUE)
                    return oCenter;

                break;
            }
        }
    }

    return OBJECT_INVALID;
}
#endif