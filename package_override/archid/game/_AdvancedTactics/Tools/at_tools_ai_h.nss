#ifndef AT_TOOLS_AI_H
#defsym AT_TOOLS_AI_H

//==============================================================================
//                              INCLUDES
//==============================================================================
/*Core*/
#include "ai_main_h_2"
#include "sys_traps_h"

/* Advanced Tactics */
#include "at_tools_conditions_h"
#include "at_tools_aoe_h"
#include "at_tools_geometry_h"
#include "at_tools_ai_constants_h"
#include "at_tools_log_h"  

//==============================================================================
//                              DECLARATIONS
//==============================================================================
int  _AT_AI_IsCommandValid(int nTacticCommand, int nTacticSubCommand, int nTacticTargetType);

void _AT_AI_SetPartyAllowedToAttack(int nStatus);
object _AT_AI_GetPotionByFilter(int nPotionType, int nPotionPower);
int _AT_AI_UseGUITables();

object _AT_GetItemByAbility(int nAbility);
void _AT_InitCombat(object oCreature);

command _AT_AI_MoveToControlled(int nLastCommandStatus);
command _AT_AI_GetPotionUseCommand(object oItem);
command _AT_AI_ExecuteAttack(object oTarget, int nLastCommandStatus);
command _AT_AI_DoNothing(int bQuick = FALSE);

command _AT_Pause();
command _AT_ChangeBehavior(int nBehaviorID);
command _AT_CommandFlankingAttack(object oTarget);

//==============================================================================
//                      DEFINITIONS
//==============================================================================
int _AT_AI_IsCommandValid(int nTacticCommand, int nTacticSubCommand, int nTacticTargetType)
{
    switch(nTacticCommand)
    {
        /* Advanced Tactics */
        case AT_COMMAND_SWITCH_TO_WEAPON_SET_1:
        {
            if (GetActiveWeaponSet(OBJECT_SELF) == 0)
                return FALSE;

            /*object oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, OBJECT_SELF, 0);
            if (IsObjectValid(oWeapon) != TRUE)
                return FALSE;*/

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        /* Advanced Tactics */
        case AT_COMMAND_SWITCH_TO_WEAPON_SET_2:
        {
            if (GetActiveWeaponSet(OBJECT_SELF) == 1)
                return FALSE;

            /*object oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN, OBJECT_SELF, 1);
            if (IsObjectValid(oWeapon) != TRUE)
                return FALSE;*/

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        case AI_COMMAND_USE_HEALTH_POTION_MOST:
        case AI_COMMAND_USE_HEALTH_POTION_LEAST:
        case AI_COMMAND_USE_LYRIUM_POTION_MOST:
        case AI_COMMAND_USE_LYRIUM_POTION_LEAST:
        {
            if (GetCombatState(OBJECT_SELF) != TRUE)
                return FALSE;

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        case AT_COMMAND_DISARM_TRAPS:
        {
            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        case AI_COMMAND_ATTACK:
        {
            if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_COMBAT)
                return FALSE;

            break;
        }
        case AI_COMMAND_ACTIVATE_MODE:
        {
            /* Cooldown, mana cost */
            if (_AI_IsAbilityValid(nTacticSubCommand) != TRUE)
                return FALSE;
            /* Advanced Tactics */
            /* Cooldown, requirements */
            if (_AT_AI_CanUseAbility(nTacticSubCommand) != TRUE)
                return FALSE;
            if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_SPELL) && (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_SPELLS))
                return FALSE;
            if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_TALENT) && (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_TALENTS))
                return FALSE;

            break;
        }
        case AI_COMMAND_DEACTIVATE_MODE:
        {
            if (IsModalAbilityActive(OBJECT_SELF, nTacticSubCommand) != TRUE)
                return FALSE;

            break;
        }
        case AI_COMMAND_USE_ABILITY:
        {
            if (Ability_IsModalAbility(nTacticSubCommand))
                return FALSE;
            /* Cooldown, mana cost */
            if (_AI_IsAbilityValid(nTacticSubCommand) != TRUE)
                return FALSE;
            /* Advanced Tactics */
            /* Cooldown, requirements */
            if (_AT_AI_CanUseAbility(nTacticSubCommand) != TRUE)
                return FALSE;
            if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_SPELL) && (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_SPELLS))
                return FALSE;
            if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_TALENT) && (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_TALENTS))
                return FALSE;

            if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_TALENT)
            && GetHasEffects(OBJECT_SELF, EFFECT_TYPE_MISDIRECTION_HEX)
            && (nTacticTargetType == AI_TARGET_TYPE_ENEMY))
                return FALSE;

            if (nTacticSubCommand == 11130)
            {
                if (GetCreatureCoreClass(OBJECT_SELF) != CLASS_WIZARD)
                    return FALSE;
            }

            break;
        }
        case AI_COMMAND_USE_ITEM:
        {
            /* Advanced Tactics */
            /* Check if we have at least 1 item to use */
            object oSelectedItem = _AT_GetItemByAbility(nTacticSubCommand);
            if (IsObjectValid(oSelectedItem) != TRUE)
                return FALSE;

            /* Cooldown, requirements.
               Fix the bug on item cooldown.
               No item where passed to this function in original script. I think
               it comes from an error in GetRemainingCooldown description.
               It is said that GetRemainingCooldown grab the first item that have
               the ability. But it is not the case.
            */
            if (_AT_AI_CanUseAbility(nTacticSubCommand, oSelectedItem) != TRUE)
                return FALSE;

            if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_ITEMS)
                return FALSE;
            if (Ability_GetAbilityType(nTacticSubCommand) != ABILITY_TYPE_ITEM)
                return FALSE;

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        case AI_COMMAND_MOVE:
        {
            if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_MOVEMENT)
                return FALSE;

            break;
        }
        case AI_COMMAND_SWITCH_TO_MELEE:
        {
            if (_AI_HasWeaponSet(AI_WEAPON_SET_MELEE) != TRUE)
                return FALSE;

            if (_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_MELEE)
                return FALSE;

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
        case AI_COMMAND_SWITCH_TO_RANGED:
        {
            if (_AI_HasWeaponSet(AI_WEAPON_SET_RANGED) != TRUE)
                return FALSE;

            if (_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_RANGED)
                return FALSE;

            if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
                return FALSE;

            break;
        }
    }

    return TRUE;
}

