#ifndef _MK_GET_RANGE_FROM_ID_H
#defsym _MK_GET_RANGE_FROM_ID_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "mk_constants_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
float _MK_GetRangeFromID(int nRangeID);

//==============================================================================
//                               DEFINITIONS
//==============================================================================
float _MK_GetRangeFromID(int nRangeID)
{
    float fRet = 0.0;
    switch( nRangeID )
    {
        case MK_RANGE_ID_SHORT: fRet = MK_RANGE_SHORT; break;
        case MK_RANGE_ID_MEDIUM: fRet = MK_RANGE_MEDIUM; break;
        case MK_RANGE_ID_LONG: fRet = MK_RANGE_LONG; break;
        case MK_RANGE_ID_DOUBLE_SHORT: fRet = MK_RANGE_DOUBLE_SHORT; break;
        case MK_RANGE_ID_DOUBLE_MEDIUM: fRet = MK_RANGE_DOUBLE_MEDIUM; break;
        case MK_RANGE_ID_BOW: fRet = MK_RANGE_BOW; break;
    }
    return fRet;
}

#endif