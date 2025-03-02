#ifndef TIN_CLUSTER_H
#defsym TIN_CLUSTER_H 

//==============================================================================
//                                MkBot: Fixes
//==============================================================================
//  1) Added _AT_AI_IsTargetValidForAbility check


//==============================================================================
/* Improved Potions Mod by Tinman
   cluster_h.nss
//==============================================================================

This header file contains a rewritten version of the GetEnemyClusteredWithSameGroup
function, based on the advanced tactics version. I always had trouble getting
the "Enemy Clustered with X Allies" condition to work, and saw alot of complaints
about it in comments on mod forums, so I decided to fix it.

The function goes through the 20 closest enemies and returns the nearest enemy
target that has at least nClusterSize # of enemies within the radius of the aoe
ability being used. It returns OBJECT_INVALID if no enemy can be found that matches
the criteria.

The size limit of the cluster varies depending on the ability's radius of effect.

AOE talent/spell area sizes (per vanilla abi_base.gda)
===========================
scattershot     15m radius
rock barrage    10m radius
fireball        7.5m radius
cone of cold    projects 10m in a 35 degree area in front of caster (width at furthest point ~7m)
flame blast     projects 10m in a 35 degree area in front of caster (width at furthest point ~7m)
shock           projects 10m in a 35 degree area in front of caster (width at furthest point ~7m)
mana cleanse    10m radius
mana clash      10m radius
mass paralysis  10m radius
sleep           10m radius
Death cloud     10m radius
Blood wound     10m radius
default         10m radius

Special handling is done for cones. I assume that the enemy target will be near
the center of the outer edge of the cone, so the cluster (if any) must be in a
radius around that enemy equal to about 1/2 the width of the outer edge of the
cone to stay within the AOE.
*/

#include "core_h" 
#include "at_tools_conditions_h"

object[] tin_GetClusterCenter(object oCreator,        // The creature who's tactic is being processed
                              int nAbilityId,         // The ability ID
                              int nClusterSize,       // The minimum # of enemies in the cluster, including the target
                              int nAllyFailChance,    // The probability of failing the condition if an ally is in the cluster area
                              int bReturnFirstMatch)  // This parameter is ignored in my function
{
    float fRadius;
    int shape; // 0 = sphere, 1 = cone

    switch(nAbilityId)
    {
        case ABILITY_TALENT_SCATTERSHOT:
        {   fRadius = 15.0f;
            shape = 0; }
        case 300303: // Shale's Rock Barrage
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_FIREBALL:
        {   fRadius = 7.5f;
            shape = 0; }
        case ABILITY_SPELL_CONE_OF_COLD:
        {   fRadius = 3.0f;
            shape = 1; } // Radius used is ~1/2 the width of the cone at its widest point
        case ABILITY_SPELL_FLAME_BLAST:
        {   fRadius = 3.0f;
            shape = 1; } // Radius used is ~1/2 the width of the cone at its widest point
        case ABILITY_SPELL_SHOCK:
        {   fRadius = 3.0f;
            shape = 1; } // Radius used is ~1/2 the width of the cone at its widest point
        case ABILITY_SPELL_MANA_CLEANSE:
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_MANA_CLASH:
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_MASS_PARALYSIS:
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_SLEEP:
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_DEATH_CLOUD:
        {   fRadius = 10.0f;
            shape = 0; }
        case ABILITY_SPELL_BLOOD_WOUND:
        {   fRadius = 10.0f;
            shape = 0; }
        default : // default aoe radius and shape
        {   fRadius = 10.0f;
            shape = 0; }
    }

    object [] oEnemies;
    object [] oCreatures;
    object [] oTarget;
    oTarget[0] = OBJECT_INVALID;
    oEnemies = GetNearestObjectByHostility(/*Point of reference*/ oCreator,
                                           /*Hostile to oCreator?*/ TRUE,
                                           /*Type of object?*/ OBJECT_TYPE_CREATURE,
                                           /*Max # of objects to return*/ 20,
                                           /*Objects living?*/ TRUE,
                                           /*Objects perceived?*/ TRUE,
                                           /*Include oCreator?*/ FALSE);

    int nSize = GetArraySize(oEnemies);
    int nSize2;
    int i;
    int j;
    int k;
    int l;
    for(i = 0; i < nSize && oTarget[0] == OBJECT_INVALID; i++)
    {
        oCreatures = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oEnemies[i]), fRadius, 0.0f, 0.0f, TRUE);

        k = 0; // use to keep track of # of allies in aoe area
        l = 0; // use to keep track of # of valid enemies in aoe area
        nSize2 = GetArraySize(oCreatures);
        for(j = 0; j < nSize2 && k == 0; j++)
        {
            if(IsFollower(oCreatures[j]))
                k++;
            else if(IsObjectHostile(oCreator, oCreatures[j]) && 
                    !IsDeadOrDying(oCreatures[j]) &&
                    _AT_AI_IsTargetValidForAbility(oCreatures[j], COMMAND_TYPE_USE_ABILITY, nAbilityId))
                l++;
        }

        // Ally fail chance is only checked once if allies are present, the # of allies doesn't matter
        if(k > 0 && RandomFloat()*100.0f <= IntToFloat(nAllyFailChance))
            oTarget[0] == OBJECT_INVALID;
        else if(l >= nClusterSize)
            oTarget[0] = oEnemies[i];
    }

    return oTarget;
}

#endif
