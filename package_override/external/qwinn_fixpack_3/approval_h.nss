// approval_h

/** @addtogroup scripting_approval Scripting Approval
*
* These are the main system's functions - used mostly to handle approval rating in dialogs or by item gifting
*/
/** @{*/

#include "plt_genpt_app_alistair"
#include "plt_genpt_app_dog"
#include "plt_genpt_app_leliana"
#include "plt_genpt_app_loghain"
#include "plt_genpt_app_morrigan"
#include "plt_genpt_app_oghren"
#include "plt_genpt_app_shale"
#include "plt_genpt_app_sten"
#include "plt_genpt_app_wynne"
#include "plt_genpt_app_zevran"
#include "2da_constants_h"
#include "global_objects_h"
#include "log_h"
#include "wrappers_h"
#include "ui_h"
#include "party_h"
#include "plt_tut_approval_warm"

// Follower constants - any follower that can be affected by approval
const int APP_FOLLOWER_ALISTAIR = 1;
const int APP_FOLLOWER_DOG = 2;
const int APP_FOLLOWER_MORRIGAN = 3;
const int APP_FOLLOWER_WYNNE = 4;
const int APP_FOLLOWER_SHALE = 5;
const int APP_FOLLOWER_STEN = 6;
const int APP_FOLLOWER_ZEVRAN = 7;
const int APP_FOLLOWER_OGHREN = 8;
const int APP_FOLLOWER_LELIANA = 9;
const int APP_FOLLOWER_LOGHAIN = 10;

// Approval bonus ranges
const int APP_BONUS_1 = 25;
const int APP_BONUS_2 = 50;
const int APP_BONUS_3 = 75;
const int APP_BONUS_4 = 90;

// bonuses:
// Alistair: Constitution
// Dog: Dexterity
// Sten: Strength
// Leliana: Intelligence
// Morrigan: Magic
// Wynne: Will
// Oghren: Constitution
// Loghain: Strength
// Zevran: Dexterity


/** @brief Initialize the approval system
*
* This includes reading the ranges values from the 2da level for each log system
*
* @author Yaron
*/
void Approval_Init();

/** @brief Returns the approval range limit value for a certain approval range
*
* Returns the approval range limit value for a certain approval range.
* For exampme: the result for APP_RANGE_HOSTILE should be -26.
*
* @param nRange APP_RANGE_*** constant - the range we are checking the limit for
* @returns the approval value for a specific range
* @author Yaron
*/
int Approval_GetNormalApprovalRangeValue(int nRange);

/** @brief Returns the approval range limit value for a certain ROMANCE approval range
*
* Returns the approval range limit value for a certain ROMANCE approval range
*
* @param nRange APP_ROMANCE_RANGE_*** constants - the range we are checking the limit for
* @returns the approval value for a specific range
* @author Yaron
*/
int Approval_GetRomanceApprovalRangeValue(int nRange);

/** @brief Returns the approval rating range for the follower
*
* This function might return values in the 'romance' range - any code that uses this function should
* also check the 'romance active' flag.
*
* @param nFollower the follower whose approval range we check
* @returns the approval of the follower - return value can be APP_RANGE_CRISIS, APP_RANGE_HOSTILE etc�
* @author Yaron
*/
int Approval_GetApprovalRange(int nFollower);

/** @brief Gift an item to a follower: destorying the item and adjusting approval rating if needed
*
* Gift an item to a follower: destorying the item and adjusting approval rating if needed
*
* @param nFollower the follower who we want to give the gift to
* @param oItem the item being gifted
* @author Yaron
*/
int Approval_HandleGift(int nFollower, object oItem);

/** @brief Changes the approval rating of nFollower by nChange (positive or negative)
*
* Changes the approval rating of oFollower by nChange (positive or negative)
*
* @param nFollower the follower whose approval we want to change
* @param nChange the approval change value
* @author Yaron
*/
void Approval_ChangeApproval(int nFollower, int nChange);

/** @brief Sets a oFollower's approval to 0
*
* Sets a nFollower's approval to 0
*
* @param nFollower the follower whose approval we want to change
* @author Yaron
*/
void Approval_SetToZero(int nFollower);

/** @brief Returns the approval rating of oFollower
*
* Returns the approval rating of nFollower
*
* @param nFollower the follower whose approval we want to get
* @returns the approval value of the follower
* @author Yaron
*/
int Approval_GetApproval(int nFollower);

/** @brief Sets or unsets the romance status for oFollower
*
* Sets or unsets the romance status for oFollower
*
* @param nFollower the follower whose romance status we want to change
* @param nStatus TRUE to set it active, FALSE to set it inactive
* @sa Approval_GetRomanceActive
* @author Yaron
*/
void Approval_SetRomanceActive(int nFollower, int nStatus);

/** @brief Returns the romace status of a follower
*
* Returns the romace status of a follower
*
* @param nFollower the follower whose romance status we want to get
* @returns the romace status of the follower (TRUE if active, FALSE if inactive)
* @sa Approval_GetRomanceActive
* @author Yaron
*/
int Approval_GetRomanceActive(int nFollower);

