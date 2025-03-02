#ifndef MK_GET_X_ENEMIES_AT_PARTY_RADIUS_H
#defsym MK_GET_X_ENEMIES_AT_PARTY_RADIUS_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Advanced Tactics */
#include "at_tools_conditions_h"   

/* MkBot */
#include "mk_constants_h"
#include "mk_get_creatures_h"
#include "mk_condition_ai_status_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
object[] _MK_GetXEnemiesAtPartyRadius(int nNumOfTargets, int nIncludeSummoned, float fRadius, int nExcludeSleepRoot = TRUE);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
object[] _MK_GetXEnemiesAtPartyRadius(int nNumOfTargets, int nIncludeSummoned, float fRadius, int nExcludeSleepRoot)
{
    float fStart = 0.0f;
    float fEnd = 360.0f;
    int nCheckLiving = TRUE;

    object[] arRet;
    int nRetCount = 0;

    object[] arPartyMembers = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
    int arPartySize = GetArraySize(arPartyMembers);

    object[] arTargets = _AT_AI_GetEnemies();
    int nTargetsSize = GetArraySize(arTargets);

    int i;
    for(i=0; i<nTargetsSize; i++)
    {
        if( nRetCount >= nNumOfTargets )
            break;

        //MkBot: Validity Check
        if( _AT_AI_IsEnemyValid(arTargets[i]) == FALSE )
            continue;

        //MkBot: Sleep/Root Check
        if( nExcludeSleepRoot == TRUE && MK_IsSleepRoot(arTargets[i]) == TRUE )
            continue;

        //MkBot: Range Check
        int j;
        for(j=0; j<arPartySize; j++)
        {
            if( IsSummoned(arPartyMembers[j]) == TRUE )
                continue;

            float fDist = GetDistanceBetween(arTargets[i], arPartyMembers[j]);
            if( fDist <= MK_RANGE_MEDIUM )
            {
                arRet[nRetCount++] = arTargets[i];
                break;
            }
        }
    }

