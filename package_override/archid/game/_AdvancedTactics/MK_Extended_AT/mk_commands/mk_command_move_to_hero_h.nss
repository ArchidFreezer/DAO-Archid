#ifndef MK_COMMAND_MOVE_TO_HERO_H
#defsym MK_COMMAND_MOVE_TO_HERO_H

//==============================================================================
//                                INCLUDES
//==============================================================================
/* Core */
#include "ai_main_h_2"
/* Advanced Tactics */
#include "at_tools_ai_h"
#include "at_tools_geometry_h"
/* MkBot */
#include "mk_party_member_index_h"
#include "mk_geometry_h"
#include "mk_constants_h"
/* Talmud Storage*/
#include "talmud_storage_h"

//==============================================================================
//                                DECLARATIONS
//==============================================================================
command _MK_AI_MoveToTarget(object oTarget, int nLastCommandStatus, float fDistance=3.5, int nStandInFormation=TRUE);

location MK_GetLocationInFormation_Vanilia(object oTarget);

//==============================================================================
//                                DEFINITIONS
//==============================================================================

command _MK_AI_MoveToTarget(object oTarget, int nLastCommandStatus, float fDistance, int nStandInFormation)
{
    command cRet;
    if(GetGameMode() != GM_COMBAT)
        return cRet;

    if( AT_IsControlled(OBJECT_SELF) == TRUE || oTarget == OBJECT_SELF || IsDead(oTarget) )
        return cRet;

    float fCurrentDistance = GetDistanceBetween(OBJECT_SELF, oTarget);
    // Incoming AOE system
    if ((IsStealthy(oTarget) != TRUE)
    &&  (AI_BehaviorCheck_AvoidAOE() != TRUE || _AT_IsAOEValid(_AT_GetAOEOnCreature(oTarget)) != TRUE) )
    {
        if( fCurrentDistance > fDistance + 1 )
        {
            cRet = CommandMoveToObject(oTarget, TRUE, fDistance, FALSE);
        }else if( fCurrentDistance > 2.5 && nStandInFormation == TRUE )
        {
            /*
            location lTargetLoc = GetLocation(oTarget);
            vector vTargetPos = GetPositionFromLocation(lTargetLoc);
            vector vTargetOrientation = GetOrientationFromLocation(lTargetLoc);
            float fTargetOrientation = VectorToAngle(vTargetOrientation);
            float fTargetFacing = GetFacing(oTarget);//VectorToAngle( vHeroOrientation );

            vector vNewPos;
            int nId = MK_GetPartyMemberIndex();
            if( nId == 3 )
            {
              float fAngle = fTargetOrientation - 180.0;
              vNewPos = vTargetPos + AngleToVector(fAngle)*1.5;
            }else
            {
                object[] arAllies = GetPartyList();

                float fAngle1 = fTargetOrientation - 120.0;
                float fAngle2 = fTargetOrientation + 120.0;
                vector vNewPos1 = vTargetPos + AngleToVector(fAngle1)*1.5;
                vector vNewPos2 = vTargetPos + AngleToVector(fAngle2)*1.5;

                vector vMyPos = GetPosition(OBJECT_SELF);
                vector vHisPos;
                if( nId == 1 )
                    vHisPos = GetPosition(arAllies[2]);
                else
                    vHisPos = GetPosition(arAllies[1]);

                float fMyDistToNewPos1 = GetVectorMagnitude(vNewPos1 - vMyPos);
                float fMyDistToNewPos2 = GetVectorMagnitude(vNewPos2 - vMyPos);

                float fHisDistToNewPos1 = GetVectorMagnitude(vNewPos1 - vHisPos);
                float fHisDistToNewPos2 = GetVectorMagnitude(vNewPos2 - vHisPos);

                if( fMyDistToNewPos1 < fHisDistToNewPos1 )
                    vNewPos = vNewPos1;
                else
                    vNewPos = vNewPos2;

            }

            location lFollowerNewLocation = Location(GetArea(OBJECT_SELF), vNewPos, fTargetFacing);
            */
            location lFollowerNewLocation = MK_GetLocationInFormation_Vanilia(oTarget);
            cRet = CommandMoveToLocation(lFollowerNewLocation, TRUE);

        }
    }
    //DisplayFloatyMessage(OBJECT_SELF, FloatToString(fCurrentDistance));
    return cRet;

}

location MK_GetLocationInFormation_Vanilia(object oTarget)
{

    location lTargetLoc = GetLocation(oTarget);
    //Get target Facing
    float fTargetFacingStd = MK_GetFacingStd(oTarget);
    // Target XYZ coordinates as vector [x,y,z]
    vector vTargetPosStd = MK_GetPositionFromLocationStd(lTargetLoc);
    // TargetTarget XY coordinates as complex number: fTargetMagnitude[m] and fTargetAngleStd[deg]
    float fTargetMagnitude = GetVectorMagnitude(vTargetPosStd);
    float fTargetAngleStd = MK_VectorStdToAngleStd(vTargetPosStd);


    vector vFollowerPosStd;
    int nId = MK_GetPartyMemberIndex();
    if( nId == 3 )
    {
      float fFormationAngleStd = fTargetFacingStd - PI;//180[deg]
      vector vFormationVectorStd = MK_AngleStdToVectorStd(fFormationAngleStd)*1.5;
      vFollowerPosStd = vTargetPosStd + vFormationVectorStd;
    }else
    {
        object[] arAllies = GetPartyList();

        float fFormationAngleStd1 = fTargetFacingStd - 120.0*PI/180.0;//120[deg]
        float fFormationAngleStd2 = fTargetFacingStd + 120.0*PI/180.0;//120[deg]
        vector vFormationVectorStd1 = MK_AngleStdToVectorStd(fFormationAngleStd1)*1.5;
        vector vFormationVectorStd2 = MK_AngleStdToVectorStd(fFormationAngleStd2)*1.5;

        vector vNewPosStd1 = vTargetPosStd + vFormationVectorStd1;
        vector vNewPosStd2 = vTargetPosStd + vFormationVectorStd2;

        vector vMyPosStd = MK_GetPositionStd(OBJECT_SELF);
        vector vHisPosStd;
        if( nId == 1 )
            vHisPosStd = MK_GetPositionStd(arAllies[2]);
        else
            vHisPosStd = MK_GetPositionStd(arAllies[1]);

        float fMyDistToNewPos1 = GetVectorMagnitude(vNewPosStd1 - vMyPosStd);
        float fMyDistToNewPos2 = GetVectorMagnitude(vNewPosStd2 - vMyPosStd);

        float fHisDistToNewPos1 = GetVectorMagnitude(vNewPosStd1 - vHisPosStd);
        float fHisDistToNewPos2 = GetVectorMagnitude(vNewPosStd2 - vHisPosStd);

        if( fMyDistToNewPos1 < fHisDistToNewPos1 )
            vFollowerPosStd = vNewPosStd1;
        else
            vFollowerPosStd = vNewPosStd2;

    }

    location lFollowerNewLocation = MK_LocationStd( GetArea(OBJECT_SELF), vFollowerPosStd, fTargetFacingStd );
    return   lFollowerNewLocation;

}

#endif