// -----------------------------------------------------------------------------
//  Sound set system.
//
//  A rough implementation for E3, but it seems we're now permanently stuck with it.
//
// -----------------------------------------------------------------------------

#include "2da_constants_h"
#include "sys_stealth_h"
#include "core_h"

#include "plt_qwinn_approval"

const float SOUND_THRESH_MANA_STAMINA_LOW       = 0.15;
const float SOUND_THRESH_HEALTH_LOW             = 0.25;
const float SOUND_THRESH_HEALTH_NEAR_DEATH      = 0.15;
const float SOUND_THRESH_DAMAGE_AMOUNT          = 5.0f; // minimum damage for pain grunt, see damaged event in rules core

const int SOUND_SITUATION_COMMAND_COMPLETE      = 1;
const int SOUND_SITUATION_ENEMY_SIGHTED         = 2;
const int SOUND_SITUATION_GOT_DAMAGED           = 3;
const int SOUND_SITUATION_ENEMY_KILLED          = 4;
const int SOUND_SITUATION_COMBAT_CHARGE         = 5;
const int SOUND_SITUATION_COMBAT_BATTLECRY      = 6;
const int SOUND_SITUATION_ATTACK_IMPACT         = 7;
const int SOUND_SITUATION_PARTY_MEMBER_SLAIN    = 8;
const int SOUND_SITUATION_DYING                 = 9;
const int SOUND_SITUATION_END_OF_COMBAT         = 10;
const int SOUND_SITUATION_SELECTED              = 11;
const int SOUND_SITUATION_ORDER_RECEIVED        = 12;
const int SOUND_SITUATION_SPELL_INTERRUPTED     = 13;
const int SOUND_SITUATION_SKILL_FAILURE         = 14;


float  _GetRelativeResourceLevel(object oCreature, int nResource)
{
    float fCur = GetCreatureProperty(oCreature,nResource, PROPERTY_VALUE_CURRENT);
    float fMax = GetCreatureProperty(oCreature,nResource, PROPERTY_VALUE_TOTAL);

    return (fMax > 0.0?fCur/fMax:0.0);

}


/**
* @brief Returns the state of a soundset flag
*
* A creature flag (SOUNDSET_FLAG_*) is a persistent boolean variable
*
* @param oCreature The creature to check
* @returns  TRUE or FALSE state of the flag.
*/
int SSGetSoundSetFlag(object oCreature, int nSSEntry);
int SSGetSoundSetFlag(object oCreature, int nSSEntry)
{
    // -------------------------------------------------------------------------
    // We got more than 32 SS entries, so we need find out in which variable
    // this particular ssentry is stored. We do this by dividing the entry
    // by 32 and appending the result to the base flag variable name.
    // -------------------------------------------------------------------------
    int nVar = nSSEntry / 32;
    string sVar = SOUND_SET_FLAGS + ToString(nVar);

    int nFlag = (0x00000001 << (nSSEntry % 32));

    int nVal  = GetLocalInt(oCreature, sVar) ;

    //Log_Trace(LOG_CHANNEL_SOUNDSETS,"sys_soundsets_h.GetFlag." + sVar, "Flag: " + IntToString(nSSEntry) + "("+ IntToHexString(nFlag) +")"+ " Value: " + IntToHexString(nVal) + " Result: " + IntToString(( (nVal  & nFlag ) == nFlag)),oCreature);

    return ( (nVal  & nFlag ) == nFlag);
}



/**
* @brief Sets a SOUNDSET_FLAG_* flag (boolean persistent variable) on a creature
**
* @param oCreature The creature to set the flag on
* @param nFlag     SOUNDSET_FLAG_* to set.
* @param bSet      whether to set or to clear the flag.
*
* @returns  TRUE or FALSE
**/
void SSSetSoundSetFlag(object oCreature, int nSSEntry, int bSet = TRUE);
void SSSetSoundSetFlag(object oCreature, int nSSEntry, int bSet = TRUE)
{

    // -------------------------------------------------------------------------
    // We got more than 32 SS entries, so we need find out in which variable
    // this particular ssentry is stored. We do this by dividing the entry
    // by 32 and appending the result to the base flag variable name.
    // -------------------------------------------------------------------------
    int nVar = nSSEntry / 32;
    string sVar = SOUND_SET_FLAGS + ToString(nVar);

    int nFlag = (0x00000001 << (nSSEntry % 32));

    int nVal = GetLocalInt(oCreature, sVar);
    int nOld = nVal;

    if (bSet)
    {
        nVal |= nFlag;
    }
    else
    {
        nVal &= ~nFlag;
    }

    //Log_Trace(LOG_CHANNEL_SOUNDSETS, "sys_soundset_h.SetFlag." + sVar + "." +ToString(bSet), "Flag: " + IntToString(nSSEntry) + "("+ IntToHexString(nFlag) +")"  + " Was: " + IntToHexString(nOld) + " Is: " + IntToHexString(nVal) ,oCreature);

    SetLocalInt(oCreature,sVar,nVal);
}


