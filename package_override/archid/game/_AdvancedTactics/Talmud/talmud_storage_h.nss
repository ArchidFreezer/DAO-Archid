/*

INSTRUCTIONS:
1. Add a call to Storage_HandleModuleEvents to the beginning of your module script.

The start of your module script should look like this:

    // ... any other include files
    #include "talmud_storage_h"

    void main()
    {
        Storage_HandleModuleEvents();
        //... The rest of the module script

    }

2. Add #include "talmud_storage_h" to the top of any script you want to use storage from.

3. Use the storage functions. All functions are accessible by filtering for "store", "fetch", or "storage" in the
function filter in the upper right of the script editor.

NOTE: if you change the stage area to be different from "char_stage" make sure you update TAL_STORAGE_AREA_TAG to the resource name of the new area.

*/


#include "core_h"  
#include "mk_storage_h"

/**** CONFIG ****/
const string TAL_STORAGE_AREA_TAG = "char_stage"; //TODO: Update this tag if you change stage areas.

// Customize TAL_STORAGE_CACHE_TAG if you want to use a different cache from everyone else.
const string TAL_STORAGE_CACHE_TAG = "t2lmud_storage_cach3";
/**** END CONFIG ****/



// Uncomment this and recompile your scripts to enable debug info.
//#defsym TALMUD_STORAGE_DEBUG_USER



const string TAL_STORAGE_ITEM_CACHE_TAG = "t2lmud_cach3_1t3m";
const string TAL_STORAGE_ITEM_TAG = "t2lmud_storage_it3m";

const string TAL_STORAGE_OBJECT_VAR = ITEM_COUNTER_1;
const string TAL_STORAGE_FACTOR_VAR = ITEM_COUNTER_2;
const string TAL_STORAGE_CACHE_OBJECT_VAR = PLC_COUNTER_1;
const string TAL_STORAGE_CACHE_FACTOR_VAR = PLC_COUNTER_2;

const resource TAL_STORAGE_CACHE_RESOURCE = R"genip_invisible_wide.utp";
const resource TAL_STORAGE_ITEM_RESOURCE = R"gen_im_treas_silvchal.uti";

const int TAL_STORAGE_MAXIMUM_LOAD_FACTOR = 8000;

const string TAL_STORAGE_HASH = "@%";


const int TAL_EFFECT_TYPE_STORAGE = 1; //generic effect - doesn't proc EVENT_TYPE_APPLY_EFFECT

const int TAL_MASS_STORAGE_STRING_POS_CACHE = 0;
const int TAL_MASS_STORAGE_INT_POS_LOAD = 0;
const int TAL_STORAGE_ARRAY_START_POSITION = 6;

const int STORAGE_ARRAY_INTEGER = 0;
const int STORAGE_ARRAY_FLOAT = 1;
const int STORAGE_ARRAY_STRING = 2;
const int STORAGE_ARRAY_OBJECT = 3;
const int STORAGE_ARRAY_LOCATION = 4;

const string STORAGE_CACHE_TYPE_STANDARD = "t2l7";
const string STORAGE_CACHE_TYPE_ARRAY = "t2l5";
const string STORAGE_CACHE_TYPE_LOCATION = "t214";
const string STORAGE_CACHE_TYPE_LOCATION_ARRAY = "t213";

const int STORAGE_APPEND_TO_ARRAY = -1;
const int STORAGE_END_OF_ARRAY = -1;




// internal debugging parameters
//#defsym TALMUD_STORAGE_DEBUG_INTERNAL
//#defsym TALMUD_STORAGE_DEBUG_INTERNAL_LOOPING





/** @brief Internal sorting function for storage objects. Modified gnome sort.
* @author Talmud
**/

object[] _TalStorage_SortStorageObjects(object[] arObjects);
/** @brief Returns the main storage object or one of the additional storage objects.
*
* Internal function for the storage system.
*
* @author Talmud
**/

object _TalGetStorageCache(int nStorageCache = 0);
/** @brief Returns a valid storage effect associated with an item.
*
* Internal function for the storage system.
*
* @param sTag - The tag of the storage item.
* @author Talmud
**/

effect _TalGetStorageEffect(string sTag);
/** @brief Set an effect on the storage object associated with an item.
*
* Internal function for the storage system.
*
* @author Talmud
**/

void _TalSetStorageEffect(string sTag, effect eFect, int nLoadFactor = 0);
/** @brief Internal maintenance function for the storage system.
*
*  Called on EVENT_TYPE_MODULE_PRESAVE to move all storage objects to the player's area so they will be saved.
*
* @author Talmud
**/
void  _TalStorage_ModulePresave();


/** @brief Internal maintenance function for the storage system.
*
*  Called on EVENT_TYPE_MODULE_LOAD and EVENT_TYPE_GAMEMODE_CHANGE to move all storage objects from the player's area to the stage for safekeeping.
*
* @author Talmud
**/
void _TalStorage_ModuleLoad();

/** @brief Put this on the first line in the void main() of your module script.
*
*  Allows storage persistence. Without this function the storage objects are not saved with the game.
*
* @param : The start of your module script should look like this:
* @param : #include "talmud_storage_h"
* @param : void main()
* @param : {
* @param :     Storage_HandleModuleEvents();
* @param : //... The rest of the module script
* @author Talmud
**/
void Storage_HandleModuleEvents();

/** @brief EXAMPLE: int nFollowersToAdd = Storage_GetArraySize("MyStoredParty", STORAGE_ARRAY_OBJECT);
*
* Get the size of a stored array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStorageArrayType - The type of array to check the size of.
* @author Talmud
**/
int Storage_GetArraySize(string sArrayName, int nStorageArrayType = STORAGE_ARRAY_INTEGER);

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
void Storage_SetArraySize(string sArrayName, int nStorageArrayType, int nSize);

/** @brief EXAMPLE: Storage_PurgeCache("MyStoredParty");
*
* Clears the cache of sCacheType with sName, freeing memory.
* STORAGE_CACHE_TYPE_STANDARD is for integers, floats, strings and objects; STORAGE_CACHE_TYPE_LOCATION is for locations and vectors;
* STORAGE_CACHE_TYPE_ARRAY is for arrays of integers, floats, strings and objects; and STORAGE_CACHE_TYPE_ARRAY_LOCATION is for arrays of locations.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sCacheType - The type of cache to purge.
* @author Talmud
**/
void Storage_PurgeCache(string sName, string sCacheType = STORAGE_CACHE_TYPE_STANDARD);

/** @brief EXAMPLE: StoreLocationInArray("SpawnPoints", lNewLocation, STORAGE_APPEND_TO_ARRAY);
*
* Store a location at position nSlot in the array with sArrayName.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param lValue - The location to store.
* @param nSlot - The array slot in which to store the variable.
* @author Talmud
**/
void StoreLocationInArray(string sArrayName, location lValue, int nSlot = STORAGE_APPEND_TO_ARRAY);

/** @brief EXAMPLE: location lSpawn = FetchLocationFromArray("SpawnPoints", 3);
*
* Returns the location stored at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the
* variable at the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nSlot - The array slot from which to fetch the variable.
* @author Talmud
**/
location FetchLocationFromArray(string sArrayName, int nSlot);

/** @brief EXAMPLE: StoreIntegerInArray("MostKillsPerRound", nCurrentKills, STORAGE_APPEND_TO_ARRAY);
*
* Store an integer at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at the
* end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nValue - The integer to store.
* @param nSlot - The array slot in which to store the variable.
* @author Talmud
**/
void StoreIntegerInArray(string sArrayName, int nValue, int nSlot = STORAGE_APPEND_TO_ARRAY);

/** @brief EXAMPLE: int nArenaKills = FetchIntegerFromArray("MostKillsPerRound", 4);
*
* Returns the integer stored at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nSlot - The array slot from which to fetch the variable.
* @author Talmud
**/
int FetchIntFromArray(string sArrayName, int nSlot);

/** @brief EXAMPLE: StoreFloatInArray("DamageToDealPerRound", 15.0, 2);
*
* Store a float at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param fValue - The float to store.
* @param nSlot - The array slot in which to store the variable.
* @author Talmud
**/
void StoreFloatInArray(string sArrayName, float fValue, int nSlot = STORAGE_APPEND_TO_ARRAY);

