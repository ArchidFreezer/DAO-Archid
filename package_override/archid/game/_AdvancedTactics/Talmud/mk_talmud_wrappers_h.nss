#include "talmud_storage_h"

/** @brief EXAMPLE: Storage_SetArraySize("MyStoredParty", STORAGE_ARRAY_OBJECT, 0);
*
* Set the size of a stored array, use with caution. Array size grows dynamically, so this is mostly useful when you want to overwrite an existing array with new values.
* This does not free memory; use Storage_PurgeCache for that.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStorageArrayType - The type of array to set the size of.
* @param nSize - The new size of the array.
* @author Talmud
**/
void _MK_Storage_SetArraySize(string sArrayName, int nStorageArrayType, int nSize)
{
    string sCacheType = nStorageArrayType == STORAGE_ARRAY_LOCATION ? STORAGE_CACHE_TYPE_LOCATION_ARRAY : STORAGE_CACHE_TYPE_ARRAY;
    effect eArray = _TalGetStorageEffect(sCacheType + sArrayName);
    eArray = SetEffectInteger(eArray, nStorageArrayType, nSize);
    //--------
    //MkBot Talmud Bug Fix: In Storage_SetArraySize sTag is not generated properly
    //  There is:
    //        _TalSetStorageEffect(sArrayName, eArray);
    //  Should be:
    //        _TalSetStorageEffect(sCacheType + sArrayName, eArray);
    //-------- 
    _TalSetStorageEffect(sCacheType + sArrayName, eArray);    
    //_TalSetStorageEffect(sArrayName, eArray);
}