int _GetSituationalCombatSound(object oCreature, int nSituation, object oTarget = OBJECT_INVALID, int nCommandType = COMMAND_TYPE_INVALID)
{
    int nSound = 0;

    switch (nSituation)
    {
        case SOUND_SITUATION_COMBAT_BATTLECRY:
        {
            int nRand = Random(12);
            if (nRand < 1)
                nSound = SS_COMBAT_TAUNT;
            else if (nRand < 7)
                nSound = SS_COMBAT_ATTACK;
            else
                nSound = SS_COMBAT_BATTLE_CRY;

            break;
        }
        case SOUND_SITUATION_GOT_DAMAGED:
            nSound = SS_COMBAT_PAIN_GRUNT;
            break;
        /*case SOUND_SITUATION_COMBAT_CHARGE:
            nSound = SS_COMBAT_ATTACK;
            break;*/
        case SOUND_SITUATION_ENEMY_KILLED:
            nSound = SS_COMBAT_ENEMY_KILLED;
            break;
        case SOUND_SITUATION_ATTACK_IMPACT:
            nSound = SS_COMBAT_ATTACK_GRUNT;
            break;
        case SOUND_SITUATION_END_OF_COMBAT:
            nSound = SS_COMBAT_CHEER_PARTY;
            break;
        case SOUND_SITUATION_SPELL_INTERRUPTED:
            nSound = SS_SPELL_FAILED;
            break;
        case SOUND_SITUATION_PARTY_MEMBER_SLAIN:
            if (IsObjectValid(oTarget) && IsObjectHostile(oTarget, oCreature))
                nSound = SS_COMBAT_MONSTER_SLEW_PARTY_MEMBER;
            break;
        case SOUND_SITUATION_COMMAND_COMPLETE:
        {
            if (_GetRelativeResourceLevel(oCreature, PROPERTY_DEPLETABLE_HEALTH) < SOUND_THRESH_HEALTH_NEAR_DEATH)
                nSound = SS_COMBAT_NEAR_DEATH;
            else if (_GetRelativeResourceLevel(oCreature, PROPERTY_DEPLETABLE_HEALTH) < SOUND_THRESH_HEALTH_LOW)
                nSound = SS_COMBAT_HEAL_ME;
            else if (_GetRelativeResourceLevel(oCreature, PROPERTY_DEPLETABLE_MANA_STAMINA) < SOUND_THRESH_MANA_STAMINA_LOW
                    && IsControlled(oCreature))
            {
                nSound = (GetCreatureCoreClass(oCreature) == CLASS_WIZARD) ? SS_MANA_LOW : SS_COMBAT_STAMINA_LOW;
            }
            break;
        }
        case SOUND_SITUATION_DYING:
            nSound = SS_COMBAT_DEATH;
            break;
        case SOUND_SITUATION_SELECTED:
            nSound = SS_COMBAT_SELECT_NEUTRAL;
            break;
        case SOUND_SITUATION_ORDER_RECEIVED:
            nSound = SS_EXPLORE_START_TASK;
            break;
    }
    return nSound;
}