/** @brief EXAMPLE: float fDamageToDeal = FetchFloatFromArray("DamageToDealPerRound", 3);
*
* Returns the float stored at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at
* the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nSlot - The array slot from which to fetch the variable.

* @author Talmud
**/
float FetchFloatFromArray(string sArrayName, int nSlot);

/** @brief EXAMPLE: StoreStringInArray("AlistairInventory", sWeaponTag, INVENTORY_SLOT_MAIN);
*
* Store a string at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sValue - The string to store.
* @param nSlot - The array slot in which to store the variable.
* @author Talmud
**/
void StoreStringInArray(string sArrayName, string sValue, int nSlot = STORAGE_APPEND_TO_ARRAY);

/** @brief EXAMPLE: string sWeaponTag = FetchStringFromArray("AlistairInventory", INVENTORY_SLOT_MAIN);
*
* Returns the string stored at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at
* the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nSlot - The array slot from which to fetch the variable.
* @author Talmud
**/
string FetchStringFromArray(string sArrayName, int nSlot);

/** @brief EXAMPLE: StoreObjectInArray("AlistairInventory", oShield, INVENTORY_SLOT_OFF);
*
* Store a object at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param oValue - The object to store.
* @param nSlot - The array slot in which to store the variable.
* @author Talmud
**/
void StoreObjectInArray(string sArrayName, object oValue, int nSlot = STORAGE_APPEND_TO_ARRAY);

/** @brief EXAMPLE: object oWeapon = FetchObjectFromArray("AlistairInventory", INVENTORY_SLOT_OFFHAND);
*
* Returns the object stored at position nSlot in the array with sArrayName. Using STORAGE_APPEND_TO_ARRAY for nSlot will store the variable at
* the end of the array.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nSlot - The array slot from which to fetch the variable.
* @author Talmud
**/
object FetchObjectFromArray(string sArrayName, int nSlot);

/** @brief EXAMPLE: StoreLocationArray("SpawnPoints", arLocations, STORAGE_APPEND_TO_ARRAY);
* Store an array of locations for later retrieval. Array size grows dynamically. Using STORAGE_APPEND_TO_ARRAY for nStart will store arLocations at
* the end of the stored array. Only 1000 variables can be added per function call. Array sizes of greater than a few thousand are not recommended.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param arLocations - The array of locations you wish to store.
* @param nStart - The insertion point for the array being stored. Use this to expand an array or replace a particular range of values.
* @author Talmud
**/
void StoreLocationArray(string sArrayName, location[] arLocations, int nStart = 0);

/** @brief EXAMPLE: location[] arSpawnPoints = FetchLocationArray("SpawnPoints");
* Retrieves an array of locations. Only 1000 variables can be retrieved per function call. Array sizes of greater
* than a few thousand are not recommended. Using STORAGE_END_OF_ARRAY for nEnd will attempt to retrieve all array
* slots between nStart and the size of the array, still limited to 1000 slots retrieved.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStart - The stored array slot from which to begin retrieving the fetched array.
* @param nEnd - The stored array slot at which to stop retrieving the fetched array. "FetchLocationArray(sArray, 1400, 1500);" will retrieve array slots 1400-1499.
* @author Talmud
**/
location[] FetchLocationArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY);

/** @brief EXAMPLE: StoreIntegerArray("KillsByPartyMember", arKillsByPartySlot, 0);
* Store an array of integers for later retrieval. Array size grows dynamically. Using STORAGE_APPEND_TO_ARRAY for nStart will store arLocations at
* the end of the stored array. Only 1000 variables can be added per function call. Array sizes of greater than a few thousand are not recommended.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param arIntegers - The array of integers you wish to store.
* @param nStart - The insertion point for the array being stored. Use this to expand an array or replace a particular range of values.
* @author Talmud
**/
void StoreIntegerArray(string sArrayName, int[] arIntegers, int nStart = 0);

/** @brief EXAMPLE: int[] arArenaKillsInFinalRounds = FetchIntegerArray("MostKillsPerRound", 3, STORAGE_END_OF_ARRAY);
* Retrieves an array of integers. Only 1000 variables can be retrieved per function call. Array sizes of greater
* than a few thousand are not recommended. Using STORAGE_END_OF_ARRAY for nEnd will attempt to retrieve all array
* slots between nStart and the size of the array, still limited to 1000 slots retrieved.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStart - The stored array slot from which to begin retrieving the fetched array.
* @param nEnd - The stored array slot at which to stop retrieving the fetched array. "FetchIntegerArray(sArray, 1400, 1500);" will retrieve array slots 1400-1499.
* @author Talmud
**/
int[] FetchIntegerArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY);

/** @brief EXAMPLE: StoreFloatArray("DamageToDealPerRound", arDamages);
* Store an array of floats for later retrieval. Array size grows dynamically. Using STORAGE_APPEND_TO_ARRAY for nStart will store arLocations at
* the end of the stored array. Only 1000 variables can be added per function call. Array sizes of greater than a few thousand are not recommended.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param arFloats - The array of floats you wish to store.
* @param nStart - The insertion point for the array being stored. Use this to expand an array or replace a particular range of values.
* @author Talmud
**/
void StoreFloatArray(string sArrayName, float[] arFloats, int nStart = 0);

/** @brief EXAMPLE: float[] arDamageToDealPerRound = FetchFloatArray("DamageToDealPerRound");
* Retrieves an array of floats. Only 1000 variables can be retrieved per function call. Array sizes of greater
* than a few thousand are not recommended. Using STORAGE_END_OF_ARRAY for nEnd will attempt to retrieve all array
* slots between nStart and the size of the array, still limited to 1000 slots retrieved.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStart - The stored array slot from which to begin retrieving the fetched array.
* @param nEnd - The stored array slot at which to stop retrieving the fetched array. "FetchIntegerArray(sArray, 1400, 1500);" will retrieve array slots 1400-1499.
* @author Talmud
**/
float[] FetchFloatArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY);

/** @brief EXAMPLE: StoreStringArray("NamesToSet", arNamesToSet);
* Store an array of integers for later retrieval. Array size grows dynamically. Using STORAGE_APPEND_TO_ARRAY for nStart will store arLocations at
* the end of the stored array. Only 1000 variables can be added per function call. Array sizes of greater than a few thousand are not recommended.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param arStrings - The array of strings you wish to store.
* @param nStart - The insertion point for the array being stored. Use this to expand an array or replace a particular range of values.
* @author Talmud
**/
void StoreStringArray(string sArrayName, string[] arStrings, int nStart = 0);

/** @brief EXAMPLE: string[] arNamesToSet = FetchStringArray("NamesToSet");
* Retrieves an array of strings. Only 1000 variables can be retrieved per function call. Array sizes of greater
* than a few thousand are not recommended. Using STORAGE_END_OF_ARRAY for nEnd will attempt to retrieve all array
* slots between nStart and the size of the array, still limited to 1000 slots retrieved.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStart - The stored array slot from which to begin retrieving the fetched array.
* @param nEnd - The stored array slot at which to stop retrieving the fetched array. "FetchIntegerArray(sArray, 1400, 1500);" will retrieve array slots 1400-1499.
* @author Talmud
**/
string[] FetchStringArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY);

/** @brief EXAMPLE: StoreObjectArray("ArmyMembers", GetTeam(10), STORAGE_APPEND_TO_ARRAY);
* Store an array of objects for later retrieval. Array size grows dynamically. Using STORAGE_APPEND_TO_ARRAY for nStart will store arLocations at
* the end of the stored array. Only 1000 variables can be added per function call. Array sizes of greater than a few thousand are not recommended.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param arObjects - The array of objects you wish to store.
* @param nStart - The insertion point for the array being stored. Use this to expand an array or replace a particular range of values.
* @author Talmud
**/
void StoreObjectArray(string sArrayName, object[] arObjects, int nStart = 0);

/** @brief EXAMPLE: object[] arArmyMembers = FetchObjectArray("ArmyMembers");
* Retrieves an array of objects. Only 1000 variables can be retrieved per function call. Array sizes of greater
* than a few thousand are not recommended. Using STORAGE_END_OF_ARRAY for nEnd will attempt to retrieve all array
* slots between nStart and the size of the array, still limited to 1000 slots retrieved.
*
* @param sArrayName - The name of the array cache. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param nStart - The stored array slot from which to begin retrieving the fetched array.
* @param nEnd - The stored array slot at which to stop retrieving the fetched array. "FetchObjectArray(sArray, 1400, 1500);" will retrieve array slots 1400-1499.
* @author Talmud
**/
object[] FetchObjectArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY);


