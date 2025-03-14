// -----------------------------------------------------------------------------
// combat_h - Combat related functions
// -----------------------------------------------------------------------------
/*
    This file holds the combat resolution logic for the gtacticame.

    Item specific functions are included from items_h
    Damage specific functions (such as attack damage calculations and resists)
     are included from combat_damage_h

    core game resource - any change to this file has the potential to wreck
    the combat system, handle with care.


*/
// -----------------------------------------------------------------------------
// Owner: Georg Zoeller
// -----------------------------------------------------------------------------

#include "effects_h"
#include "items_h"
#include "combat_damage_h"
#include "ui_h"
#include "sys_soundset_h"
#include "ai_threat_h"
#include "2da_constants_h"

#include "stats_core_h"
#include "af_option_h"


// -----------------------------------------------------------------------------
//
//             L I M I T E D   E D I T   P E R M I S S I O N S
//
//      If you are not Georg, you need permission to edit this file
//      and the changes have to be code reviewed before they are checked
//      in.
//
// -----------------------------------------------------------------------------


const float ATTACK_LOOP_DURATION_INVALID = 999.0f;
const float ATTACK_HIT_BIAS = 4.0f; // General bias in the system towards hits instead of misses.
const int ATTACK_TYPE_MELEE = 1;
const int ATTACK_TYPE_RANGED = 2;

const float SPECIAL_BOSS_DEATHBLOW_THRESHOLD = 0.04;        // at this % of health, any meelee attack may trigger the deathblow of special bosses;


// -----------------------------------------------------------------------------
// Point blank range (no penalty range for bows)
// -----------------------------------------------------------------------------
const float POINT_BLANK_RANGE = 8.0f;

 /**
* @brief Determine which hand to use for an attack
*
* Only applicable in dual weapon style. Returns which hand to use for the next attack
*
* @returns  0 - main hand, 1 - offhand
*
* @author Georg Zoeller
*
**/

int Combat_GetAttackHand(object oCreature = OBJECT_SELF)
{

    int nHand = 0;
    if (GetWeaponStyle(oCreature) == WEAPONSTYLE_DUAL)
    {
        nHand = GetLocalInt(oCreature, COMBAT_LAST_WEAPON);
        SetLocalInt(oCreature, COMBAT_LAST_WEAPON, !nHand);
    }

    return nHand;
}


/**
* @brief Check if a deathblow should occur.
*
* Examine a number of parameters to see whether or not we can play a deathblow
* without interrupting the flow of combat.
*
* @author Georg Zoeller
**/

int CheckForDeathblow(object oAttacker, object oTarget)
{
    int nRank = GetCreatureRank(oTarget);
    int nLevel = GetLevel(oAttacker);
    float fChance = GetM2DAFloat(TABLE_CREATURERANKS,"fDeathblow", nRank);

    // -------------------------------------------------------------------------
    // Any rank flagged 1.0 or higher triggers a deathblow.
    // -------------------------------------------------------------------------
    if (fChance >= 1.0f)
        return TRUE;

    // -------------------------------------------------------------------------
    // If we perceive more than 1 creature, then half the chance of triggering
    // a deathblow with each perceived hostile.
    // -------------------------------------------------------------------------
    int nCount = GetArraySize(GetPerceivedCreatureList(oAttacker, TRUE));
    if (nCount > 2)
        fChance *= (2.0/nCount);

    //Increase chance of death blow in origin stories (level 1 and 2)
    //1.5 times the chance
    if (nLevel < 3)
        fChance *= 1.5;

    // Messy kills doubles the chance
    if (AF_IsOptionEnabled(AF_OPT_MESSY_KILLS) && GetHasEffects(oAttacker, AF_EFFECT_TYPE_MESSY_KILLS))
        fChance *= 2.0;

    return (fChance > RandomFloat());
}

/**
* @brief Determine a valid deathblow for the current target
*
* Called when the script decides to do a deathblow, this function will return
* a DEATHBLOW_* constant representing the deathblow to use against the creature
*
* If the creature does not support deathblows (immunity, no animation) or can not
* be deathblowed (Immortal, Plot, Party Member, Flagged as invalid in the toolset)
* the function returns 0
*
* @param oTarget    The target for the Deathblow
*
* @returns  0 or DEATH_BLOW_*
*
* @author Georg Zoeller
*
**/
int Combat_GetValidDeathblow(object oAttacker, object oTarget);
int Combat_GetValidDeathblow(object oAttacker, object oTarget)
{

     // ------------------------------------------------------------------------
     // First, let's check if we can even perform deathblows with the attacker
     // ------------------------------------------------------------------------
     int bCanDeathblow =       CanPerformDeathblows(oAttacker);

     if (!bCanDeathblow)
     {
        return FALSE;
     }

     int nValid =              GetM2DAInt(TABLE_APPEARANCE,"ValidDeathblows", GetAppearanceType(oTarget));

     int bImmortal            = IsImmortal(oTarget);
     int bPlot                = IsPlot(oTarget);
     int bCanDiePermanently   = GetCanDiePermanently(oTarget);
     int bAlreadyDead         = HasDeathEffect(oTarget);

      #ifdef DEBUG
     Log_Trace(LOG_CHANNEL_COMBAT_DEATH,"GetValidDeathblow","nValid: " + ToString(nValid) + " bImmortal: " + ToString(bImmortal) + " bPlot:" +
                                ToString(bPlot) + " bCanDiePermanently:" + ToString(bCanDiePermanently));

     #endif

     // ------------------------------------------------------------------------
     // If we are immortal, Plot, or can not die permanently (e.g. a party member),
     // we return 0
     // ------------------------------------------------------------------------
     if (bImmortal || bPlot || !bCanDiePermanently || IsPartyMember(oTarget) || bAlreadyDead)
     {
       return 0;
     }

     return 1;
}

// -----------------------------------------------------------------------------
// Return the type of the current attack based on the weapon in the main hand
// used only in command_pending...
// -----------------------------------------------------------------------------
int Combat_GetAttackType(object oAttacker, object oWeapon);
int Combat_GetAttackType(object oAttacker, object oWeapon)
{
    if (IsUsingRangedWeapon(oAttacker, oWeapon))
    {
        return ATTACK_TYPE_RANGED;
    }
    else
    {
        return ATTACK_TYPE_MELEE;
    }
}


