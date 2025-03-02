#ifndef AT_CONDITIONS_TOOLS_H
#defsym AT_CONDITIONS_TOOLS_H

//==============================================================================
//                                MkBot: Bug Fixes
//==============================================================================
//  1)  _AT_AI_CantAttack : [Grabbing] creatures are considered to have combat
//      disabled. Check added to determine whether EFFECT_FLAG_DISABLE_COMBAT
//      is caused by [Grabbing]. This bug was preventing using knockdown/stun etc.
//      abilities to rescue grabbed ally.
//
//  2)  _AT_AI_IsTargetValidForAbility : 5th check is disabled i.e. whether enemy
//      is at given distance to Controlled Character (distance was defined by Behaviour).
//      I consider any hardcoded check that depends on Controlled Character a bad
//      idea - e.g. you select your mage to give him an order to cast a spell and
//      it turns out that it alters the way your warriors act. I have found that
//      many strange actions of followers that I thought was a bug was caused by this check.
//
//  3)  _AT_AI_IsTargetValidForAbility : added check for effect immunity (eg. stun)
//      we will no longer waste time and stamina trying to knockdown a Revenat
//
//  4)  _AT_AI_IsTargetValidForAbility : Added validity checks for SLEEP,
//      WAKING_NIGHTMARE, PARALYZE and GLYPH_OF_PARALYSIS
//
//  5)  _AT_AI_HasAIStatus : AI_STATUS_PARALYZE now also applies to BLOOD_WOUND ability.
//==============================================================================


//==============================================================================
//                                INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
#include "ai_conditions_h"

/* Advanced Tactics */
#include "at_tools_ai_constants_h"
#include "at_tools_aoe_h"
#include "at_subcond_has_rank_h"

/* MkBot */
#include "mk_ability_mutex_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================

//------------------------------------------------------------------------------
//                                Tools functions
//------------------------------------------------------------------------------
int _AT_AI_HasAIStatus(object oCreature, int nAIStatus);
object[] _AT_AI_GetAlliesInParty(int nCheckLiving = TRUE, int nCheckPerceived = FALSE, int nIncludeSelf = FALSE);
object[] _AT_AI_GetAllies (int nCheckLiving = TRUE, int nCheckPerceived = FALSE, int nIncludeSelf = FALSE);
object[] _AT_AI_GetEnemies(int nCheckLiving = TRUE, int nCheckPerceived = TRUE);
object _AT_AI_GetPartyTarget(int nTargetType, int nTacticID);
object _AT_AI_GetRelatedPartyTarget(int nTargetType, int nTacticID);

//------------------------------------------------------------------------------
//                          Validity check functions
//------------------------------------------------------------------------------
// 1st check : you can use the ability, whatever the target is
int _AT_AI_CanUseAbility(int nTacticSubCommand, object oItem = OBJECT_INVALID);
// 2nd check : you didn't failed attaking this target previously (mainly for archdemon fight)
int _AT_AI_IsTargetValidForAttack(object oTarget, object oLastTarget, int nLastCommandStatus);
// 3rd check : the ability can be applied to the target
int _AT_AI_IsSelfValidForAbility(int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType);
int _AT_AI_IsEnemyValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType);
int _AT_AI_IsAllyValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType);
int _AT_AI_IsTargetValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand);
int _AT_AI_IsTargetValidForBeneficialAbility(object oTarget, int nAbilityID);

int _AT_AI_IsRangeValid(object oTarget);
int _AT_AI_IsEnemyValid(object oTarget, int nCheckLiving = TRUE, int nCheckPerceived = FALSE);
int _AT_AI_IsAllyValid (object oTarget, int nCheckLiving = TRUE, int nCheckPerceived = FALSE);
int _AT_AI_CantAttack(object oTarget);

int AT_IsAtFlank(object oTarget);
int AT_IsControlled(object oTarget);
int AT_IsHostileSelfAOE(int nTacticCommand, int nTacticSubCommand);
int MK_IsShatterable(object oCreature);


//==============================================================================
//                               DEFINITIONS
//==============================================================================

