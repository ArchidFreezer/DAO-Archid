#include "ability_h"
#include "ability_summon_h"
#include "sys_rewards_h"
#include "af_utility_h"
// Indirectly Referenced By: (Recompile both if you change this file)
//   eds_dheu_module_core
//   eds_dheu_dying_override
//

const int AF_LOGGROUP_EDS = 9;
// ========================================================
// Variables
// ========================================================
// NOTE: All variables must be registered in var_module.2da

// Name of variable I store on PC to track
// if dog should be added after Party Screen
// Value is int
const string NODOGSLOT = "EDS_ND";

// Name of variable I store to track the NPC(tag)
// he is currently/was last attached to
// Value is string
const string DOG_OWNER = "EDS_WDO";

// When the PC hits the dog whistle button,
// we want to let the dog go away. But normally,
// we want to save the dog if a DYING event fires...
//
// so... we have a bypass variable which tells the DYING event
// to ignore what is going on...
// Value is int
const string DOG_BYPASS = "EDS_BP";

// Needed an event so I could delay removing
// the dog from the party when you blow the
// whistle (So he has time to run away)
const int EVENT_DOG_RAN_AWAY = 6610000;

// Needed to delay activating the dog when
// you return to camp. PC enters area before the
// dog actually exists, which causes the problem.
const int EVENT_MAKE_DOG_CLICKABLE = 6610001;

// Value of new AF_ABI_EDS_DOG_SUMMONED ability I added
// If I use the ITEM_DOG_WHISTLE value for the upkeep
// effect, then I can't use the item while the effect
// is still valid (till owner dies). So I made a new
// ability ID. Needed so I can differentiate between
// my new upkeep effect and the existing onces.
const int AF_ABI_EDS_DOG_SUMMONED  = 0;

// string in module string table for reporting potential
// conflict with another mod.
const int E1_EDS_CONFLICT = 6610149; // Dying only
const int E2_EDS_CONFLICT = 6610150; // Party Member Fired Only
const int E3_EDS_CONFLICT = 6610151; // Dying and Party Member Fired

const int W1_EDS_CONFLICT = 6610148; // Summon Died Only
const int W2_EDS_CONFLICT = 6610152; // Command Pending/Complete Only
const int W3_EDS_CONFLICT = 6610153; // Summon Died and Command Pending/Complete  

// Custom events
const int EVENT_TYPE_DOG_RAN_AWAY = 6610000;
const int EVENT_TYPE_DOG_MAKE_CLICKABLE = 6610001;
// Boolean, tracks if the popup result us the result of us
// requesting the dog name.
const string EDS_GET_DOG_NAME = "EDS_DN";

// Variable used to remember if we have checked
// if there is a conflict. This allows more specific
// feedback and we only bother the user with it once.
// If they want the feedback again, they have to
// disable and re-enable the mod.
//
// 0 = never checked
// 1 = checked, no conflicts
// 2 = checked, conflicts (allows alternate implementation)
const string EDS_CHECK_CONFLICT = "EDS_CC";

// DOG RESTORATION VARIABLES
// ===========================================
// DOG_NAME is type string
const string EDS_DOG_NAME = "EDS_NA";
// DOG_XP is type float
const string EDS_DOG_XP = "EDS_XP";
// DOG_LEVEL is type float
const string EDS_DOG_LEVEL = "EDS_LV";
// DOG_XTRA_ATTRIBUTES is type float
const string EDS_DOG_XTRA_ATTRIBUTES = "EDS_AT";
// DOG_XTRA_SKILLS is type float
const string EDS_DOG_XTRA_SKILLS = "EDS_SK";
// DOG_XTRA_TALENTS is type float
const string EDS_DOG_XTRA_TALENTS = "EDS_TA";
// DOG_EQUIP_COLLAR is type string
const string EDS_DOG_EQUIP_COLLAR = "EDS_CO";
// DOG_EQUIP_WARPAINT is type string
const string EDS_DOG_EQUIP_WARPAINT = "EDS_PA";
// DOG_STR is type float
const string EDS_DOG_STR = "EDS_SR";
// DOG_CON is type float
const string EDS_DOG_CON = "EDS_CN";
// DOG_DEX is type float
const string EDS_DOG_DEX = "EDS_DX";
// DOG_INT is type float
const string EDS_DOG_INT = "EDS_IT";
// DOG_WIL is type float
const string EDS_DOG_WIL = "EDS_WL";
// DOG_MAG is type float
const string EDS_DOG_MAG = "EDS_MG";

// DOG_HAS_CHARGE is type int
const string EDS_DOG_HAS_CHARGE = "EDS_CA";
// DOG_HAS_COMBAT is type int
const string EDS_DOG_HAS_COMBAT = "EDS_CM";
// DOG_HAS_FORT is type int
const string EDS_DOG_HAS_FORT = "EDS_FO";
// DOG_HAS_GROWL is type int
const string EDS_DOG_HAS_GROWL = "EDS_GR";
// DOG_HAS_NEMESIS is type int
const string EDS_DOG_HAS_NEMESIS = "EDS_NE";
// DOG_HAS_OVERWHELM is type int
const string EDS_DOG_HAS_OVERWHELM = "EDS_OW";
// DOG_HAS_SHRED is type int
const string EDS_DOG_HAS_SHRED = "EDS_SH";
// DOG_HAS_HOWL is type int
const string EDS_DOG_HAS_HOWL = "EDS_HW";

/* Whistle Item */

// Value of new ITEM_DOG_WHISTLE ability I added
// This was attached to the item instead of UNIQUE_POWER
// so that I could control the animation.
const int AF_ABI_EDS_DOG_WHISTLE  = 6610011;

// Tag of Dog whistle item
const string AF_ITM_EDS_DOG_WHISTLE = "af_eds_dog_whistle";

// Resource of Dog Wistle
const resource AF_ITR_EDS_WHISTLE = R"af_eds_dog_whistle.uti";

// Dog resource
const resource GEN_FLR_DOG = R"gen00fl_dog.utc";

const resource AF_RES_SYS_TREASURE =  R"sys_treasure.ncs"; 

const int STRING_REF_RENAME_DOG = 362390;


void _AF_DogSnapShot() {
        object oDog = AF_GetPartyMemberByTag(GEN_FL_DOG);
        if (IsObjectValid(oDog)) {
            string sDogName = GetName(oDog);
            float exp = GetCreatureProperty(oDog,PROPERTY_SIMPLE_EXPERIENCE);
            float level = GetCreatureProperty(oDog,PROPERTY_SIMPLE_LEVEL);
            float xtr_attr = GetCreatureProperty(oDog,PROPERTY_SIMPLE_ATTRIBUTE_POINTS);
            float xtr_skil = GetCreatureProperty(oDog,PROPERTY_SIMPLE_SKILL_POINTS);
            float xtr_tal = GetCreatureProperty(oDog,PROPERTY_SIMPLE_TALENT_POINTS);

            string sCollar = "";
            object oCollar = GetItemInEquipSlot(INVENTORY_SLOT_DOG_COLLAR,oDog);
            if (IsObjectValid(oCollar)) sCollar = GetTag(oCollar);

            string sPaint = "";
            object oPaint = GetItemInEquipSlot(INVENTORY_SLOT_DOG_WARPAINT,oDog);
            if (IsObjectValid(oPaint)) sPaint = GetTag(oPaint);

            float con = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_CONSTITUTION);
            float dex = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_DEXTERITY);
            float itl = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_INTELLIGENCE);
            float mag = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_MAGIC);
            float str = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_STRENGTH);
            float wil = GetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_WILLPOWER);

            int hasCharge = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_CHARGE);
            int hasCombat = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_COMBAT_TRAINING);
            int hasFort   = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_FORTITUDE);
            int hasGrowl  = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_GROWL);
            int hasNemes  = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_NEMESIS);
            int hasOver   = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_OVERWHELM);
            int hasShred  = HasAbility(oDog, ABILITY_TALENT_MONSTER_DOG_SHRED);
            int hasHowl   = HasAbility(oDog, ABILITY_TALENT_MONSTER_MABARI_HOWL);