// -----------------------------------------------------------------------------
// Attack Result struct, used by Combat_PerformAttack*
// -----------------------------------------------------------------------------
struct CombatAttackResultStruct
{

    int     nAttackResult;      //  - COMBAT_RESULT_* constant
    int     nDeathblowType;
    float   fAttackDuration;   //  - Duration of the aim loop for ranged weapons
    effect  eImpactEffect;       //  - Impact Effect
};




float Combat_GetFlankingBonus(object oAttacker, object oTarget)
{


    if (HasAbility(oTarget, ABILITY_TALENT_SHIELD_TACTICS))
    {
        if (IsUsingShield(oTarget))
            return 0.0;
    }


    if (GetHasEffects(oTarget, EFFECT_TYPE_FLANK_IMMUNITY))
    {
        return 0.0;
    }




    float fAngle = GetAngleBetweenObjects(oTarget, oAttacker);
    float fFactor = 0.0;
    float fMaxModifier = 15.0;

    // The attackers ability to flank is stored in a creature property
    float fFlankingAngle = GetCreatureProperty(oAttacker, PROPERTY_ATTRIBUTE_FLANKING_ANGLE);

    if (fFlankingAngle <= 10.0 ) /*old savegames have this at 10*/
    {
        fFlankingAngle = 60.0; // old savegames need this to avoid divby0 later
    }
    else if (fFlankingAngle>180.0)
    {
        fFlankingAngle = 180.0;
    }


    // -------------------------------------------------------------------------
    if (HasAbility(oAttacker, ABILITY_TALENT_COMBAT_MOVEMENT))
    {
        fMaxModifier = 20.0;
    }

    if ( fMaxModifier <= 0.0 )
    {
        return 0.0;
    }

    if ( (fAngle>= (180.0 - fFlankingAngle) && fAngle<=(180.0 + fFlankingAngle )))
    {
        // Shield block negats flanking on the left.

        int bShieldBlock =  HasAbility(oTarget,ABILITY_TALENT_SHIELD_BLOCK);
        int bUsingShield = IsUsingShield(oTarget);

        if (!bShieldBlock || fAngle < 180.0 || (bShieldBlock && !bUsingShield) )
        {
            fFactor = (fFlankingAngle -  fabs( 180.0 - fAngle))/fFlankingAngle;
        }

    }

    // Only rogues get the full positional benefits on the battlefield,
    // everyone else gets halfa
    float fClassModifier = GetCreatureCoreClass(oAttacker) == CLASS_ROGUE?1.0f:0.5f;


    return fFactor * fMaxModifier * fClassModifier;
}

// -----------------------------------------------------------------------------
// Check if backstab conditions are true
// -----------------------------------------------------------------------------
int Combat_CheckBackstab(object oAttacker, object oTarget, object oWeapon, float fFlankingBonus)
{

    // -------------------------------------------------------------------------
    // If we we are a rogue
    // -------------------------------------------------------------------------
    if (!HasAbility(oAttacker, ABILITY_TALENT_HIDDEN_ROGUE))
    {
        return FALSE;
    }

    if (!IsHumanoid(oAttacker))
    {
        return FALSE;
    }

    // -------------------------------------------------------------------------
    // And target is not immune
    // -------------------------------------------------------------------------
    if (HasAbility(oTarget, ABILITY_TRAIT_CRITICAL_HIT_IMMUNITY))
    {
        return FALSE;
    }

    // -------------------------------------------------------------------------
    // And attacker does not use double strike mode
    // -------------------------------------------------------------------------
    if (IsModalAbilityActive(oAttacker, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE))
    {
        return FALSE;
    }


     // -------------------------------------------------------------------------
    // We can only backstab if we are flanking.
    // -------------------------------------------------------------------------
    if (fFlankingBonus>0.0)
    {
        return TRUE;
    }
    else
    {
         /* Coup de grace*/
        if (HasAbility(oAttacker, ABILITY_TALENT_BACKSTAB))
        {
            if (GetHasEffects(oTarget, EFFECT_TYPE_STUN))
            {
                return TRUE;
            }
            else if (GetHasEffects(oTarget, EFFECT_TYPE_PARALYZE))
            {
                return TRUE;
            }
        }

    }

    return FALSE;
}