int _AT_AI_HasAIStatus(object oCreature, int nAIStatus)
{
    switch(nAIStatus)
    {
        /* Advanced Tactics */
        /*6*/case AT_STATUS_PETRIFY: return GetHasEffects(oCreature, EFFECT_TYPE_PETRIFY);
        /*10*/case AT_STATUS_FEAR: return GetHasEffects(oCreature, EFFECT_TYPE_FEAR);
        /*14*/case AI_STATUS_DEAD: return (IsDying(oCreature) || IsDead(oCreature));
        /*96*/case AT_STATUS_INVULNERABLE: return GetHasEffects(oCreature, EFFECT_TYPE_DAMAGE_WARD);

        /*1*/case AI_STATUS_POLYMORPH: return GetHasEffects(oCreature, EFFECT_TYPE_SHAPECHANGE);
        /*2*/case AI_STATUS_CHARM: return GetHasEffects(oCreature, EFFECT_TYPE_CHARM);
        /*3*/case AI_STATUS_PARALYZE: return (GetHasEffects(oCreature, EFFECT_TYPE_PARALYZE) || GetHasEffects(oCreature, EFFECT_TYPE_DRAINING));
        /*4*/case AI_STATUS_STUN: return GetHasEffects(oCreature, EFFECT_TYPE_STUN);
        /*5*/case AI_STATUS_SLEEP: return GetHasEffects(oCreature, EFFECT_TYPE_SLEEP);

        /*7*/case AI_STATUS_ROOT: return GetHasEffects(oCreature, EFFECT_TYPE_ROOT);
        /*8*/case AI_STATUS_DAZE: return GetHasEffects(oCreature, EFFECT_TYPE_DAZE);
        /*9*/case AI_STATUS_SLOW: return GetHasEffects(oCreature, EFFECT_TYPE_MOVEMENT_RATE);

        /*11*/case AI_STATUS_STEALTH: return GetHasEffects(oCreature, EFFECT_TYPE_STEALTH);
        /*12*/ /*AI_STATUS_POISONED*/
        /*13*/case AI_STATUS_DISEASED: return GetHasEffects(oCreature, EFFECT_TYPE_DISEASE);

        /*15*/case AI_STATUS_UNCONSIOUS: return GetHasEffects(oCreature, EFFECT_TYPE_DEATH);
        /*16*/case AI_STATUS_KNOCKDOWN: return (GetHasEffects(oCreature, EFFECT_TYPE_KNOCKDOWN) || GetHasEffects(oCreature, EFFECT_TYPE_SLIP));
        /*17*/case AI_STATUS_GRABBED: return (GetHasEffects(oCreature, EFFECT_TYPE_GRABBED) || GetHasEffects(oCreature, EFFECT_TYPE_OVERWHELMED));
        /*18*/case AI_STATUS_GRABBING: return (GetHasEffects(oCreature, EFFECT_TYPE_GRABBING) || GetHasEffects(oCreature, EFFECT_TYPE_OVERWHELMING));
        /*19*/case AI_STATUS_BERSERK: return IsModalAbilityActive(oCreature, AT_ABILITY_BERSERK);
        /*20*/case AI_STATUS_CONFUSED: return GetHasEffects(oCreature, EFFECT_TYPE_CONFUSION);

        /*97*/case AI_STATUS_CANT_ATTACK: return _AT_AI_CantAttack(oCreature);
        /*98*/case AI_STATUS_IMMOBLIZED: return (GetEffectsFlags(oCreature) & EFFECT_FLAG_DISABLE_MOVEMENT);
        /*99*/case AI_STATUS_MOVEMENT_IMPAIRED: return ((GetEffectsFlags(oCreature) & EFFECT_FLAG_DISABLE_MOVEMENT) || GetHasEffects(oCreature, EFFECT_TYPE_MOVEMENT_RATE));

    }

    return FALSE;
}

object[] _AT_AI_GetAlliesInParty(int nCheckLiving = TRUE, int nCheckPerceived = FALSE, int nIncludeSelf = FALSE)
{
    object[] arTargets = GetPartyPoolList();
    int nSize = GetArraySize(arTargets);

    object[] arTargetsFinal;

    int i;
    int j = 0;
    for (i = 0; i < nSize; i++)
    {
        if ((nIncludeSelf != TRUE)
        && (arTargets[i] == OBJECT_SELF))
            continue;

        if (_AT_AI_IsAllyValid(arTargets[i], nCheckLiving, nCheckPerceived) == TRUE)
        {
            arTargetsFinal[j] = arTargets[i];
            j++;
        }
    }

    return arTargetsFinal;
}

/* This function is a black box as it should have been.
   It return a list of available allies (max 5).
   Nothing more or less.

   The original function was checking the validy of allies for a specific ability.
   It was an unexpected behavior to me because we don't know this without reading the
   code of the function.
*/
object[] _AT_AI_GetAllies(int nCheckLiving = TRUE, int nCheckPerceived = FALSE, int nIncludeSelf = FALSE)
{

    object[] arTargets = GetNearestObjectByGroup(OBJECT_SELF,
                                                 GetGroupId(OBJECT_SELF),
                                                 OBJECT_TYPE_CREATURE,
                                                 AT_MAX_ALLIES_NEAREST,
                                                 nCheckLiving,
                                                 nCheckPerceived,
                                                 nIncludeSelf);

    int nSize = GetArraySize(arTargets);

    object[] arTargetsFinal;