void _AT_AI_SetPartyAllowedToAttack(int nStatus)
{
    SetLocalInt(GetModule(), AI_PARTY_CLEAR_TO_ATTACK, nStatus);
}

object _AT_AI_GetPotionByFilter(int nPotionType, int nPotionPower)
{
    object[] arItems = GetItemsInInventory(GetPartyLeader());
    int nSize = GetArraySize(arItems);

    object oCurrent;
    object oSelectedItem = OBJECT_INVALID;
    int nCurrentCost;
    int nStoredCost = -1;
    int nAbility;

    int i;

    switch(nPotionType)
    {
        case AI_POTION_TYPE_HEALTH:
        {
            if(nPotionPower == AI_POTION_LEVEL_MOST_POWERFUL)
            {
                for (i = 0; i < nSize; i++)
                {
                    oCurrent = arItems[i];

                    if (_HasItemProperty(oCurrent, ITEM_PROPERTY_IS_HEALING_POTION) == TRUE)
                    {
                        nCurrentCost = GetItemValue(oCurrent);
                        nAbility = GetItemAbilityId(oCurrent);

                        /* Advanced Tactics */
                        /* Cooldown */
                        if (((nCurrentCost > nStoredCost) || (nStoredCost == -1))
                        && (_AT_AI_CanUseAbility(nAbility, oCurrent) == TRUE))
                        {
                            nStoredCost = nCurrentCost;
                            oSelectedItem = oCurrent;
                        }
                    }
                }
            }
            else if (nPotionPower == AI_POTION_LEVEL_LEAST_POWERFUL)
            {
                for (i = 0; i < nSize; i++)
                {
                    oCurrent = arItems[i];

                    if (_HasItemProperty(oCurrent, ITEM_PROPERTY_IS_HEALING_POTION) == TRUE)
                    {
                        nCurrentCost = GetItemValue(oCurrent);
                        nAbility = GetItemAbilityId(oCurrent);

                        /* Advanced Tactics */
                        /* Cooldown */
                        if (((nCurrentCost < nStoredCost) || (nStoredCost == -1))
                        && (_AT_AI_CanUseAbility(nAbility, oCurrent) == TRUE))
                        {
                            nStoredCost = nCurrentCost;
                            oSelectedItem = oCurrent;
                        }
                    }
                }
            }

            break;
        }
        case AI_POTION_TYPE_MANA:
        {
            if (nPotionPower == AI_POTION_LEVEL_MOST_POWERFUL)
            {
                for (i = 0; i < nSize; i++)
                {
                    oCurrent = arItems[i];

                    if (_HasItemProperty(oCurrent, ITEM_PROPERTY_IS_MANA_POTION) == TRUE)
                    {
                        nCurrentCost = GetItemValue(oCurrent);
                        nAbility = GetItemAbilityId(oCurrent);

                        /* Advanced Tactics */
                        /* Cooldown */
                        if (((nCurrentCost > nStoredCost) || (nStoredCost == -1))
                        && (_AT_AI_CanUseAbility(nAbility, oCurrent) == TRUE))
                        {
                            nStoredCost = nCurrentCost;
                            oSelectedItem = oCurrent;
                        }
                    }
                }
            }
            else if (nPotionPower == AI_POTION_LEVEL_LEAST_POWERFUL)
            {
                for (i = 0; i < nSize; i++)
                {
                    oCurrent = arItems[i];

                    if (_HasItemProperty(oCurrent, ITEM_PROPERTY_IS_MANA_POTION) == TRUE)
                    {
                        nCurrentCost = GetItemValue(oCurrent);
                        nAbility = GetItemAbilityId(oCurrent);

                        /* Advanced Tactics */
                        /* Cooldown */
                        if (((nCurrentCost < nStoredCost) || (nStoredCost == -1))
                        && (_AT_AI_CanUseAbility(nAbility, oCurrent) == TRUE))
                        {
                            nStoredCost = nCurrentCost;
                            oSelectedItem = oCurrent;
                        }
                    }
                }
            }

            break;
        }
        default:
        {
            break;
        }
    }