/**
* @brief Determine whether or not an attack hits a target.
*
* Note that this function only calculates to hit and crits, death blows are
* determined in Combat_PerformAttack
*
* @param oAttacker  The attacker
* @param oTarget    The target that is being attacked
* @param nAbility   If != 0, it won't trigger backstabs and deathblows.
*
* @returns  COMBAT_RESULT_HIT, COMBAT_RESULT_CRITICALHIT or COMBAT_RESULT_MISS
*
* @author Georg Zoeller
*
**/
int Combat_GetAttackResult(object oAttacker, object oTarget, object oWeapon, float fBonus = 0.0f, int nAbility = 0);
int Combat_GetAttackResult(object oAttacker, object oTarget, object oWeapon, float fBonus = 0.0f, int nAbility = 0)
{

    // -------------------------------------------------------------------------
    // Debug
    // -------------------------------------------------------------------------
    int nForcedCombatResult = GetForcedCombatResult(oAttacker);
    if (nForcedCombatResult != -1)
    {
        #ifdef DEBUG
        Log_Trace_Combat("combat_h.GetAttackResult"," Skipped rules, FORCED RESULT IS:" + ToString(nForcedCombatResult), oTarget);
        #endif
        return nForcedCombatResult;
    }



    // -------------------------------------------------------------------------
    // Placeables are always hit
    // -------------------------------------------------------------------------
    if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
    {
        #ifdef DEBUG
        Log_Trace_Combat("combat_h.GetAttackResult"," Placeable, automatic result : COMBAT_RESULT_HIT", oTarget);
        #endif
        return COMBAT_RESULT_HIT;
    }


    // -------------------------------------------------------------------------
    // Displacement
    // -------------------------------------------------------------------------
    float fDisplace = GetCreatureProperty(oTarget, PROPERTY_ATTRIBUTE_DISPLACEMENT);
    float fRand = RandomFloat()*100.0;
    if ( fRand < fDisplace)
    {
        #ifdef DEBUG
        Log_Trace_Combat("combat_h.GetAttackResult"," Displacement effect kciked in, automatic result : COMBAT_RESULT_MISS", oTarget);
        #endif

        // ---------------------------------------------------------------------
        // if the target has the evasion talent, attribute this miss to the talent
        // (random 50% because the anim is interrupting)
        // ---------------------------------------------------------------------
        if (HasAbility(oTarget, ABILITY_TALENT_EVASION) && !AF_IsOptionEnabled(AF_OPT_REMOVE_EVASION_DODGE) && fRand < (20.0f - (RandomFloat()*10.0f)))
        {
                command currentCmd = GetCurrentCommand(oTarget);
                int nCmdType = GetCommandType(currentCmd);
                // Evasion only plays during attack and wait commands.
                if (nCmdType == COMMAND_TYPE_WAIT || nCmdType == COMMAND_TYPE_ATTACK || nCmdType == COMMAND_TYPE_INVALID)
                {
                    ApplyEffectOnObject(EFFECT_DURATION_TYPE_INSTANT, Effect(1055), oTarget, 0.0f, oTarget, ABILITY_TALENT_EVASION);
                }
        }

        return COMBAT_RESULT_MISS;
    }



    int  nAttackType = Combat_GetAttackType(oAttacker, oWeapon);
    int nRet;

    // -------------------------------------------------------------------------
    // Get the attackers attack rating (includes effects and equipment stats)
    // -------------------------------------------------------------------------
    float   fAttackRating;

    if (GetBaseItemType(oWeapon) == BASE_ITEM_TYPE_STAFF)
    {
        // ---------------------------------------------------------------------
        // Staves always hit
        // ---------------------------------------------------------------------
        return COMBAT_RESULT_HIT;
    }



    fAttackRating =  GetCreatureAttackRating (oAttacker);

    // -------------------------------------------------------------------------
    // Add item stat (usually 0) along with scripted boni and attack bias.
    // -------------------------------------------------------------------------

    fAttackRating += GetItemStat(oWeapon,   ITEM_STAT_ATTACK) + fBonus + ATTACK_HIT_BIAS;

    // -------------------------------------------------------------------------
    // Easier difficulties grant the player a bonus.
    // -------------------------------------------------------------------------
    fAttackRating += Diff_GetRulesAttackBonus(oAttacker);


    // -------------------------------------------------------------------------
    // This section deals with figuring out which critical hit modifier (melee, ranged, etc)
    // to use for this attack.
    // -------------------------------------------------------------------------
    float   fCriticalHitModifier;
    int     nCriticalHitModifier  = (nAttackType == ATTACK_TYPE_RANGED) ?  CRITICAL_MODIFIER_RANGED : CRITICAL_MODIFIER_MELEE;



    fCriticalHitModifier = GetCreatureCriticalHitModifier(oAttacker, nCriticalHitModifier);
    fCriticalHitModifier += GetItemStat(oWeapon, ITEM_STAT_CRIT_CHANCE_MODIFIER);

    // -------------------------------------------------------------------------
    //  Bravery grants +3.5 critical hit per enemy past the first 2
    // -------------------------------------------------------------------------
    if (HasAbility(oAttacker, ABILITY_TALENT_BRAVERY))
    {

        int nEnemies = Max(0,GetArraySize(GetCreaturesInMeleeRing(oAttacker,0.0, 359.99f,TRUE,0))-2);
        fCriticalHitModifier +=  nEnemies * 3.5f;
    }


    // -------------------------------------------------------------------------
    // Calculate Flanking Bonus
    // -------------------------------------------------------------------------
    float fFlanking = Combat_GetFlankingBonus(oAttacker, oTarget);
    if (fFlanking > 0.0 )
    {
        // ---------------------------------------------------------------------
        // Also increase chance for critical hits by 1/5th of the flanking bonus
        // ---------------------------------------------------------------------
        fCriticalHitModifier *=  (1.0 + (fFlanking/5.0));
    }

    // -------------------------------------------------------------------------
    // Range plays a role too.
    // -------------------------------------------------------------------------
    float fDistance =  GetDistanceBetween(oAttacker, oTarget);
    float fNoPenaltyDistance = MaxF(POINT_BLANK_RANGE,GetItemStat(oWeapon, ITEM_STAT_OPTIMUM_RANGE));
    fDistance = MaxF(fDistance-fNoPenaltyDistance,0.0f);

    float fAttackRoll = 50.0;
    float fPenalties = fDistance; // every meter distance past the free range is -1!
    float fAttack = fAttackRating  + fAttackRoll + fFlanking - fPenalties;

    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // BEGIN SECTION CRITICAL HITS
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    int bThreatenCritical;

    if (AF_IsOptionEnabled(AF_OPT_NORMALISE_CRITS)) {
        int autoCrit = 0;
        autoCrit += IsModalAbilityActive(oAttacker, ABILITY_SKILL_STEALTH_1);
        autoCrit += GetHasEffects(oTarget, EFFECT_TYPE_DEATH_HEX);
        autoCrit += GetHasEffects(oAttacker, EFFECT_TYPE_AUTOCRIT);
        autoCrit -= IsModalAbilityActive(oAttacker, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE);
        autoCrit -= IsModalAbilityActive(oAttacker, ABILITY_TALENT_RAPIDSHOT);

        bThreatenCritical = autoCrit == 0 ? RandomFloat()*100.0f < fCriticalHitModifier : autoCrit > 0;
    } else {
        // god the OG code is bad
        bThreatenCritical = (RandomFloat()*100.0f < fCriticalHitModifier);

        if (!bThreatenCritical)
        {
            // ---------------------------------------------------------------------
            // Attacking out of stealth always threatens crit.
            // ---------------------------------------------------------------------
            if (IsModalAbilityActive(oAttacker, ABILITY_SKILL_STEALTH_1))
            {
                bThreatenCritical = TRUE;
            }

            // -----------------------------------------------------------------
            // Death hex effect ... all hits are auto crit
            // -----------------------------------------------------------------
            if (GetHasEffects(oTarget, EFFECT_TYPE_DEATH_HEX))
            {
                bThreatenCritical = TRUE;
            }

            // -----------------------------------------------------------------
            // Autocrit effect
            // -----------------------------------------------------------------
            if (GetHasEffects(oAttacker, EFFECT_TYPE_AUTOCRIT))
            {
                bThreatenCritical = TRUE;
            }
        }
        else
        {
            // ---------------------------------------------------------------------
            // Double strike does not allow crits
            // ---------------------------------------------------------------------
            if (IsModalAbilityActive(oAttacker, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE))
            {
                bThreatenCritical = FALSE;
            }

            // rapid shot doesn't allow critical strikes
            if (IsModalAbilityActive(oAttacker, ABILITY_TALENT_RAPIDSHOT))
            {
                bThreatenCritical = FALSE;
            }
        }
    }

    // ---------------------------------------------------------------------
    // Targets that have critical hit immunity can not be crit...
    // ---------------------------------------------------------------------
    if (bThreatenCritical)
    {
        Log_Trace_Combat("combat_h.GetAttackResult"," Critical hit averted, target has critical hit immunity", oTarget);
        bThreatenCritical = !HasAbility(oTarget, ABILITY_TRAIT_CRITICAL_HIT_IMMUNITY);
    }



    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    // END SECTION CRITICAL HITS
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




    // -------------------------------------------------------------------------
    // This section deals with calculating the defense values of the attack target
    // -------------------------------------------------------------------------
    float fDefenseRating =  GetCreatureDefense(oTarget) + ((nAttackType == ATTACK_TYPE_RANGED) ? GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_MISSILE_SHIELD):0.0f);

    // -------------------------------------------------------------------------
    // Easier difficulties grant the player a bonus.
    // -------------------------------------------------------------------------
    fDefenseRating += Diff_GetRulesDefenseBonus(oTarget);

    // -------------------------------------------------------------------------
    // A hit is successful if the attack rating exceeds the defense rating
    // -------------------------------------------------------------------------
    if (RandomFloat()*100.0f <  fAttack - fDefenseRating)
    {

        // ---------------------------------------------------------------------
        // If we threatened a critical, we crit here, otherwise just report normal hit
        // ---------------------------------------------------------------------
        nRet =  ( (bThreatenCritical) ? COMBAT_RESULT_CRITICALHIT : COMBAT_RESULT_HIT  );

        if ( nAttackType == ATTACK_TYPE_MELEE)
        {
            // -----------------------------------------------------------------
            // If we are backstabbing, we change the result here if it
            // was a crit. Abilities never bs (anim priority)
            // -----------------------------------------------------------------
            if ( nAbility == 0 && Combat_CheckBackstab(oAttacker, oTarget, oWeapon,fFlanking))
            {
                    nRet =  COMBAT_RESULT_BACKSTAB;
            }
        }

    }
    // -------------------------------------------------------------------------
    // Miss...
    // -------------------------------------------------------------------------
    else
    {
        nRet = COMBAT_RESULT_MISS;

    }

    // -------------------------------------------------------------------------
    // Misdirection Hex
    // -------------------------------------------------------------------------
    if (GetHasEffects(oAttacker, EFFECT_TYPE_MISDIRECTION_HEX))
    {
        #ifdef DEBUG
        Log_Trace_Combat("combat_h.GetAttackResult"," Attacker under misdirection hex: Hits are misses, crits are hits.", oTarget);
        #endif

        if (nRet == COMBAT_RESULT_HIT || nRet == COMBAT_RESULT_BACKSTAB && (!bThreatenCritical || !AF_IsOptionEnabled(AF_OPT_MISDIRECT_BACKSTABS)))
        {
            nRet = COMBAT_RESULT_MISS;
        }
        else if (nRet == COMBAT_RESULT_CRITICALHIT)
        {
            nRet = COMBAT_RESULT_HIT;
        }
    }


  //  return COMBAT_RESULT_BACKSTAB;

    #ifdef DEBUG
    Log_Trace_Combat("combat_h.GetAttackResult"," ToHit Calculation: " +
                     " fAttack:"  + ToString(fAttack) +
                     " = (fAttackRating: " + ToString(fAttackRating) +
                     " fAttackRoll:" + ToString(fAttackRoll) +
                     " (range penalty:" + ToString(fPenalties) + ")"+
                     " fFlanking: " + ToString(fFlanking) +
                     " fBonus(script): " + ToString(fBonus) +
                     ")" , oAttacker, oTarget, LOG_CHANNEL_COMBAT_TOHIT );

    Log_Trace_Combat("combat_h.GetAttackResult"," ToHit Calculation (2):  " +
                     " fDefenseRating: " + ToString(fDefenseRating) +
                     " fCriticalHitModifier: " + ToString(fCriticalHitModifier) +
                     " bThreatenCritical: " + ToString(bThreatenCritical), oAttacker, oTarget, LOG_CHANNEL_COMBAT_TOHIT );

    #endif

    return nRet;




}