    int i;
    int j = 0;
    for (i = 0; i < nSize; i++)
    {
        if ((IsFollower(arTargets[i]) != TRUE)
        && (GetCombatState(arTargets[i]) != TRUE)
        && (GetDistanceBetween(OBJECT_SELF, arTargets[i]) > AI_RANGE_MAX_ALLY_HELP))
            continue;

        if (_AT_AI_IsAllyValid(arTargets[i], nCheckLiving, nCheckPerceived) == TRUE)
        {
            arTargetsFinal[j] = arTargets[i];
            j++;
        }
    }

    return arTargetsFinal;
}

/* This function is a black box as it should have been.
   It return a list of available enemies (max 10).
   Nothing more or less.

   I cannot comment the original function. My goal is not to be nasty, but look
   at it and you will see what I am talking about. There is a check on current
   target (why ?) and multiple distance check.
   Well, the original function DID NOT returned a simple list of enemies.

   WE WANT A LIST OF VALID ENEMIES. If we need to check their range from the follower
   or their validy for an ability or their non equality with our current target, we
   will do it by ourselves. Thanks.
   If I wanted to give a name to the original function, it would be :
   _AI_GetEnemiesAtRangeAndValidForAbilityOrCurrentTargetIfValidForAMeleeUseABility
   it is just a name that tell what the function did.
*/
object[] _AT_AI_GetEnemies(int nCheckLiving = TRUE, int nCheckPerceived = TRUE)
{
    object[] arTargets = GetNearestObjectByHostility(OBJECT_SELF,
                                                     TRUE,
                                                     OBJECT_TYPE_CREATURE,
                                                     AT_MAX_ENEMIES_NEAREST,
                                                     nCheckLiving,
                                                     nCheckPerceived,
                                                     FALSE);

    int nSize = GetArraySize(arTargets);

    object[] arTargetsFinal;

    int i;
    int j = 0;
    for (i = 0; i < nSize; i++)
    {
        if (_AT_AI_IsEnemyValid(arTargets[i], nCheckLiving, nCheckPerceived) == TRUE)
        {
            arTargetsFinal[j] = arTargets[i];
            j++;
        }
    }

    return arTargetsFinal;
}

object _AT_AI_GetPartyTarget(int nTargetType, int nTacticID)
{
    if (nTargetType == AI_TARGET_TYPE_HERO)
        return GetHero();
    else if (nTargetType == AI_TARGET_TYPE_MAIN_CONTROLLED)
        return GetMainControlled();
    else
        return GetTacticTargetObject(OBJECT_SELF, nTacticID);
}

object _AT_AI_GetRelatedPartyTarget(int nTargetType, int nTacticID)
{
    if (nTargetType == AI_TARGET_TYPE_HERO)
        return GetHero();
    else if (nTargetType == AI_TARGET_TYPE_MAIN_CONTROLLED)
        return GetMainControlled();
    else
        return GetTacticConditionObject(OBJECT_SELF, nTacticID);
}