/** @brief Allows the follower to advance to the 'friendly' range
*
* Allows the follower to advance to the 'friendly' range
*
* @param nFollower the follower who we want to enable the friendly status
* @sa Approval_GetFriendlyEligible
* @author Yaron
*/
void Approval_SetFriendlyEligible(int nFollower, int nStatus = TRUE);

/** @brief Returns the friendly status of a follower
*
* Returns the friendly status of a follower
*
* @param nFollower the follower who we want to get the friendly status
* @returns TRUE if friendly eligible, FALSE if not
* @sa Approval_SetFriendlyEligible
* @author Yaron
*/
int Approval_GetFriendlyEligible(int nFollower);

/** @brief Allows the follower to advance to the 'love' range
*
* Allows the follower to advance to the 'love' range
*
* @param nFollower the follower who we want to enable the love status
* @sa Approval_GetLoveEligible
* @author Yaron
*/
void Approval_SetLoveEligible(int nFollower, int nStatus = TRUE);

/** @brief Returns the love status of a follower
*
* Returns the love status of a follower
*
* @param nFollower the follower who we want to get the love status
* @returns TRUE if love eligible, FALSE if not
* @sa Approval_SetLoveEligible
* @author Yaron
*/
int Approval_GetLoveEligible(int nFollower);

/** @brief Checks if a specific approval range is valid for a follower (romance or not)
*
* A range is valid if the follower's approval is inside the range or higher.
* For example: if the approval is friendly and I check for neutral then it should
* still return TRUE.
*
* @param nFollower the follower whose approval range we check
* @param nRange the level of approval we want to check the follower for (APP_RANGE_***)
* @param bRomanceTable TRUE if we check the romance table, FALSE if we check the normal approval table
* @returns TRUE if within the range, FALSE if not
* @author Yaron
*/
int Approval_IsRangeValid(int nFollower, int nRange, int bRomanceTable);

// Qwinn - added these two functions, flag to turn off notifications, so far to Morrigan only, for before
// she is officially recruited, and ApprovalFromZero so approval gets backed out and readded
// for correct notification at point of recruitment
int Approval_GetApprovalNotification(int nFollower);
int Approval_GetApprovalFromZero(int nFollower);

void Approval_AddFollowerGiftCodex(int nFollower);

string Approval_GetFollowerPlot(int nFollower);
int Approval_GetFollowerRomanceFlag(int nFollower);
int Approval_GetFollowerLoveEligFlag(int nFollower);
int Approval_GetFollowerFriendEligFlag(int nFollower);
int Approval_GetFollowerCutOffFlag(int nfollower);
string Approval_GetFollowerGiftCountVar(int nFollower);
string Approval_GetFollowerName(int nFollower);
int Approval_GetApprovalRangeID(int nFollower);

/*******************************************************************************
/*                        FUNCTION DEFINITIONS
/******************************************************************************/

object Approval_GetFollowerObject(int nFollower)
{
    string sFollowerTag;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: sFollowerTag = GEN_FL_ALISTAIR; break;
        case APP_FOLLOWER_DOG: sFollowerTag = GEN_FL_DOG; break;
        case APP_FOLLOWER_MORRIGAN: sFollowerTag = GEN_FL_MORRIGAN; break;
        case APP_FOLLOWER_WYNNE: sFollowerTag = GEN_FL_WYNNE; break;
        case APP_FOLLOWER_SHALE: sFollowerTag = GEN_FL_SHALE; break;
        case APP_FOLLOWER_STEN: sFollowerTag = GEN_FL_STEN; break;
        case APP_FOLLOWER_ZEVRAN: sFollowerTag = GEN_FL_ZEVRAN; break;
        case APP_FOLLOWER_OGHREN: sFollowerTag = GEN_FL_OGHREN; break;
        case APP_FOLLOWER_LELIANA: sFollowerTag = GEN_FL_LELIANA; break;
        case APP_FOLLOWER_LOGHAIN: sFollowerTag = GEN_FL_LOGHAIN; break;
    }

    return Party_GetFollowerByTag(sFollowerTag);
}

int Approval_CheckFollowerBonusAbility(int nFollower, int nBonusRank)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_CheckFollowerBonusAbility", "follower: " + IntToString(nFollower) + ", bonus rank: " + IntToString(nBonusRank));
    string sColumn = "bonus" + IntToString(nBonusRank);
    int nAbility = GetM2DAInt(TABLE_APP_FOLLOWER_BONUSES, sColumn, nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    return HasAbility(oFollower, nAbility);
}

void Approval_AddFollowerBonusAbility(int nFollower, int nBonusRank)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_AddFollowerBonusAbility", "follower: " + IntToString(nFollower) + ", bonus rank: " + IntToString(nBonusRank));
    string sColumn = "bonus" + IntToString(nBonusRank);
    int nAbility = GetM2DAInt(TABLE_APP_FOLLOWER_BONUSES, sColumn, nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    if(!HasAbility(oFollower, nAbility))
    {
        AddAbility(oFollower, nAbility, TRUE);
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_AddFollowerBonusAbility", "follower: " + GetTag(oFollower) + ", add ability: " + IntToString(nAbility));
    }

}