effect MassStorage_GetEffect(string sCache, string sCacheType = STORAGE_CACHE_TYPE_STANDARD);
void MassStorage_SetEffect(string sCache, effect eStorage, string sCacheType = STORAGE_CACHE_TYPE_STANDARD);

/** @brief EXAMPLE: eStorage = MassStorage_StoreLocation(eStorage, "HarpyQueen", lSpawn);
* Store a location with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect,
* store it with MassStorage_SetEffect.  Be sure to use STORAGE_CACHE_TYPE_LOCATION for locations and vectors.
*
* @param eStorage - The storage effect to store the location in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param lLoc - The location to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest", STORAGE_CACHE_TYPE_LOCATION);
* @param : eStorage = MassStorage_StoreVector(eStorage, "ImpactPoint", vImpact);
* @param : eStorage = MassStorage_StoreLocation(eStorage, "HarpyQueen", lSpawn);
* @param : MassStorage_SetEffect("HarpyQuest", eStorage, STORAGE_CACHE_TYPE_LOCATION);
* @author Talmud
**/
effect MassStorage_StoreLocation(effect eStorage, string sVariableName, location lLoc);

/** @brief EXAMPLE: location lSpawn = MassStorage_FetchLocation(eStorage, "HarpyQueen");
* Fetch a location with sVariableName from an effect retrieved by MassStorage_GetEffect. Be sure to use STORAGE_CACHE_TYPE_LOCATION
* for locations and vectors.
*
* @param eStorage - The storage effect to fetch the location from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest", STORAGE_CACHE_TYPE_LOCATION);
* @param : vector vImpact = MassStorage_FetchVector(eStorage, "ImpactPoint");
* @param : location lSpawn = MassStorage_FetchLocation(eStorage, "HarpyQueen");
* @author Talmud
**/
location MassStorage_FetchLocation(effect eStorage, string sVariableName);

/** @brief EXAMPLE: eStorage = MassStorage_StoreVector(eStorage, "ProjectileImpact", vImpact);
* Store a vector with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect, store it with MassStorage_SetEffect.
*
* @param eStorage - The storage effect to store the vector in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param vPosition - The vector to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : eStorage = MassStorage_StoreInteger(eStorage, "HarpiesKilled", 5);
* @param : eStorage = MassStorage_StoreVector(eStorage, "ProjectileImpact", vImpact);
* @param : MassStorage_SetEffect("HarpyQuest", eStorage);
* @author Talmud
**/
effect MassStorage_StoreVector(effect eStorage, string sVariableName, vector vPosition);

/** @brief EXAMPLE: vector vImpact = MassStorage_FetchVector(eStorage, "ImpactPoint");
* Fetch a vector with sVariableName from an effect retrieved by MassStorage_GetEffect. Be sure to use STORAGE_CACHE_TYPE_LOCATION
* for locations and vectors.
*
* @param eStorage - The storage effect to fetch the vector from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest", STORAGE_CACHE_TYPE_LOCATION);
* @param : vector vImpact = MassStorage_FetchVector(eStorage, "ImpactPoint");
* @param : location lSpawn = MassStorage_FetchLocation(eStorage, "HarpyQueen");
* @author Talmud
**/
vector MassStorage_FetchVector(effect eStorage, string sVariableName);

/** @brief EXAMPLE: eStorage = MassStorage_StoreInteger(eStorage, "HarpiesKilled", 5);
* Store an integer with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect, store it with MassStorage_SetEffect.
*
* @param eStorage - The storage effect to store the integer in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param nValue - The integer to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : eStorage = MassStorage_StoreInteger(eStorage, "HarpiesKilled", 5);
* @param : eStorage = MassStorage_StoreString(eStorage, "HarpyQueen", "Priscilla");
* @param : MassStorage_SetEffect("HarpyQuest", eStorage);
* @author Talmud
**/
effect MassStorage_StoreInteger(effect eStorage, string sVariableName, int nValue);

/** @brief EXAMPLE: int nHarpiesKilled = MassStorage_FetchInteger(eStorage, "HarpiesKilled");
* Fetch an integer with sVariableName from an effect retrieved by MassStorage_GetEffect.
*
* @param eStorage - The storage effect to fetch the integer from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : string sName = MassStorage_FetchString(eStorage, "HarpyQueen");
* @param : int nHarpiesKilled = MassStorage_FetchInteger(eStorage, "HarpiesKilled");
* @author Talmud
**/
int MassStorage_FetchInteger(effect eStorage, string sVariableName);

/** @brief EXAMPLE: eStorage = MassStorage_StoreFloat(eStorage, "ExplosionDamage", 35.0);
* Store a float with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect, store it with MassStorage_SetEffect.
*
* @param eStorage - The storage effect to store the float in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param fValue - The float to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : eStorage = MassStorage_StoreFloat(eStorage, "ExplosionDamage", 35.0);
* @param : eStorage = MassStorage_StoreString(eStorage, "HarpyQueen", "Priscilla");
* @param : MassStorage_SetEffect("HarpyQuest", eStorage);
* @author Talmud
**/
effect MassStorage_StoreFloat(effect eStorage, string sVariableName, float fValue);

/** @brief EXAMPLE: float fDamage_To_Do = MassStorage_FetchFloat(eStorage, "ExplosionDamage");
* Fetch a float with sVariableName from an effect retrieved by MassStorage_GetEffect.
*
* @param eStorage - The storage effect to fetch the float from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : string sName = MassStorage_FetchString(eStorage, "HarpyQueen");
* @param : float fDamage_To_Do = MassStorage_FetchFloat(eStorage, "ExplosionDamage");
* @author Talmud
**/
float MassStorage_FetchFloat(effect eStorage, string sVariableName);

/** @brief EXAMPLE: eStorage = MassStorage_StoreString(eStorage, "HarpyQueen", "Priscilla");
* Store a string with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect, store it with MassStorage_SetEffect.
*
* @param eStorage - The storage effect to store the string in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param sValue - The string to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : eStorage = MassStorage_StoreInteger(eStorage, "HarpiesKilled", 5);
* @param : eStorage = MassStorage_StoreString(eStorage, "HarpyQueen", "Priscilla");
* @param : MassStorage_SetEffect("HarpyQuest", eStorage);
* @author Talmud
**/
effect MassStorage_StoreString(effect eStorage, string sVariableName, string sValue);

/** @brief EXAMPLE: string sName = MassStorage_FetchString(eStorage, "HarpyQueen");
* Fetch a string with sVariableName from an effect retrieved by MassStorage_GetEffect.
*
* @param eStorage - The storage effect to fetch the string from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : string sName = MassStorage_FetchString(eStorage, "HarpyQueen");
* @param : float fDamage_To_Do = MassStorage_FetchFloat(eStorage, "ExplosionDamage");
* @author Talmud
**/
string MassStorage_FetchString(effect eStorage, string sVariableName);

/** @brief EXAMPLE: eStorage = MassStorage_StoreObject(eStorage, "HarpyQueen", oQueen);
* Store an object with sVariableName in an effect retrieved by MassStorage_GetEffect. After all variables are added to the effect, store it with MassStorage_SetEffect.
*
* @param eStorage - The storage effect to store the object in. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param oValue - The object to store.
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : eStorage = MassStorage_StoreObject(eStorage, "HarpyQueen", oQueen);
* @param : eStorage = MassStorage_StoreString(eStorage, "HarpyQueen", "Priscilla");
* @param : MassStorage_SetEffect("HarpyQuest", eStorage);
* @author Talmud
**/
effect MassStorage_StoreObject(effect eStorage, string sVariableName, object oValue);

/** @brief EXAMPLE: object oQueen = MassStorage_FetchObject(eStorage, "HarpyQueen");
* Fetch an object with sVariableName from an effect retrieved by MassStorage_GetEffect.
*
* @param eStorage - The storage effect to fetch the object from. (Previously retrieved with MassStorage_GetEffect.)
* @param sVariableName - The name of the variable to fetch. (No length limit, but shorter is more efficient.)
* @param : EXAMPLE in context:
* @param : effect eStorage = MassStorage_GetEffect("HarpyQuest");
* @param : object oQueen = MassStorage_FetchObject(eStorage, "HarpyQueen");
* @param : float fDamage_To_Do = MassStorage_FetchFloat(eStorage, "ExplosionDamage");
* @author Talmud
**/
object MassStorage_FetchObject(effect eStorage, string sVariableName);

