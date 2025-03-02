#ifndef MK_SORT_CREATURES_H
#defsym MK_SORT_CREATURES_H

//==============================================================================
//                          INCLUDES
//==============================================================================
#include "mk_sort_comparators_h" 

//==============================================================================
//                          DECLARATIONS
//==============================================================================   

/** @brief Sorts creatures using insert-sort algorithm
*
* Creatures are sorted by list of properties provided in arSortId array
* i.e. Sort By arSortId[0] then by arSortId[1] then by arSortId[2] etc.
*
* See MK_SORTBY_ constants for list of valid values of arSortId array.
* Information whether sort in Ascending or Descending order is embeded in
* MK_SORTBY_ constants.

* If some elements at the beginning of arCreatures array are already sorted then
* use nStartIndex parameter to skip them.
* e.g. If first element (index = 0) of arCreature is sorted then set nStartIndex = 1
*
* Sorting is done in place ie. arCreatures array is modified.
*
* *NOTE* In Dragon Age Toolset arrays are passed to functions by reference so
* they can be used as output parameters.
*
*/
void InsertSort(object[] arCreatures, int[] arSortByIds, int nStartIndex)
{
    int i;
    int nSize = GetArraySize(arCreatures);

    for (i = nStartIndex + 1; i < nSize; i++)
    {
        int j = i; // 0...i-1 are already sorted
        object temp = arCreatures[j];
        while ((j > nStartIndex) && (CompareCreaturesByManyProperties(arCreatures[j-1], temp, arSortByIds) == COMPARE_RESULT_LOWER))
        {
            arCreatures[j] = arCreatures[j-1];
            j--;
        }
        arCreatures[j] = temp;
    }
}                          

//void main(){}
#endif