void Approval_RemoveFollowerBonusAbility(int nFollower, int nBonusRank)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_AddFollowerBonusAbility", "follower: " + IntToString(nFollower) + ", bonus rank: " + IntToString(nBonusRank));
    string sColumn = "bonus" + IntToString(nBonusRank);
    int nAbility = GetM2DAInt(TABLE_APP_FOLLOWER_BONUSES, sColumn, nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    RemoveAbility(oFollower, nAbility);
}


void Approval_Init()
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_Init", "##############################################");
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_Init", "APPROVAL SYSTEM INIT");
    SetLocalInt(GetModule(), APP_RANGE_VALUE_CRISIS, Approval_GetNormalApprovalRangeValue(APP_RANGE_CRISIS));
    SetLocalInt(GetModule(), APP_RANGE_VALUE_HOSTILE, Approval_GetNormalApprovalRangeValue(APP_RANGE_HOSTILE));
    SetLocalInt(GetModule(), APP_RANGE_VALUE_NEUTRAL, Approval_GetNormalApprovalRangeValue(APP_RANGE_NEUTRAL));
    SetLocalInt(GetModule(), APP_RANGE_VALUE_WARM, Approval_GetNormalApprovalRangeValue(APP_RANGE_WARM));
    SetLocalInt(GetModule(), APP_RANGE_VALUE_FRIENDLY, Approval_GetNormalApprovalRangeValue(APP_RANGE_FRIENDLY));
    SetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_INTERESTED, Approval_GetRomanceApprovalRangeValue(APP_ROMANCE_RANGE_INTERESTED));
    SetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_CARE, Approval_GetRomanceApprovalRangeValue(APP_ROMANCE_RANGE_CARE));
    SetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_ADORE, Approval_GetRomanceApprovalRangeValue(APP_ROMANCE_RANGE_ADORE));
    SetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_LOVE, Approval_GetRomanceApprovalRangeValue(APP_ROMANCE_RANGE_LOVE));
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_Init", "##############################################");
}

int Approval_GetApproval(int nFollower)
{
    //string sVar = Approval_GetFollowerApprovalVar(nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    int nApproval = GetFollowerApproval(oFollower);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetApproval", "FOLLOWER: " + Approval_GetFollowerName(nFollower) + ", APPROVAL: " + IntToString(nApproval));
    return nApproval;
}

int Approval_GetNormalApprovalRangeValue(int nRange)
{
    int nRet = APP_RANGE_INVALID;
    nRet = GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", nRange);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetNormalApprovalRangeValue", "Getting NORMAL range for range <"
        + IntToString(nRange) + "> : " + IntToString(nRet));
    return nRet;
}

int Approval_GetRomanceApprovalRangeValue(int nRange)
{
    int nRet = APP_RANGE_INVALID;
    nRet = GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", nRange);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetRomanceApprovalRangeValue", "Getting ROMANCE range for range <"
        + IntToString(nRange) + "> : " + IntToString(nRet));
    return nRet;
}

int Approval_GetApprovalRange(int nFollower)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetApprovalRange", "Getting approval range of follower: " + IntToString(nFollower));

    object oFollower = Approval_GetFollowerObject(nFollower);
    int nApproval = GetFollowerApproval(oFollower);

    int nRange = APP_RANGE_INVALID;
    int nCrisisRange = GetLocalInt(GetModule(), APP_RANGE_VALUE_CRISIS);
    int nHostileRange = GetLocalInt(GetModule(), APP_RANGE_VALUE_HOSTILE);
    int nNeutralRange = GetLocalInt(GetModule(), APP_RANGE_VALUE_NEUTRAL);
    int nWarmRange = GetLocalInt(GetModule(), APP_RANGE_VALUE_WARM);
    int nFriendlyRange = GetLocalInt(GetModule(), APP_RANGE_VALUE_FRIENDLY);
    int nInterestedRange = GetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_INTERESTED);
    int nCareRange = GetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_CARE);
    int nAdoreRange = GetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_ADORE);
    int nLoveRange = GetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_LOVE);

    if(!Approval_GetRomanceActive(nFollower)) // no romance - normal table
    {
        if(nApproval == nCrisisRange) nRange = nCrisisRange;
        else if(nApproval > nCrisisRange && nApproval <= nHostileRange) nRange = nHostileRange;
        else if(nApproval > nHostileRange && nApproval <= nNeutralRange) nRange = nNeutralRange;
        else if(nApproval > nNeutralRange && nApproval <= nWarmRange) nRange = nWarmRange;
        else if(nApproval > nWarmRange && nApproval <= nFriendlyRange) nRange = nFriendlyRange;
    }
    else // romance active - special table
    {
        if(nApproval == nCrisisRange) nRange = nCrisisRange;
        else if(nApproval > nCrisisRange && nApproval <= nHostileRange) nRange = nHostileRange;
        else if(nApproval > nHostileRange && nApproval <= nNeutralRange) nRange = nNeutralRange;
        else if(nApproval > nNeutralRange && nApproval <= nInterestedRange) nRange = nInterestedRange;
        else if(nApproval > nInterestedRange && nApproval <= nCareRange) nRange = nCareRange;
        else if(nApproval > nCareRange && nApproval <= nAdoreRange) nRange = nAdoreRange;
        else if(nApproval > nAdoreRange && nApproval <= nLoveRange) nRange = nLoveRange;
    }

    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetApprovalRange", "Approval range check, FOLLOWER: " + Approval_GetFollowerName(nFollower) + ", RANGE: " + IntToString(nRange));
    return nRange;
}

