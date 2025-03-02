#include "ai_constants_h"
#include "mk_constants_h"
#include "mk_constants_ai_h"

//==============================================================================
//                              DEFINITIONS
//==============================================================================
//******************************************************************************
int[] TF_GetFriendlyTargetTypes()
{
    int i = 0;
    int[] arTargetTypes;
    arTargetTypes[i++] = AI_TARGET_TYPE_SELF;
    arTargetTypes[i++] = AI_TARGET_TYPE_ALLY;
    arTargetTypes[i++] = MK_TARGET_TYPE_PARTY_MEMBER;
    arTargetTypes[i++] = MK_TARGET_TYPE_TEAM_MEMBER;
    arTargetTypes[i++] = MK_TARGET_TYPE_TEAMMATE;

    return arTargetTypes;
}

//******************************************************************************
int[] TF_GetRangeIds()
{
    int i = 0;
    int[] arRangeIds;
    arRangeIds[i++] = MK_RANGE_ID_SHORT;
    arRangeIds[i++] = MK_RANGE_ID_DOUBLE_SHORT;
    arRangeIds[i++] = MK_RANGE_ID_MEDIUM;

    return arRangeIds;
}

//******************************************************************************
//void main(){GetFriendlyTargetTypes(); GetRangeIds();}