// 90% Ability_CheckUseConditions
// 10% _AI_CanUseAbility
int _AT_AI_CanUseAbility(int nTacticSubCommand, object oItem = OBJECT_INVALID)
{
    // 1st check
    // Various self requirements for some specifics abilities
    if (IsModalAbilityActive(OBJECT_SELF, nTacticSubCommand) == TRUE)
        return FALSE;

    string sItemTag = IsObjectValid(oItem) ? GetTag(oItem) : "";
    float fCooldown = GetRemainingCooldown(OBJECT_SELF, nTacticSubCommand, sItemTag);
    if (fCooldown > 0.0f)
        return FALSE;

    int nCondition = GetM2DAInt(TABLE_ABILITIES_SPELLS, "conditions", nTacticSubCommand);

    // -------------------------------------------------------------------------
    // CONDITION_MELEE_WEAPON - Caster needs a melee weapon in main hand
    // -------------------------------------------------------------------------
    if ((nCondition & 1) == 1)
    {
        if (IsUsingMeleeWeapon(OBJECT_SELF) != TRUE)
            return FALSE;
    }

    // -------------------------------------------------------------------------
    // CONDITION_SHIELD - Caster needs a shield in the offhand
    // -------------------------------------------------------------------------
    if ((nCondition & 2) == 2)
    {
        if (IsUsingShield(OBJECT_SELF) != TRUE)
            return FALSE;
    }

    // -------------------------------------------------------------------------
    // CONDITION_RANGED_WEAPON - Caster needs a ranged weapon in main hand
    // -------------------------------------------------------------------------
    if ((nCondition & 4) == 4)
    {
        if (IsUsingRangedWeapon(OBJECT_SELF) != TRUE)
            return FALSE;
    }

    // -------------------------------------------------------------------------
    // CONDITION_ACTIVE_MODAL_ABILITY - A specific modal ability needs to be active
    // -------------------------------------------------------------------------
    if ((nCondition & 16) == 16)
    {
        int nModalAbility = GetM2DAInt(TABLE_ABILITIES_TALENTS, "condition_mode", nTacticSubCommand);
        if (nModalAbility != 0)
        {
            if (IsModalAbilityActive(OBJECT_SELF, nModalAbility) != TRUE)
                return FALSE;
        }
    }

    // -------------------------------------------------------------------------
    // CONDITION_DUAL_WEAPONS
    // -------------------------------------------------------------------------
    if ((nCondition & 64) == 64)
    {
        if (GetWeaponStyle(OBJECT_SELF) != WEAPONSTYLE_DUAL)
            return FALSE;
    }

    // -------------------------------------------------------------------------
    // CONDITION_DUAL_WEAPONS
    // -------------------------------------------------------------------------
    if ((nCondition & 128) == 128)
    {
        if (GetWeaponStyle(OBJECT_SELF) != WEAPONSTYLE_TWOHANDED)
            return FALSE;
    }

    switch(nTacticSubCommand)
    {
        case 200010: // healing potions
        case 200011:
        case 200012:
        case 200013:
        {
            float fCurrentStat = GetCurrentHealth(OBJECT_SELF);
            float fMaxStat = GetMaxHealth(OBJECT_SELF);
            if (fCurrentStat == fMaxStat)
                return FALSE;

            break;
        }
        case 200030: // mana potions
        case 200031:
        case 200032:
        case 200033:
        {
            float fCurrentStat = GetCurrentManaStamina(OBJECT_SELF);
            float fMaxStat = IntToFloat(GetCreatureMaxMana(OBJECT_SELF));
            if (fCurrentStat == fMaxStat)
                return FALSE;

            break;
        }
    }

    if (_AT_AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH) == TRUE)
    {
        effect[] eEffects = GetEffects(OBJECT_SELF, EFFECT_TYPE_SHAPECHANGE);
        effect eEffect = eEffects[0];

        int nAbility;

        int i;
        /* Support for max 20 abilities. It is for compatibility with other mods */
        for (i = 2; i <= 22; i++)
        {
            nAbility = GetEffectInteger(eEffect, i);

            if ((nAbility != 0)
            && (nAbility == nTacticSubCommand))
                return TRUE;
        }

        return FALSE;
    }

    return TRUE;
}

int _AT_AI_IsTargetValidForAttack(object oTarget, object oLastTarget, int nLastCommandStatus)
{
    if ((oTarget == oLastTarget)
    && (nLastCommandStatus < 0))
        return FALSE;

    /*
    int COMMAND_FAILED_TIMEOUT = -10;
    int COMMAND_FAILED_PATH_ACTION_REQUIRED = -9;
    int COMMAND_FAILED_DISABLED = -8;
    int COMMAND_FAILED_TARGET_DESTROYED = -7;
    int COMMAND_FAILED_NO_LINE_OF_SIGHT = -6;
    int COMMAND_FAILED_NO_SPACE_IN_MELEE_RING = -5;
    int COMMAND_FAILED_INVALID_PATH = -4;
    int COMMAND_FAILED_INVALID_DATA = -3;
    int COMMAND_FAILED_COMMAND_CLEARED = -2;
    int COMMAND_FAILED = -1;
    */

    return TRUE;
}

int _AT_AI_IsSelfValidForAbility(int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType)
{
    if ((nAbilityTargetType & TARGET_TYPE_SELF) != 0)
    {
        if (_AT_AI_IsTargetValidForAbility(OBJECT_SELF, nTacticCommand, nTacticSubCommand) != TRUE)
            return FALSE;
    }

    return TRUE;
}

int _AT_AI_IsEnemyValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType)
{
    if (((nAbilityTargetType & TARGET_TYPE_HOSTILE_CREATURE) != 0)
    || (AT_IsHostileSelfAOE(nTacticCommand, nTacticSubCommand) == TRUE))
    {
        if (_AT_AI_IsTargetValidForAbility(oTarget, nTacticCommand, nTacticSubCommand) != TRUE)
            return FALSE;

        if ((nTacticCommand == AI_COMMAND_USE_ABILITY)
        && (_AT_NoAllyInAOE(oTarget, nTacticSubCommand) != TRUE))
            return FALSE;

        // 5th check
        // Follower range
        /* The ranged is checked once you want to engage the enemy.
           Not in the GetEnemies function as in vanilla tactics.
        */

        if (IsObjectHostile(OBJECT_SELF, oTarget) == TRUE)
        {
            /* AOE system */
            /* Do not attack enemies that are going to be target by an AOE */
            if ((AI_BehaviorCheck_AvoidAOE() == TRUE)
            && (_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_MELEE)
            && (_AT_IsAOEValid(_AT_GetAOEOnCreature(oTarget)) == TRUE))
                return FALSE;

            // MkBot Fix: 5th check is disabled.
            //return _AT_AI_IsRangeValid(oTarget);
        }
    }

    return TRUE;
}

