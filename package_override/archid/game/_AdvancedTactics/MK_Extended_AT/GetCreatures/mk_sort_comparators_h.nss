#ifndef MK_SORT_COMPARATORS_H
#defsym MK_SORT_COMPARATORS_H     

//==============================================================================
//                          INCLUDES
//==============================================================================
#include "core_h"                                                             
#include "mk_logger_h"
 
//==============================================================================
//                          CONSTANTS
//==============================================================================  
const int MK_SORTBY_HIGHEST_DISTANCE      = 1;
const int MK_SORTBY_LOWEST_DISTANCE       = 2;
const int MK_SORTBY_HIGHEST_HEALTH        = 3;
const int MK_SORTBY_LOWEST_HEALTH         = 4;
const int MK_SORTBY_HIGHEST_RANK          = 5;
const int MK_SORTBY_LOWEST_RANK           = 6;
const int MK_SORTBY_HIGHEST_ARMOR         = 7;
const int MK_SORTBY_LOWEST_ARMOR          = 8;
const int MK_SORTBY_HIGHEST_MANA_STAMINA  = 9;
const int MK_SORTBY_LOWEST_MANA_STAMINA   = 10;       

//==============================================================================
//                          DECLARATIONS
//==============================================================================
int CompareCreaturesByManyProperties(object oCreature1, object oCreature2, int[] arSortIds);
int CompareCreaturesBySingleProperty(object oCreature1, object oCreature2, int nSortId);
int RevertCompare(int nCompare);     

int CompareDistance(object oCreature1, object oCreature2);
int CompareHealth(object oCreature1, object oCreature2);
int CompareManaStamina(object oCreature1, object oCreature2);
int CompareRank(object oCreature1, object oCreature2);
int CompareArmor(object oCreature1, object oCreature2);

//==============================================================================
//                      DEFINITIONS : SortBy Comparators
//==============================================================================

/** @brief
* This is auxiliary function for choosing target using multiple conditions.
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareCreaturesByManyProperties(object oCreature1, object oCreature2, int[] arSortIds)
{
    int i;
    int nSize = GetArraySize(arSortIds);
    int nCompare = COMPARE_RESULT_EQUAL;

    for (i = 0; i < nSize; i++)
    {
        nCompare = CompareCreaturesBySingleProperty(oCreature1, oCreature2, arSortIds[i]);
        if (nCompare != COMPARE_RESULT_EQUAL)
            break;
    }

    return nCompare;
}

/** @brief
* This is auxiliary function for choosing target using multiple conditions.
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareCreaturesBySingleProperty(object oCreature1, object oCreature2, int nSortId)
{
    switch(nSortId)
    { 
        case MK_SORTBY_HIGHEST_DISTANCE:
            return CompareDistance(oCreature1, oCreature2);
        case MK_SORTBY_LOWEST_DISTANCE: 
            return RevertCompare(CompareDistance(oCreature1, oCreature2));
        case MK_SORTBY_HIGHEST_HEALTH:
            return CompareHealth(oCreature1, oCreature2);
        case MK_SORTBY_LOWEST_HEALTH:
            return RevertCompare(CompareHealth(oCreature1, oCreature2));
        case MK_SORTBY_HIGHEST_RANK:
            return CompareRank(oCreature1, oCreature2);
        case MK_SORTBY_LOWEST_RANK:
            return RevertCompare(CompareRank(oCreature1, oCreature2));
        case MK_SORTBY_HIGHEST_ARMOR:
            return CompareArmor(oCreature1, oCreature2);
        case MK_SORTBY_LOWEST_ARMOR:
            return RevertCompare(CompareArmor(oCreature1, oCreature2));
        case MK_SORTBY_HIGHEST_MANA_STAMINA:
            return CompareManaStamina(oCreature1, oCreature2);
        case MK_SORTBY_LOWEST_MANA_STAMINA:
            return RevertCompare(CompareManaStamina(oCreature1, oCreature2));
        default:
        {
            string sMsg = "[CompareCreaturesBySingleProperty] ERROR: Unknown Sort Type Id= " + IntToString(nSortId);
            MK_Logger(sMsg, MK_LOG_LEVEL_FATAL);
            return COMPARE_RESULT_EQUAL;
        }
    }

    return COMPARE_RESULT_EQUAL;
}

/** @brief Reverts compare result.
*
* @returns - nCompare == COMPARE_RESULT_LOWER  : COMPARE_RESULT_HIGHER
*          - nCompare == COMPARE_RESULT_EQUAL  : COMPARE_RESULT_EQUAL
*          - nCompare == COMPARE_RESULT_HIGHER : COMPARE_RESULT_LOWER
*/
int RevertCompare(int nCompareResult)
{
    if (nCompareResult == COMPARE_RESULT_LOWER)
        return COMPARE_RESULT_HIGHER;
    else if (nCompareResult == COMPARE_RESULT_HIGHER)
        return COMPARE_RESULT_LOWER;
    else
        return COMPARE_RESULT_EQUAL;
}
   
/** @brief Compares proximity to OBJECT_SELF
*
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareDistance(object oCreature1, object oCreature2)
{
    float dist1 = GetDistanceBetween(OBJECT_SELF, oCreature1);
    float dist2 = GetDistanceBetween(OBJECT_SELF, oCreature2);
    return CompareFloat(dist1, dist2);
}

/** @brief Compares creatures health
*
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareHealth(object oCreature1, object oCreature2)
{
    int health1 = GetHealth(oCreature1);
    int health2 = GetHealth(oCreature2);
    return CompareInt(health1, health2);
}

/** @brief Compares creatures mana/stamin
*
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareManaStamina(object oCreature1, object oCreature2)
{
    float manaStamina1 = GetCreatureProperty(oCreature1, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_CURRENT);
    float manaStamina2 = GetCreatureProperty(oCreature2, PROPERTY_DEPLETABLE_MANA_STAMINA, PROPERTY_VALUE_CURRENT);
    return CompareFloat(manaStamina1, manaStamina2);
}

/** @brief Compares creatures rank
*
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareRank(object oCreature1, object oCreature2)
{
    int rank1 = GetCreatureRank(oCreature1);
    int rank2 = GetCreatureRank(oCreature2);
    return CompareInt(rank1, rank2);
}

/** @brief Compares creatures armor
*
* @returns - oCreature1 >  oCreature2 : COMPARE_RESULT_HIGHER
*          - oCreature1 == oCreature2 : COMPARE_RESULT_EQUAL
*          - oCreature1 <  oCreature2 : COMPARE_RESULT_LOWER
*/
int CompareArmor(object oCreature1, object oCreature2)
{
    float fArmor1 = GetCreatureProperty(oCreature1, PROPERTY_ATTRIBUTE_ARMOR);
    float fArmor2 = GetCreatureProperty(oCreature2, PROPERTY_ATTRIBUTE_ARMOR);
    return CompareFloat(fArmor1, fArmor2);
}
  
//void main(){}
#endif
                  