int _GetSituationalExploreSound(object oCreature, int nSituation, object oTarget, int nCommandType)
{
    int nSound = 0;

    switch (nSituation)
    {
        case SOUND_SITUATION_COMMAND_COMPLETE:
            if (_GetRelativeResourceLevel(oCreature, PROPERTY_DEPLETABLE_HEALTH) < SOUND_THRESH_HEALTH_LOW)
                nSound = SS_EXPLORE_HEAL_ME;
            break;
        case SOUND_SITUATION_ENEMY_SIGHTED:
        {
            if (IsPartyMember(oCreature))
            {
                switch (GetCreatureTypeClassification(GetAppearanceType(oTarget)))
                {
                    case CREATURE_TYPE_DARKSPAWN:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_DARKSPAWN;
                        break;
                    case CREATURE_TYPE_ANIMAL:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_ANIMAL;
                        break;
                    case CREATURE_TYPE_BEAST:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_BEAST;
                        break;
                    case CREATURE_TYPE_UNDEAD:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_UNDEAD;
                        break;
                    case CREATURE_TYPE_DEMON:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_DEMON;
                        break;
                    case CREATURE_TYPE_DRAGON:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_DRAGON;
                        break;
                    case CREATURE_TYPE_INVALID:
                        nSound = 0;
                        break;
                    default:
                        nSound = SS_EXPLORE_ENEMIES_SIGHTED_OTHER;
                        break;
                }
                break;
            }
            else
            {
                nSound = RandomFloat()>0.5? SS_WARCRY : SS_COMBAT_BATTLE_CRY;
            }
            break;
        }
        case SOUND_SITUATION_SELECTED:
        {
            nSound = SS_EXPLORE_SELECT_NEUTRAL;
            if (IsFollower(oCreature))
            {
                nSound = SS_EXPLORE_SELECT_HATE;

                int nApproval = GetFollowerApproval(oCreature);

                string sTag = GetTag(oCreature);
                int nRomance = FALSE;
                if(sTag == GEN_FL_ALISTAIR)
                   // nRomance = WR_GetPlotFlag(PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_ALISTAIR);
                   nRomance = GetPartyPlotFlag(GetParty(GetHero()),PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_ALISTAIR);
                if(sTag == GEN_FL_MORRIGAN)
                   // nRomance = WR_GetPlotFlag(PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_MORRIGAN);
                   nRomance = GetPartyPlotFlag(GetParty(GetHero()),PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_MORRIGAN);
                if(sTag == GEN_FL_LELIANA)
                   // nRomance = WR_GetPlotFlag(PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_LELIANA);
                   nRomance = GetPartyPlotFlag(GetParty(GetHero()),PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_LELIANA);
                if(sTag == GEN_FL_ZEVRAN)
                   // nRomance = WR_GetPlotFlag(PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_ZEVRAN);
                   nRomance = GetPartyPlotFlag(GetParty(GetHero()),PLT_QWINN_APPROVAL,QW_ROMANCE_ACTIVE_ZEVRAN);

                if (nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_HOSTILE))
                    nSound = SS_EXPLORE_SELECT_NEUTRAL;
                if (nApproval > GetM2DAInt(TABLE_APPROVAL_NORMAL_RANGES, "Range", APP_RANGE_NEUTRAL))
                    nSound = SS_EXPLORE_SELECT_FRIENDLY;
                if ((nApproval > GetM2DAInt(TABLE_APPROVAL_ROMANCE_RANGES, "Range", APP_ROMANCE_RANGE_CARE)) && nRomance)
                    nSound = SS_EXPLORE_SELECT_LOVE;

            }
            break;
        }
        case SOUND_SITUATION_DYING:
            nSound = SS_COMBAT_DEATH;
            break;
        case SOUND_SITUATION_ORDER_RECEIVED:
        {
            nSound = SS_EXPLORE_START_TASK;
            break;
        }
        case SOUND_SITUATION_SKILL_FAILURE:
        {
            nSound = SS_SKILL_FAILURE;
            break;
        }
    }
    return nSound;
}