int _AT_AI_IsAllyValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand, int nAbilityTargetType)
{
    if ((nAbilityTargetType & TARGET_TYPE_FRIENDLY_CREATURE) != 0)
    {
        if (_AT_AI_IsTargetValidForAbility(oTarget, nTacticCommand, nTacticSubCommand) != TRUE)
            return FALSE;
    }

    return TRUE;
}

// 70% _AI_CanUseAbility
// 10% Ability_CheckUseConditions
// 10% Ability_IsAbilityTargetValid
// 10% _AI_GetEnemies
int _AT_AI_IsTargetValidForAbility(object oTarget, int nTacticCommand, int nTacticSubCommand)
{
    if ((nTacticCommand == AI_COMMAND_USE_ABILITY)
    || (nTacticCommand == AI_COMMAND_USE_ITEM))
    {
        // 1st check
        // Target already affected by this ability

        effect[] thisEffects = GetEffects(oTarget, EFFECT_TYPE_INVALID, nTacticSubCommand);
        int nSize = GetArraySize(thisEffects);

        if (nSize > 0)
            return FALSE;

        if ((Ability_GetAbilityType(nTacticSubCommand) == ABILITY_TYPE_SPELL)
        && GetHasEffects(oTarget, EFFECT_TYPE_SPELL_WARD))
            return FALSE;

        // 2nd check
        // Various target requirements for some specifics abilities (script definied)

        float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
        float fAngle = GetAngleBetweenObjects(OBJECT_SELF, oTarget);

        switch(nTacticSubCommand)
        {
            /* Advanced Tactics */
            /* Self AOE */
            case AT_ABILITY_DUAL_WEAPON_WHIRLWIND:
            case AT_ABILITY_DUAL_WEAPON_SWEEP:
            case AT_ABILITY_TWO_HANDED_SWEEP:
            case AT_ABILITY_DEVOUR:
            case AT_ABILITY_MIND_BLAST:
            case AT_ABILITY_DISENGAGE:
            case AT_ABILITY_CLEANSE_AREA:
            case AT_ABILITY_WAR_CRY:
            case AT_ABILITY_TAUNT:
            case AT_ABILITY_DOG_MABARI_HOWL:
            {
                float nAOEParam = GetM2DAFloat(TABLE_ABILITIES_SPELLS, "aoe_param1", nTacticSubCommand);

                if (fDistance > nAOEParam)
                    return FALSE;

                break;
            }
            /* Advanced Tactics */
            /* CC */

            //MkBot:
            case AT_ABILITY_DUAL_WEAPON_RIPOSTE:
            {
                if (MK_IsShatterable(oTarget) == FALSE &&
                    (IsImmuneToEffectType(oTarget, EFFECT_TYPE_STUN) || _AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK)) == TRUE)
                    return FALSE;

                break;
            }
            //MkBot:
            case AT_ABILITY_SHIELD_PUMMEL:
            case AT_ABILITY_DIRTY_FIGHTING:
            {
                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_STUN) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                break;
            }
            //MkBot:
            case AT_ABILITY_OVERPOWER:
            {
                if (MK_IsShatterable(oTarget) == FALSE &&
                    (IsImmuneToEffectType(oTarget, EFFECT_TYPE_KNOCKDOWN) || _AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK)) == TRUE)
                    return FALSE;

                break;
            }
            //MkBot:
            case AT_ABILITY_SHIELD_BASH:
            case AT_ABILITY_POMMEL_STRIKE:
            case AT_ABILITY_DOG_CHARGE:
            {
                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_KNOCKDOWN) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                break;
            }
            //case AT_ABILITY_SHATTERING_SHOT: //MkBot: the purpose is to decrease armor
            //case AT_ABILITY_DUAL_WEAPON_PUNISHER: //MkBot: it deals a lot of damage, everything else is a bonus
            case AT_ABILITY_DAZE:
            case AT_ABILITY_DISTRACTION:
            case AT_ABILITY_PETRIFY:
            case AT_ABILITY_CONE_OF_COLD:
            case AT_ABILITY_PINNING_SHOT:
            {
                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                break;
            }
            case AT_ABILITY_CRUSHING_PRISON:
            {
                if ((_AT_AI_HasAIStatus(oTarget, AT_STATUS_INVULNERABLE) != TRUE)
                && (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE))
                    return FALSE;


                break;
            }
            case AT_ABILITY_HORROR:
            case AT_ABILITY_FRIGHTENING:
            {
                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_FEAR) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_SLEEP) == FALSE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CONFUSED) == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_GRABBING) == FALSE)
                    return FALSE;

                break;
            }
            case AT_ABILITY_SLEEP:
            {
                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_SLEEP) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CONFUSED) == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_GRABBING) == FALSE)
                    return FALSE;

                break;
            }
            case AT_ABILITY_WAKING_NIGHTMARE:
            {
                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_CONFUSION) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                break;
            }
            case AT_ABILITY_PARALYZE:
            {
                if (IsImmuneToEffectType(oTarget, EFFECT_TYPE_PARALYZE) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                if (_AT_AI_HasAIStatus(oTarget, AI_STATUS_CONFUSED) == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_GRABBING) == FALSE)
                    return FALSE;

                break;
            }
            case ABILITY_SPELL_GLYPH_OF_PARALYSIS:
            {
                int nIsHostile = !IsFollower(oTarget);
                if (nIsHostile == TRUE && IsImmuneToEffectType(oTarget, EFFECT_TYPE_PARALYZE) == TRUE)
                    return FALSE;

                if (nIsHostile == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_CANT_ATTACK) == TRUE)
                    return FALSE;

                if (nIsHostile == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_CONFUSED) == TRUE &&
                    _AT_AI_HasAIStatus(oTarget, AI_STATUS_GRABBING) == FALSE)
                    return FALSE;

                break;
            }
            case AT_ABILITY_MANA_DRAIN:
            case AT_ABILITY_MANA_CLASH:
            {
                if (IsMagicUser(oTarget) != TRUE)
                    return FALSE;

                break;
            }
            case MONSTER_HIGH_DRAGON_FIRE_SPIT:
            case ARCHDEMON_DETONATE_DARKSPAWN:
            case ARCHDEMON_CORRUPTION_BLAST:
            {
                if (fAngle > 60.0 && fAngle < 300.0)
                    return FALSE;

                break;
            }
            case ARCHDEMON_VORTEX:
            case ARCHDEMON_SMITE:
            {
                if (fDistance < AI_RANGE_MEDIUM)
                    return FALSE;

                break;
            }
            case AT_ABILITY_WALKING_BOMB:
            {
                if (Ability_IsAbilityActive(oTarget, AT_ABILITY_VIRULENT_WALKING_BOMB))
                    return FALSE;

                break;
            }
            case AT_ABILITY_VIRULENT_WALKING_BOMB:
            {
                if (Ability_IsAbilityActive(oTarget, AT_ABILITY_WALKING_BOMB))
                    return FALSE;

                break;
            }
            case AT_ABILITY_DOG_OVERWHELM:
            case ABILITY_TALENT_MONSTER_SHRIEK_OVERWHLEM:
            case MONSTER_BEAR_OVERWHELM:
            case MONSTER_SPIDER_OVERWHELM:
            case MONSTER_STALKER_OVERWHLEM:
            case MONSTER_DRAGON_OVERWHELM:
            {
                if (IsHumanoid(oTarget) != TRUE)
                    return FALSE;
                else if (GetHasEffects(oTarget, EFFECT_TYPE_OVERWHELMED) || GetHasEffects(oTarget, EFFECT_TYPE_GRABBED))
                    return FALSE;

                break;
            }
            case ABILITY_TALENT_MONSTER_OGRE_GRAB:
            case ABILITY_TALENT_BROODMOTHER_GRAB_LEFT:
            case ABILITY_TALENT_BROODMOTHER_GRAB_RIGHT:
            case MONSTER_HIGH_DRAGON_GRAB_LEFT:
            case MONSTER_HIGH_DRAGON_GRAB_RIGHT:
            {
                if (IsHumanoid(oTarget) != TRUE)
                    return FALSE;
                else if (GetHasEffects(oTarget, EFFECT_TYPE_OVERWHELMED) || GetHasEffects(oTarget, EFFECT_TYPE_GRABBED))
                    return FALSE;

                if ((nTacticSubCommand == MONSTER_HIGH_DRAGON_GRAB_LEFT) || (nTacticSubCommand == MONSTER_HIGH_DRAGON_GRAB_RIGHT))
                {
                    if ((GetAppearanceType(OBJECT_SELF) == APP_TYPE_ARCHDEMON) && IsFollower(oTarget))
                        return FALSE;
                }

                break;
            }
            case ABILITY_SPELL_MONSTER_OGRE_HURL:
            {
                if (fDistance < (AI_RANGE_SHORT * 2))
                    return FALSE;

                break;
            }
            case AT_ABILITY_SHIELD_DEFENSE:
            {
                if (HasAbility(OBJECT_SELF, AT_ABILITY_SHIELD_WALL))
                    return FALSE;

                break;
            }
        }

        // 3rd check
        // Various target requirements for some specifics abilities (M2DA definied)

        int nCondition = GetM2DAInt(TABLE_ABILITIES_SPELLS, "conditions", nTacticSubCommand);

        // -------------------------------------------------------------------------
        // CONDITION_BEHIND_TARGET - Caster needs to be located behind the target
        // -------------------------------------------------------------------------
        if ((nCondition & 8) == 8)
        {
            fAngle = GetAngleBetweenObjects(oTarget, OBJECT_SELF);

            if ((fAngle < 90.0f) || (fAngle > 270.0f))
                return FALSE;
        }

        // -------------------------------------------------------------------------
        // CONDITION_TARGET_HUMANOID - Target is humanoid
        // -------------------------------------------------------------------------
        if ((nCondition & 32) == 32)
        {
            if (IsHumanoid(oTarget) != TRUE)
                return FALSE;
        }

        // 4th check
        // Check target type. Only dead because the rest is done before.

        int nAbilityType = Ability_GetAbilityType(nTacticSubCommand);
        int nAbilityTargetType = Ability_GetAbilityTargetType(nTacticSubCommand, nAbilityType);

        /* Advanced Tactics */
        /* Guys, you forget that some spell you created can be cast on a dead target.
           Who said revival ?
        */
        if (IsDead(oTarget))
        {
            if ((nAbilityTargetType & TARGET_TYPE_BODY) != TARGET_TYPE_BODY)
                return FALSE;

            if (IsSummoned(oTarget))
                return FALSE;
        }

        if (IsDying(oTarget) && (nTacticSubCommand != ABILITY_SPELL_REVIVAL))
            return FALSE;

        if (IsObjectHostile(OBJECT_SELF, oTarget) != TRUE)
            return _AT_AI_IsTargetValidForBeneficialAbility(oTarget, nTacticSubCommand);
    }

    return TRUE;
}

