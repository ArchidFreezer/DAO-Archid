#ifndef MK_COMMAND_MOVE_TO_LINE_OF_SIGHT_H
#defsym MK_COMMAND_MOVE_TO_LINE_OF_SIGHT_H

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command _MK_CommandMoveToLineOfSightPositionKeepDistance(object oTarget, float fMaxMove);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command _MK_CommandMoveToLineOfSightPositionKeepDistance(object oTarget, float fMaxMove)
{

    location lSelfLoc = GetLocation( OBJECT_SELF );
    location lTargetLoc = GetLocation( oTarget );
    vector vSelfPos = GetPositionFromLocation(lSelfLoc);
    vector vTargetPos = GetPositionFromLocation(lTargetLoc);
    vTargetPos.z = vTargetPos.z +1.0;

    vector vDiff = vSelfPos - vTargetPos;
    float fDiffAngle = VectorToAngle(vDiff);
    float fDiffMagnitude = GetVectorMagnitude(vDiff);

    float fEsilonRad = fMaxMove/fDiffMagnitude;
    float fEpsilon = fEsilonRad*180.0/PI;

    float fAngle1 = fDiffAngle + fEpsilon;
    float fAngle2 = fDiffAngle - fEpsilon;
    vector vAngle1 = AngleToVector(fAngle1);
    vector vAngle2 = AngleToVector(fAngle2);

    vector vNewPos1 = vTargetPos + vAngle1*fDiffMagnitude;//vSelfPos - vDiff*0.1;/*GetPositionFromLocation(GetLocation(GetHero()));*/ /*vTargetPos + vAngle1*fDiffMagnitude;*/
    vector vNewPos2 = vTargetPos + vAngle2*fDiffMagnitude;

    object oArea = GetAreaFromLocation(lSelfLoc);
    location lNewLoc1 = Location(oArea, vNewPos1, -fAngle1);
    location lNewLoc2 = Location(oArea, vNewPos2, -fAngle2);

    if( CheckLineOfSightVector(vNewPos1, vTargetPos) && IsLocationSafe(lNewLoc1))
    {
        //lNewLoc = GetSafeLocation(lSelfLoc/*lNewLoc*/);
        /*
        DisplayFloatyMessage(OBJECT_SELF, "Goto Pos1", FLOATY_MESSAGE, 0x888888, 5.0f);
        if( IsLocationValid(lNewLoc1) == FALSE )
            DisplayFloatyMessage(OBJECT_SELF, "Location Invalid", FLOATY_MESSAGE, 0x888888, 5.0f);
        else if( IsLocationSafe(lNewLoc1) == FALSE )
            DisplayFloatyMessage(OBJECT_SELF, "Location is not safe", FLOATY_MESSAGE, 0x888888, 5.0f);
        */
        return CommandMoveToLocation(lNewLoc1, TRUE, FALSE);

    }
    if( CheckLineOfSightVector(vNewPos2, vTargetPos) && IsLocationSafe(lNewLoc2))
    {
        //lNewLoc = GetSafeLocation(lNewLoc2);
        /*
        DisplayFloatyMessage(OBJECT_SELF, "Goto Pos2", FLOATY_MESSAGE, 0x888888, 5.0f);
        if( IsLocationValid(lNewLoc2) == FALSE )
            DisplayFloatyMessage(OBJECT_SELF, "Location Invalid", FLOATY_MESSAGE, 0x888888, 5.0f);
        else if( IsLocationSafe(lNewLoc2) == FALSE )
            DisplayFloatyMessage(OBJECT_SELF, "Location is not safe", FLOATY_MESSAGE, 0x888888, 5.0f);
        */
        return CommandMoveToLocation(lNewLoc2, TRUE, FALSE);
    }
    //if(  IsLocationSafe(lNewLoc1)==FALSE && IsLocationSafe(lNewLoc2)==FALSE )
    {
        //DisplayFloatyMessage(OBJECT_SELF, "Both position are not safe.", FLOATY_MESSAGE, 0xFF0000, 5.0f);
        /*
        lNewLoc1 = GetSafeLocation(lNewLoc1);
        lNewLoc2 = GetSafeLocation(lNewLoc2);
        if(  IsLocationSafe(lNewLoc1)==FALSE && IsLocationSafe(lNewLoc2)==FALSE )
            DisplayFloatyMessage(OBJECT_SELF, "Position correction failed.", FLOATY_MESSAGE, 0xFF0000, 5.0f);

        if( CheckLineOfSightVector(vNewPos1, vTargetPos) && IsLocationSafe(lNewLoc1))
            return CommandMoveToLocation(lNewLoc1, TRUE, FALSE);
        if( CheckLineOfSightVector(vNewPos2, vTargetPos) && IsLocationSafe(lNewLoc2))
            return CommandMoveToLocation(lNewLoc2, TRUE, FALSE);
        */

    }
    command cInvalid;
    return cInvalid;
}
#endif