/** @brief EXAMPLE: StoreInteger("HarpyQuest", "HarpiesKilled", 5);
* Store an integer in a cache for later retrieval. Appropriate for storing quest variables and basic system data.
*
* @param sCache - The name of the cache to store the integer in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param nValue - The integer to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreInteger(good) or StoreIntegerArray(best) for better performance and efficiency. Calling StoreInteger a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreInteger(string sCache, string sVariableName, int nValue);

/** @brief EXAMPLE: int nHarpiesKilled = FetchInteger("HarpyQuest", "HarpiesKilled");
* Fetch a previously stored integer from a cache. Appropriate for quest variables and basic system data.
* @param sCache - The name of the cache to fetch the integer from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchInteger(good) or FetchIntegerArray(best) for better performance and efficiency. Calling FetchInteger a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
int FetchInteger(string sCache, string sName);

/** @brief EXAMPLE: StoreFloat("HarpyQuest", "PercentComplete", 3.5 + FetchFloat("HarpyQuest", "PercentComplete"));
* Store an float in a cache for later retrieval. Appropriate for storing quest variables and basic system data.
*
* @param sCache - The name of the cache to store the float in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param nValue - The float value to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreFloat(good) or StoreFloatArray(best) for better performance and efficiency. Calling StoreFloat a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreFloat(string sCache, string sVariableName, float fValue);

/** @brief EXAMPLE: float fQuestPercentComplete = FetchFloat("HarpyQuest", "PercentComplete");
* Fetch a previously stored float from a cache. Appropriate for quest variables and basic system data.
* @param sCache - The name of the cache to fetch the float from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchFloat(good) or FetchFloatArray(best) for better performance and efficiency. Calling FetchFloat a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
float FetchFloat(string sCache, string sVariableName);

/** @brief EXAMPLE: StoreString("HarpyQuest", "HarpyHealer", "Clotilda");
* Store a string in a cache for later retrieval. Appropriate for storing quest variables and basic system data.
*
* @param sCache - The name of the cache to store the string in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param sValue - The string to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreString(good) or StoreStringArray(best) for better performance and efficiency. Calling StoreString a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreString(string sCache, string sVariableName, string sValue);

/** @brief EXAMPLE: string sHarpyName = FetchString("HarpyQuest", "HarpyHealer");
* Fetch a previously stored string from a cache. Appropriate for quest variables and basic system data.
* @param sCache - The name of the cache to fetch the string from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchString(good) or FetchStringArray(best) for better performance and efficiency. Calling FetchString a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
string FetchString(string sCache, string sVariableName);

/** @brief EXAMPLE: StoreObject("HarpyQuest", "NextTarget", oHarpyTarget);
* Store an object in a cache for later retrieval. Appropriate for storing quest variables and basic system data.
*
* @param sCache - The name of the cache to store the object in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param oValue - The object to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreObject(good) or StoreObjectArray(best) for better performance and efficiency. Calling StoreObject a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreObject(string sCache, string sVariableName, object oValue);

/** @brief EXAMPLE: object oHarpyTarget = FetchObject("HarpyQuest", "NextTarget");
* Fetch a previously stored object from a cache. Appropriate for quest variables and basic system data.
* @param sCache - The name of the cache to fetch the object from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchObject(good) or FetchObjectArray(best) for better performance and efficiency. Calling FetchObject a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
object FetchObject(string sCache, string sVariableName);

/** @brief EXAMPLE: StoreLocation("HarpyQuest", "HarpyQueen", lSpawnLocation);
* Store an location in a cache for later retrieval. Appropriate for storing quest variables and basic system data. StoreLocation shares a namespace with
* StoreVector, so StoreVector("Quest", "Start") would overwrite the position data previously stored with StoreLocation("Quest", "Start").
*
* @param sCache - The name of the cache to store the location in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param lLoc - The location to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreLocation(good) or StoreLocationrArray(best) for better performance and efficiency. Calling StoreLocation a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreLocation(string sCache, string sVariableName, location lLoc);

/** @brief EXAMPLE: location lSpawn = FetchLocation("HarpyQuest", "HarpyQueen");
* Fetch a previously stored location from a cache. Appropriate for quest variables and basic system data. FetchLocation shares a namespace with
* FetchVector, so FetchVector("Quest", "Start") retrieves the same position data that GetPositionFromLocation(FetchLocation("Quest", "Start")) would.
*
* @param sCache - The name of the cache to fetch the location from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchLocation(good) or FetchLocationArray(best) for better performance and efficiency. Calling FetchLocation a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
location FetchLocation(string sCache, string sVariableName);

/** @brief EXAMPLE: StoreVector("HarpyQuest", "QuestStart", vCurrentPosition);
* Store an vector in a cache for later retrieval. Appropriate for storing quest variables and basic system data.  StoreLocation shares a namespace with
* StoreVector, so StoreVector("Quest", "Start") would overwrite the position data previously stored with StoreLocation("Quest", "Start").
*
* @param sCache - The name of the cache to store the vector in. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be stored. (No length limit, but shorter is more efficient.)
* @param nValue - The vector value to store.
* @param NOTE: To store multiple variables on the same cache use MassStorage_StoreVector(good) or StoreLocationArray(best) for better performance and efficiency. Calling StoreVector a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
void StoreVector(string sCache, string sVariableName, vector vPosition);

/** @brief EXAMPLE: vector vStart = FetchVector("HarpyQuest", "QuestStart");
* Fetch a previously stored vector from a cache. Appropriate for quest variables and basic system data.FetchLocation shares a namespace with
* FetchVector, so FetchVector("Quest", "Start") retrieves the same position data that GetPositionFromLocation(FetchLocation("Quest", "Start")) would.
*
* @param sCache - The name of the cache to fetch the vector from. (Should be between 1 and 27 characaters in length, beginning with a letter.)
* @param sVariableName - The name of the variable to be retrieved. (No length limit, but shorter is more efficient.)
* @param NOTE: To access multiple variables from the same cache use MassStorage_FetchVector(good) or FetchLocationArray(best) for better performance and efficiency. Calling FetchVector a hundred times or more in a single script will noticeably affect gameplay (slight hitch). Do not store more than 1000 variable names on the same cache.
* @author Talmud
**/
vector FetchVector(string sCache, string sVariableName);


object[] _TalStorage_SortStorageObjects(object[] arObjects)
{
    int nFinalPosition = GetArraySize(arObjects) - 1;
    int nPos = nFinalPosition;
    object oTemp;
    while (nPos > 1)
    {
        if (nPos == nFinalPosition || GetLocalInt(arObjects[nPos], TAL_STORAGE_CACHE_FACTOR_VAR) <= GetLocalInt(arObjects[nPos+1], TAL_STORAGE_CACHE_FACTOR_VAR))
        {
            nPos--;
        }
        else
        {
            oTemp = arObjects[nPos];
            arObjects[nPos] = arObjects[nPos + 1];
            arObjects[nPos + 1] = oTemp;
            nPos++;
        }
    }
    return arObjects;
}

object _TalGetStorageCache(int nCache = 0)
{
    string sTag = TAL_STORAGE_CACHE_TAG + IntToString(nCache);
    object oStorage = GetObjectByTag(sTag);
    if (!IsObjectValid(oStorage))
    {
        object oArea = MK_GetCharStage();
        location lStorage = Location(oArea, Vector(), 0.0);
        oStorage = CreateObject(OBJECT_TYPE_PLACEABLE, TAL_STORAGE_CACHE_RESOURCE, lStorage, " ");
        EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_ADDED);
        EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_REMOVED);
        EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_FULL);


        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("_TalGetStorageCache: storage cache inventory size: " + ToString(GetArraySize(GetItemsInInventory(oStorage))));
        #endif

        SetTag(oStorage, sTag);
        SetObjectInteractive(oStorage, FALSE);
        SetLocation(oStorage, lStorage);


        if (!nCache)
        {
            CreateItemOnObject(TAL_STORAGE_ITEM_RESOURCE, oStorage, 300, "", TRUE, FALSE);
            StoreObjectInArray(TAL_STORAGE_ITEM_CACHE_TAG, oStorage, 0);
            object oMainCache = _TalGetStorageCache(1);
            StoreObjectInArray(TAL_STORAGE_ITEM_CACHE_TAG, oMainCache, 1);
            #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
            PrintToLog("_TalGetStorageCache: storage cache inventory size: " + ToString(GetArraySize(GetItemsInInventory(oStorage))));
            FetchObjectArray(TAL_STORAGE_ITEM_CACHE_TAG);
            #endif
        }
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("_TalGetStorageCache: tag of oStorage = " + GetTag(oStorage));
        PrintToLog("_TalGetStorageCache: storage cache effect array size: " + ToString(GetArraySize(GetEffects(oStorage))));
        //PrintToLog("storage object array size: " + ToString(Storage_GetArraySize(TAL_STORAGE_ITEM_CACHE_TAG, STORAGE_ARRAY_OBJECT)));
        #endif

    }

    return oStorage;
}