int _AT_AI_IsTargetValidForBeneficialAbility(object oTarget, int nAbilityID)
{
    switch(nAbilityID)
    {
        case ARCHDEMON_DETONATE_DARKSPAWN:
        {
            if ((GetCreatureRank(oTarget) == CREATURE_RANK_LIEUTENANT)
            || (GetCreatureRank(oTarget) == CREATURE_RANK_BOSS))
                return FALSE;

            object[] arEnemies = GetNearestObjectByHostility(oTarget, TRUE, OBJECT_TYPE_CREATURE, 5, TRUE, FALSE, FALSE);
            int nSize = GetArraySize(arEnemies);

            int i;
            for (i = 0; i < nSize; i++)
            {
                if (GetDistanceBetween(arEnemies[i], oTarget) <= ARCHDEMON_DETONATE_RADIUS)
                    return TRUE;
            }

            return FALSE;

            break;
        }
        case AT_ABILITY_HEAL:
        case AT_ABILITY_REGENERATION:
        {
            float fMaxHealth = GetMaxHealth(oTarget);
            float fCurrentHealth = GetCurrentHealth(oTarget);

            if (fCurrentHealth == fMaxHealth)
                return FALSE;

            if (GetHasEffects(oTarget, EFFECT_TYPE_CURSE_OF_MORTALITY) == TRUE)
                return FALSE;

            if (IsModalAbilityActive(oTarget, AT_ABILITY_BLOOD_MAGIC) == TRUE)
                return FALSE;

            break;
        }
        case AT_ABILITY_REJUVINATION:
        {
            float fMaxManaStamina = GetCreatureProperty(oTarget, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_BASE);
            float fCurrentManaStamina = GetCreatureProperty(oTarget, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_CURRENT);

            if (fCurrentManaStamina == fMaxManaStamina)
                return FALSE;

            break;
        }
        case AT_ABILITY_DISPEL_MAGIC:
        {
            effect[] arSpell = GetEffects(oTarget);
            int nSize = GetArraySize(arSpell);

            int nAbility;
            int nDebuff;

            int i;
            for (i = 0; i < nSize; i++)
            {
                nAbility = GetEffectAbilityID(arSpell[i]);
                nDebuff = GetM2DAInt(TABLE_AI_ABILITY_COND, "MagicalDebuf", nAbility);

                if (nDebuff == 1)
                    return TRUE;
            }

            return FALSE;

            break;
        }
    }

    return TRUE;
}