void Approval_SetToZero(int nFollower)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetToZero", "Setting follower approval to ZERO, FOLLOWER: " + Approval_GetFollowerName(nFollower));
    int nCurrentApproval = Approval_GetApproval(nFollower);
    int nChange = 0 - nCurrentApproval;
    Approval_ChangeApproval(nFollower, nChange);
}

void Approval_ChangeApproval(int nFollower, int nChange)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_ChangeApproval", "FOLLOWER: " + IntToString(nFollower) + ", CHANGE: " + IntToString(nChange));
    //string sVar = Approval_GetFollowerApprovalVar(nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    int nApproval = GetFollowerApproval(oFollower);
    int nOldApproval = nApproval;
    nApproval += nChange;
    if(nApproval < -100) nApproval = -100;
    if(nApproval > 100) nApproval = 100;

    // Qwinn:  Next few lines used to be below the "Verify new ranges" if-else-else, moved up.
    // Qwinn:  Added this for Morrigan pre-recruit approval to not show up until recruited
    if (Approval_GetApprovalFromZero(nFollower))
    {
       AdjustFollowerApproval(oFollower, -nOldApproval, FALSE);
       nChange = nApproval;
    }
    else
       nChange = nApproval - nOldApproval;

    // Qwinn
    // AdjustFollowerApproval(oFollower, nChange, TRUE);
    AdjustFollowerApproval(oFollower, nChange, Approval_GetApprovalNotification(nFollower));

    // Verify new ranges:
    // Player can get to 'friendly' only if he is eligible
    // Player can get to 'in love' only if he is eligible
    if(!Approval_GetRomanceActive(nFollower) && nApproval > GetLocalInt(GetModule(), APP_RANGE_VALUE_WARM))
    {
        // Trying to get to the 'friendly' range
        // if elig flag set then set GUI tag to 'friendly'
        if(Approval_GetFriendlyEligible(nFollower))
        {
            int nStringRef = GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "StringRef", APP_RANGE_FRIENDLY);
            SetFollowerApprovalDescription(oFollower, nStringRef);
        }

    }
    else if(Approval_GetRomanceActive(nFollower) && nApproval > GetLocalInt(GetModule(), APP_ROMANCE_RANGE_VALUE_ADORE))
    {
        // Trying to get to the in love range
        // if elig flag set then set GUI tag to 'in love'
        if(Approval_GetFriendlyEligible(nFollower))
        {
            int nStringRef = GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "StringRef", APP_ROMANCE_RANGE_LOVE);
            SetFollowerApprovalDescription(oFollower, nStringRef);
        }

    }
    else // dealing with lower range approvals - clear to change tag
    {
        int nRange = Approval_GetApprovalRangeID(nFollower);
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_ChangeApproval", "Approval range: " + IntToString(nRange));
        int nStringRef;
        // Qwinn changed to get HOSTILE and NEUTRAL to show for romance range.
        // if(Approval_GetRomanceActive(nFollower))
        if(Approval_GetRomanceActive(nFollower) && nApproval > GetLocalInt(GetModule(), APP_RANGE_VALUE_NEUTRAL))
            nStringRef = GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "StringRef", nRange);
        else
            nStringRef = GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "StringRef", nRange);
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_ChangeApproval", "Approval tag string ref: " + IntToString(nStringRef));

        SetFollowerApprovalDescription(oFollower, nStringRef);
    }

    /* Qwinn:  The following two lines are moved up to above the preceding block setting the approval description,
       because to do it after makes it not update properly.  Several other changes are made to them.
    nChange = nApproval - nOldApproval;
    AdjustFollowerApproval(oFollower, nChange, TRUE);
    */



    //SetLocalInt(GetModule(), sVar, nApproval);
    if(nApproval != nOldApproval)
    {
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_ChangeApproval", "Changed approval - old value: " + IntToString(nOldApproval) + " new value: " + IntToString(nApproval));
        // check bonus
        if(nChange > 0) // increase - bonuses might be added
        {
            if(nApproval > GetLocalInt(GetModule(), APP_RANGE_VALUE_NEUTRAL))
            {
                WR_SetPlotFlag(PLT_TUT_APPROVAL_WARM, TUT_APPROVAL_WARM_1, TRUE);
                // tutorial
            }

            if(nApproval >= APP_BONUS_1 && nApproval < APP_BONUS_2)
            {
                Approval_AddFollowerBonusAbility(nFollower, 1);
                Approval_AddFollowerGiftCodex(nFollower);
            }
            else if(nApproval >= APP_BONUS_2 && nApproval < APP_BONUS_3)
            {
                Approval_AddFollowerBonusAbility(nFollower, 1);
                Approval_AddFollowerBonusAbility(nFollower, 2);
            }
            else if(nApproval >= APP_BONUS_3 && nApproval < APP_BONUS_4)
            {
                Approval_AddFollowerBonusAbility(nFollower, 1);
                Approval_AddFollowerBonusAbility(nFollower, 2);
                Approval_AddFollowerBonusAbility(nFollower, 3);
            }
            else if(nApproval >= APP_BONUS_4)
                Approval_AddFollowerBonusAbility(nFollower, 4);
        }
        else // decrease - bonuses might be lost
        {
            if(nApproval < APP_BONUS_1)
            {
                Approval_RemoveFollowerBonusAbility(nFollower, 1);
                Approval_RemoveFollowerBonusAbility(nFollower, 2);
                Approval_RemoveFollowerBonusAbility(nFollower, 3);
                Approval_RemoveFollowerBonusAbility(nFollower, 4);
            }
            else if(nApproval < APP_BONUS_2)
            {
                Approval_RemoveFollowerBonusAbility(nFollower, 2);
                Approval_RemoveFollowerBonusAbility(nFollower, 3);
                Approval_RemoveFollowerBonusAbility(nFollower, 4);
            }
            else if(nApproval < APP_BONUS_3)
            {
                Approval_RemoveFollowerBonusAbility(nFollower, 3);
                Approval_RemoveFollowerBonusAbility(nFollower, 4);
            }
            else if(nApproval < APP_BONUS_4)
                Approval_RemoveFollowerBonusAbility(nFollower, 4);


        }
        //UI_DisplayApprovalChangeMessage(oFollower, nChange);
    }
    else
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_ChangeApproval", "Approval NOT changed - not eligible for new range!");
}