/*
            AF_LogDebug("Dog SnapShot : ", AF_LOGGROUP_EDS
            AF_LogDebug("", AF_LOGGROUP_EDS
            AF_LogDebug("  Name       : " + sDogName, AF_LOGGROUP_EDS
            AF_LogDebug("  Experience : " + ToString(exp), AF_LOGGROUP_EDS
            AF_LogDebug("  Level      : " + ToString(level), AF_LOGGROUP_EDS
            AF_LogDebug("  Skill Pts  : " + ToString(xtr_skil), AF_LOGGROUP_EDS
            AF_LogDebug("  Talent Pts : " + ToString(xtr_tal), AF_LOGGROUP_EDS
            AF_LogDebug("  Attr Pts   : " + ToString(xtr_attr), AF_LOGGROUP_EDS
            AF_LogDebug("", AF_LOGGING_EDS);
            AF_LogDebug("  Collar     : [" + sCollar + "]", AF_LOGGROUP_EDS
            AF_LogDebug("  Paint      : [" + sPaint  + "]", AF_LOGGROUP_EDS
            AF_LogDebug("", AF_LOGGING_EDS);
            AF_LogDebug("  Con        : " + ToString(con), AF_LOGGROUP_EDS
            AF_LogDebug("  Dex        : " + ToString(dex), AF_LOGGROUP_EDS
            AF_LogDebug("  Int        : " + ToString(itl), AF_LOGGROUP_EDS
            AF_LogDebug("  Mag        : " + ToString(mag), AF_LOGGROUP_EDS
            AF_LogDebug("  Str        : " + ToString(str), AF_LOGGROUP_EDS
            AF_LogDebug("  Wil        : " + ToString(wil), AF_LOGGROUP_EDS
            AF_LogDebug("", AF_LOGGING_EDS);
            AF_LogDebug("  hasCharge  : " + ToString(hasCharge), AF_LOGGROUP_EDS
            AF_LogDebug("  hasCombat  : " + ToString(hasCombat), AF_LOGGROUP_EDS
            AF_LogDebug("  hasFort    : " + ToString(hasFort), AF_LOGGROUP_EDS
            AF_LogDebug("  hasGrowl   : " + ToString(hasGrowl), AF_LOGGROUP_EDS
            AF_LogDebug("  hasNemes   : " + ToString(hasNemes), AF_LOGGROUP_EDS
            AF_LogDebug("  hasOver    : " + ToString(hasOver), AF_LOGGROUP_EDS
            AF_LogDebug("  hasShred   : " + ToString(hasShred), AF_LOGGROUP_EDS
            AF_LogDebug("  hasHowl    : " + ToString(hasHowl), AF_LOGGROUP_EDS
*/
            // Now store everything in module variables
            object oModule = GetModule();
            SetLocalString(oModule,EDS_DOG_NAME,sDogName);
            SetLocalFloat(oModule,EDS_DOG_XP,exp);
            SetLocalFloat(oModule,EDS_DOG_LEVEL,level);
            SetLocalFloat(oModule,EDS_DOG_XTRA_ATTRIBUTES,xtr_attr);
            SetLocalFloat(oModule,EDS_DOG_XTRA_SKILLS,xtr_skil);
            SetLocalFloat(oModule,EDS_DOG_XTRA_TALENTS,xtr_tal);

            SetLocalString(oModule,EDS_DOG_EQUIP_COLLAR,sCollar);
            SetLocalString(oModule,EDS_DOG_EQUIP_WARPAINT,sPaint);

            SetLocalFloat(oModule,EDS_DOG_CON,con);
            SetLocalFloat(oModule,EDS_DOG_DEX,dex);
            SetLocalFloat(oModule,EDS_DOG_INT,itl);
            SetLocalFloat(oModule,EDS_DOG_MAG,mag);
            SetLocalFloat(oModule,EDS_DOG_STR,str);
            SetLocalFloat(oModule,EDS_DOG_WIL,wil);

            SetLocalInt(oModule,EDS_DOG_HAS_CHARGE,hasCharge);
            SetLocalInt(oModule,EDS_DOG_HAS_COMBAT,hasCombat);
            SetLocalInt(oModule,EDS_DOG_HAS_FORT,hasFort);
            SetLocalInt(oModule,EDS_DOG_HAS_GROWL,hasGrowl);
            SetLocalInt(oModule,EDS_DOG_HAS_NEMESIS,hasNemes);
            SetLocalInt(oModule,EDS_DOG_HAS_OVERWHELM,hasOver);
            SetLocalInt(oModule,EDS_DOG_HAS_SHRED,hasShred);
            SetLocalInt(oModule,EDS_DOG_HAS_HOWL,hasHowl);
        }
}

/**
* @brief Checks the NPC To see if they have the dog attached
*
* Performs a check to see if the AF_ABI_EDS_DOG_SUMMONED upkeep effects is present.
*
* @param    oCharacter player to check
* @return   TRUE if the dog is attached; FALSE otherwise
*/
// AF_ABI_EDS_DOG_SUMMONED upkeep effects present.
int _AF_IsDogAttached(object oCharacter)
{
    effect[] eUpKept = GetEffects(oCharacter, EFFECT_TYPE_UPKEEP, AF_ABI_EDS_DOG_SUMMONED);
    int nSize = GetArraySize(eUpKept);

    // A redundant check is needed incase AF_ABI_EDS_DOG_SUMMONED is 0, which is
    // also the wildcard value for the GetEffects Query above.

    if (0 != nSize) {
        int i;
        int id;
        for (i = 0; i < nSize; i++) {
            id = GetEffectAbilityID(eUpKept[i]);
            if (AF_ABI_EDS_DOG_SUMMONED == id) {
                // eds_Log("AF_ABI_EDS_DOG_SUMMONED Found on [" + GetTag(oCaster) + "]");
                // Need to include util if we uncomment this.
                // PrintEffectProperties(eUpKept[i]);
                return TRUE;
            }
        }
    }
    return FALSE;
}

/**
* @brief Returns True if dog is a member of the active party. False otherwise
*/
int _AF_IsDogInParty()
{
    AF_LogDebug("isDogInParty Called", AF_LOGGROUP_EDS);
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        object oDog = AF_GetPartyMemberByTag(GEN_FL_DOG);
        if (IsObjectValid(oDog)) return TRUE;
    }
    // AF_LogDebug("isDogInParty: Dog is not a member of the active party.]", AF_LOGGING_EDS);
    return FALSE;
}

/**
* @brief    Gets the current owner, if any of the dog.
*
* @return   Party member that has the dog attached
*/
object _AF_GetDogOwner()
{
    AF_LogDebug("getDogOwner Called", AF_LOGGROUP_EDS);
    if (_AF_IsDogInParty()) {
        object [] arParty = GetPartyList();
        int i;
        int nSize = GetArraySize(arParty);
        object oCurrent;
        for(i = 0; i < nSize; i++) {
            oCurrent = arParty[i];
            if (_AF_IsDogAttached(oCurrent)) return oCurrent;
        }
    }
    return OBJECT_INVALID;
}
 
/**
* @brief Get the owner of the dog
*
* Used to retrieve dog owner during combat when UPKEEP effect may have ended due to death. Also used when party picker closed event fires
* to see if PC removed companion that the dog was attached to.
*
* @return   Tag of the dog owner
*/
string _AF_GetStoredDogOwner() {
    AF_LogDebug("getStoredDogOwner Called", AF_LOGGROUP_EDS);
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        return GetLocalString(GetModule(),DOG_OWNER);
    } else {
        AF_LogDebug("getStoredDogOwner : GEN_DOG_RECRUITED not set", AF_LOGGROUP_EDS);
    }
    return "";
}