int _AT_AI_IsRangeValid(object oTarget)
{
    float fFollowerMaxEngageRange;

    if (AI_BehaviorCheck_ChaseEnemy() != TRUE)
        fFollowerMaxEngageRange = AI_FOLLOWER_ENGAGE_DISTANCE_CLOSE;
    else
        fFollowerMaxEngageRange = AT_FOLLOWER_ENGAGE_DISTANCE_LONG;

    float fDistance = GetDistanceBetween(GetMainControlled(), oTarget);

    if (fDistance > fFollowerMaxEngageRange)
        return FALSE;

    return TRUE;
}

// _AI_IsHostileTargetValid
int _AT_AI_IsEnemyValid(object oTarget, int nCheckLiving = TRUE, int nCheckPerceived = FALSE)
{
    if ((IsObjectValid(oTarget) != TRUE)
    || (nCheckLiving && (IsDead(oTarget) == TRUE))
    || (nCheckLiving && (IsDying(oTarget) == TRUE))
    || (GetObjectActive(oTarget) != TRUE)
    || (IsObjectHostile(OBJECT_SELF, oTarget) != TRUE))
        return FALSE;

    /* Advanced Tactics */
    if (AT_IsControlled(OBJECT_SELF) == TRUE)
        return TRUE;

    if ((Effects_HasAIModifier(oTarget, AI_MODIFIER_IGNORE) == TRUE)
    || (nCheckPerceived && (IsPerceiving(OBJECT_SELF, oTarget) != TRUE))
    || (IsStealthy(oTarget) == TRUE)
    || GetHasEffects(oTarget, EFFECT_TYPE_DAMAGE_WARD))
        return FALSE;

    return TRUE;
}

