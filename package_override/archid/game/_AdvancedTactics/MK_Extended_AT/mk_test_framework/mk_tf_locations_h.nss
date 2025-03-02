#ifndef MK_TEST_FRAMEWORK_LOCATIONS_H
#defsym MK_TEST_FRAMEWORK_LOCATIONS_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "mk_constants_h"

//==============================================================================
//                              CONSTANTS
//==============================================================================
const int TF_RANGE_BIAS = 1;

//==============================================================================
//                                DECLARATIONS
//==============================================================================
location TF_GetStartLoc();
location TF_GetLocNearShortRange();
location TF_GetLocNear2xShortRange();
location TF_GetLocNearMediumRange();
location TF_GetLocAtDistance(float fDist);

//==============================================================================
//                              DEFINITIONS
//==============================================================================
//******************************************************************************
location TF_GetStartLoc()
{
    object oWaypoint = GetObjectByTag("wp_start");
    return GetLocation(oWaypoint);
}

//******************************************************************************
location TF_GetLocNearShortRange()
{
    return TF_GetStartLoc();
}

//******************************************************************************
location TF_GetLocNear2xShortRange()
{
    location lLocAt2xShort = TF_GetLocAtDistance(MK_RANGE_DOUBLE_SHORT);
    vector vPosAt2xShort = GetPositionFromLocation(lLocAt2xShort);
    vPosAt2xShort.x = vPosAt2xShort.x - 2.0;

    return Location(GetAreaFromLocation(lLocAt2xShort), vPosAt2xShort, GetFacingFromLocation(lLocAt2xShort));
}

//******************************************************************************
location TF_GetLocNearMediumRange()
{
    location lLocAtMedium = TF_GetLocAtDistance(MK_RANGE_MEDIUM);
    vector vPosAtMedium = GetPositionFromLocation(lLocAtMedium);
    vPosAtMedium.x = vPosAtMedium.x - 2.0;

    return Location(GetAreaFromLocation(lLocAtMedium), vPosAtMedium, GetFacingFromLocation(lLocAtMedium));
}

//******************************************************************************
location TF_GetLocAtDistance(float fDist)
{
    location lLoc = TF_GetStartLoc();

    object oArea = GetAreaFromLocation(lLoc);
    vector vPosition = GetPositionFromLocation(lLoc);
    vPosition.y += fDist - TF_RANGE_BIAS;

    return Location(oArea, vPosition, DIRECTION_SOUTH);
}

//******************************************************************************
//void main(){TF_GetLocNear2xShortRange();TF_GetLocNearMediumRange();TF_GetLocAtDistance(10.0);}
#endif