effect _TalGetStorageEffect(string sTag)//, int nID = 0)
{
    object oStorageCache = _TalGetStorageCache();
    object oItem = GetItemPossessedBy(oStorageCache, sTag);
    object oCurrentCache = _TalGetStorageCache(GetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR));
    effect[] arEffects = GetEffects(oCurrentCache, TAL_EFFECT_TYPE_STORAGE, 0, oItem);

    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("_GetObjectStorageEffect: sTag: " + sTag);
//    PrintToLog("_GetObjectStorageEffect: object effect array size: " + ToString(GetArraySize(arEffects)));
    PrintToLog("_GetObjectStorageEffect: oCurrentCache: " + GetTag(oCurrentCache));
    #endif
    return GetArraySize(arEffects) > 0 ? arEffects[0] : Effect(TAL_EFFECT_TYPE_STORAGE);
}

void _TalSetStorageEffect(string sTag, effect eFect, int nLoadFactor = 0)
{
    object oStorageCache = _TalGetStorageCache();
    object oCurrentCache;
    object oItem = GetItemPossessedBy(oStorageCache, sTag);
    int nStorageObjectArraySize = Storage_GetArraySize(TAL_STORAGE_ITEM_CACHE_TAG, STORAGE_ARRAY_OBJECT);
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("_TalSetStorageEffect: sTag: " + sTag);
    #endif

    if (IsObjectValid(oItem))
    {
        oCurrentCache = _TalGetStorageCache(GetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR)) ;
        RemoveEffectsByParameters(oCurrentCache, TAL_EFFECT_TYPE_STORAGE, 0, oItem);
    }
    else
    {
        oItem = GetItemPossessedBy(oStorageCache, TAL_STORAGE_ITEM_TAG);
        if (IsObjectValid(oItem))
            SetTag(oItem, sTag);
        else
            oItem =  CreateItemOnObject(TAL_STORAGE_ITEM_RESOURCE, oStorageCache, 1, sTag, TRUE, FALSE);

        if (!nStorageObjectArraySize)
        {
            oCurrentCache = oStorageCache;
        }
        else
        {
            oCurrentCache = FetchObjectFromArray(TAL_STORAGE_ITEM_CACHE_TAG, nStorageObjectArraySize - 1);
            SetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR, nStorageObjectArraySize - 1);
        }
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("_TalSetStorageEffect: oItem not found, creating");
        PrintToLog("_TalSetStorageEffect: storage object array size: " + IntToString(nStorageObjectArraySize));
        #endif
    }
    if (nLoadFactor)  //update load info
    {
        int nTotalLoadFactor = GetLocalInt(oCurrentCache, TAL_STORAGE_CACHE_FACTOR_VAR);
        int nEffectLoadFactor = GetLocalInt(oItem, TAL_STORAGE_FACTOR_VAR);
        nEffectLoadFactor += nLoadFactor;
        nTotalLoadFactor += nLoadFactor;
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("_TalSetStorageEffect: oCurrentCache: " + GetTag(oCurrentCache));
        PrintToLog("_TalSetStorageEffect: nLoadFactor: " + ToString(nLoadFactor));
        PrintToLog("_TalSetStorageEffect: nEffectLoadFactor: " + ToString(nEffectLoadFactor));
        PrintToLog("_TalSetStorageEffect: nTotalLoadFactor: " + ToString(nTotalLoadFactor));
        #endif
        // if maximum load exceeded find new cache
        if (nTotalLoadFactor > TAL_STORAGE_MAXIMUM_LOAD_FACTOR)
        {
            #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
            PrintToLog("_TalSetStorageEffect: nTotalLoadFactor exceeds TAL_STORAGE_MAXIMUM_LOAD_FACTOR ");
            #endif

            if (nEffectLoadFactor > TAL_STORAGE_MAXIMUM_LOAD_FACTOR)
            {
                #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
                PrintToLog("_TalSetStorageEffect: nEffectLoadFactor exceeds TAL_STORAGE_MAXIMUM_LOAD_FACTOR ");
                #endif

                #ifdef TALMUD_STORAGE_DEBUG_USER
                PrintToLog("WARNING: storage cache effect " + sTag + " is overloaded. Retrieval and storage on this cache will be slow.");
                #endif


                if (nTotalLoadFactor != nEffectLoadFactor) // make sure we don't keep spawning new storage objects for the same effect
                {
                    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
                    PrintToLog("_TalSetStorageEffect: nEffectLoadFactor != nEffectLoadFactor");
                    #endif
                    oCurrentCache = _TalGetStorageCache(nStorageObjectArraySize);
                    StoreObjectInArray(TAL_STORAGE_ITEM_CACHE_TAG, oCurrentCache);
                    nTotalLoadFactor = nEffectLoadFactor;
                    SetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR, nStorageObjectArraySize);
                    SetLocalInt(oCurrentCache, TAL_STORAGE_CACHE_OBJECT_VAR, nStorageObjectArraySize);
                }
            }
            else
            {
                object[] arObjects = FetchObjectArray(TAL_STORAGE_ITEM_CACHE_TAG);

                #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
                PrintToLog("_TalSetStorageEffect: nEffectLoadFactor in safe range");
                PrintToLog("_TalSetStorageEffect: storage object array size: " + IntToString(GetArraySize(arObjects)));
                #endif

                arObjects = _TalStorage_SortStorageObjects(arObjects);
                StoreObjectArray(TAL_STORAGE_ITEM_CACHE_TAG, arObjects);

                nTotalLoadFactor = GetLocalInt(arObjects[nStorageObjectArraySize - 1], TAL_STORAGE_FACTOR_VAR);
                nTotalLoadFactor += nEffectLoadFactor;

                if (nTotalLoadFactor > TAL_STORAGE_MAXIMUM_LOAD_FACTOR)
                {
                    oCurrentCache = _TalGetStorageCache(nStorageObjectArraySize);
                    StoreObjectInArray(TAL_STORAGE_ITEM_CACHE_TAG, oCurrentCache);
                    nTotalLoadFactor = nEffectLoadFactor;
                    SetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR, nStorageObjectArraySize);
                    SetLocalInt(oCurrentCache, TAL_STORAGE_CACHE_OBJECT_VAR, nStorageObjectArraySize);
                }
                else
                {
                    oCurrentCache = arObjects[nStorageObjectArraySize - 1];
                    SetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR, GetLocalInt(oCurrentCache, TAL_STORAGE_OBJECT_VAR));
                }
            }
        }
        SetLocalInt(oCurrentCache, TAL_STORAGE_CACHE_FACTOR_VAR, nTotalLoadFactor);
        SetLocalInt(oItem, TAL_STORAGE_FACTOR_VAR, nEffectLoadFactor);

    }
    Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eFect, oCurrentCache , 0.0, oItem);
}

void _TalStorage_ModulePresave()
{
    object oPC = GetPartyLeader();
    object oStorage = _TalGetStorageCache();
    if (GetArea(oPC) != GetArea(oStorage))
    {
        object[] arStorage = FetchObjectArray(TAL_STORAGE_ITEM_CACHE_TAG);
        int nArraySize = GetArraySize(arStorage);
        int n;
        for (n = 0; n < nArraySize; n++)
        {
            SetLocation(arStorage[n], GetSafeLocation(GetLocation(oPC)));
        }
    }
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("_TalStorage_ModulePresave, storage area: " + GetTag(GetArea(oStorage)));
    #endif
}