void Approval_SetRomanceActive(int nFollower, int nStatus)
{
    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerRomanceFlag(nFollower);
    int nCutOffFlag = Approval_GetFollowerCutOffFlag(nFollower);
    object oFollower = Approval_GetFollowerObject(nFollower);
    int nStringRef;
    if(nFlag != -1)
        WR_SetPlotFlag(sPlot, nFlag, nStatus, FALSE);

    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetRomanceActive", "FOLLOWER: " + Approval_GetFollowerName(nFollower) + ", CHANGING ROMANCE STATUS TO: " + IntToString(nStatus));

    if(nStatus == FALSE)
    {
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetRomanceActive", "Romance is now INACTIVE");
        // If disabling romance and the player is not eligible for friendly, while being in the 'friendly' range,
        // than the approval rating should go down just below the 'friendly' range.
        if(Approval_GetApproval(nFollower) > GetLocalInt(GetModule(), APP_RANGE_VALUE_WARM)
            && !Approval_GetFriendlyEligible(nFollower))
        {
            int nLowerRate = GetLocalInt(GetModule(), APP_RANGE_VALUE_WARM) - Approval_GetApproval(nFollower) - 1; // this should lower to 1 below the friendly range
            Approval_ChangeApproval(nFollower, nLowerRate);
            Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetRomanceActive", "Romance disabled while approval is lower than 'friendly' - lowered approval to " + IntToString(Approval_GetApproval(nFollower)));
        }
        // update GUI
        int nRange = Approval_GetApprovalRangeID(nFollower);
        nStringRef = GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "StringRef", nRange);
        SetFollowerApprovalDescription(oFollower, nStringRef);
    }
    else
    {
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetRomanceActive", "Romance is now ACTIVE");
        WR_SetPlotFlag(sPlot, nCutOffFlag, FALSE, FALSE);
        // change GUI defs
        int nRange = Approval_GetApprovalRangeID(nFollower);
        nStringRef = GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "StringRef", nRange);
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetRomanceActive", "setting string ref: " + IntToString(nStringRef));
        SetFollowerApprovalDescription(oFollower, nStringRef);
    }

}

int Approval_GetRomanceActive(int nFollower)
{
    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerRomanceFlag(nFollower);

    int bRet = (nFlag != -1 && WR_GetPlotFlag(sPlot, nFlag, FALSE));

    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetRomanceActive", "Checking romance flag for follower: " + IntToString(nFollower) + ", flag= " + IntToString(bRet));

    return bRet;
}


void Approval_SetFriendlyEligible(int nFollower, int nStatus = TRUE)
{
    if(nStatus == TRUE)
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetFriendlyEligible", "Setting follower to be friendly-eligible: " + IntToString(nFollower));
    else
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetFriendlyEligible", "CLEARING friendly-eligible flag: " + IntToString(nFollower));

    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerFriendEligFlag(nFollower);
    WR_SetPlotFlag(sPlot, nFlag, nStatus, TRUE);


}

int Approval_GetFriendlyEligible(int nFollower)
{
    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerFriendEligFlag(nFollower);
    int nRet = WR_GetPlotFlag(sPlot, nFlag, FALSE);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetFriendlyEligible", "Checking friendly-eligible flag for follower: " + IntToString(nFollower) + ", flag= " + IntToString(nRet));
    return nRet;
}

void Approval_SetLoveEligible(int nFollower, int nStatus = TRUE)
{
    if(nStatus == TRUE)
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetLoveEligible", "Setting follower to be love-eligible: " + IntToString(nFollower));
    else
       Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_SetLoveEligible", "CLEARING follower love-eligible flag: " + IntToString(nFollower));

    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerLoveEligFlag(nFollower);
    WR_SetPlotFlag(sPlot, nFlag, nStatus, TRUE);
}