/**
*  @brief Handles processing an Attack Command
*
*  @param oAttacker       The command owner, usually OBJECT_SELF
*  @param oTarget         The Target of the command
*
*  @returns CombatAttackResultStruct with damage and attackresult populated
*
*  "Don't touch this if you want to live"
*
*  @author Georg Zoeller
**/
struct CombatAttackResultStruct Combat_PerformAttack(object oAttacker, object oTarget, object oWeapon , float fDamageOverride = 0.0f, int nAbility = 0);
struct CombatAttackResultStruct Combat_PerformAttack(object oAttacker, object oTarget, object oWeapon ,  float fDamageOverride = 0.0f, int nAbility = 0)
{
    struct  CombatAttackResultStruct stRet;
    float   fDamage = 0.0f;
    int     nAttackType = Combat_GetAttackType(oAttacker, oWeapon);

    stRet.fAttackDuration =    ATTACK_LOOP_DURATION_INVALID ;

    // -------------------------------------------------------------------------
    // Attack check happens here...
    // -------------------------------------------------------------------------

    stRet.nAttackResult = Combat_GetAttackResult(oAttacker, oTarget, oWeapon );

    // -------------------------------------------------------------------------
    // If attack result was not a miss, go on to calculate damage
    // -------------------------------------------------------------------------
    if (stRet.nAttackResult != COMBAT_RESULT_MISS)
    {
        int bCriticalHit = (stRet.nAttackResult == COMBAT_RESULT_CRITICALHIT);

        // -------------------------------------------------------------------------
        // If attack result was not a miss, check if we need to handle a deathblow
        // -------------------------------------------------------------------------
        fDamage = ( (fDamageOverride == 0.0f) ?
                          Combat_Damage_GetAttackDamage(oAttacker, oTarget, oWeapon, stRet.nAttackResult) : fDamageOverride);


        float fTargetHealth = GetCurrentHealth( oTarget );


        // -----------------------------------------------------------------
        //  Ranged weapons attacks are not synched and therefore we never
        //  need to worry about reporting deathblows to the engine.
        // ---------------------------------------------------------------------

        // ---------------------------------------------------------------------
        // When not using a ranged weapon, there are synchronize death blows to handle
        // ---------------------------------------------------------------------
        if ( nAttackType != ATTACK_TYPE_RANGED && nAbility == 0 && stRet.nAttackResult != COMBAT_RESULT_MISS )
        {

            // -----------------------------------------------------------------
            // Deathblows against doors look cool, but really...
            // -----------------------------------------------------------------
            if (  GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
            {

                // ---------------------------------------------------------
                // Special conditions.
                //
                // There are a few cases in the single player campaign
                // where we want the spectacular deathblow to occur if possible.
                //
                // The following logic defines these conditions
                // ---------------------------------------------------------
                int nAppearance =   GetAppearanceType(oTarget) ;
                int nRank       = GetCreatureRank(oTarget);

                int bSpecial =   FALSE;

                // ---------------------------------------------------------
                // ... all boss ogres (there's 1 in the official campaign) by request
                //     from Dr. Muzyka.
                // ... all elite bosses
                // ---------------------------------------------------------
                if ( (nAppearance == APR_TYPE_OGRE || (nRank == CREATURE_RANK_BOSS||nRank == CREATURE_RANK_ELITE_BOSS)  ) ||
                      nRank == CREATURE_RANK_ELITE_BOSS)
                {
                        // -------------------------------------------------
                        // ... but only if they are at the health threshold
                        //     required for deathblows to trigger
                        // -------------------------------------------------
                        if (IsHumanoid(oAttacker))
                        {
                            bSpecial = _GetRelativeResourceLevel(oTarget, PROPERTY_DEPLETABLE_HEALTH) < SPECIAL_BOSS_DEATHBLOW_THRESHOLD;
                        }
                }

                // ---------------------------------------------------------
                // Deathblows occur when
                //  ... target isn't immortal (duh) AND
                //      ... the damage of the hit exceeds the creature's health OR
                //      ... aforementioned 'special' conditions are met.
                // ---------------------------------------------------------
                if ( (!IsImmortal( oTarget ) && (fDamage >= fTargetHealth || bSpecial)))
                {

                    // -----------------------------------------------------
                    // ... only from party members AND
                    //    ... if we determine that a deathblow doesn't interrupt gameplay OR
                    //    ... aforementioned 'special' conditions are met
                    // -----------------------------------------------------
                    if (IsPartyMember(oAttacker) && (CheckForDeathblow(oAttacker, oTarget) || bSpecial))
                    {
                        // -------------------------------------------------
                        // Verify some more conditions...
                        // -------------------------------------------------
                        int bDeathBlow = Combat_GetValidDeathblow(oAttacker, oTarget);
                        if (bDeathBlow)
                        {
                            stRet.nAttackResult = COMBAT_RESULT_DEATHBLOW ;

                            // ---------------------------------------------
                            // Special treatment for ogre
                            // Reason: The ogre, unlike all other special bosses
                            //         has a second, non spectacular deathblow.
                            //         if we specify 0, there's a 50% chance that
                            //         one is played, which we don't want in this
                            //         case, so we're passing the id of the
                            //         spectacular one instead.
                            // ---------------------------------------------
                            if (bSpecial && nAppearance == APR_TYPE_OGRE)
                            {
                                stRet.nDeathblowType = 5; // 5 - ogre slowmo deathblow
                            }
                            else
                            {
                                stRet.nDeathblowType = 0;  // 0 - auto select in engine;
                            }

                        }
                        else
                        {
                            // Failure to meet conditions: convert to hit.
                            if (stRet.nAttackResult != COMBAT_RESULT_BACKSTAB)
                            {
                                stRet.nAttackResult = COMBAT_RESULT_HIT;
                            }
                        }
                    }
                    else
                    {
                        // Failure to meet conditions: convert to hit.
                        if (stRet.nAttackResult != COMBAT_RESULT_BACKSTAB)
                        {
                            stRet.nAttackResult = COMBAT_RESULT_HIT;
                        }
                    }



                 } /* ishumanoid*/


            } /* obj_type creature*/
        }


    }
    int nDamageType = DAMAGE_TYPE_PHYSICAL;

    if ( nAttackType == ATTACK_TYPE_RANGED)
    {
        // ---------------------------------------------------------------------
        // Certain projectiles modifyt the damage type done by a ranged weapon
        // This is defined in PRJ_BASE.
        // ---------------------------------------------------------------------
        int nProjectileIndex = GetLocalInt(oWeapon,PROJECTILE_OVERRIDE);
        if (nProjectileIndex)
        {
            int nDamageTypeOverride = GetM2DAInt(TABLE_PROJECTILES,"DamageType",nProjectileIndex);
            if (nDamageTypeOverride>0)
            {
                nDamageType = nDamageTypeOverride;
            }
        }

        // ---------------------------------------------------------------------
        // When using a ranged weapon, we need to report the duration of the
        // aim loop to the engine
        // ---------------------------------------------------------------------
        stRet.fAttackDuration = GetCreatureRangedDrawSpeed(oAttacker, oWeapon);
    }
    else
    {
        float fSpeed = CalculateAttackTiming(oAttacker, oWeapon);
        if (fSpeed>0.0f)
        {
            stRet.fAttackDuration = fSpeed;
        }
    }

    // -------------------------------------------------------------------------
    // The Impact effect is not a real effect - it is not ever applied. Instead
    // it is used to marshal information about the attack back to the impact
    // event.
    // -------------------------------------------------------------------------
    stRet.eImpactEffect = EffectImpact(fDamage, oWeapon, 0, 0, nDamageType);

    #ifdef DEBUG
    Log_Trace_Combat("combat_h.Combat_PerformAttack"," Attack Result: " + Log_GetAttackResultNameById(stRet.nAttackResult),  oAttacker, oTarget, LOG_CHANNEL_COMBAT_TOHIT );
    #endif

    return stRet;
}








/**
*  @brief Handles processing an Attack Command
*
*  @param oAttacker       The command owner, usually OBJEC_TSE
*  @param oTarget         The Target of the command
*  @param nCommandId      The command Id
*  @param nCommandSubType The command subtype
*
*  @returns COMBAT_RESULT_* constant
*
*  @author Georg Zoeller
**/
int  Combat_HandleCommandAttack(object oAttacker, object oTarget, int nCommandSubType);
int  Combat_HandleCommandAttack(object oAttacker, object oTarget, int nCommandSubType)
{

    struct CombatAttackResultStruct stAttack1;
    struct CombatAttackResultStruct stAttack2;


    object oWeapon;
    object oWeapon2;

    int nHand = Combat_GetAttackHand(oAttacker);

    if (nHand == HAND_MAIN)
    {
        oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN);
    }
    else if (nHand == HAND_OFFHAND)
    {
        oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND);
    }

    // -------------------------------------------------------------------------
    // Double Weapon Strike.
    // -------------------------------------------------------------------------
    if (IsModalAbilityActive(oAttacker, ABILITY_TALENT_DUAL_WEAPON_DOUBLE_STRIKE))
    {
        nHand=HAND_BOTH;
        oWeapon = GetItemInEquipSlot(INVENTORY_SLOT_MAIN);
        oWeapon2 = GetItemInEquipSlot(INVENTORY_SLOT_OFFHAND);
    }


    int nAttackType = Combat_GetAttackType(oAttacker, oWeapon);



    // -------------------------------------------------------------------------
    // Handle Attack #1
    // -------------------------------------------------------------------------
    stAttack1 = Combat_PerformAttack(oAttacker, oTarget, oWeapon);

    if (nHand == HAND_BOTH)
    {
           stAttack2 = Combat_PerformAttack(oAttacker, oTarget, oWeapon2);

           if (stAttack1.nAttackResult != COMBAT_RESULT_DEATHBLOW &&  stAttack2.nAttackResult == COMBAT_RESULT_DEATHBLOW)
           {
                stAttack1 = stAttack2;
                nHand = HAND_MAIN; // Deathblows just use the main hand.
           }

    }

    // -------------------------------------------------------------------------
    // If we execute a deathblow, we gain the death fury effect for a couple of
    // seconds and apply the deathblow command
    // -------------------------------------------------------------------------
    if (stAttack1.nAttackResult == COMBAT_RESULT_DEATHBLOW)
    {

        // ----------------------------------------------------------------------
        // Georg: Do Not Modify the following section.
        // START >>
        // GM - Adding the deathblow should be the last thing done because it
        // will clear the attack command.
        // Specifically, SetAttackResult MUST be executed before adding the deathblow.
        // ----------------------------------------------------------------------
        SetAttackResult(oAttacker,  stAttack1.nAttackResult, stAttack1.eImpactEffect,
                                    COMBAT_RESULT_INVALID, Effect());


        WR_AddCommand(oAttacker, CommandDeathBlow(oTarget, stAttack1.nDeathblowType), TRUE, TRUE);

        return COMMAND_RESULT_SUCCESS;
        // ----------------------------------------------------------------------
        // << END
        // ----------------------------------------------------------------------
    }


    // -------------------------------------------------------------------------
    // SetAttackResult requires a result in either the first or second result
    // field to determine which hand should attack.
    // -------------------------------------------------------------------------
    if (nHand == HAND_MAIN || stAttack1.nAttackResult == COMBAT_RESULT_BACKSTAB)
    {
          SetAttackResult(oAttacker,  stAttack1.nAttackResult, stAttack1.eImpactEffect,
                                    COMBAT_RESULT_INVALID, Effect()  );

    }
    else if (nHand == HAND_OFFHAND)
    {
          SetAttackResult(oAttacker,  COMBAT_RESULT_INVALID, Effect(),
                                        stAttack1.nAttackResult, stAttack1.eImpactEffect );
    }
    else if (nHand == HAND_BOTH)
    {
         SetAttackResult(oAttacker,  stAttack1.nAttackResult, stAttack1.eImpactEffect,stAttack2.nAttackResult, stAttack2.eImpactEffect );
    }
    else
    {
          SetAttackResult(oAttacker,  stAttack1.nAttackResult, stAttack1.eImpactEffect,
                                    COMBAT_RESULT_INVALID, Effect()  );
    }


    if (stAttack1.fAttackDuration != ATTACK_LOOP_DURATION_INVALID)
    {

        if (IsHumanoid(oAttacker))
        {

            if(nAttackType == ATTACK_TYPE_RANGED)
            {
                // the "attack duration" for ranged weapons actually overrides
                // the time spent drawing and preparing to aim
                if ( GetBaseItemType(oWeapon) == BASE_ITEM_TYPE_STAFF )
                {
                    SetAttackDuration(oAttacker, 0.30);
                }
                else
                {
                    object oArmor =GetItemInEquipSlot(INVENTORY_SLOT_CHEST);
                    if ( !IsArmorMassive(oArmor) && HasAbility(oAttacker, ABILITY_TALENT_MASTER_ARCHER))
                    {
                        if(IsFollower(oAttacker))
                            SetAttackDuration(oAttacker, 0.8);
                        else
                            SetAttackDuration(oAttacker, 1.5);
                    }
                    else if (IsArmorHeavyOrMassive(oArmor) )
                    {
                         if(IsFollower(oAttacker))
                            SetAttackDuration(oAttacker, 2.0);
                        else
                            SetAttackDuration(oAttacker, 2.5);
                    }
                    else
                    {
                        if(IsFollower(oAttacker))
                            SetAttackDuration(oAttacker, 0.8);
                        else
                            SetAttackDuration(oAttacker, 1.5);
                    }
                }

                SetAimLoopDuration(oAttacker, stAttack1.fAttackDuration );

                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleCommandAttack","RangedAim Loop Duration set to " + FloatToString(stAttack1.fAttackDuration));
                #endif
            }
            else if (nAttackType == ATTACK_TYPE_MELEE) {
                if (nHand == HAND_BOTH && AF_IsOptionEnabled(AF_OPT_DUAL_STRIKING_TIMING))
                    SetAttackDuration(oAttacker,0.5*(stAttack1.fAttackDuration + stAttack2.fAttackDuration));
                else
                    SetAttackDuration(oAttacker,stAttack1.fAttackDuration);
            }
        }
    }


    return COMMAND_RESULT_SUCCESS;
}