int _AT_AI_IsAllyValid(object oTarget, int nCheckLiving = TRUE, int nCheckPerceived = FALSE)
{
    if ((IsObjectValid(oTarget) != TRUE)
    || (nCheckLiving && (IsDead(oTarget) == TRUE))
    || (nCheckLiving && (IsDying(oTarget) == TRUE))
    || (GetObjectActive(oTarget) != TRUE)
    || (IsObjectHostile(OBJECT_SELF, oTarget) == TRUE)
    || (Effects_HasAIModifier(oTarget, AI_MODIFIER_IGNORE) == TRUE)
    || (nCheckPerceived && (IsPerceiving(OBJECT_SELF, oTarget) != TRUE)))
        return FALSE;

    return TRUE;
}

int _AT_AI_CantAttack(object oTarget)
{
    if ((GetEffectsFlags(oTarget) & EFFECT_FLAG_DISABLE_COMBAT) != 0 &&
        _AT_AI_HasAIStatus(oTarget, AI_STATUS_GRABBING) != TRUE)
        return TRUE;

    return FALSE;
}

int AT_IsAtFlank(object oTarget)
{
    float fAngle = GetAngleBetweenObjects(oTarget, OBJECT_SELF);
    float fFlankingAngle = GetCreatureProperty(OBJECT_SELF, PROPERTY_ATTRIBUTE_FLANKING_ANGLE);

    /* It is a bioware's patch. */
    if (fFlankingAngle <= 10.0f)
        fFlankingAngle = 60.0f;
    else if (fFlankingAngle > 180.0f)
        fFlankingAngle = 180.0f;

    if ((fAngle >= (180.0f - fFlankingAngle))
    && (fAngle <= (180.0f + fFlankingAngle)))
        return TRUE;

    return FALSE;
}

int AT_IsControlled(object oTarget)
{
    int nBitVar = GetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT");
    if (IsControlled(oTarget) && ((nBitVar & 1) == 0))
        return TRUE;

    return FALSE;
}

int AT_IsHostileSelfAOE(int nTacticCommand, int nTacticSubCommand)
{
    if (nTacticCommand == AI_COMMAND_USE_ABILITY)
    {
        switch(nTacticSubCommand)
        {
            case AT_ABILITY_DISENGAGE: // 3016
            case AT_ABILITY_CLEANSE_AREA: // 3017
            case AT_ABILITY_TWO_HANDED_SWEEP: // 3031
            case AT_ABILITY_WAR_CRY: // 3037
            case AT_ABILITY_TAUNT: // 3041
            case AT_ABILITY_DUAL_WEAPON_WHIRLWIND: // 3043
            case AT_ABILITY_DUAL_WEAPON_SWEEP: // 3044
            case AT_ABILITY_DEVOUR: // 3065
            case AT_ABILITY_MIND_BLAST: // 12006
            case AT_ABILITY_ARCHDEMON_SMITE: // 90001
            case AT_ABILITY_DOG_MABARI_HOWL: // 90048
            case AT_ABILITY_GOLEM_HURL: // 90060
            {
                return TRUE;

                break;
            }
        }
    }

    return FALSE;
}

int MK_IsShatterable(object oCreature)
{
    if (!IsCreatureBossRank(oCreature) && !IsPlot(oCreature) && !IsImmortal(oCreature))
    {
        int nDifficulty = GetGameDifficulty();
        if ((IsPartyMember(oCreature) == FALSE) || (nDifficulty >= GAME_DIFFICULTY_HARD))
            return TRUE;
    }
    return FALSE;
}
#endif