    return arRet;
/*
    //Check yourself first
    object[] arTargets = _MK_AI_GetEnemies(OBJECT_SELF);
    int nSize = GetArraySize(arTargets);
    //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Myself" + " Enemies = " + IntToString(nSize) );

    int i;
    for (i = 0; i < nSize; i++)
    {
        //MkBot: Validity Check
        if( _AT_AI_IsEnemyValid(arTargets[i]) == FALSE )
            continue;

        //MkBot: Sleep/Root Check
        if( nExcludeSleepRoot )
        {
            int nIsNewSleepingOrPinned = _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_ROOT) || _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_SLEEP);
            if( nIsNewSleepingOrPinned == TRUE )
                continue;
        }

        //MkBot: Range Check
        if( GetDistanceBetween(OBJECT_SELF, arTargets[i]) > fRadius )
            continue;

        //MkBot: Passed all tests
        arRet[nEnemiesCount] = arTargets[i];
        nEnemiesCount++;
        if( nEnemiesCount >= nNumOfTargets )
            return arRet;
    }


//Check rest of the party
    object[] arAllies = _AT_AI_GetAlliesInParty();
    int arAlliesSize = GetArraySize(arAllies);

    int allyId;
    for( allyId = 0; allyId < arAlliesSize; allyId++ )
    {
        if( IsSummoned(arAllies[allyId]) && nIncludeSummoned == FALSE )
            continue;

        arTargets = _MK_AI_GetEnemies(arAllies[allyId]);
        int nSize = GetArraySize(arTargets);

        int i;
        for (i = 0; i < nSize; i++)
        {
            //MkBot: Validity Check
            if( _AT_AI_IsEnemyValid(arTargets[i]) == FALSE )
                continue;

            //MkBot: Sleep/Root Check
            if( nExcludeSleepRoot )
            {
                int nIsNewSleepingOrPinned = _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_ROOT) || _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_SLEEP);
                if( nIsNewSleepingOrPinned == TRUE )
                    continue;
            }

            //MkBot: Range Check
            if( GetDistanceBetween(arAllies[allyId], arTargets[i]) > fRadius )
                continue;

            //MkBot: Passed all tests
            arRet[nEnemiesCount] = arTargets[i];
            nEnemiesCount++;
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Passed all tests nEnemiesCount = " + IntToString(nEnemiesCount) );
            if( nEnemiesCount >= nNumOfTargets )
                return arRet;

        }
    }

    return arRet;
*/

/*
    float fStart = 0.0f;
    float fEnd = 360.0f;
    int nCheckLiving = TRUE;

    object[] arAllies = _AT_AI_GetAlliesInParty(TRUE, FALSE, TRUE);
    int arAlliesSize = GetArraySize(arAllies);

    object[] arRet;
    int nEnemiesCount = 0;

    //Check yourself first
//Get all living creatures within sphere centered at given ally
    object oCenter = OBJECT_SELF;
    object[] arTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oCenter), fRadius, 0.0f, 0.0f, nCheckLiving);
    int nSize = GetArraySize(arTargets);
    //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Myself" + " Enemies = " + IntToString(nSize) );

    int i;
    for (i = 0; i < nSize; i++)
    {
        //MkBot: is it necessery? Hostility Check should do the work
        if ( arTargets[i] == oCenter )
            continue;
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " arTargets[i] == oCenter: OK");

        //MkBot: Hostility Check
        if( IsObjectHostile(oCenter, arTargets[i]) == FALSE )
            continue;
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Hostility Check: OK");

        //MkBot: Validity Check
        if( _AT_AI_IsEnemyValid(arTargets[i]) == FALSE )
            continue;
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Validity Check: OK");

        //MkBot: Sleep/Root Check
        if( nExcludeSleepRoot )
        {
            int nIsNewSleepingOrPinned = _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_ROOT) || _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_SLEEP);
            if( nIsNewSleepingOrPinned == TRUE )
                continue;
        }
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Sleep/Root Check: OK");

        //MkBot: Passed all tests
        arRet[nEnemiesCount] = arTargets[i];
        nEnemiesCount++;
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Passed all tests nEnemiesCount = " + IntToString(nEnemiesCount) );
        if( nEnemiesCount >= nNumOfTargets )
            return arRet;
    }


//Check rest of the party
    int allyId;
    for( allyId = 0; allyId < arAlliesSize; allyId++ )
    {
        if( IsSummoned(arAllies[allyId]) && nIncludeSummoned == FALSE )
            continue;
        if( arAllies[allyId] == OBJECT_SELF )
            continue;

        //Get all living creatures within sphere centered at given ally
        object oCenter = arAllies[allyId];
        object[] arTargets = GetObjectsInShape(OBJECT_TYPE_CREATURE, SHAPE_SPHERE, GetLocation(oCenter), fRadius, 0.0f, 0.0f, nCheckLiving);
        int nSize = GetArraySize(arTargets);
        //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Enemies = " + IntToString(nSize) );

        int i;
        for (i = 0; i < nSize; i++)
        {
            //MkBot: is it necessery? Hostility Check should do the work
            if ( arTargets[i] == oCenter )
                continue;
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " arTargets[i] == oCenter: OK");

            //MkBot: Hostility Check
            if( IsObjectHostile(oCenter, arTargets[i]) == FALSE )
                continue;
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Hostility Check: OK");

            //MkBot: Validity Check
            if( _AT_AI_IsEnemyValid(arTargets[i]) == FALSE )
                continue;
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Validity Check: OK");

            //MkBot: Sleep/Root Check
            if( nExcludeSleepRoot )
            {
                int nIsNewSleepingOrPinned = _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_ROOT) || _AT_AI_HasAIStatus(arTargets[i], AI_STATUS_SLEEP);
                if( nIsNewSleepingOrPinned == TRUE )
                    continue;
            }
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Ally_" + IntToString(allyId) + " Sleep/Root Check: OK");

            //MkBot: Passed all tests
            arRet[nEnemiesCount] = arTargets[i];
            nEnemiesCount++;
            //PrintToLog(MK_LogCreatureId(OBJECT_SELF) + " - _MK_GetXEnemiesAtPartyRadius: Passed all tests nEnemiesCount = " + IntToString(nEnemiesCount) );
            if( nEnemiesCount >= nNumOfTargets )
                return arRet;

        }
    }

    return arRet;
*/
}
#endif