/**
* @brief unattaches the dog from a party member
* 
* @param    oCaster party member to unattach the dog from
* @param    bRes whether the dog should be resurrected if the owner is dead
* @param    bForceStoredRemoval -> Primarily used by EVENT_PARTY_MEMBER_FIRED
* @return   Dog object if it is alive
*/
object _AF_UnattachDogFromPartyMember(object oCaster, int bRes = TRUE, int bForceStoredRemoval = FALSE) {
    AF_LogDebug("UnAttachDogFromPartyMember Called", AF_LOGGROUP_EDS);
    object oDog = AF_GetPartyMemberByTag(GEN_FL_DOG);
    int noHealth = (1.0 > GetCurrentHealth(oCaster));
    if (IsDead(oCaster) || noHealth) {
        AF_LogDebug("UnAttachDogFromPartyMember : oCaster is dead or health is 0", AF_LOGGROUP_EDS);
        if (bRes && (IsDead(oDog) || IsDying(oDog))) {
            float health = GetMaxHealth(oDog) * 0.5;
            int stamina  = GetCreatureMaxStamina(oDog);

            SetCurrentHealth(oDog,health);
            SetCreatureStamina(oDog, stamina);
            SetAILevel(oDog, CSERVERAIMASTER_AI_LEVEL_INVALID);
            SetCreatureFlag(oDog,CREATURE_RULES_FLAG_DYING,FALSE);
        }


        // To get the new variables to work, I had
        // to make my own var_module.gda file and
        // declare my variable names/types.

        SetLocalString(GetModule(),DOG_OWNER,"");
        return oDog;
    }

    effect[] eUpKept = GetEffects(oCaster, EFFECT_TYPE_UPKEEP, AF_ABI_EDS_DOG_SUMMONED);
    int nSize = GetArraySize(eUpKept);

    // A redundant check is needed incase AF_ABI_EDS_DOG_SUMMONED is 0, which is
    // also the wildcard value for the GetEffects Query above.

    int i;
    int id;
    for (i = 0; i < nSize; i++) {
        id = GetEffectAbilityID(eUpKept[i]);
        if (AF_ABI_EDS_DOG_SUMMONED == id) {
            float health = GetCurrentHealth(oDog);
            int stamina = GetCreatureStamina(oDog);

            SetLocalString(GetModule(),DOG_OWNER,"");
            // Set ByPass... The RemoveEffect will kill the
            // dog, an event that is normally caught and
            // handled by EVENT_DYING... So we need to set
            // the Bypass flag so that we dont handle it.

            // Unfortunately, as a threaded event, we dont
            // know when it will fire, so if we set bypass
            // to FALSE towards the end of this method,
            // it may or may not be true when the dying
            // event fires.
            //
            // So.. we only set it to true here and let
            // the dying event set it back to false.
            //
            // As a backup measure, we set bypass to
            // false when the use clicks on the whistle
            // as well.

            // To get the new variables to work, I had
            // to make my own var_module.gda file and
            // declare my variable names/types.

            SetLocalInt(GetModule(),DOG_BYPASS,TRUE);
            RemoveEffect(oCaster,eUpKept[i]);

            // They are still in the party, but when we removed the effect, we just
            // killed the dog. Need to resurrect so that the dog isn't dead when we
            // get back to camp or if we re-summon.

            // FROM effect_resurrection:
            SetCurrentHealth(oDog,health);
            SetCreatureStamina(oDog, stamina);
            SetAILevel(oDog, CSERVERAIMASTER_AI_LEVEL_INVALID);
            SetCreatureFlag(oDog,CREATURE_RULES_FLAG_DYING,FALSE);
            // AF_LogDebug("Setting Bypass To False", AF_LOGGING_EDS);
            // SetLocalInt(GetModule(),DOG_BYPASS,FALSE);
            return oDog;
        }
    }
    if (bForceStoredRemoval) {
        SetLocalString(GetModule(),DOG_OWNER,"");
        return oDog;
    }
    return OBJECT_INVALID;
}

/**
* @brief Ensure that the dog is stable and no party member has the dog effect attached without the dog
*
* @return   Dog object
*/
object _AF_FixBrokenDog() {
    AF_LogDebug("WARNING : fixBrokenDog() called.", AF_LOGGROUP_EDS);

    // Normally when this happens, the effect is still attached to the
    // player which can make other function fail. So we start by
    // making sure there is no DOG effect attached to player

    object oCaster = GetHero();
    effect[] eUpKept = GetEffects(oCaster, EFFECT_TYPE_UPKEEP, AF_ABI_EDS_DOG_SUMMONED);
    int nSize = GetArraySize(eUpKept);

    // A redundant check is needed incase AF_ABI_EDS_DOG_SUMMONED is 0, which is
    // also the wildcard value for the GetEffects Query above.

    int i;
    int id;
    for (i = 0; i < nSize; i++) {
        id = GetEffectAbilityID(eUpKept[i]);
        if (AF_ABI_EDS_DOG_SUMMONED == id) {
            SetLocalString(GetModule(),DOG_OWNER,"");
            RemoveEffect(oCaster,eUpKept[i]);
        }
    }

    // STEP 2 : See if the dog is in the local area. If so, grab him...
    object [] oDogs = GetNearestObjectByTag(GetMainControlled(),GEN_FL_DOG, OBJECT_TYPE_CREATURE,1);
    if (GetArraySize(oDogs) > 0) {
        AF_LogDebug("SUCCESS! Found dog in current map.", AF_LOGGROUP_EDS);
        string sDogName = GetLocalString(GetModule(),EDS_DOG_NAME);
        if ("" != sDogName) {
            SetName(oDogs[0],sDogName);
        }

        return oDogs[0];
    }

    // STEP 3 : Couldn't find old dog, so create new. Based on the
    // presence of the dogs name in persistent storage, we will
    // either make a barnd new dog or a clone of the old dog.

    AF_LogDebug("Attempting to Restore lost dog", AF_LOGGROUP_EDS);

    resource rDog = GEN_FLR_DOG;
    object oDog = CreateObject(OBJECT_TYPE_CREATURE, rDog, GetLocation(OBJECT_SELF));

    // Provide Access to dog talents:
    AddAbility(oDog,ABILITY_TALENT_HIDDEN_DOG);

    // WR_SetObjectActive(oDog,TRUE);
    WR_SetFollowerState(oDog, FOLLOWER_STATE_ACTIVE, TRUE);