void _TalStorage_ModuleLoad()
{
    object oPC = GetPartyLeader();
    object oStorage = _TalGetStorageCache();
    if (GetArea(oPC) == GetArea(oStorage))
    {
        location lStorage = Location(GetObjectByTag(TAL_STORAGE_AREA_TAG), Vector(), 0.0);
        object[] arStorage = FetchObjectArray(TAL_STORAGE_ITEM_CACHE_TAG);
        int nArraySize = GetArraySize(arStorage);
        int n;
        for (n = 0; n < nArraySize; n++)
        {
            SetLocation(arStorage[n], lStorage);
        }
    }
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("_TalStorage_ModuleLoad, storage area: " + GetTag(GetArea(oStorage)));
    #endif

}
void Storage_HandleModuleEvents()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);
    switch(nEventType)
    {
        case EVENT_TYPE_MODULE_PRESAVE:
        {
            _TalStorage_ModulePresave();
            break;
        }
        case EVENT_TYPE_MODULE_LOAD:
        {
            _TalStorage_ModuleLoad();
            break;
        }
        case EVENT_TYPE_GAMEMODE_CHANGE:
        {
            int nNewGameMode = GetEventInteger(ev,0);
            int nOldGameMode = GetEventInteger(ev,1);

            if (nNewGameMode == GM_EXPLORE
                && nOldGameMode == GM_LOADING)
            {
                _TalStorage_ModuleLoad();
            }
            break;
        }
    }
}

int Storage_GetArraySize(string sArrayName, int nStorageArrayType = STORAGE_ARRAY_INTEGER)
{
    string sCacheType = nStorageArrayType == STORAGE_ARRAY_LOCATION ? STORAGE_CACHE_TYPE_LOCATION_ARRAY : STORAGE_CACHE_TYPE_ARRAY;
    effect eArray = _TalGetStorageEffect(sCacheType + sArrayName);

    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("Storage_GetArraySize, sArrayName: " + sArrayName);
    PrintToLog("Storage_GetArraySize, nStorageArrayType: " + ToString(nStorageArrayType));
    PrintToLog("Storage_GetArraySize, size: " + ToString(GetEffectInteger(eArray, nStorageArrayType)));
    #endif

    return GetEffectInteger(eArray, nStorageArrayType);
}

void Storage_SetArraySize(string sArrayName, int nStorageArrayType, int nSize)
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

void Storage_PurgeCache(string sName, string sCacheType = STORAGE_CACHE_TYPE_STANDARD)
{
    sName = sCacheType + sName;
    object oStorageCache = _TalGetStorageCache();
    object oItem = GetItemPossessedBy(oStorageCache, sName);
    object oCurrentCache = _TalGetStorageCache(GetLocalInt(oItem, TAL_STORAGE_OBJECT_VAR));
    object[] arStorage = FetchObjectArray(TAL_STORAGE_ITEM_CACHE_TAG);
    effect eFect = _TalGetStorageEffect(sName);
    RemoveEffect(oCurrentCache, eFect);
    SetLocalInt(oItem, TAL_STORAGE_FACTOR_VAR, 0);
    SetTag(oItem, TAL_STORAGE_ITEM_TAG);

    arStorage = _TalStorage_SortStorageObjects(arStorage);
    StoreObjectArray(TAL_STORAGE_ITEM_CACHE_TAG, arStorage);
}

void StoreLocationInArray(string sArrayName, location lValue, int nSlot = STORAGE_APPEND_TO_ARRAY)
{
    location[] arLocations;
    arLocations[0] = lValue;
    StoreLocationArray(sArrayName, arLocations, nSlot);
}

location FetchLocationFromArray(string sArrayName, int nSlot)
{
    location[] arLocations = FetchLocationArray(sArrayName, nSlot, nSlot+1);
    return arLocations[0];
}

void StoreIntegerInArray(string sArrayName, int nValue, int nSlot = STORAGE_APPEND_TO_ARRAY)
{
    int[] arIntegers;
    arIntegers[0] = nValue;
    StoreIntegerArray(sArrayName, arIntegers, nSlot);
}

int FetchIntFromArray(string sArrayName, int nSlot)
{
    int[] arIntegers = FetchIntegerArray(sArrayName, nSlot, nSlot+1);
    return arIntegers[0];
}

void StoreFloatInArray(string sArrayName, float fValue, int nSlot = STORAGE_APPEND_TO_ARRAY)
{
    float[] arFloats;
    arFloats[0] = fValue;
    StoreFloatArray(sArrayName, arFloats, nSlot);
}

float FetchFloatFromArray(string sArrayName, int nSlot)
{
    float[] arFloats = FetchFloatArray(sArrayName, nSlot, nSlot+1);
    return arFloats[0];
}

void StoreStringInArray(string sArrayName, string sValue, int nSlot = STORAGE_APPEND_TO_ARRAY)
{
    string[] arStrings;
    arStrings[0] = sValue;
    StoreStringArray(sArrayName, arStrings, nSlot);
}

string FetchStringFromArray(string sArrayName, int nSlot)
{
    string[] arStrings = FetchStringArray(sArrayName, nSlot, nSlot+1);
    return arStrings[0];
}
void StoreObjectInArray(string sArrayName, object oValue, int nSlot = STORAGE_APPEND_TO_ARRAY)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("StoreObjectInArray: sArrayName: " + sArrayName);
    PrintToLog("StoreObjectInArray: oValue: " + GetTag(oValue));
    PrintToLog("StoreObjectInArray: nSlot: " + ToString(nSlot));
    #endif
    object[] arObjects;
    arObjects[0] = oValue;
    StoreObjectArray(sArrayName, arObjects, nSlot);
}

object FetchObjectFromArray(string sArrayName, int nSlot)
{
    object[] arObjects = FetchObjectArray(sArrayName, nSlot, nSlot+1);
    return arObjects[0];
}

void StoreLocationArray(string sArrayName, location[] arLocations, int nStart = 0)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_LOCATION_ARRAY + sArrayName);
    int n, m  ;
    int nArraySize = GetArraySize(arLocations);
    int nEffectArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_LOCATION);
    int nTotal;
    vector vPosition;
    location lLoc;
    nArraySize = Min(nArraySize, 1000);
    if (nStart < 0)
    {
        nStart = nEffectArraySize;
    }
    nTotal = nArraySize + nStart;

    if (nTotal > nEffectArraySize)
    {
        eArray = SetEffectInteger(eArray, STORAGE_ARRAY_LOCATION, nTotal * 5);
        nTotal -= nEffectArraySize;
    }
    else
    {
        nTotal = 0;
    }

    for(n = 0; n < nArraySize; n++)
    {
        m = nStart + n * 4;
        lLoc = arLocations[n];
        vPosition = GetPositionFromLocation(lLoc);

        eArray = SetEffectObject(eArray, m, GetAreaFromLocation(lLoc));
        eArray = SetEffectFloat(eArray, m, vPosition.x);
        eArray = SetEffectFloat(eArray, m + 1, vPosition.y);
        eArray = SetEffectFloat(eArray, m + 2, vPosition.z);
        eArray = SetEffectFloat(eArray, m + 3, GetFacingFromLocation(lLoc));
    }
    _TalSetStorageEffect(STORAGE_CACHE_TYPE_LOCATION_ARRAY + sArrayName, eArray, nTotal * 5);
}

location[] FetchLocationArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_LOCATION_ARRAY + sArrayName);
    location[] arLocations;
    int n, m;
    object oArea;
    object oCurrentArea = GetArea(GetPartyLeader());
    vector vPosition;
    float fFacing;
    int nArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_LOCATION);

    if (nEnd < 0)
    {
        nEnd = nArraySize;
    }
    else
    {
        nEnd = Min(nArraySize, nEnd);
    }

    nStart = Max(nStart, 0);
    nArraySize = Min(nEnd - nStart, 1000);


    for(n = 0; n < nArraySize; n++)
    {
        m = nStart + n * 4;
        oArea       = GetEffectObject(eArray, m);
        if (!IsObjectValid(oArea))
        {
            oArea = oCurrentArea;
        }
        vPosition.x = GetEffectFloat(eArray, m);
        vPosition.y = GetEffectFloat(eArray, m + 1);
        vPosition.z = GetEffectFloat(eArray, m + 2);
        fFacing     = GetEffectFloat(eArray, m + 3);
        arLocations[n] = Location(oArea, vPosition, fFacing);
    }
    return arLocations;
}