int Approval_GetLoveEligible(int nFollower)
{
    string sPlot = Approval_GetFollowerPlot(nFollower);
    int nFlag = Approval_GetFollowerLoveEligFlag(nFollower);
    int nRet = WR_GetPlotFlag(sPlot, nFlag, FALSE);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetLoveEligible", "Checking love-eligible flag for follower: " + IntToString(nFollower) + ", flag= " + IntToString(nRet));
    return nRet;
}

int Approval_IsRangeValid(int nFollower, int nRange, int bRomanceTable)
{
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_IsRangeValid", "START, follower: " + IntToString(nFollower) + ", range: " + IntToString(nRange) + ", check romanace= " + IntToString(bRomanceTable));

    int nResult = FALSE;
    int nApproval = Approval_GetApproval(nFollower);

    // First, check if the creature's approval table matches the requested table
    int bFoundResult = FALSE;
    int bRomanceActive = Approval_GetRomanceActive(nFollower);
    if(!bRomanceActive && bRomanceTable) // Creature uses normal table but it was requested to check the romance table
    {
        bFoundResult = TRUE;
    }

    if (!bFoundResult) // normal approval ranges
    {
        switch(nRange)
        {
            case APP_RANGE_CRISIS:
            {
                if(nApproval <= GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_CRISIS))
                    nResult = TRUE;
                break;
            }
            case APP_RANGE_HOSTILE:
            {
                if(nApproval <= GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_HOSTILE))
                    nResult = TRUE;
                break;
            }
            case APP_RANGE_NEUTRAL:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_HOSTILE))
                    nResult = TRUE;
                break;
            }
            case APP_RANGE_WARM:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_NEUTRAL))
                    nResult = TRUE;
                break;
            }
            case APP_RANGE_FRIENDLY:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_WARM) &&
                    Approval_GetFriendlyEligible(nFollower) == TRUE)
                    nResult = TRUE;
                break;
            }
            case APP_ROMANCE_RANGE_INTERESTED:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_NEUTRAL) &&
                    Approval_GetRomanceActive(nFollower))
                    nResult = TRUE;
                break;
            }
            case APP_ROMANCE_RANGE_CARE:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_INTERESTED) &&
                    Approval_GetRomanceActive(nFollower))
                    nResult = TRUE;
                break;
            }
            case APP_ROMANCE_RANGE_ADORE:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_CARE) &&
                    Approval_GetRomanceActive(nFollower))
                    nResult = TRUE;
                break;
            }
            case APP_ROMANCE_RANGE_LOVE:
            {
                if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_ADORE) &&
                    Approval_GetRomanceActive(nFollower) &&
                    Approval_GetFriendlyEligible(nFollower))
                    nResult = TRUE;
                break;
            }
        }
    }

    return nResult;
}

int Approval_HandleGift(int nFollower, object oItem)
{
    int nValue = GetItemValue(oItem); // in bits (100 bit= 1 silver, 100 silver=1 gold, 10000 bits = 1 gold
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_HandleGift", "Value of item: " + IntToString(nValue));

    int nApprovalChange = 5;

    // Each subsequent gift given for the same follower is worth 1 point less.
    // If the item�s motivation matches the follower�s motivation then it is worth as least 1 point.
    string sGiftCountVar = Approval_GetFollowerGiftCountVar(nFollower);
    int nGiftCount = GetLocalInt(GetModule(), sGiftCountVar);
    nApprovalChange -= nGiftCount;
    if(nApprovalChange <= 0)
        nApprovalChange = 1;
    nGiftCount++;
    SetLocalInt(GetModule(), sGiftCountVar, nGiftCount);

    // if follower likes item increase by 5
    int nLike = GetLocalInt(oItem, APP_ITEM_MOTIVATION);
    if(nLike == nFollower)
    {
        Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_HandleGift", "Follower likes item - increasing by 5");
        nApprovalChange += 5;
    }

    // APPROVAL CHANGE MOVED TO sp_module_item_acquired. This was done to handle gifts refunds.
    //Approval_ChangeApproval(nFollower, nApprovalChange);
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_HandleGift", "Item gifted to "+ Approval_GetFollowerName(nFollower) + ", approval change: " + IntToString(nApprovalChange));

    return nApprovalChange;

}

string Approval_GetFollowerPlot(int nFollower)
{
    string sPlot;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: sPlot = PLT_GENPT_APP_ALISTAIR; break;
        case APP_FOLLOWER_DOG: sPlot = PLT_GENPT_APP_DOG; break;
        case APP_FOLLOWER_MORRIGAN: sPlot = PLT_GENPT_APP_MORRIGAN; break;
        case APP_FOLLOWER_WYNNE: sPlot = PLT_GENPT_APP_WYNNE; break;
        case APP_FOLLOWER_SHALE: sPlot = PLT_GENPT_APP_SHALE; break;
        case APP_FOLLOWER_STEN: sPlot = PLT_GENPT_APP_STEN; break;
        case APP_FOLLOWER_ZEVRAN: sPlot = PLT_GENPT_APP_ZEVRAN; break;
        case APP_FOLLOWER_OGHREN: sPlot = PLT_GENPT_APP_OGHREN; break;
        case APP_FOLLOWER_LELIANA: sPlot = PLT_GENPT_APP_LELIANA; break;
        case APP_FOLLOWER_LOGHAIN: sPlot = PLT_GENPT_APP_LOGHAIN; break;
    }
    return sPlot;
}