    object oModule = GetModule();
    string sDogName = GetLocalString(oModule,EDS_DOG_NAME);
    if ("" != sDogName) {
        // We dont want to autolevel, but the autoscale functions
        // do a lot of setup work. By scaling to a lower level
        // we ensure Race, class and other important character
        // traits are set.
        AS_CommenceAutoScaling(oDog, 2);

        // When added to party, this tracks if it is the
        // first time. If FALSE, it autolevels the creature.
        SetLocalInt(oDog, FOLLOWER_SCALED, TRUE);

        SetName(oDog,sDogName);
        float exp       = GetLocalFloat(oModule,EDS_DOG_XP);
        float level     = GetLocalFloat(oModule,EDS_DOG_LEVEL);
        float xtr_attr = GetLocalFloat(oModule,EDS_DOG_XTRA_ATTRIBUTES);
        float xtr_skil = GetLocalFloat(oModule,EDS_DOG_XTRA_SKILLS);
        float xtr_tal = GetLocalFloat(oModule,EDS_DOG_XTRA_TALENTS);

        exp = GetCreatureProperty(GetHero(),PROPERTY_SIMPLE_EXPERIENCE);
        AF_LogDebug("Updating XP on dogto match PC", AF_LOGGROUP_EDS);
        SetCreatureProperty(oDog,PROPERTY_SIMPLE_EXPERIENCE,exp);
        SetCreatureProperty(oDog,PROPERTY_SIMPLE_LEVEL,level);
        SetCreatureProperty(oDog,PROPERTY_SIMPLE_ATTRIBUTE_POINTS,xtr_attr);
        SetCreatureProperty(oDog,PROPERTY_SIMPLE_SKILL_POINTS,xtr_skil);
        SetCreatureProperty(oDog,PROPERTY_SIMPLE_TALENT_POINTS,xtr_tal);

        string sCollar = GetLocalString(oModule,EDS_DOG_EQUIP_COLLAR);
        string sPaint = GetLocalString(oModule,EDS_DOG_EQUIP_WARPAINT);

        float con = GetLocalFloat(oModule,EDS_DOG_CON);
        float dex = GetLocalFloat(oModule,EDS_DOG_DEX);
        float itl = GetLocalFloat(oModule,EDS_DOG_INT);
        float mag = GetLocalFloat(oModule,EDS_DOG_MAG);
        float str = GetLocalFloat(oModule,EDS_DOG_STR);
        float wil = GetLocalFloat(oModule,EDS_DOG_WIL);

        if (0.0 != con) {
            // eds_Log("Updating CON on dog clone to [" + ToString(con) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_CONSTITUTION,con);
        }
        if (0.0 != dex) {
            // eds_Log("Updating DEX on dog clone to [" + ToString(dex) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_DEXTERITY,dex);
        }
        if (0.0 != itl) {
            // eds_Log("Updating INT on dog clone to [" + ToString(itl) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_INTELLIGENCE,itl);
        }
        if (0.0 != mag) {
            // eds_Log("Updating MAG on dog clone to [" + ToString(mag) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_MAGIC,mag);
        }
        if (0.0 != str) {
            // eds_Log("Updating STR on dog clone to [" + ToString(str) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_STRENGTH,str);
        }
        if (0.0 != wil) {
            // eds_Log("Updating WIL on dog clone to [" + ToString(wil) + "]");
            SetCreatureProperty(oDog,PROPERTY_ATTRIBUTE_WILLPOWER,wil);
        }


        if (GetLocalInt(oModule,EDS_DOG_HAS_GROWL)) {
            AF_LogDebug("Updating Growl Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_GROWL);
            SetQuickslot(oDog, -1, ABILITY_TALENT_MONSTER_DOG_GROWL);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_HOWL)) {
            AF_LogDebug("Updating Howl Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_MABARI_HOWL);
            SetQuickslot(oDog, -1, ABILITY_TALENT_MONSTER_MABARI_HOWL);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_COMBAT)) {
            AF_LogDebug("Updating Combat Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_COMBAT_TRAINING);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_OVERWHELM)) {
            AF_LogDebug("Updating Overwhelm Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_OVERWHELM);
            SetQuickslot(oDog, -1, ABILITY_TALENT_MONSTER_DOG_OVERWHELM);
        }

        if (GetLocalInt(oModule,EDS_DOG_HAS_SHRED)) {
            AF_LogDebug("Updating Shred Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_SHRED);
            SetQuickslot(oDog, -1, ABILITY_TALENT_MONSTER_DOG_SHRED);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_CHARGE))
        {
            AF_LogDebug("Updating Charge Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_CHARGE);
            SetQuickslot(oDog, -1, ABILITY_TALENT_MONSTER_DOG_CHARGE);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_FORT))
        {
            AF_LogDebug("Updating Fort Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_FORTITUDE);
        }
        if (GetLocalInt(oModule,EDS_DOG_HAS_NEMESIS))
        {
            AF_LogDebug("Updating Nemesis Talent]", AF_LOGGROUP_EDS);
            AddAbility(oDog,ABILITY_TALENT_MONSTER_DOG_NEMESIS);
        }
    } else {
        AF_LogDebug("Previous Record Not Found. Using Defaults", AF_LOGGROUP_EDS);

        // When added to party, this tracks if it is the
        // first time and if so, autolevels the creature.
        //
        // see player_core, EVENT_TYPE_PARTY_MEMBER_HIRED
        SetLocalInt(oDog, FOLLOWER_SCALED, FALSE);
        AddAbility(oDog,ABILITY_TALENT_HIDDEN_DOG);

        // AS_ = AutoScale functions
        AS_InitCreature(oDog);

        int p_exp = FloatToInt(GetCreatureProperty(GetHero(),PROPERTY_SIMPLE_EXPERIENCE));
        int d_exp = FloatToInt(GetCreatureProperty(oDog,PROPERTY_SIMPLE_EXPERIENCE));
        if (p_exp-d_exp > 0) {
            RewardXP(oDog,p_exp-d_exp);
        }
    }
    return oDog;
}

/**
* @brief Gets if the party member has an active summons
*
* @return   TRUE if the party member has an activew summons; FALSE otherwise
*/
int _AF_HasSummonedCompanions(object oCaster)
{
    effect[] eSummons = GetEffects(oCaster, EFFECT_TYPE_SUMMON, 0, oCaster);
    int nSize = GetArraySize(eSummons);
    if (0 == nSize) return FALSE;

    // Confirm Summon is not the dog.
    object oSummon = GetCurrentSummon(oCaster);
    if (IsObjectValid(oSummon)) {
        if (GetTag(oSummon) != GEN_FL_DOG) {
            return TRUE;
        }
    }
    return FALSE;
}

/**
* @brief Gets the number of party members with no summons
*
* @return number of party members with no active summons
*/
int _AF_GetNumNonSummonedPartyMembers()
{
    object [] theParty = GetPartyList();
    int nSize = GetArraySize(theParty);
    int total = GetArraySize(theParty);

    AF_LogDebug("Beginning Search for companions with no summons", AF_LOGGROUP_EDS);

    // Some party members may have summoned
    // companions. So we scan all party members
    // and if someone has a summoned effect,
    // we subtract 1 from the total.

    int j;
    for (j = 0; j < nSize; j++) {
        if (_AF_HasSummonedCompanions(theParty[j])) {
            // eds_Log("[" + GetTag(theParty[j]) + "] has a summon");
            total--;
        }
        // else
        // {
        //    eds_Log("[" + GetTag(theParty[j]) + "] does not have a summon");
        // }
    }
    // eds_Log("Examined [" + ToString(nSize) + "] Party Members. Final Total = [" + ToString(total) + "]");
    return total;
}

/**
* @brief Summon the dog
*
* @return   dog object or OBJECT_INVALID on Failure
*/
object _AF_SummonDog()
{
    object oArea = GetArea(GetPartyLeader());
    string sArea = GetTag(oArea);
    // eds_Log("summonDog() Called in area = [" + sArea + "]");

    object oDog = OBJECT_INVALID;
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        // Area checks : We dont allow the whistle to work in all locations
        // Not in fade
        if (GetAreaFlag(oArea,AREA_FLAG_IS_FADE)) {
            UI_DisplayMessage(GetMainControlled(),UI_MESSAGE_NOT_AT_THIS_LOCATION);
            return OBJECT_INVALID;
        }

        // not in combat
        if (GM_COMBAT == GetGameMode()) {
            UI_DisplayMessage(GetMainControlled(),UI_MESSAGE_CANT_DO_IN_COMBAT);
            return OBJECT_INVALID;
        }

        // Not when the PC is playing solo... (Like at the pearl)
        if (1 == _AF_GetNumNonSummonedPartyMembers()) {
            UI_DisplayMessage(GetMainControlled(),UI_MESSAGE_NOT_AT_THIS_LOCATION);
            return OBJECT_INVALID;
        }

        // sArea == "pre200ar_korcari_wilds" ||
        // sArea == "pre100ar_kings_camp_night" ||

        // Specific area checks
        // sArea == "cam100ar_camp_plains" -> Covered by solo check

        if (sArea == "pre100ar_kings_camp" ||
            sArea == "pre211ar_flemeths_hut_int" ||
            sArea == "pre210ar_flemeths_hut_ext" ||
            sArea == "ran405ar_highway_dog") {
            UI_DisplayMessage(GetMainControlled(),UI_MESSAGE_NOT_AT_THIS_LOCATION);
            return OBJECT_INVALID;
        }

        oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);

        if (!IsObjectValid(oDog)) {
            // Dog recruited, but instance not found (this is bad).
            // Maybe it was destroyed or died somehow? Anyway, need code
            // to restore the dog instance. Appears to be in some area
            // transition handler somewhere (leave camp, select dog. If
            // dog is dead, a new instance is created when you enter
            // new area...) Need to trace through scripts and find code
            // to do this, but haven't found time yet.

            oDog = _AF_FixBrokenDog();
            if (IsObjectValid(oDog)) {
                // if name is "gen00fl_dog" or "dog", request new name.
                string s_oldname = StringLowerCase(GetName(oDog));
                if ("dog" == s_oldname || "gen00fl_dog" == s_oldname) {
                    SetLocalInt(GetModule(), EDS_GET_DOG_NAME, 1);

                    // Result of event will go to the OBJECT field (module)
                    // as an EVENT_TYPE_POPUP_RESULT. The input string will
                    // be reflected as string event parameter 0.
                    // Type 2 is the row from popups.gda (Dog Name Input)
                    ShowPopup(STRING_REF_RENAME_DOG, AF_POPUP_RENAME_DOG, GetModule(), TRUE);
                }
            }

        }

        if (IsObjectValid(oDog)) {
            AF_LogDebug("Found Dog", AF_LOGGROUP_EDS);
            WR_SetObjectActive(oDog,TRUE);
            // location behindPC = GetFollowerWouldBeLocation(GetPartyLeader());
            location behindPC = GetLocation(GetMainControlled());
            command cJump = CommandJumpToLocation(behindPC);
            WR_SetFollowerState(oDog, FOLLOWER_STATE_ACTIVE, TRUE);
            WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_PARTY, TRUE, TRUE);
            WR_AddCommand(oDog, cJump);
        } else {
            AF_LogDebug("ERROR : Dog instance not found and could not be created (This is bad).", AF_LOGGROUP_EDS);
            UI_DisplayMessage(GetMainControlled(),UI_MESSAGE_ABILITY_CONDITION_NOT_MET);
        }
    }
    return oDog;
}