void StoreIntegerArray(string sArrayName, int[] arIntegers, int nStart = 0)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    int n;
    int nTotal;
    int nArraySize = GetArraySize(arIntegers);
    int nEffectArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_INTEGER);
    nArraySize = Min(nArraySize, 1000);
    if (nStart < 0)
    {
        nStart = nEffectArraySize;
    }
    nTotal = nArraySize + nStart;

    if (nTotal > nEffectArraySize)
    {
        eArray = SetEffectInteger(eArray, STORAGE_ARRAY_INTEGER, nTotal);
        nTotal -= nEffectArraySize;
    }
    else
    {
        nTotal = 0;
    }

    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("storing from " + ToString(nStart) + " to " + ToString(nArraySize + nStart));
    #endif

    nStart += TAL_STORAGE_ARRAY_START_POSITION;
    for(n = 0; n < nArraySize; n++)
    {
        eArray = SetEffectInteger(eArray, n + nStart, arIntegers[n]);
    }

    _TalSetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName, eArray, nTotal);

    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("done storing from " + ToString(nStart) + " to " + ToString(nArraySize + nStart));
    #endif
}

int[] FetchIntegerArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    int[] arIntegers;
    int n;
    int nArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_INTEGER) ;

    if (nEnd < 0)
    {
        nEnd = nArraySize;
    }
    else
    {
        nEnd = Min(nArraySize, nEnd);
    }

    nStart = Max(nStart, 0);
    nArraySize = Min(nEnd - nStart, 1000);
    nStart += TAL_STORAGE_ARRAY_START_POSITION;

    for(n = 0; n < nArraySize; n++)
    {
        arIntegers[n] = GetEffectInteger(eArray, n + nStart);
    }
    return arIntegers;
}

void StoreFloatArray(string sArrayName, float[] arFloats, int nStart = 0)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    int n;
    int nTotal;
    int nArraySize = GetArraySize(arFloats);
    int nEffectArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_FLOAT);
    nArraySize = Min(nArraySize, 1000);
    if (nStart < 0)
    {
        nStart = nEffectArraySize;
    }
    nTotal = nArraySize + nStart;

    if (nTotal > nEffectArraySize)
    {
        eArray = SetEffectInteger(eArray, STORAGE_ARRAY_FLOAT, nTotal);
        nTotal -= nEffectArraySize;
    }
    else
    {
        nTotal = 0;
    }

    for(n = 0; n < nArraySize; n++)
    {
        eArray = SetEffectFloat(eArray, n + nStart, arFloats[n]);
    }
    _TalSetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName, eArray, nTotal);
}
int[] FetchFloatArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    float[] arFloats;
    int n;
    int nTotal;
    int nArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_FLOAT) ;

    if (nEnd < 0)
    {
        nEnd = nArraySize;
    }
    else
    {
        nEnd = Min(nArraySize, nEnd);
    }

    nStart = Max(nStart, 0);
    nArraySize = Min(nEnd - nStart, 1000);

    for(n = 0; n < nArraySize; n++)
    {
        arFloats[n] = GetEffectFloat(eArray, n + nStart);
    }
    return arFloats;
}

void StoreStringArray(string sArrayName, string[] arStrings, int nStart = 0)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    int n;
    int nTotal;
    int nArraySize = GetArraySize(arStrings);
    int nEffectArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_STRING);
    nArraySize = Min(nArraySize, 1000);
    if (nStart < 0)
    {
        nStart = nEffectArraySize;
    }
    nTotal = nArraySize + nStart;

    if (nTotal > nEffectArraySize)
    {
        eArray = SetEffectInteger(eArray, STORAGE_ARRAY_STRING, nTotal);
        nTotal -= nEffectArraySize;
    }
    else
    {
        nTotal = 0;
    }


    for(n = 0; n < nArraySize; n++)
    {
        eArray = SetEffectString(eArray, n + nStart, arStrings[n]);
    }
    _TalSetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName, eArray, nTotal);
}
int[] FetchStringArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY)
{
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    string[] arStrings;
    int n;
    int nArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_STRING);

    if (nEnd < 0)
    {
        nEnd = nArraySize;
    }
    else
    {
        nEnd = Min(nArraySize, nEnd);
    }

    nStart = Max(nStart, 0);
    nArraySize = Min(nEnd - nStart, 1000);

    for(n = 0; n < nArraySize; n++)
    {
        arStrings[n] = GetEffectString(eArray, n + nStart);
    }
    return arStrings;
}

void StoreObjectArray(string sArrayName, object[] arObjects, int nStart = 0)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("StoreObjectArray: sArrayName: " + sArrayName);
    PrintToLog("StoreObjectArray: nStart: " + ToString(nStart));
    PrintToLog("StoreObjectArray: arObjects size: " + IntToString(GetArraySize(arObjects)));
    #endif

    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    int n;
    int nTotal;
    int nArraySize = GetArraySize(arObjects);
    int nEffectArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_OBJECT);
    nArraySize = Min(nArraySize, 1000);
    if (nStart < 0)
    {
        nStart = nEffectArraySize;
    }
    nTotal = nArraySize + nStart;

    if (nTotal > nEffectArraySize)
    {
        eArray = SetEffectInteger(eArray, STORAGE_ARRAY_OBJECT, nTotal);
        nTotal -= nEffectArraySize;
    }
    else
    {
        nTotal = 0;
    }

    for(n = 0; n < nArraySize; n++)
    {
        eArray = SetEffectObject(eArray, n + nStart, arObjects[n]);
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL_LOOPING
        PrintToLog("StoreObjectArray: arObjects[" + IntToString(n) + "]: " + GetTag(arObjects[n]) );
        #endif
    }
    _TalSetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName, eArray, nTotal);
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("StoreObjectArray: storage object array size: " + IntToString(nStart + nArraySize));
    #endif
}
object[] FetchObjectArray(string sArrayName, int nStart = 0, int nEnd = STORAGE_END_OF_ARRAY)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("FetchObjectArray: sArrayName: " + sArrayName);
    PrintToLog("FetchObjectArray: nStart: " + ToString(nStart));
    PrintToLog("FetchObjectArray: nEnd: " + ToString(nEnd));
    #endif
    effect eArray = _TalGetStorageEffect(STORAGE_CACHE_TYPE_ARRAY + sArrayName);
    object[] arObjects;
    int n;
    int nArraySize = GetEffectInteger(eArray, STORAGE_ARRAY_OBJECT) ;
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("FetchObjectArray: storage object array size: " + IntToString(nArraySize));
    #endif

    if (nEnd < 0)
    {
        nEnd = nArraySize;
    }
    else
    {
        nEnd = Min(nArraySize, nEnd);
    }

    nStart = Max(nStart, 0);
    nArraySize = Min(nEnd - nStart, 1000);

    for(n = 0; n < nArraySize; n++)
    {
        arObjects[n] = GetEffectObject(eArray, n + nStart);
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL_LOOPING
        PrintToLog("FetchObjectArray: arObjects[" + IntToString(n) + "]: " + GetTag(arObjects[n]) );
        #endif
    }
    return arObjects;
}

effect MassStorage_GetEffect(string sCache, string sCacheType = STORAGE_CACHE_TYPE_STANDARD)
{
    effect eStorage = _TalGetStorageEffect(sCacheType + sCache);
    return eStorage;
}
void MassStorage_SetEffect(string sCache, effect eStorage, string sCacheType = STORAGE_CACHE_TYPE_STANDARD)
{
    int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
    eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, 0);
    _TalSetStorageEffect(sCacheType + sCache, eStorage, nLoad);
}

effect MassStorage_StoreLocation(effect eStorage, string sVariableName, location lLoc)
{
    vector vPosition = GetPositionFromLocation(lLoc);
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectObject(eStorage, nPos / 5, GetAreaFromLocation(lLoc));
        eStorage = SetEffectFloat(eStorage, nPos, vPosition.x);
        eStorage = SetEffectFloat(eStorage, nPos + 1, vPosition.y);
        eStorage = SetEffectFloat(eStorage, nPos + 2, vPosition.z);
        eStorage = SetEffectFloat(eStorage, nPos + 3, GetFacingFromLocation(lLoc));
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName);
        nPos = GetStringLength(sTokenString);
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectObject(eStorage, nPos / 5, GetAreaFromLocation(lLoc));
        eStorage = SetEffectFloat(eStorage, nPos, vPosition.x);
        eStorage = SetEffectFloat(eStorage, nPos + 1, vPosition.y);
        eStorage = SetEffectFloat(eStorage, nPos + 2, vPosition.z);
        eStorage = SetEffectFloat(eStorage, nPos + 3, GetFacingFromLocation(lLoc));
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}

