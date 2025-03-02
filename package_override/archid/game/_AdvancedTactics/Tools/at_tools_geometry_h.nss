#ifndef AT_TOOLS_GEOMETRY_H
#defsym AT_TOOLS_GEOMETRY_H
/*
    Advanced Tactics geometry tools

    Std :
    Horizontal X axis point to West
    Vertical Y axis point to Nord

    Angle from [0, 2pi[ Anticlockwise.
    ([0, 360[ if expressed in degree)
*/

vector AT_PositionToStd(vector vPos)
{
    return Vector(-vPos.y, vPos.x, vPos.z);
}

vector AT_StdToPosition(vector vPos)
{
    return Vector(vPos.y, -vPos.x, vPos.z);
}

float AT_ToRadians(float fAngle)
{
     return (fAngle*PI/180.0);
}
   
float AT_AngleToStd(float fAngle)
{
    int nAngle = FloatToInt(fAngle);
    float fRet = fAngle - nAngle;

    nAngle = (nAngle + 180) % 360;
    fRet += nAngle;

    return AT_ToRadians(fRet);
}

float ToDegree(float fRadians)
{
    return (fRadians * 180.0f / PI);
}
float AT_ToDegree(float fRadians)
{                             
    return ToDegree( fRadians );   
}
float AT_StdToAngle(float fAngle)
{
    float fRet = ToDegree(fAngle);
    int nAngle = FloatToInt(fRet);
    fRet = fRet - nAngle;

    nAngle %= 360;
    fRet += nAngle;

    return (fRet - 180.0f);
}

#endif