void SSPlaySituationalSound(object oCreature, int nSituation, object oTarget = OBJECT_INVALID, int nCommandType = COMMAND_TYPE_INVALID)
{

    if (IsObjectValid(oCreature) && (!IsDead(oCreature) || nSituation == SOUND_SITUATION_DYING)  && GetObjectActive(oCreature) && GetObjectType(oCreature) == OBJECT_TYPE_CREATURE)
    {
        int nMode = GetGameMode();
        int nSound = 0;

        // -------------------------------------------------------------------------
        // Only play sound in combat or explore mode so cinematics don't get unintentional VO.
        // -------------------------------------------------------------------------
        if (nMode == GM_COMBAT)
        {
            nSound = _GetSituationalCombatSound (oCreature, nSituation, oTarget, nCommandType);
        }
        else if (nMode == GM_EXPLORE)
        {
            nSound = _GetSituationalExploreSound(oCreature, nSituation, oTarget, nCommandType);
        }

        // Immortal creatures never ask for healing.
        if (nSound ==  SS_COMBAT_NEAR_DEATH || nSound == SS_COMBAT_HEAL_ME ||
            nSound == SS_EXPLORE_HEAL_ME)
        {
            if (IsImmortal(oCreature) || IsPlot(oCreature))
            {
                nSound = 0;
            }
        }

        if (nSound > 0)
        {
            if (nSound == SS_COMBAT_DEATH)
            {
                //Log_Trace(LOG_CHANNEL_, "sys_soundsets.play", "nSituation: " + ToString(nSituation) + ", Sound: " + ToString(nSound));

                int nRank = GetCreatureRank(oCreature);
                if (nRank == CREATURE_RANK_BOSS || nRank == CREATURE_RANK_ELITE_BOSS)
                {
                    // boss+ creature always complain about dying.
                    PlaySoundSet(oCreature, nSound, 1.0);
                }
                else
                {
                    PlaySoundSet(oCreature, nSound);
                }
            }
            else if (!SSGetSoundSetFlag(oCreature,nSound))
            {
                if (nSituation == SOUND_SITUATION_ORDER_RECEIVED)
                {
                    if (!IsStealthy(oCreature))
                    {
                        float fProb = GetM2DAFloat(TABLE_COMMANDS, "SoundsetProbability", nCommandType);

                        // No voice chat when moving in explore mode.
                        switch (nCommandType)
                        {
                            case COMMAND_TYPE_DRIVE:
                            case COMMAND_TYPE_MOVE_TO_LOCATION:
                            case COMMAND_TYPE_MOVE_TO_OBJECT:
                                if (nMode == GM_EXPLORE)
                                    fProb = 0.0f;
                        }

                        if (fProb > 0.0f)
                        {
                            #ifdef DEBUG
                            Log_Trace(LOG_CHANNEL_SOUNDSETS, "sys_soundsets.play", "SOUND_SITUATION_ORDER_RECEIVED: Command = " + Log_GetCommandNameById(nCommandType) + ", Probability = " + ToString(fProb));
                            #endif
                            PlaySoundSet(oCreature, nSound, fProb);
                        }
                    }
                }
                else
                {
                    #ifdef DEBUG
                    Log_Trace(LOG_CHANNEL_SOUNDSETS, "sys_soundsets.play", "oCreature: " + ToString(oCreature) + ", nSituation: " + ToString(nSituation) + ", Sound: " + ToString(nSound));
                    #endif
                    PlaySoundSet(oCreature, nSound);
                }

                if (GetIsSoundSetEntryTypeRestricted(nSound))
                {
                    SSSetSoundSetFlag(oCreature, nSound);
                }
            }
            else
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_SOUNDSETS,"sys_soundsets.play", "Not playing sound " + ToString(nSound) + " as flag was set");
                #endif
            }
        }
    }
}


void SSResetSoundsetRestrictions(object oCreature)
{
    SSSetSoundSetFlag(oCreature, SS_COMBAT_NEAR_DEATH, FALSE);
    SSSetSoundSetFlag(oCreature, SS_COMBAT_HEAL_ME, FALSE);
    SSSetSoundSetFlag(oCreature, SS_EXPLORE_HEAL_ME, FALSE);
    SSSetSoundSetFlag(oCreature, SS_MANA_LOW, FALSE);
    SSSetSoundSetFlag(oCreature, SS_COMBAT_STAMINA_LOW, FALSE);
}


void SSPartyResetSoundsetRestrictions()
{
    object[] aParty = GetPartyList();
    int nSize = GetArraySize(aParty);
    int i;

    for (i = 0; i < nSize; i++)
    {
        SSResetSoundsetRestrictions(aParty[i]);
    }

}


void SSResetSoundsetRestrictionsOnHeal(object oCreature)
{
    SSSetSoundSetFlag(oCreature, SS_COMBAT_NEAR_DEATH, FALSE);
    SSSetSoundSetFlag(oCreature, SS_COMBAT_HEAL_ME, FALSE);
    SSSetSoundSetFlag(oCreature, SS_EXPLORE_HEAL_ME, FALSE);
}

void SSResetSoundsetRestrictionsOnDamage(object oCreature, float fOldHealth)
{
    if (fOldHealth > SOUND_THRESH_HEALTH_LOW)
    {
        SSSetSoundSetFlag(oCreature, SS_COMBAT_HEAL_ME, FALSE);
        SSSetSoundSetFlag(oCreature, SS_EXPLORE_HEAL_ME, FALSE);
    }
    else if (fOldHealth > SOUND_THRESH_HEALTH_NEAR_DEATH)
    {
        SSSetSoundSetFlag(oCreature, SS_COMBAT_NEAR_DEATH, FALSE);
    }
}

/**
* @brief Causes a party member of a given class (other than oPartyMember) to play a sound for a given situation.
**/
void SSPartyMemberComment(int nClass, int nSituation, object oPartyMember)
{
    object[] aParty = GetPartyList(oPartyMember);
    int i;
    for (i = 0; i < GetArraySize(aParty); i++)
    {
        if (GetCreatureCoreClass(aParty[i]) == nClass
            && aParty[i] != oPartyMember)
        {
            SSPlaySituationalSound(aParty[i], nSituation);
            break;
        }
    }
}