    return oSelectedItem;
}

int _AT_AI_UseGUITables()
{
    int nUseGUI = GetLocalInt(GetModule(), AI_USE_GUI_TABLES_FOR_FOLLOWERS);
    if (nUseGUI == 0)
        return FALSE;

    return (GetFollowerState(OBJECT_SELF) != FOLLOWER_STATE_INVALID);
}

/* Do the job GetRemainingCooldown doesn't do. */
object _AT_GetItemByAbility(int nAbility)
{
    object[] arItems = GetItemsInInventory(GetPartyLeader());
    int nSize = GetArraySize(arItems);

    int i;
    for (i = 0; i < nSize; i++)
    {
        if (GetItemAbilityId(arItems[i]) == nAbility)
            return arItems[i];
    }

    return OBJECT_INVALID;
}

void _AT_InitCombat(object oCreature)
{
    command cCurrentCommand = GetCurrentCommand(oCreature);

    if ((AT_IsControlled(oCreature) != TRUE)
    && (GetCommandQueueSize(oCreature) == 0)
    && (GetCommandType(cCurrentCommand) == COMMAND_TYPE_INVALID))
    {
        command cWait = CommandWait(0.1f);
        WR_AddCommand(oCreature, cWait);
    }
}

command _AT_AI_MoveToControlled(int nLastCommandStatus)
{
    object oMainControlled = GetMainControlled();
    float fDistance = GetDistanceBetween(OBJECT_SELF, oMainControlled);

    /* Incoming AOE system */
    if ((IsStealthy(oMainControlled) != TRUE)
    && (nLastCommandStatus == COMMAND_SUCCESSFUL)
    && (fDistance > AI_RANGE_SHORT)
    && ( (AI_BehaviorCheck_AvoidAOE() != TRUE) || (_AT_IsAOEValid(_AT_GetAOEOnCreature(oMainControlled)) != TRUE)) )
    {
        location lLoc = GetFollowerWouldBeLocation(OBJECT_SELF);

        if (AI_BehaviorCheck_AvoidNearbyEnemies())
        {
            object[] arEnemies = GetNearestObjectByHostility(oMainControlled,
                                                             TRUE,
                                                             OBJECT_TYPE_CREATURE,
                                                             1);

            if ((GetArraySize(arEnemies) > 0)
            && (arEnemies[0] != OBJECT_INVALID))
            {
                float fDistance = GetDistanceBetweenLocations(lLoc, GetLocation(arEnemies[0]));
                int nAppearance = GetAppearanceType(arEnemies[0]);
                float fAppearance = GetM2DAFloat(TABLE_APPEARANCE, "PERSPACE", nAppearance) * 6.0;
                float fMoved =  MaxF(AI_MOVE_AWAY_DISTANCE_SHORT, fAppearance);

                /* Advanced Tactics */
                /* Include the scale of nearest enemy in calculation. Whitout this,
                   followers comes to their location when you are in melee with Archdemon.
                */
                if ((fDistance >= 0.0f)
                && (fDistance < (fMoved + 1.0f)))
                    return _AT_AI_DoNothing(TRUE);
            }
        }

        return CommandMoveToLocation(lLoc, TRUE);
    }

    return _AT_AI_DoNothing(TRUE);
}

