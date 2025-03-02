#ifndef MK_TEST_FRAMEWORK_SETUP_ENEMIES_H
#defsym MK_TEST_FRAMEWORK_SETUP_ENEMIES_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "mk_tf_locations_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
object TF_CreatePassiveEnemy(float fDist);
void TF_RemoveAllEnemies();
void TF_RefreshPartyPerception();

//==============================================================================
//                              DEFINITIONS
//==============================================================================
//******************************************************************************
object TF_CreatePassiveEnemy(float fDist)
{
    location EnemyToBeLocation = TF_GetLocAtDistance(fDist);  
    return CreateObject(OBJECT_TYPE_CREATURE, R"werewolf_core.utc", EnemyToBeLocation, "empty_ai");
}

//******************************************************************************
void TF_RemoveAllEnemies()
{
    object[] arEnemies = GetNearestObjectByHostility(GetHero(), TRUE, OBJECT_TYPE_CREATURE, 100, FALSE, FALSE);
    int nSize = GetArraySize(arEnemies);
    int i;
    for (i = 0; i < nSize; i++)
    {
     DestroyObject(arEnemies[i]);
    }    
}                                                                               

//******************************************************************************
void TF_RefreshPartyPerception()
{
    object[] arFollowers = GetPartyPoolList();
    object[] arEnemies = GetNearestObjectByHostility(GetHero(), TRUE, OBJECT_TYPE_CREATURE, 100, FALSE, FALSE);
    
    int iFollower, iEnemy;
    int nFollowersSize = GetArraySize(arFollowers);
    int nEnemiesSize = GetArraySize(arEnemies);
    
    for (iEnemy = 0 ; iEnemy < nEnemiesSize; iEnemy++)
    {
        for (iFollower = 0; iFollower < nFollowersSize; iFollower++)
        {
            TriggerPerception(arFollowers[iFollower], arEnemies[iEnemy]);
        }        
    }
}

//******************************************************************************
//void main(){CreatePassiveEnemy(1.0);RefreshPartyPerception();}

#endif
