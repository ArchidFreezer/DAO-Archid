#ifndef MK_GEOMETRY_H
#defsym MK_GEOMETRY_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "at_tools_geometry_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================  
location MK_LocationStd( object oArea, vector vPositionStd, float fFacingStd );
vector MK_GetPositionFromLocationStd(location lLocation);
vector MK_GetPositionStd(object oObject);
float MK_GetFacingStd(object oObject, int nRadians = TRUE);

float MK_FacingStdToFacingDA(float fAngleStd, int nRadians = TRUE);
float MK_VectorStdToAngleStd(vector vVectorStd, int nRadians = TRUE);
vector MK_AngleStdToVectorStd(float fAngleStd, int nRadians = TRUE);

//==============================================================================
//                                DEFINITIONS
//==============================================================================
location MK_LocationStd( object oArea, vector vPositionStd, float fFacingStd )
{
    return Location( oArea, vPositionStd, MK_FacingStdToFacingDA(fFacingStd) );        
}

vector MK_GetPositionFromLocationStd(location lLocation)
{
   vector vRet = GetPositionFromLocation(lLocation);
   //vRet = MK_PositionToStd(vRet);
   return vRet;
}

vector MK_GetPositionStd(object oObject)
{
   vector vRet = GetPosition(oObject);
   return vRet;
}

float MK_GetFacingStd(object oObject, int nRadians)
{
    float fAngle = GetFacing(oObject);
    fAngle = -fAngle;//Change to Anticlockwise
    fAngle = fAngle - 90.0;//Angle=0 at X-axis (West)
    int nAngle = FloatToInt(fAngle);
    float fRet = fAngle - nAngle;
    nAngle = nAngle % 360;
    fRet = fRet + IntToFloat(nAngle);
    if( nRadians == TRUE )
        fRet = fRet * PI/180.0;
    return fRet;
}

float MK_FacingStdToFacingDA(float fAngleStd, int nRadians = TRUE)
{
    float fRet;
    if( nRadians == TRUE )
        fAngleStd = fAngleStd*180.0/PI;
    fRet = fAngleStd + 90.0;//South axis
    fRet = -fRet;// ClockWise;
    return fRet;
}

float MK_VectorStdToAngleStd(vector vVectorStd, int nRadians)
{
    vector vPosition = AT_StdToPosition( vVectorStd );
    float fAngle = VectorToAngle( vVectorStd );
    float fAngleStd = AT_AngleToStd( fAngle );
    if( nRadians == FALSE )
        fAngleStd = fAngleStd * 180.0f / PI;
    return fAngleStd;
}

vector MK_AngleStdToVectorStd(float fAngleStd, int nRadians)
{ 
    vector vRet;

    if( nRadians == TRUE )
        vRet = Vector(cos(fAngleStd), sin(fAngleStd), 0.0);
    else
        vRet = Vector(cos(fAngleStd*PI/180.0), sin(fAngleStd*PI/180.0), 0.0); 
        
    return vRet;
}

#endif