command _AT_AI_GetPotionUseCommand(object oItem)
{
    command cRet;

    if (IsObjectValid(oItem))
    {
        int nAbility = GetItemAbilityId(oItem);

        vector vNul;
        return CommandUseAbility(nAbility, OBJECT_SELF, vNul, -1.0, GetTag(oItem));
    }

    return cRet;
}

command _AT_AI_ExecuteAttack(object oTarget, int nLastCommandStatus)
{
    command cTacticCommand;
    int nTacticID;
    int nLastTacticID = GetLocalInt(OBJECT_SELF, AI_LAST_TACTIC);

    /* Advanced Tactics */
    int nBitVar = GetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT");

    if (GetEffectsFlags(OBJECT_SELF) & EFFECT_FLAG_DISABLE_COMBAT)
    {
        nTacticID = AI_TACTIC_ID_WAIT;
        SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, nTacticID);

        return _AT_AI_DoNothing();
    }
    else if ((_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_RANGED)
    && _AI_IsTargetInMeleeRange(oTarget)
    && _AI_HasWeaponSet(AI_WEAPON_SET_MELEE)
    && (nLastTacticID != AI_TACTIC_ID_SWITCH_MELEE_TO_RANGED))
    {
        if (AI_BehaviorCheck_PreferRange())
        {
            // nothing
        }
        else
        {
            cTacticCommand = _AI_SwitchWeaponSet(AI_WEAPON_SET_MELEE);
            nTacticID = AI_TACTIC_ID_SWITCH_RANGED_TO_MELEE;

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
            {
                /* Advanced Tactics */
                if (((nBitVar & 2) != 0)
                && (nLastCommandStatus >= 0))
                    cTacticCommand = _AT_CommandFlankingAttack(oTarget);
                else
                    cTacticCommand = CommandAttack(oTarget);

                nTacticID = AI_TACTIC_ID_ATTACK;
            }
        }
    }
    else if ((_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_MELEE)
    && (_AI_IsTargetInMeleeRange(oTarget) != TRUE)
    && _AI_HasWeaponSet(AI_WEAPON_SET_RANGED)
    && (nLastTacticID != AI_TACTIC_ID_SWITCH_RANGED_TO_MELEE))
    {
        if ((AI_BehaviorCheck_PreferMelee() == TRUE)
        || (AI_BehaviorCheck_PreferRange() != TRUE))
        {
            // nothing
        }
        else
        {
            cTacticCommand = _AI_SwitchWeaponSet(AI_WEAPON_SET_RANGED);
            nTacticID = AI_TACTIC_ID_SWITCH_MELEE_TO_RANGED;

            if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
            {
                /* Advanced Tactics */
                if (((nBitVar & 2) != 0)
                && (nLastCommandStatus >= 0))
                    cTacticCommand = _AT_CommandFlankingAttack(oTarget);
                else
                    cTacticCommand = CommandAttack(oTarget);

                nTacticID = AI_TACTIC_ID_ATTACK;
            }
        }

    }
    else
    {
        /* Advanced Tactics */
        if (((nBitVar & 2) != 0)
        && (nLastCommandStatus >= 0))
            cTacticCommand = _AT_CommandFlankingAttack(oTarget);
        else
            cTacticCommand = CommandAttack(oTarget);

        nTacticID = AI_TACTIC_ID_ATTACK;
    }

    if (GetCommandType(cTacticCommand) == COMMAND_TYPE_INVALID)
    {
        /* Advanced Tactics */
        if (((nBitVar & 2) != 0)
        && (nLastCommandStatus >= 0))
            cTacticCommand = _AT_CommandFlankingAttack(oTarget);
        else
            cTacticCommand = CommandAttack(oTarget);

        nTacticID = AI_TACTIC_ID_ATTACK;
    }

    SetLocalInt(OBJECT_SELF, AI_LAST_TACTIC, nTacticID);

    return cTacticCommand;
}

