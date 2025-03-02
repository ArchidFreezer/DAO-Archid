#ifndef MK_OTHER_H
#defsym MK_OTHER_H

//==============================================================================
//                          INCLUDES
//==============================================================================
#include "mk_constants_h"

// Talmud Storage
#include "talmud_storage_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
int _MK_PartyMemberID(object oPartyMember = OBJECT_SELF);
int MK_GetPartyMemberIndex(object oPartyMember = OBJECT_SELF);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
int _MK_PartyMemberID(object oPartyMember)
{
    return MK_GetPartyMemberIndex(oPartyMember);
}

int MK_GetPartyMemberIndex(object oPartyMember)
{
    int ID = StringToInt(ObjectToString(oPartyMember));    
    int[] arrRegisteredIndex = FetchIntegerArray(MK_PARTY_MEMBER_INDEX_TABLE);
    int nSize = GetArraySize(arrRegisteredIndex);
    
    int idx;
    for(idx=0; idx<nSize; idx++)
    {
        if( arrRegisteredIndex[idx] == ID )
            return idx;  
    } 
    
    StoreIntegerInArray(MK_PARTY_MEMBER_INDEX_TABLE, ID);
    return nSize;    
}


#endif