// Scan party and find someone without a companion/familiar.
// then attach dog to them. Yes... since party members may cast
// spells that add companions, those spells must be changed to
// check for the dog and move them if need be.
/**
* @brief Attach dog to best party member
*
* Scan party and find someone without a companion/familiar then attach dog to them. Yes... since party members may cast
* spells that add companions, those spells must be changed to check for the dog and move them if need be.
*/
void _AF_AttachDogToParty(object oDog)
{
    AF_LogDebug("attachDogToParty() Called", AF_LOGGROUP_EDS);
    if (IsObjectValid(oDog)) {
        object [] arParty = GetPartyList();
        int nSize = GetArraySize(arParty);
        int i;
        int notFound = TRUE;
        for (i = 0; i < nSize && notFound; i++) {
            // Yes, you can attach a portrait of someone to themself
            // so we have to check for this...
            if (GetTag(arParty[i]) != GEN_FL_DOG) {
                if (!_AF_HasSummonedCompanions(arParty[i])) {
                    int hasHealth = (0.0 < GetCurrentHealth(arParty[i]));
                    if  (!IsDead(arParty[i]) && hasHealth) {
                        notFound = FALSE;
                        effect eSummon = EffectSummon(arParty[i], oDog);

                        // The upkeep affect associated with eSummon places a
                        // picture of the eSummon creature next to the eSummon
                        // owner
                        Ability_ApplyUpkeepEffect(arParty[i], AF_ABI_EDS_DOG_SUMMONED, eSummon);

                        // This effect turns the associaed creature into a "SUMMONED"
                        // creature. The issue is that when the engine removes the
                        // effect, it deletes the creature associated with it. So
                        // we dont want to invoke this effect on the dog.
                        // ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eSummon, oDog, 0.0f, oCaster, 0);

                        // Must set most properties AFTER we apply the effect
                        // as the effect itself will set some of these properties
                        SetLocalInt(oDog, IS_SUMMONED_CREATURE,FALSE);
                        // eds_Log("Attempting to Set dog owner tag to [" + GetTag(arParty[i]) + "]");
                        SetLocalString(GetModule(), DOG_OWNER, GetTag(arParty[i]));
                    }
                }
            }
        }
    }
}

/**
* @brief gets a safe location behind the given creature
*/
location _AF_GetLocationBehindCreature(object oCreature, float distance = -7.5)
{
    float facing = GetFacingFromLocation(GetLocation(oCreature));
    float rFacing = ToRadians(facing);
    vector pos = GetPositionFromLocation(GetLocation(oCreature));

    // trace line
    float xoffset = distance * cos(rFacing);
    float yoffset = distance * sin(rFacing);
    vector traceLine = Vector(pos.x + xoffset, pos.y + yoffset, pos.z);

    location behindMe = Location(GetArea(oCreature),traceLine,facing);
    return GetSafeLocation(behindMe);
}

/**
* @brief causes the dog to run away
*
* If you want a more instant verision, see AF_RemoveDog().
*
* @param    oCaster the party member to deactivate the dog from
*/
void _AF_Deactivate_DogSlot(object oCaster)
{
    AF_LogDebug("deactivate_DogSlot called", AF_LOGGROUP_EDS);

    object oDog = _AF_UnattachDogFromPartyMember(oCaster);
    if (IsObjectValid(oDog)) {
        location offScreen = _AF_GetLocationBehindCreature(oCaster,-40.0);
        command cRunAway = CommandMoveToLocation(offScreen, TRUE);
        WR_AddCommand(oDog, cRunAway);

        // DOESNT WORK:
        // command cRunAway = CommandMoveAwayFromObject(arParty[pm], 40.0);

        // Update variables (checked when party-change events fire).
        AF_LogDebug("Setting NODOGSLOT to TRUE", AF_LOGGROUP_EDS);
        SetLocalInt(GetModule(),NODOGSLOT,TRUE);

        // Give him two seconds and then remove him:
        event eRunAway = Event(EVENT_DOG_RAN_AWAY);
        DelayEvent(1.5, GetModule(), eRunAway);

        // Handled in module event handler : EVENT_DOG_RAN_AWAY
        // if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED))
        //    WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);

    }
}

/**
* @brief removes the dog from the party
* 
* If the dog is attached to a party member it is unattached first and then sent back to camp
*/
void AF_RemoveDog(int bOnlyIfAttached=FALSE) {
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        // Make sure the dog is not attached to anyone
        int bForceStoredFlag = FALSE;
        object oOwner = _AF_GetDogOwner();
        if (!IsObjectValid(oOwner)) {
            string sOwner = _AF_GetStoredDogOwner();
            if ("" != sOwner) {
                oOwner = AF_GetPartyPoolMemberByTag(sOwner);
                if (!_AF_IsDogAttached(oOwner)) {
                    bForceStoredFlag = TRUE;
                    object oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);
                    if (IsObjectValid(oDog)) {
                        SetCurrentHealth(oDog,GetMaxHealth(oDog));
                        SetCreatureStamina(oDog, GetCreatureMaxStamina(oDog));
                    }
                }
            }
        }
        if (IsObjectValid(oOwner)) {
            _AF_UnattachDogFromPartyMember(oOwner, TRUE, bForceStoredFlag);
            WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
        } else if (FALSE == bOnlyIfAttached) {
            WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
        }
    }
}