/**
*  @brief Handles processing an attack impact event
*
*  @param oAttacker       The command owner, usually OBJECT_SELF
*  @param oTarget         The Target of the command
*  @param nAttackResult   The result of the attack (COMBAT_RESULT_*)
*  @param eImpactEffect   The attack's impact effect.
*
*  @returns COMBAT_RESULT_* constant
*
*  @author Georg Zoeller
**/
void Combat_HandleAttackImpact(object oAttacker, object oTarget, int nAttackResult, effect eImpactEffect);
void Combat_HandleAttackImpact(object oAttacker, object oTarget, int nAttackResult, effect eImpactEffect)
{

    int nUIMessage = UI_MESSAGE_MISSED;

    // -------------------------------------------------------------------------
    // We retired combat result blocked, so we treat it as a miss here.
    // Might be back in DA2
    // -------------------------------------------------------------------------
    if (nAttackResult == COMBAT_RESULT_BLOCKED)
    {
        nAttackResult = COMBAT_RESULT_MISS;
        nUIMessage = UI_MESSAGE_BLOCKED;
    }


    // -----------------------------------------------------------------
    // If the target managed to stealth, we're converting it into a miss
    // -----------------------------------------------------------------
    if (nAttackResult != COMBAT_RESULT_DEATHBLOW && nAttackResult != COMBAT_RESULT_MISS && IsInvisible(oTarget) )
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","Target turned invisible - hit converted to miss");
        #endif
        nAttackResult = COMBAT_RESULT_MISS;
    }


    if (nAttackResult != COMBAT_RESULT_MISS)
    {
        // -------------------------------------------------------------
        // Tell the damage effect to update gore and by how much...
        // see gore_h for details or ask georg.
        // -------------------------------------------------------------
        object oWeapon = GetEffectObject(eImpactEffect,0);
        int nApp = GetAppearanceType(oAttacker);
        int nAbility = GetEffectInteger(eImpactEffect,1);

        float fPerSpace = GetM2DAFloat(TABLE_APPEARANCE, "PERSPACE", nApp);
        // Skipping range check if the creature is large (personal space greater or equal to one)
        if (IsObjectValid(oWeapon) && IsUsingMeleeWeapon(oAttacker, oWeapon) && fPerSpace < 1.0)
        {
            if (GetDistanceBetween(oTarget, oAttacker) > 5.0f)
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","Melee attack impact from past 5m found, changed to COMBAT_RESULT_MISS");
                #endif
                nAttackResult = COMBAT_RESULT_MISS;
            }

        }


    // -----------------------------------------------------------------
    // The attack was successful, ...
    // -----------------------------------------------------------------
       float fDamage = GetEffectFloat(eImpactEffect,0);
       int nVfx = GetEffectInteger(eImpactEffect,0);
       int nDamageType = GetEffectInteger(eImpactEffect, 2);

        // special damage type override for Shale, filtered for performance reasons
        int nAppearanceType = GetAppearanceType(oAttacker);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","Attacker appearance type = " + ToString(nAppearanceType));
        #endif
        if (nAppearanceType == 10100) // new shale type
        {
            // check for damage type modifying effect
            effect[] eModifiers = GetEffects(oAttacker, 10000);
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","  Modifier effects present = " + ToString(GetArraySize(eModifiers)));
            #endif
            if (IsEffectValid(eModifiers[0]) == TRUE)
            {
                int nOverrideDamageType = GetEffectInteger(eModifiers[0], 0);
                nDamageType = nOverrideDamageType;

                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","  First modifier is valid with type " + ToString(nOverrideDamageType));
                #endif
            }
        }

        // -------------------------------------------------------------
        // If damage was negative, something went wrong and we bail out
        // -------------------------------------------------------------
        if(fDamage < 0.0f)
        {
            return;
        }



        int nGore;

        // ---------------------------------------------------------------------
        // Only melee weapons update gore.
        // ---------------------------------------------------------------------
        if (IsObjectValid(oWeapon))
        {
            if (GetItemType(oWeapon) == ITEM_TYPE_WEAPON_MELEE)
            {
                // -------------------------------------------------------------
                // Attacks that are not deathblows may play an attack grount.
                // -------------------------------------------------------------
                if (nAttackResult != COMBAT_RESULT_DEATHBLOW)
                {
                    SSPlaySituationalSound(oAttacker, SOUND_SITUATION_ATTACK_IMPACT);
                }

                // only update gore if the target can bleed (PeterT 25/7/08)
                int nTargetAppearance = GetAppearanceType(oTarget);
                if (GetM2DAInt(TABLE_APPEARANCE, "bCanBleed", nTargetAppearance) == TRUE)
                {
                    nGore =  DAMAGE_EFFECT_FLAG_UPDATE_GORE;
                }
            }
        }

        if ( nAttackResult == COMBAT_RESULT_CRITICALHIT)
        {

            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_CRITICALHIT");
            #endif

            // -----------------------------------------------------------------
            // Damage below a certain threshold is not displayed as critical
            // -----------------------------------------------------------------
            if (fDamage >= DAMAGE_CRITICAL_DISPLAY_THRESHOLD)
            {
                if (IsPartyMember(oAttacker))
                {
                        Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY,EffectScreenShake( SCREEN_SHAKE_TYPE_CRITICAL_HIT ),oTarget, 1.0f, oAttacker);
                }

                nGore |= DAMAGE_EFFECT_FLAG_CRITICAL;
            }


        }
        else if ( nAttackResult == COMBAT_RESULT_BACKSTAB)
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_BACKSTAB");
            #endif

             nGore |= DAMAGE_EFFECT_FLAG_BACKSTAB;
             nGore |= DAMAGE_EFFECT_FLAG_CRITICAL;
          //   UI_DisplayMessage(oAttacker, UI_MESSAGE_BACKSTAB);


        }
        else if (nAttackResult == COMBAT_RESULT_DEATHBLOW)
        {
              #ifdef DEBUG
              Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_DEATHBLOW");
              #endif

              nGore |= DAMAGE_EFFECT_FLAG_CRITICAL;

        }
        else
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_HIT");
            #endif

        }


        // ---------------------------------------------------------------------
        // Templar's Righteous Strike - 25% mana damage
        // ---------------------------------------------------------------------
        if (IsMagicUser(oTarget))
        {
            if (GetItemType(oWeapon) == ITEM_TYPE_WEAPON_MELEE)
            {
                if (HasAbility(oAttacker,ABILITY_TALENT_RIGHTEOUS_STRIKE))
                {
                     nGore |= DAMAGE_EFFECT_FLAG_LEECH_MANA;
                     nGore |= DAMAGE_EFFECT_FLAG_LEECH_25;


                     ApplyEffectVisualEffect(oAttacker, oTarget, 90181, EFFECT_DURATION_TYPE_INSTANT, 0.0f, ABILITY_TALENT_RIGHTEOUS_STRIKE);
                }
            }
        }

        // -------------------------------------------------------------
        //            Here is where the actual damage is dealt
        // -------------------------------------------------------------
        Effects_ApplyInstantEffectDamage(oTarget, oAttacker, fDamage, nDamageType, nGore,nAbility,nVfx);
        Combat_Damage_CheckOnImpactAbilities(oTarget, oAttacker, fDamage, nAttackResult, oWeapon, nAbility);
    }

    else  if (nAttackResult == COMBAT_RESULT_MISS)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_MISS");
        #endif

        UI_DisplayMessage(oAttacker, nUIMessage);

    }
    else  if (nAttackResult == COMBAT_RESULT_BLOCKED)
    {
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_COMBAT,"combat_h.HandleAttackImpact","COMBAT_RESULT_BLOCKED");
        #endif

        // Do something smart here in the future
        //        UI_DisplayMessage(oAttacker, UI_MESSAGE_MISSED);
    }

    // Stats - handle hit rate
    STATS_HandleHitRate(oAttacker, nAttackResult);
}