int Approval_GetFollowerRomanceFlag(int nFollower)
{
    int nFlag = -1;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: nFlag = APP_ALISTAIR_ROMANCE_ACTIVE; break;
        case APP_FOLLOWER_MORRIGAN: nFlag = APP_MORRIGAN_ROMANCE_ACTIVE; break;
        case APP_FOLLOWER_ZEVRAN: nFlag = APP_ZEVRAN_ROMANCE_ACTIVE; break;
        case APP_FOLLOWER_LELIANA: nFlag = APP_LELIANA_ROMANCE_ACTIVE; break;
    }
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetFollowerRomanceFlag", "Follower romance flag= " + IntToString(nFlag));

    return nFlag;
}

int Approval_GetFollowerCutOffFlag(int nFollower)
{
    int nFlag;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: nFlag = APP_ALISTAIR_ROMANCE_CUT_OFF; break;
        case APP_FOLLOWER_MORRIGAN: nFlag = APP_MORRIGAN_ROMANCE_CUT_OFF; break;
        case APP_FOLLOWER_ZEVRAN: nFlag = APP_ZEVRAN_ROMANCE_CUT_OFF; break;
        case APP_FOLLOWER_LELIANA: nFlag = APP_LELIANA_ROMANCE_CUT_OFF; break;
    }
    return nFlag;
}

int Approval_GetFollowerLoveEligFlag(int nFollower)
{
    int nFlag;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: nFlag = APP_ALISTAIR_LOVE_ELIGIBLE; break;
        case APP_FOLLOWER_MORRIGAN: nFlag = APP_MORRIGAN_LOVE_ELIGIBLE; break;
        case APP_FOLLOWER_ZEVRAN: nFlag = APP_ZEVRAN_LOVE_ELIGIBLE; break;
        case APP_FOLLOWER_LELIANA: nFlag = APP_LELIANA_LOVE_ELIGIBLE; break;
    }
    return nFlag;
}
int Approval_GetFollowerFriendEligFlag(int nFollower)
{
    int nFlag;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: nFlag = APP_ALISTAIR_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_DOG: nFlag = APP_DOG_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_MORRIGAN: nFlag = APP_MORRIGAN_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_WYNNE: nFlag = APP_WYNNE_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_SHALE: nFlag = APP_SHALE_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_STEN: nFlag = APP_STEN_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_ZEVRAN: nFlag = APP_ZEVRAN_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_OGHREN: nFlag = APP_OGHREN_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_LELIANA: nFlag = APP_LELIANA_FRIENDLY_ELIGIBLE; break;
        case APP_FOLLOWER_LOGHAIN: nFlag = APP_LOGHAIN_FRIENDLY_ELIGIBLE; break;
    }
    return nFlag;
}

string Approval_GetFollowerGiftCountVar(int nFollower)
{
    string sVar;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: sVar = APP_APPROVAL_GIFT_COUNT_ALISTAIR; break;
        case APP_FOLLOWER_DOG: sVar = APP_APPROVAL_GIFT_COUNT_DOG; break;
        case APP_FOLLOWER_MORRIGAN: sVar = APP_APPROVAL_GIFT_COUNT_MORRIGAN; break;
        case APP_FOLLOWER_WYNNE: sVar = APP_APPROVAL_GIFT_COUNT_WYNNE; break;
        case APP_FOLLOWER_SHALE: sVar = APP_APPROVAL_GIFT_COUNT_SHALE; break;
        case APP_FOLLOWER_STEN: sVar = APP_APPROVAL_GIFT_COUNT_STEN; break;
        case APP_FOLLOWER_ZEVRAN: sVar = APP_APPROVAL_GIFT_COUNT_ZEVRAN; break;
        case APP_FOLLOWER_OGHREN: sVar = APP_APPROVAL_GIFT_COUNT_OGHREN; break;
        case APP_FOLLOWER_LELIANA: sVar = APP_APPROVAL_GIFT_COUNT_LELIANA; break;
        case APP_FOLLOWER_LOGHAIN: sVar = APP_APPROVAL_GIFT_COUNT_LOGHAIN; break;
    }
    return sVar;
}

int Approval_GetFollowerIndex(object oFollower)
{
    string sTag = GetTag(oFollower);
    int nRet = -1;
    if(sTag == GEN_FL_ALISTAIR) nRet = 1;
    else if(sTag == GEN_FL_DOG) nRet = 2;
    else if(sTag == GEN_FL_MORRIGAN) nRet = 3;
    else if(sTag == GEN_FL_WYNNE) nRet = 4;
    else if(sTag == GEN_FL_SHALE) nRet = 5;
    else if(sTag == GEN_FL_STEN) nRet = 6;
    else if(sTag == GEN_FL_ZEVRAN) nRet = 7;
    else if(sTag == GEN_FL_OGHREN) nRet = 8;
    else if(sTag == GEN_FL_LELIANA) nRet = 9;
    else if(sTag == GEN_FL_LOGHAIN) nRet = 10;

    return nRet;
}