/**
* @brief Check to see if the mod configuration is valid
*
* This function is expected to be run when the module loads
* It perform a series of checks to ensure that theevent manager configuration appears correct
* The player is presented with warninmg dialogs if an issue is found
*/
void AF_ExtraDogSlotCheckConfig() {
  AF_LogDebug("Testing if dog slot valid", AF_LOGGROUP_EDS);

  int nChecked = GetLocalInt(GetModule(), EDS_CHECK_CONFLICT);
  if (0 == nChecked) {
    int bShowedVital = 0;
    int bShowedMinor = 0;

    // ======  VITAL EVENTS ======
    string dieStr  = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_DYING);
    string firStr  = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_PARTY_MEMBER_FIRED);

    int bDie = (-1 == FindSubString(dieStr,"eventmanager"));
    int bFir = (-1 == FindSubString(firStr,"eventmanager"));
    int bSum = 0;
    int bCom = 0;

    if (2 == (bDie + bFir)) {
      AF_LogWarn("MAJOR CONFLICTS DETECTED", AF_LOGGROUP_EDS);
      ShowPopup(E3_EDS_CONFLICT, AF_POPUP_QUESTION);
    } else if (1 == (bDie + bFir)) {
      if (bDie) {
        AF_LogWarn("MAJOR CONFLICT DETECTED", AF_LOGGROUP_EDS);
        ShowPopup(E1_EDS_CONFLICT, AF_POPUP_QUESTION);
      }
      if (bFir) {
        AF_LogWarn("MAJOR CONFLICT DETECTED", AF_LOGGROUP_EDS);
        ShowPopup(E2_EDS_CONFLICT, AF_POPUP_QUESTION);
      }
    } else {

      // ======  MINOR EVENTS ======

      string sumStr  = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_SUMMON_DIED);
      string penStr  = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_COMMAND_PENDING);
      string comStr  = GetM2DAString(TABLE_EVENTS, "Script", EVENT_TYPE_COMMAND_COMPLETE);

      bSum = (-1 == FindSubString(sumStr,"eventmanager"));
      bCom = (-1 == FindSubString(comStr,"eventmanager") || -1 == FindSubString(penStr,"eventmanager"));

      if (2 == (bSum + bCom)) {
        AF_LogWarn("MINOR CONFLICTS DETECTED", AF_LOGGROUP_EDS);
        ShowPopup(W3_EDS_CONFLICT, AF_POPUP_QUESTION);
      } else {
        if (bSum) {
          AF_LogWarn("MINOR CONFLICT DETECTED", AF_LOGGROUP_EDS);
          ShowPopup(W1_EDS_CONFLICT, AF_POPUP_QUESTION);
        }
        if (bCom) {
          AF_LogWarn("MINOR CONFLICT DETECTED", AF_LOGGROUP_EDS);
          ShowPopup(W2_EDS_CONFLICT, AF_POPUP_QUESTION);
        }
      }
    }

    if (0 < (bDie + bFir + bSum + bCom))
      SetLocalInt(GetModule(), EDS_CHECK_CONFLICT, 2);
    else
      SetLocalInt(GetModule(), EDS_CHECK_CONFLICT, 1);

  }
}

// Checks the PC inventory and gives a dog whistle
// if PC doesn't already have one (And the dog has been recruited).
void AF_ExtraDogSlotGiveDogWhistle()
{
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        object oPC = GetHero();
        int nHasDW = CountItemsByTag(oPC, AF_ITM_EDS_DOG_WHISTLE);
        if ( nHasDW == 0 ) {
            if  (IsObjectValid(oPC)) {
                object dw = CreateItemOnObject(AF_ITR_EDS_WHISTLE,oPC,1);
                if (OBJECT_INVALID == dw) {
                    AF_LogDebug("Dog Whistle was NOT Created", AF_LOGGROUP_EDS);
                } else {
                    AF_LogDebug("Dog Whistle created", AF_LOGGROUP_EDS);
                }
            }
        }
    } else {
        AF_LogDebug("Dog Not member of party. Whistle was NOT Created", AF_LOGGROUP_EDS);
    }
}
                      
/**
* @brief Ensuredog attachment status is valid
*
* If the dog is aet to be attached to an owner but isn't actually attached then the dog
* is unattached and then reattached to the best owner.
* If the number of party summons is maxxed out then unattach the dog from whomever they are attached to
*/
void AF_CheckDogSlot(int markSlot = FALSE)
{
    if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
        int total = _AF_GetNumNonSummonedPartyMembers();
        if (total > 4) {
            object [] arParty = GetPartyList();
            if (GetTag(arParty[4]) != GEN_FL_DOG) {
                WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
                WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_PARTY, TRUE, TRUE);
            }
            object oOwner = _AF_GetDogOwner();
            if (!IsObjectValid(oOwner)) {
                string sOwner = _AF_GetStoredDogOwner();
                if ("" != sOwner) {
                    oOwner = AF_GetPartyPoolMemberByTag(sOwner);
                }
            }
            if (IsObjectValid(oOwner)) {
                // eds_Log("Owner Found... [" + GetTag(oOwner) + "[");
                if ("player" != GetTag(oOwner)) {
                    AF_LogDebug("Owner is not player. Moving...", AF_LOGGROUP_EDS);
                    // Even if PC has a summon, this code will
                    // shift the dog up as far as we can toward
                    // the top.
                    object oDog = _AF_UnattachDogFromPartyMember(oOwner);

                    if (IsObjectValid(oDog)) {
                        // Attempt to re-attach to someone who isn't dead....
                        if (markSlot) {
                            AF_LogDebug("Setting NODOGSLOT to FALSE", AF_LOGGROUP_EDS);
                            SetLocalInt(GetModule(),NODOGSLOT,FALSE);
                        }
                        _AF_AttachDogToParty(oDog);
                    }
                }
            } else {
                object oDog = AF_GetPartyMemberByTag(GEN_FL_DOG);
                if (!IsObjectValid(oDog)) {
                    oDog = _AF_FixBrokenDog();
                    if (IsObjectValid(oDog)) {
                        // if name is "gen00fl_dog" or "dog", request new name.
                        string s_oldname = StringLowerCase(GetName(oDog));
                        if ("dog" == s_oldname || "gen00fl_dog" == s_oldname) {
                            SetLocalInt(GetModule(), EDS_GET_DOG_NAME, 1);

                           // Result of event will go to the OBJECT field (module)
                            // as an EVENT_TYPE_POPUP_RESULT. The input string will
                            // be reflected as string event parameter 0.
                            ShowPopup(STRING_REF_RENAME_DOG, AF_POPUP_RENAME_DOG,GetModule(),TRUE);
                        }
                    }
                }
                if (IsObjectValid(oDog)) {
                    // Attempt to re-attach to someone who isn't dead....
                    if (markSlot) {
                        AF_LogDebug("Setting NODOGSLOT to FALSE", AF_LOGGROUP_EDS);
                        SetLocalInt(GetModule(),NODOGSLOT,FALSE);
                    }
                    _AF_AttachDogToParty(oDog);
                }
            }
        } else {
            // If dog is in party, ensure they do not have an owner.
            if (_AF_IsDogInParty()) {
                object oOwner = _AF_GetDogOwner();
                if (IsObjectValid(oOwner)) {
                    _AF_UnattachDogFromPartyMember(oOwner);
                }
            }
        }
    }
}


/**
* @brief Summon the dog and attach to a pparty member
*/
void AF_Activate_DogSlot(object oCaster, int markSlot=TRUE)
{
    AF_LogDebug("activate_DogSlot Called", AF_LOGGROUP_EDS);

    // No matter what, we summon the dog and add to the party
    object oDog = _AF_SummonDog();
    if (IsObjectValid(oDog))
        AF_CheckDogSlot(markSlot);
    else
        AF_LogDebug("Summon Dog returned invalid object", AF_LOGGROUP_EDS);
}
  