// GZ: Temporary function to prevent the world from collapsing upon itself

void Combat_HandleAbilityAttackImpact(object oAttacker, object oTarget, int nAttackResult, float fDamage);
void Combat_HandleAbilityAttackImpact(object oAttacker, object oTarget, int nAttackResult, float fDamage)
{

    effect eImpactEffect = EffectImpact(fDamage, OBJECT_INVALID);

    Combat_HandleAttackImpact(oAttacker, oTarget, nAttackResult, eImpactEffect);
}

// Handles any combat related logic for when a creature disappears from combat. This function should be run
// at 2 cases both for a player object and a creature object:
// 1. Disappear event
// 2. Appear event when the hostile creature turned non-hostile
void Combat_HandleCreatureDisappear(object oCreature, object oDisappearer)
{
    #ifdef DEBUG
    Log_Trace(LOG_CHANNEL_COMBAT,"Combat_HandleCreatureDisappeart","creature: " + GetTag(oCreature) + ", disappearer: " + GetTag(oDisappearer));
    #endif

    if(IsFollower(oCreature))
    {
        AI_Threat_UpdateEnemyDisappeared(oCreature, oDisappearer);

        // ----------------------------------------------------------------------
        // If the party does no longer perceive any hostiles....
        // ----------------------------------------------------------------------
        if (!IsPartyPerceivingHostiles(oCreature))
        {

            if (!IsPartyDead())
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_COMBAT, "Combat_HandleCreatureDisappear", "STOPPING COMBAT FOR PARTY!");
                #endif

                SSPlaySituationalSound(GetRandomPartyMember(),SOUND_SITUATION_END_OF_COMBAT);

                DelayEvent(3.0f, GetModule(), Event(EVENT_TYPE_DELAYED_GM_CHANGE));
            }
        }
    }
    else // non party members
    {
        AI_Threat_UpdateEnemyDisappeared(oCreature, oDisappearer);
        if (!IsPerceivingHostiles(oCreature) && GetCombatState(oCreature) == TRUE)
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_COMBAT, "Combat_HandleCreatureDisappear", "STOPPING COMBAT FOR NORMAL CREATURE!");
            #endif
            SetCombatState(oCreature,FALSE);

            // Added to make a COMBAT_END event
            // FAB 9/4
            event evCombatEnds = Event(EVENT_TYPE_COMBAT_END);
            //evCombatEnds = SetEventInteger(evCombatEnds, 0, bcombatstate);
            SignalEvent(oCreature, evCombatEnds);
        }
    }
}

int IsCombatHit(int nAttackResult)
{
    if (nAttackResult == COMBAT_RESULT_MISS || nAttackResult == COMBAT_RESULT_BLOCKED || nAttackResult == COMBAT_RESULT_INVALID)
    {
        return FALSE;
    } else
    {
        return TRUE;
    }
}