command _AT_AI_DoNothing(int bQuick = FALSE)
{
    command cRet;

    /* Advanced Tactics */
    if (AT_IsControlled(OBJECT_SELF) == TRUE)
        return cRet;

    if (bQuick)
        cRet = CommandWait(AI_DO_NOTHING_DELAY_QUICK);
    else
        cRet = CommandWait(AI_DO_NOTHING_DELAY);

    return cRet;
}

command _AT_Pause()
{
    command cRet = CommandWait(0.1f);

    ToggleGamePause();

    return cRet;
}

command _AT_ChangeBehavior(int nBehaviorID)
{
    command cRet;

    if (nBehaviorID != GetAIBehavior(OBJECT_SELF))
    {
        SetAIBehavior(OBJECT_SELF, nBehaviorID);
        cRet = CommandWait(0.1f);
    }

    return cRet;
}

command _AT_CommandFlankingAttack(object oTarget)
{
    command cRet = CommandAttack(oTarget);

    if ((GetCreatureCoreClass(OBJECT_SELF) == CLASS_ROGUE)
    && (IsUsingMeleeWeapon(OBJECT_SELF) == TRUE))
    {
        int nTargetApp = GetAppearanceType(oTarget);
        float fTargetPerSpace = GetM2DAFloat(TABLE_APPEARANCE, "PERSPACE", nTargetApp);
        float fDistance = fTargetPerSpace + 1.5f;

        float fDistanceToTarget = GetDistanceBetween(OBJECT_SELF, oTarget);

        if (fDistanceToTarget <= fDistance + 1.5f)
        {
            /* Advanced Tactics */
            /* Do not attack behind the enemy in the following situation :
               - The enemy is not in melee range
               - The enemy is attacking you
               - You are already at flank
               - You can one shot the enemy
               - The enemy has special abilities for flankers :)
            */
            if ((GetAttackTarget(oTarget) != OBJECT_SELF)
            && (AT_IsAtFlank(oTarget) != TRUE)
            && (IsOneShotKillCreature(oTarget) != TRUE))
            {
                location lTargetLoc = GetLocation(oTarget);

                if (IsLocationValid(lTargetLoc) == TRUE)
                {
                    vector vTargetPos = GetPositionFromLocation(lTargetLoc);
                    vector vTargetOri = GetOrientationFromLocation(lTargetLoc);
                    float fTargetAngle = VectorToAngle(vTargetOri);
                    object oTargetArea = GetAreaFromLocation(lTargetLoc);

                    location lLoc = GetLocation(OBJECT_SELF);
                    float fFlankingAngle = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_FLANKING_ANGLE);

                    /* It is a bioware's patch. */
                    if (fFlankingAngle <= 10.0f)
                        fFlankingAngle = 60.0f;
                    else if (fFlankingAngle > 180.0f)
                        fFlankingAngle = 180.0f;

                    /* Standardize */
                    vTargetPos = AT_PositionToStd(vTargetPos);
                    fTargetAngle = AT_AngleToStd(fTargetAngle);
                    fFlankingAngle = ToRadians(fFlankingAngle);

                    /* Compute new position in Std mark */
                    float fAngle1 = fTargetAngle;
                    float fAngle2 = fTargetAngle + (fFlankingAngle * 0.5f);
                    float fAngle3 = fTargetAngle - (fFlankingAngle * 0.5f);

                    vector delta1 = Vector(fDistance * cos(fAngle1), fDistance * sin(fAngle1), -0.5f);
                    vector delta2 = Vector(fDistance * cos(fAngle2), fDistance * sin(fAngle2), -0.5f);
                    vector delta3 = Vector(fDistance * cos(fAngle3), fDistance * sin(fAngle3), -0.5f);

                    vector vNewPos1 = vTargetPos - delta1;
                    vector vNewPos2 = vTargetPos - delta2;
                    vector vNewPos3 = vTargetPos - delta3;

                    /* DAOize */
                    vNewPos1 = AT_StdToPosition(vNewPos1);
                    vNewPos2 = AT_StdToPosition(vNewPos2);
                    vNewPos3 = AT_StdToPosition(vNewPos3);

                    /* Compute new position in DAO mark */
                    location lNewLoc1 = Location(oTargetArea, vNewPos1, 0.0f);
                    location lNewLoc2 = Location(oTargetArea, vNewPos2, 0.0f);
                    location lNewLoc3 = Location(oTargetArea, vNewPos3, 0.0f);

                    /* Compute new orientation in DAO mark */
                    vector vOri1 = AngleToVector(AT_StdToAngle(fAngle1));
                    vector vOri2 = AngleToVector(AT_StdToAngle(fAngle2));
                    vector vOri3 = AngleToVector(AT_StdToAngle(fAngle3));

                    lNewLoc1 = SetLocationOrientation(lNewLoc1, vOri1);
                    lNewLoc2 = SetLocationOrientation(lNewLoc2, vOri2);
                    lNewLoc3 = SetLocationOrientation(lNewLoc3, vOri3);

                    float fDistance1 = GetDistanceBetweenLocations(lLoc, lNewLoc1);
                    float fDistance2 = GetDistanceBetweenLocations(lLoc, lNewLoc2);
                    float fDistance3 = GetDistanceBetweenLocations(lLoc, lNewLoc3);

                    location lFinalLoc;

                    if ((fDistance2 < fDistance1)
                    && (fDistance2 <= fDistance3)
                    && (IsLocationValid(lNewLoc2) == TRUE)
                    && (IsLocationSafe(lNewLoc2) == TRUE))
                        lFinalLoc = lNewLoc2;
                    else if ((fDistance3 < fDistance1)
                    && (IsLocationValid(lNewLoc3) == TRUE)
                    && (IsLocationSafe(lNewLoc3) == TRUE))
                        lFinalLoc = lNewLoc3;
                    else if ((IsLocationValid(lNewLoc1) == TRUE)
                    && (IsLocationSafe(lNewLoc1) == TRUE))
                        lFinalLoc = lNewLoc1;

                    if (IsLocationValid(lFinalLoc) == TRUE)
                        cRet = CommandMoveToLocation(lFinalLoc);
                }
            }
        }
    }

    return cRet;
}
#endif