/**
* @brief Initialises the mod on entering a new area
*
* Expected to be run by the module event handler when the player enters a new area
* In some areas the slot is forcibly removed and in others it is added
*/
void AF_ExtraDogSlotLoadingInit() {
  string sArea = GetTag(GetArea(GetMainControlled()));
  AF_LogDebug("Entering Area [" + sArea + "]", AF_LOGGROUP_EDS);

  if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {

    _AF_DogSnapShot();

    if ("arl300ar_fade" == sArea || "cir350ar_fade_weisshaupt" == sArea || "pre211ar_flemeths_hut_int" == sArea || "cam100ar_camp_plains" == sArea || "den211ar_arl_eamon_estate_1" == sArea) {
      AF_RemoveDog();
      if ("cam100ar_camp_plains" == sArea || "den211ar_arl_eamon_estate_1" == sArea) {
        object oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);
        if (!IsObjectValid(oDog)) {
          // Fix the dog
          oDog = _AF_FixBrokenDog();
          if (IsObjectValid(oDog)) {
            WR_SetObjectActive(oDog,TRUE);
            WR_SetFollowerState(oDog, FOLLOWER_STATE_ACTIVE, TRUE);

            // if name is "gen00fl_dog" or "dog", request new name.
            string s_oldname = StringLowerCase(GetName(oDog));
            if ("dog" == s_oldname || "gen00fl_dog" == s_oldname) {
              SetLocalInt(GetModule(), EDS_GET_DOG_NAME, 1);

              // Result of event will go to the OBJECT field (module)
              // as an EVENT_TYPE_POPUP_RESULT. The input string will
              // be reflected as string event parameter 0.
              ShowPopup(STRING_REF_RENAME_DOG, AF_POPUP_RENAME_DOG,GetModule(),TRUE);
            }
          }
        }
        AF_LogDebug("Sending EVENT_MAKE_DOG_CLICKABLE in 1.5 Sec", AF_LOGGROUP_EDS);
        event eMakeClickable = Event(EVENT_MAKE_DOG_CLICKABLE);
        DelayEvent(1.5, GetModule(), eMakeClickable);
      }
    }
    else
    {
      // If they are human noble, add dog when they enter the wilds.
      if ("pre200ar_korcari_wilds" == sArea) {
        int noDogSlot = GetLocalInt(GetModule(),NODOGSLOT);
        if (!noDogSlot) {
          AF_Activate_DogSlot(GetHero());
        }
      }
      AF_CheckDogSlot();
    }
  }
}
              
/**
* @brief event handler for when the dog whistlke is blown
*/
void AF_HandleDogWhistle(event ev)
{
    // See _AF_UnattachDogFromPartyMember above for explantion of BYPASS variable.
    SetLocalInt(GetModule(),DOG_BYPASS,FALSE);
    object oItem = GetEventObject(ev, 0);
    // object oTarget = GetEventObject(ev, 2);

    if (OBJECT_INVALID != oItem && GetTag(oItem) == AF_ITM_EDS_DOG_WHISTLE) {
        if(WR_GetPlotFlag( PLT_GEN00PT_PARTY, GEN_DOG_RECRUITED)) {
            object oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);
            if (IsObjectValid(oDog)) {
                // if name is "gen00fl_dog" or "dog", request new name.
                string s_oldname = StringLowerCase(GetName(oDog));
                if ("dog" == s_oldname || "gen00fl_dog" == s_oldname || "" == s_oldname) {
                    SetLocalInt(GetModule(), EDS_GET_DOG_NAME, 1);

                    // Result of event will go to the OBJECT field (module)
                    // as an EVENT_TYPE_POPUP_RESULT. The input string will
                    // be reflected as string event parameter 0.
                    ShowPopup(STRING_REF_RENAME_DOG, 2,GetModule(),TRUE);
                }
            }
        }

        object oOwner = _AF_GetDogOwner();
        if (IsObjectValid(oOwner)) {
            _AF_Deactivate_DogSlot(oOwner);
        } else if (FALSE == _AF_IsDogInParty()) {
            object oCaster = GetEventObject(ev, 1);
            AF_Activate_DogSlot(oCaster);
        }
    }
}
       
/**
* @brief event handler for the rename dog popup
*
* @return TRUE if the event is handled:; FALSE otherwise
*/
int AF_ExtraDogSlotPopupEventHandler(event ev) {
    int nPopupID  = GetEventInteger(ev, 0);  // popup ID (references a row in popups 2da)
    if (nPopupID == AF_POPUP_RENAME_DOG) {
        if (GetLocalInt(GetModule(), EDS_GET_DOG_NAME)) {
            SetLocalInt(GetModule(), EDS_GET_DOG_NAME, 0);
            string dogName = GetEventString(ev,0);
            if ("" != dogName) {
                // Find the dog and set its name:
                object oDog = AF_GetPartyPoolMemberByTag(GEN_FL_DOG);
                if (IsObjectValid(oDog)) {
                    AF_LogDebug("Renaming Dog to [" + dogName + "]", AF_LOGGROUP_EDS);
                    SetName(oDog,dogName);
                }
            }
        }
        return TRUE;
    } else {
        return FALSE;
    }
}

/**
* @brief  Update the dog slot on party selection change
*/
void AF_ExtraDogSlotPartyPicker() {
  AF_LogDebug("EVENT_TYPE_PARTYPICKER_CLOSED", AF_LOGGROUP_EDS);
  // Should I care?
  int noDogSlot = GetLocalInt(GetModule(),NODOGSLOT);
  if (!noDogSlot) {
    AF_LogDebug("NO DOG SLOT is false", AF_LOGGROUP_EDS);
    // Only need to attach if dog is not in party
    if (!_AF_IsDogInParty()) {
      object oOwner = OBJECT_INVALID;
      string sOwner = _AF_GetStoredDogOwner();
      if ("" != sOwner) oOwner = AF_GetPartyPoolMemberByTag(sOwner);
      if (IsObjectValid(oOwner)) _AF_UnattachDogFromPartyMember(oOwner);
      // This will set NODOGSLOT to FALSE, but it is already false (hense why we got here)...
      // so it doesn't matter.
      AF_Activate_DogSlot(GetHero());
    }
  } else {
    AF_LogDebug("NODOGSLOT is true. Ignoring change of party", AF_LOGGROUP_EDS);
  }
}

/**
* @brief event handler for EVENT_TYPE_COMMAND_PENDING post listener
*
* @param    ev event being handled
*/
void AF_EDS_EventCommandPending(event ev) {
    int nCommandId       = GetEventInteger(ev, 0);
    if (COMMAND_TYPE_USE_ABILITY == nCommandId) {
        int nCommandSubType  = GetEventInteger(ev, 1);
        switch (nCommandSubType) {
            case ABILITY_TALENT_NATURE_I_COURAGE_OF_THE_PACK:
            case ABILITY_TALENT_NATURE_II_HARDINESS_OF_THE_BEAR:
            case ABILITY_TALENT_SUMMON_SPIDER:
            case ABILITY_SPELL_ANIMATE_DEAD: {
                AF_LogDebug("Intercepted Summon Spell Begin. Removing Dog", AF_LOGGROUP_EDS);
                object oCaster = GetEventObject(ev, 0);
                object oDog = OBJECT_INVALID;
                if (_AF_IsDogAttached(oCaster)) {
                    oDog = _AF_UnattachDogFromPartyMember(oCaster);
                }
                break;
            }
            case ABILITY_SPELL_SPIDER_SHAPE:
            case ABILITY_SPELL_FLYING_SWARM:
            case ABILITY_SPELL_BEAR: {
                // When they activate a shapechange, it has a
                // location object. When they disable a shapechange
                // it does not. However, disabling shapechange does
                // not break the dog slot.

                location l1 = GetEventLocation(ev,0);
                vector pos1 = GetPositionFromLocation(l1);
                if (0.0 != pos1.x && 0.0 != pos1.y && 0.0 != pos1.z) {
                    AF_LogDebug("Intercepted Summon Spell Begin. Removing Dog", AF_LOGGROUP_EDS);
                    object oCaster = GetEventObject(ev, 0);
                    object oDog = OBJECT_INVALID;
                    if (_AF_IsDogAttached(oCaster)) {
                        oDog = _AF_UnattachDogFromPartyMember(oCaster);
                    }
                }
            }
            break;
        }
    }
}