location MassStorage_FetchLocation(effect eStorage, string sVariableName)
{
    vector vPosition;
    object oArea;
    float fFacing;

    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    nPos += TAL_STORAGE_ARRAY_START_POSITION;

    oArea = GetEffectObject(eStorage, nPos / 5);
    if (!IsObjectValid(oArea))
    {
        oArea = GetArea(GetPartyLeader());
    }
    vPosition.x = GetEffectFloat(eStorage, nPos);
    vPosition.y = GetEffectFloat(eStorage, nPos + 1);
    vPosition.z = GetEffectFloat(eStorage, nPos + 2);
    fFacing     = GetEffectFloat(eStorage, nPos + 3);

    return Location(oArea, vPosition, fFacing);
}

effect MassStorage_StoreVector(effect eStorage, string sVariableName, vector vPosition)
{
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectFloat(eStorage, nPos, vPosition.x);
        eStorage = SetEffectFloat(eStorage, nPos + 1, vPosition.y);
        eStorage = SetEffectFloat(eStorage, nPos + 2, vPosition.z);
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName);
        nPos = GetStringLength(sTokenString);
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectFloat(eStorage, nPos, vPosition.x);
        eStorage = SetEffectFloat(eStorage, nPos + 1, vPosition.y);
        eStorage = SetEffectFloat(eStorage, nPos + 2, vPosition.z);
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}
vector MassStorage_FetchVector(effect eStorage, string sVariableName)
{
    vector vPosition;

    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    nPos += TAL_STORAGE_ARRAY_START_POSITION;

    vPosition.x = GetEffectFloat(eStorage, nPos);
    vPosition.y = GetEffectFloat(eStorage, nPos + 1);
    vPosition.z = GetEffectFloat(eStorage, nPos + 2);

    return vPosition;
}
effect MassStorage_StoreInteger(effect eStorage, string sVariableName, int nValue)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("MassStorage_Int: " + ToString(nValue));
    #endif
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectInteger(eStorage, nPos, nValue);
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName) / 5;
        nPos = GetStringLength(sTokenString);
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;

        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("storing " + sVariableName + " at position nPos: "+ IntToString(nPos));
        PrintToLog("length of token string: " +IntToString(GetStringLength(sTokenString)));
        PrintToLog("effect id: " + ToString(GetEffectID(eStorage)));
        #endif
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectInteger(eStorage, nPos, nValue);
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}
int MassStorage_FetchInteger(effect eStorage, string sVariableName)
{
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
    }

    return GetEffectInteger(eStorage, nPos);
}

effect MassStorage_StoreFloat(effect eStorage, string sVariableName, float fValue)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("MassStorage_StoreFloat: " + ToString(fValue));
    #endif
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectFloat(eStorage, nPos, fValue);
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName) / 5;
        nPos = GetStringLength(sTokenString);
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;

        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("storing " + sVariableName + " at position nPos: "+ IntToString(nPos));
        PrintToLog("length of token string: " +IntToString(GetStringLength(sTokenString)));
        PrintToLog("effect id: " + ToString(GetEffectID(eStorage)));
        #endif
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectFloat(eStorage, nPos, fValue);
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}
float MassStorage_FetchFloat(effect eStorage, string sVariableName)
{
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
    }

    return GetEffectFloat(eStorage, nPos);
}

effect MassStorage_StoreString(effect eStorage, string sVariableName, string sValue)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("MassStorage_StoreString: " + sValue);
    #endif
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectString(eStorage, nPos, sValue);
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName) / 5;
        nPos = GetStringLength(sTokenString);
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("storing " + sVariableName + " at position nPos: "+ IntToString(nPos));
        PrintToLog("length of token string: " +IntToString(GetStringLength(sTokenString)));
        PrintToLog("effect id: " + ToString(GetEffectID(eStorage)));
        #endif
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectString(eStorage, nPos, sValue);
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}
string MassStorage_FetchString(effect eStorage, string sVariableName)
{
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
    }

    return GetEffectString(eStorage, nPos);
}

effect MassStorage_StoreObject(effect eStorage, string sVariableName, object oValue)
{
    #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
    PrintToLog("MassStorage_StoreObject: " + GetTag(oValue));
    #endif
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        eStorage = SetEffectObject(eStorage, nPos, oValue);
    }
    else
    {
        int nLoad = GetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD);
        nLoad += GetStringLength(sVariableName) / 5;
        nPos = GetStringLength(sTokenString);
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
        #ifdef TALMUD_STORAGE_DEBUG_INTERNAL
        PrintToLog("storing " + sVariableName + " at position nPos: "+ IntToString(nPos));
        PrintToLog("length of token string: " +IntToString(GetStringLength(sTokenString)));
        PrintToLog("effect id: " + ToString(GetEffectID(eStorage)));
        #endif
        sTokenString += sVariableName;
        eStorage = SetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE, sTokenString);
        eStorage = SetEffectObject(eStorage, nPos, oValue);
        eStorage = SetEffectInteger(eStorage, TAL_MASS_STORAGE_INT_POS_LOAD, nLoad);
    }
    return eStorage;
}

object MassStorage_FetchObject(effect eStorage, string sVariableName)
{
    string sTokenString = GetEffectString(eStorage, TAL_MASS_STORAGE_STRING_POS_CACHE);
    sVariableName = TAL_STORAGE_HASH + sVariableName + TAL_STORAGE_HASH;
    int nPos = FindSubString(sTokenString, sVariableName);
    if (nPos != -1)
    {
        nPos /= 5;
        nPos += TAL_STORAGE_ARRAY_START_POSITION;
    }

    return GetEffectObject(eStorage, nPos);
}

void StoreInteger(string sCache, string sVariableName, int nValue)

{
    effect eStorage = MassStorage_GetEffect(sCache);
    eStorage = MassStorage_StoreInteger(eStorage, sVariableName, nValue);
    MassStorage_SetEffect(sCache, eStorage);
}
int FetchInteger(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    return MassStorage_FetchInteger(eStorage, sVariableName);
}

void StoreFloat(string sCache, string sVariableName, float fValue)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    eStorage = MassStorage_StoreFloat(eStorage, sVariableName, fValue);
    MassStorage_SetEffect(sCache, eStorage);
}
float FetchFloat(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    return MassStorage_FetchFloat(eStorage, sVariableName);
}

void StoreString(string sCache, string sVariableName, string sValue)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    eStorage = MassStorage_StoreString(eStorage, sVariableName, sValue);
    MassStorage_SetEffect(sCache, eStorage);
}
string FetchString(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    return MassStorage_FetchString(eStorage, sVariableName);
}

void StoreObject(string sCache, string sVariableName, object oValue)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    eStorage = MassStorage_StoreObject(eStorage, sVariableName, oValue);
    MassStorage_SetEffect(sCache, eStorage);
}
object FetchObject(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache);
    return MassStorage_FetchObject(eStorage, sVariableName);
}

void StoreLocation(string sCache, string sVariableName, location lLoc)
{
    effect eStorage = MassStorage_GetEffect(sCache, STORAGE_CACHE_TYPE_LOCATION);
    eStorage = MassStorage_StoreLocation(eStorage, sVariableName, lLoc);
    MassStorage_SetEffect(sCache, eStorage, STORAGE_CACHE_TYPE_LOCATION);
}
location FetchLocation(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache, STORAGE_CACHE_TYPE_LOCATION);
    return MassStorage_FetchLocation(eStorage, sVariableName);
}

void StoreVector(string sCache, string sVariableName, vector vPosition)
{
    effect eStorage = MassStorage_GetEffect(sCache, STORAGE_CACHE_TYPE_LOCATION);
    eStorage = MassStorage_StoreVector(eStorage, sVariableName, vPosition);
    MassStorage_SetEffect(sCache, eStorage, STORAGE_CACHE_TYPE_LOCATION);
}
vector FetchVector(string sCache, string sVariableName)
{
    effect eStorage = MassStorage_GetEffect(sCache, STORAGE_CACHE_TYPE_LOCATION);
    return MassStorage_FetchVector(eStorage, sVariableName);
}