string Approval_GetFollowerName(int nFollower)
{
    string sName;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: sName = "Alistair"; break;
        case APP_FOLLOWER_DOG: sName = "Dog"; break;
        case APP_FOLLOWER_MORRIGAN: sName = "Morrigan"; break;
        case APP_FOLLOWER_WYNNE: sName = "Wynne"; break;
        case APP_FOLLOWER_SHALE: sName = "Shale"; break;
        case APP_FOLLOWER_STEN: sName = "Sten"; break;
        case APP_FOLLOWER_ZEVRAN: sName = "Zevran"; break;
        case APP_FOLLOWER_OGHREN: sName = "Oghren"; break;
        case APP_FOLLOWER_LELIANA: sName = "Leliana"; break;
        case APP_FOLLOWER_LOGHAIN: sName = "Loghain"; break;
    }
    return sName;
}

void Approval_AddFollowerGiftCodex(int nFollower)
{
    string sPlot;
    int nFlag;
    switch(nFollower)
    {
        case APP_FOLLOWER_ALISTAIR: sPlot = "cod_cha_alistair"; nFlag = 8; break;
        case APP_FOLLOWER_DOG: break;
        case APP_FOLLOWER_MORRIGAN: sPlot = "cod_cha_morrigan"; nFlag = 6; break;
        case APP_FOLLOWER_WYNNE: sPlot = "cod_cha_wynne"; nFlag = 7; break;
        case APP_FOLLOWER_SHALE: break;
        case APP_FOLLOWER_STEN: sPlot = "cod_cha_sten"; nFlag = 5; break;
        case APP_FOLLOWER_ZEVRAN: sPlot = "cod_cha_zevran"; nFlag = 10; break;
        case APP_FOLLOWER_OGHREN: sPlot = "cod_cha_oghren"; nFlag = 5; break;
        case APP_FOLLOWER_LELIANA: sPlot = "cod_cha_leliana"; nFlag = 10; break;
        case APP_FOLLOWER_LOGHAIN: sPlot = "cod_cha_loghain"; nFlag = 11; break;
    }
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_AddFollowerGiftCodex", "Follower: " + IntToString(nFollower));


    if(sPlot != "")
        WR_SetPlotFlag(sPlot, nFlag, TRUE);
}

int Approval_GetApprovalRangeID(int nFollower)
{
    object oFollower = Approval_GetFollowerObject(nFollower);
    int nApproval = GetFollowerApproval(oFollower);
    int nRet;
    if(Approval_GetRomanceActive(nFollower))
    {
        if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_ADORE))
            nRet = APP_ROMANCE_RANGE_LOVE;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_CARE))
            nRet = APP_ROMANCE_RANGE_ADORE;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_INTERESTED))
            nRet = APP_ROMANCE_RANGE_CARE;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_NEUTRAL))
            nRet = APP_ROMANCE_RANGE_INTERESTED;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_HOSTILE))
            nRet = APP_RANGE_NEUTRAL;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_CRISIS))
            nRet = APP_RANGE_HOSTILE;
        else
            nRet = APP_RANGE_CRISIS;

    }
    else
    {
        if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_WARM))
            nRet = APP_RANGE_FRIENDLY;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_NEUTRAL))
            nRet = APP_RANGE_WARM;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_HOSTILE))
            nRet = APP_RANGE_NEUTRAL;
        else if(nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_CRISIS))
            nRet = APP_RANGE_HOSTILE;
        else
            nRet = APP_RANGE_CRISIS;
    }
    Log_Trace(LOG_CHANNEL_SYSTEMS, "Approval_GetApprovalRangeID", "Approval range is: " + IntToString(nRet));
    return nRet;
}

int Approval_GetApprovalNotification(int nFollower)
{
    string sPlot;
    int nFlag;
    int bNotify;
    switch(nFollower)
    {
        case APP_FOLLOWER_MORRIGAN: sPlot = PLT_GENPT_APP_MORRIGAN; nFlag = APP_MORRIGAN_NO_APPROVAL_NOTIFICATION; break;
        case APP_FOLLOWER_ZEVRAN: sPlot = PLT_GENPT_APP_ZEVRAN; nFlag = APP_ZEVRAN_NO_APPROVAL_NOTIFICATION; break;
    }
    if(sPlot != "") bNotify = WR_GetPlotFlag(sPlot, nFlag);
    return !bNotify;
}

int Approval_GetApprovalFromZero(int nFollower)
{
    string sPlot;
    int nFlag;
    int bNotifyFromZero;
    switch(nFollower)
    {
        case APP_FOLLOWER_MORRIGAN: sPlot = PLT_GENPT_APP_MORRIGAN; nFlag = APP_MORRIGAN_NOTIFY_APPROVAL_FROM_ZERO; break;
        case APP_FOLLOWER_ZEVRAN: sPlot = PLT_GENPT_APP_ZEVRAN; nFlag = APP_ZEVRAN_NOTIFY_APPROVAL_FROM_ZERO; break;
    }
    if(sPlot != "")
    {
        bNotifyFromZero = WR_GetPlotFlag(sPlot, nFlag);
        if (bNotifyFromZero) WR_SetPlotFlag(sPlot, nFlag, FALSE);  // Should only do this once.
    }
    return bNotifyFromZero;
}

/** @} */