/**
* @brief event handler for EVENT_TYPE_COMMAND_COMPLETE post listener
*
* @param    ev event being handled
*/
void AF_EDS_EventCommandComplete(event ev) {
    int nCommandId       = GetEventInteger(ev, 0);
    if (COMMAND_TYPE_USE_ABILITY == nCommandId) {
        int nCommandSubType  = GetEventInteger(ev, 2);
        switch (nCommandSubType) {
            case ABILITY_TALENT_NATURE_I_COURAGE_OF_THE_PACK:
            case ABILITY_TALENT_NATURE_II_HARDINESS_OF_THE_BEAR:
            case ABILITY_TALENT_SUMMON_SPIDER:
            case ABILITY_SPELL_ANIMATE_DEAD:
            case ABILITY_SPELL_SPIDER_SHAPE:
            case ABILITY_SPELL_FLYING_SWARM:
            case ABILITY_SPELL_BEAR: {
                AF_LogDebug("Intercepted Summon Spell End. Re-Adding Dog", AF_LOGGROUP_EDS);
                AF_CheckDogSlot();
            }
            break;
        }
    }
}

/**
* @brief event handler for EVENT_TYPE_DYING post listener
*
* @param    ev event being handled
*/
void AF_EDS_EventDying(event ev) {
    object oKiller = GetEventObject(ev, 0);
    object oCreature = OBJECT_SELF;
    object oPC = GetPartyLeader();

    // Extra : Non-Party kills XP
    if (IsObjectValid(oKiller) && TRUE != IsPartyMember(oKiller) && IsObjectHostile(OBJECT_SELF, oPC)) {
        RewardXPParty(0, XP_TYPE_COMBAT, oCreature, oPC);
        if (GetCombatantType(oCreature) != CREATURE_TYPE_NON_COMBATANT) {
            HandleEvent(ev, AF_RES_SYS_TREASURE);
        }
    }

    // Extra Dog Slot
    //
    // Dog shifts to new owner if owner dies in combat.
    //
    // Notes: Dog Dying event fires first when owner dies, but
    // his death event fires after the owner. The idea is to
    // catch the dying event and revive the dog if he is the
    // last man standing so that combat doesn't end early.
    //
    // There is no way of knowing what the dogs health/stamina was
    // before the event fired, so we simply grant half health
    // on resurrection/transfer to new owner.
    //
    // This should be complimented by an end of combat event
    // so we can fix the dog owner after the party has been
    // resurrected.

    if (IsPartyMember(oCreature)) {
        // AF_LogDebug("Party member is dying", AF_LOGGING_EDS);
        // PrintEventProperties(ev);

        // Do we care? Only if there are more than 4
        // party members:
        int total = _AF_GetNumNonSummonedPartyMembers();
        if (total > 4) {
            // If we can find a dog owner, there
            // is no need in continueing.
            object oOwner = _AF_GetDogOwner();
            if (FALSE == IsObjectValid(oOwner)) {
                // OK, something is up. 5 people in
                // party, but dog doesn't have an owner...

                if (GetTag(oCreature) == GEN_FL_DOG) {
                    AF_LogDebug("Party member is Dog", AF_LOGGROUP_EDS);

                    // To get the new variables to work, I had
                    // to make my own var_module.gda file and
                    // declare my variable names/types.

                    if (GetLocalInt(GetModule(),DOG_BYPASS)) {
                        AF_LogDebug("ByPass is TRUE. Ignoring Dog Dying event", AF_LOGGROUP_EDS);
                        SetLocalInt(GetModule(),DOG_BYPASS,FALSE);
                    } else {
                        AF_LogDebug("ByPass is FALSE. Handling Dog Dying event", AF_LOGGROUP_EDS);

                        // What is known:
                        // - there are > 4 PM, so the dog should have an owner
                        // - the getDogOwner function returned nothing, so
                        //   case 1: the owner just died and took the dog with it
                        //   case 2: all living NPCs had summons, and there wan't any room for an attachment
                        //   case 3: Dog is the last man standing and he just died.
                        //
                        // - When we scan for a dog owner, on success we store
                        //   the tag in a variable. If that tag has a value,
                        //   then the dog HAD an owner... (case 1). If it
                        //   is empty, then it is case 2 or 3... but case
                        //   2 and 3 do not involve resurrecting/salvaging
                        //   the dog. (We can treat them both the same)

                        string sOwner = _AF_GetStoredDogOwner();
                        AF_LogDebug("Stored Owner returned [" +  sOwner + "]", AF_LOGGROUP_EDS);
                        if ("" != sOwner) {
                            AF_LogDebug("Owner died. Handling", AF_LOGGROUP_EDS);

                            // case 1: 1 the owner just died and took the dog with it

                            object oOldOwner = AF_GetPartyPoolMemberByTag(sOwner);
                            object oDog = _AF_UnattachDogFromPartyMember(oOldOwner);
                            if (IsObjectValid(oDog)) {
                                // Attempt to re-attach to someone who isn't dead....
                                _AF_AttachDogToParty(oDog);
                            }
                        } else {
                            // Case 2 or 3.
                            //
                            //   Case 2 - There could be party members alive
                            //   and a summon might have died since our last
                            //   check. If this is the case, a clickable
                            //   portrait would be nice.
                            //
                            //   Case 3 - Scanning the dead party will be a
                            //   waste of time. But figuring out if the party
                            //   is dead or not would take just as much time,
                            //   so it doesn't hurt to simply scan. (Same
                            //   implementation as case 2)
                            //
                            //   NOTE : We could add a check for
                            //   EVENT_SUMMON_DIED and handle these scenarios
                            //   there...

                            _AF_AttachDogToParty(oCreature);
                        }
                    }
                } else {
                    // What is known:
                    // - there are > 4 PM, so the dog should have an owner
                    // - the getDogOwner function returned nothing. It is
                    //   possible that the owner of a dead dog just died.
                    //   If that is the case, we want to move the portrait
                    //   to someone else.

                    string sOwner = _AF_GetStoredDogOwner();
                    // AF_LogDebug("Stored Owner returned [" +  sOwner + "]", AF_LOGGROUP_EDS
                    if (sOwner ==  GetTag(oCreature)) {
                        object oDog = _AF_UnattachDogFromPartyMember(oOwner,FALSE);
                        if (IsObjectValid(oDog)) {
                            // Attempt to re-attach to someone who isn't dead....
                            _AF_AttachDogToParty(oDog);
                        }
                    }
                }
            } // if oOwner object is valid
        } // if party size > 4
    } // if isPartyMember(oCreature)
}

/**
* @brief event handler for EVENT_TYPE_PARTY_MEMBER_FIRED post listener
*
* @param    ev event being handled
*/
void AF_EDS_EventPartyMemberFired(event ev) {
    // fix for human noble intro.
    string sArea = GetTag(GetArea(GetHero()));
    if ("bhn100ar_castle_cousland" == sArea)
        return;

    // NOTES: When the game removes the party, it pings the current
    // party list and then, the first 3 array entries (list[1] -> list[3]
    // sets party member as being at camp. This happens all at once.
    // THEN, these events start to trickle. So by the time
    // the first event happens, getPartyList will already be returning
    // only the PC and what was previously the 5th party member.
    //
    // MOST the time, the fifth party member array element/was the dog,
    // but sometimes it belongs to someone else. Problem is, when the
    // game restores the other 3 party members, it will destroy the person
    // with the PC, effectively removing that person from the game and
    // possibly breaking the game.
    //
    // SO... Regardless of who the last person is, if we get down
    // to 2 party members, we automaticallly remove the second
    // party member.
    //
    // This code assumes that there are not more than 5 (non-summoned)
    // companions.

    object [] arParty = GetPartyList();
    int nSize = GetArraySize(arParty);
    if (nSize > 1) {
        int total = _AF_GetNumNonSummonedPartyMembers();
        if (total == 2) {
            AF_RemoveDog();

            // Just in case the last person is not the dog
            arParty = GetPartyList();
            nSize = GetArraySize(arParty);

            int i;
            for (i = 1; i < nSize; i++) {
                AF_RemoveParyMember(arParty[i]);
            }
        }
    }
}