//::///////////////////////////////////////////////
//:: Plot Events
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Plot events for Background Elf City
*/
//:://////////////////////////////////////////////
//:: Created By: Cori
//:: Created On: 10/31/06
//:://////////////////////////////////////////////

#include "log_h"
#include "utility_h"
#include "wrappers_h"
#include "plot_h"
#include "sys_achievements_h"
#include "sys_audio_h"
#include "campaign_h"
#include "tutorials_h"

#include "plt_bec000pt_talked_to"
#include "plt_bec000pt_main"
#include "plt_gen00pt_party"
#include "plt_bec210pt_guard_sleeping"
#include "plt_bec100pt_soris"
#include "bec_constants_h"
#include "plt_gen00pt_class_race_gend"
#include "plt_bec110pt_shianni"
#include "plt_bec100pt_wedding"
#include "plt_gen00pt_class_race_gend"
#include "plt_tut_plot_map"
#include "plt_bec000pt_knowledge"

#include "plt_cod_cha_duncan"
#include "plt_cod_hst_wardens"
#include "plt_cod_mgc_chant_blight"
#include "plt_cod_mgc_darkspawn"
#include "plt_cod_hst_denerim"

#include "plt_mnp000pt_autoss_origins"

#include "achievement_core_h"

int StartingConditional()
{
    event eParms = GetCurrentEvent();                // Contains all input parameters
    int nType = GetEventType(eParms);               // GET or SET call
    string strPlot = GetEventString(eParms, 0);         // Plot GUID
    int nFlag = GetEventInteger(eParms, 1);          // The bit flag # being affected
    object oParty = GetEventCreator(eParms);      // The owner of the plot table for this script
    object oConversationOwner = GetEventObject(eParms, 0); // Owner on the conversation, if any
    int nResult = FALSE; // used to return value for DEFINED GET events
    object oPC = GetHero();
    object oBetrothed;
    int nFemale = WR_GetPlotFlag( PLT_GEN00PT_CLASS_RACE_GEND, GEN_GENDER_FEMALE);
    // -----------------------------------------------------
    ////Sets whether the betrothed is male or female version
    // -----------------------------------------------------
    if(nFemale == TRUE)
    {
        oBetrothed = UT_GetNearestCreatureByTag(oPC,BEC_CR_NELAROS);
    }
    else
    {
        oBetrothed = UT_GetNearestCreatureByTag(oPC,BEC_CR_NESIARA);
    }
    object oAmbientF1 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_F_1);
    object oAmbientF2 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_F_2);
    object oAmbientF3 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_F_3);
    object oAmbientM1 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_M_1);
    object oAmbientM2 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_M_2);
    object oAmbientM3 = UT_GetNearestCreatureByTag(oPC,BEC_CR_AMBIENT_M_3);
    object oBoy = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_BOY);
    object oBridesmaid1 = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_BRIDESMAID1);
    object oBridesmaid2 = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_BRIDESMAID2);
    object oCaptain = UT_GetNearestCreatureByTag(oPC,BEC_CR_GUARD_CAPTAIN);
    object oChild = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_CHILD);
    object oChildTr = UT_GetNearestObjectByTag(oPC,BEC_TR_CHILDREN);
    object oCommonerF = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_COMMONER_F);
    object oDilwyn = UT_GetNearestCreatureByTag(oPC,BEC_CR_DILWYN);
    object oDuncan = UT_GetNearestCreatureByTag(oPC,BEC_CR_DUNCAN);
    object oElva = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELVA);
    object oFather = UT_GetNearestCreatureByTag(oPC,BEC_CR_FATHER);
    object oGambler1 = UT_GetNearestCreatureByTag(oPC,BEC_CR_GAMBLING_GUARD1);
    object oGambler2 = UT_GetNearestCreatureByTag(oPC,BEC_CR_GAMBLING_GUARD2);
    object oGambler3 = UT_GetNearestCreatureByTag(oPC,BEC_CR_GAMBLING_GUARD3);
    object oGethon = UT_GetNearestCreatureByTag(oPC,BEC_CR_GETHON);
    object oGirl = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_GIRL);
    object oGuard = UT_GetNearestCreatureByTag(oPC,BEC_CR_CITY_GUARD);
    object oDaughter = UT_GetNearestCreatureByTag(oPC,BEC_CR_HOMELESS_DAUGHTER);
    object oHomelessM = UT_GetNearestCreatureByTag(oPC,BEC_CR_HOMELESS_ELF_MAN);
    object oHomelessW = UT_GetNearestCreatureByTag(oPC,BEC_CR_HOMELESS_ELF_WOMAN);
    object oLaborer = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_LABORER);
    object oLord1 = UT_GetNearestCreatureByTag(oPC,BEC_CR_HENCHLORD1);
    object oLord2 = UT_GetNearestCreatureByTag(oPC,BEC_CR_HENCHLORD2);
    object oBoann = UT_GetNearestCreatureByTag(oPC,BEC_CR_MOTHER_BOANN);
    object oServant = UT_GetNearestCreatureByTag(oPC,BEC_CR_ELF_SERVANT);
    object oShianni = UT_GetNearestCreatureByTag(oPC,BEC_CR_SHIANNI);
    object oSleeping =  UT_GetNearestCreatureByTag(oPC,BEC_CR_SLEEPING_GUARD);
    object oSoldier = UT_GetNearestCreatureByTag(oPC,BEC_CR_SOLDIER);
    object oSoris = UT_GetNearestCreatureByTag(oPC,BEC_CR_SORIS);
    object oTaeodor = UT_GetNearestCreatureByTag(oPC,BEC_CR_TAEODOR);
    object oValendrian = UT_GetNearestCreatureByTag(oPC,BEC_CR_VALENDRIAN);
    object oValora = UT_GetNearestCreatureByTag(oPC,BEC_CR_VALORA);
    object oVaughan = UT_GetNearestCreatureByTag(oPC,BEC_CR_VAUGHAN);
    object oFamilyFriendsTrigger = UT_GetNearestObjectByTag(oPC,BEC_TR_FAMILY_FRIENDS);
    object oSouthPatrol = UT_GetNearestObjectByTag(oPC,BEC_CR_PATROL_SOUTH);
    object oArlBedroom = UT_GetNearestObjectByTag(oPC,BEC_IP_ARL_BEDROOM_DOOR);
    object oHomelessAmbTr = UT_GetNearestObjectByTag(oPC,BEC_TR_HOMELESS_AMBIENT);
    object oCart = UT_GetNearestObjectByTag(oPC,BEC_IP_HOMELESS_CART);

    plot_GlobalPlotHandler(eParms); // any global plot operations, including debug info

    if(nType == EVENT_TYPE_SET_PLOT) // actions -> normal flags only
    {
        int nValue = GetEventInteger(eParms, 2);        // On SET call, the value about to be written (on a normal SET that should be '1', and on a 'clear' it should be '0')
        int nOldValue = GetEventInteger(eParms, 3);     // On SET call, the current flag value (can be either 1 or 0 regardless if it's a set or clear event)
        // IMPORTANT: The flag value on a SET event is set only AFTER this script finishes running!
        switch(nFlag)
        {

            case BEC_MAIN_SORIS_JOINS_GROUP:
            {
                // -----------------------------------------------------
                // //ACTION: Add Soris to the Party
                // -----------------------------------------------------
                UT_HireFollower(oSoris);

                // -----------------------------------------------------
                // //ACTION: Spawn Wedding Party (Shianni, Bridesmaids, Valora, Player's Betrothed)
                // -----------------------------------------------------
                WR_SetObjectActive(oShianni,TRUE);
                WR_SetObjectActive(oBridesmaid1,TRUE);
                WR_SetObjectActive(oBridesmaid2,TRUE);
                WR_SetObjectActive(oValora,TRUE);
                SetObjectInteractive(oValora,FALSE);
                WR_SetObjectActive(oBetrothed,TRUE);
                WR_SetObjectActive(oLaborer,TRUE);
                SetObjectInteractive(oLaborer,FALSE);
                int nLabourer = GetObjectInteractive(oLaborer);
                Log_Trace(LOG_CHANNEL_PLOT,"bec000pt_main.nss","Laborer interactive: " + IntToString(nLabourer));

                // -----------------------------------------------------
                // //ACTION: Spawn Vaughn and 2 friends
                // -----------------------------------------------------
                UT_SetTeamInteractive(BEC_TEAM_ALIENAGE_CUTSCENE,FALSE);

                WR_SetObjectActive(oVaughan,TRUE);
                WR_SetObjectActive(oLord1,TRUE);
                WR_SetObjectActive(oLord2,TRUE);

                // -----------------------------------------------------
                // //and set talk trigger to init the vaughn1 dialog when the player approaches.
                // -----------------------------------------------------
                WR_SetPlotFlag(PLT_BEC100PT_SORIS,BEC_SORIS_IN_PARTY,TRUE,TRUE);

                break;
            }

            case BEC_MAIN_GIRLS_KIDNAPPED:
            {
                // -----------------------------------------------------
                // If the PC is Male
                // -----------------------------------------------------
                if(WR_GetPlotFlag( PLT_GEN00PT_CLASS_RACE_GEND, GEN_GENDER_MALE))
                {
                // -----------------------------------------------------
                // Set journal entry
                // -----------------------------------------------------
                    WR_SetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_PC_FIANCEE_IS_KIDNAPPED,TRUE,TRUE);
                // -----------------------------------------------------
                // //Spawn gate servant near Valendrian.
                // -----------------------------------------------------
                    WR_SetObjectActive(oServant,TRUE);

                // -----------------------------------------------------
                // //Crowd elves around Duncan and Valendrian.
                // -----------------------------------------------------

                    UT_LocalJump(oBoann,BEC_WP_MOB_BOANN);
                    UT_LocalJump(oValendrian,BEC_WP_MOB_VALENDRIAN);
                    UT_LocalJump(oDuncan,BEC_WP_MOB_DUNCAN);
                    UT_LocalJump(oLaborer,BEC_WP_MOB_LABOURER);
                    UT_LocalJump(oDilwyn,BEC_WP_MOB_DILWYN);
                    UT_LocalJump(oCommonerF,BEC_WP_MOB_COMMONER);
                    UT_LocalJump(oGethon,BEC_WP_MOB_GETHON);
                    UT_LocalJump(oFather,BEC_WP_MOB_FATHER);
                    UT_LocalJump(oBoy,BEC_WP_MOB_BOY);
                    UT_LocalJump(oTaeodor,BEC_WP_MOB_TAEODOR);
                    UT_LocalJump(oElva,BEC_WP_MOB_ELVA);
                    UT_LocalJump(oAmbientF1,BEC_WP_MOB_AMBIENT_F1);
                    UT_LocalJump(oAmbientF2,BEC_WP_MOB_AMBIENT_F2);
                    UT_LocalJump(oAmbientF3,BEC_WP_MOB_AMBIENT_F3);
                    UT_LocalJump(oAmbientM1,BEC_WP_MOB_AMBIENT_M1);
                    UT_LocalJump(oAmbientM2,BEC_WP_MOB_AMBIENT_M2);
                    UT_LocalJump(oAmbientM3,BEC_WP_MOB_AMBIENT_M3);



                // -----------------------------------------------------
                // //Put a talk trigger around them for Valendrian to init.
                // Soris wakes up the player and inits dialog afte the screen fade back in.
                // -----------------------------------------------------
                    WR_SetPlotFlag(PLT_BEC100PT_SORIS,BEC_SORIS_AND_PC_LEFT_BEHIND_AFTER_KIDNAPPING,TRUE,TRUE);
//                    AudioTriggerPlotEvent(43);
                    UT_Talk(oSoris,oPC);
                 }

                // -----------------------------------------------------
                // IF the PC is Female
                // -----------------------------------------------------
                else
                {
                // -----------------------------------------------------
                // Set journal entry
                // -----------------------------------------------------
                    WR_SetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_PC_IS_KIDNAPPED,TRUE,TRUE);
                // -----------------------------------------------------
                // //Remove Soris from party
                // -----------------------------------------------------
                    UT_FireFollower(oSoris,FALSE,FALSE);
                    WR_SetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_SORIS_JOINS_GROUP,FALSE);
                    WR_SetPlotFlag(PLT_BEC100PT_SORIS,BEC_SORIS_IN_PARTY,FALSE);
                    WR_SetPlotFlag(PLT_BEC100PT_SORIS,BEC_SORIS_LEFT_BEHIND_AFTER_KIDNAPPING,TRUE,TRUE);
                    //WR_SetObjectActive(oSoris,FALSE);

                // -----------------------------------------------------
                // //PC FEMALE: Jump all to armory.
                // -----------------------------------------------------
                    UT_DoAreaTransition(BEC_AR_ESTATE_INTERIOR, BEC_WP_PALACE_PC);
                }

                // -----------------------------------------------------
                // REGARDLESS OF GENDER:
                // Set plot and codex entries
                // -----------------------------------------------------
                WR_SetPlotFlag(PLT_BEC110PT_SHIANNI,BEC_SHIANNI_KIDNAPPED,TRUE,TRUE);

                // -----------------------------------------------------
                // //Remove all children.
                // -----------------------------------------------------
                if(GetObjectActive(oChild) == TRUE)
                {
                    WR_SetObjectActive(oChild,FALSE);
                }
                if(GetObjectActive(oBoy) == TRUE)
                {
                    SetObjectInteractive(oBoy,FALSE);
                }
                if(GetObjectActive(oGirl) == TRUE)
                {
                    WR_SetObjectActive(oGirl,FALSE);
                }
                if(GetObjectActive(oChildTr) == TRUE)
                {
                    WR_SetObjectActive(oChildTr,FALSE);
                }

                // -----------------------------------------------------
                // //Jump female fiance, Valora, Shiani and 2 bridesmaids into the castle.
                // -----------------------------------------------------
                WR_SetObjectActive(oBetrothed,FALSE);
                WR_SetObjectActive(oValora,FALSE);
                WR_SetObjectActive(oShianni,FALSE);
                WR_SetObjectActive(oBridesmaid1,FALSE);
                WR_SetObjectActive(oBridesmaid2,FALSE);

                // -----------------------------------------------------
                // //remove the hooligans
                // -----------------------------------------------------
                WR_SetObjectActive(oVaughan,FALSE);
                WR_SetObjectActive(oLord1,FALSE);
                WR_SetObjectActive(oLord2,FALSE);

                // -----------------------------------------------------
                // //Remove the priest
                // -----------------------------------------------------
                SetObjectInteractive(oBoann,FALSE);

                // -----------------------------------------------------
                // //destroy repeating triggers
                // -----------------------------------------------------
                WR_SetObjectActive(oFamilyFriendsTrigger,FALSE);
                // -----------------------------------------------------
                // remove characters with no post-kidnapping dialogue
                // -----------------------------------------------------
                if(GetObjectActive(oTaeodor) == TRUE)
                {
                    SetObjectInteractive(oTaeodor,FALSE);
                }
                else
                {
                    WR_SetObjectActive(oTaeodor,TRUE);
                    SetObjectInteractive(oTaeodor,FALSE);
                }
                if(GetObjectActive(oDaughter) == TRUE)
                {
                    WR_SetObjectActive(oDaughter,FALSE);
                }
                if(GetObjectActive(oHomelessM) == TRUE)
                {
                    WR_SetObjectActive(oHomelessM,FALSE);
                }
                if(GetObjectActive(oHomelessW) == TRUE)
                {
                    WR_SetObjectActive(oHomelessW,FALSE);
                }
                if(GetObjectActive(oHomelessAmbTr) == TRUE)
                {
                    WR_SetObjectActive(oHomelessAmbTr,FALSE);
                }
                if(GetObjectActive(oCart) == TRUE)
                {
                    WR_SetObjectActive(oCart,FALSE);
                }
                break;
            }

            case BEC_MAIN_PALACE_COMBAT_BEGINS_WITH_GAMBLERS:
            {
                // -----------------------------------------------------
                // //Combat begins. Castle is now on aggro.
                // COMBAT still to be scripted
                // -----------------------------------------------------
                //WR_SetPlotFlag(PLT_BEC210PT_GUARD_SLEEPING,BEC_SLEEPING_AWAKENED_BY_ACTIVITY,TRUE);
                UT_TeamMove(BEC_TEAM_ESTATE_GAMBLING_GUARDS,BEC_WP_GAMBLER_COMBAT,TRUE,0.1,TRUE);
                UT_TeamGoesHostile(BEC_TEAM_ESTATE_GAMBLING_GUARDS, TRUE);
                /*
                WR_SetObjectActive(oGambler1,FALSE);
                WR_SetObjectActive(oGambler2,FALSE);
                WR_SetObjectActive(oGambler3,FALSE);
                */
                event ePatrol = Event(EVENT_TYPE_CUSTOM_EVENT_01);
                SignalEvent(oSouthPatrol,ePatrol);
                break;
            }

            case BEC_MAIN_PALACE_COMBAT_BEGINS_WITH_SLEEPER:
            {
                // -----------------------------------------------------
                // //Combat begins. Castle is now on aggro.
                // COMBAT still to be scripted
                // -----------------------------------------------------
                SetCreatureIsGhost(oSleeping, FALSE);
                UT_TeamGoesHostile(BEC_TEAM_ESTATE_SLEEPING_GUARD, TRUE);
                /*
                WR_SetObjectActive(oSleeping,FALSE);
                WR_SetObjectActive(oGambler1,FALSE);
                WR_SetObjectActive(oGambler2,FALSE);
                WR_SetObjectActive(oGambler3,FALSE);
                */
                break;
            }
            case BEC_MAIN_BRIBE_ACCEPTED:
            {
                // -----------------------------------------------------
                // //ACTION: give bribe to player to leave girls behind
                // -----------------------------------------------------
                WR_SetPlotFlag(PLT_BEC110PT_SHIANNI,BEC_SHIANNI_LEFT_AT_PALACE,TRUE);
                if(nFemale == FALSE)
                {
                    WR_SetPlotFlag(PLT_BEC100PT_WEDDING,BEC_WEDDING_NESIARA_LEFT_BEHIND,TRUE);
                }
                UT_DoAreaTransition(BEC_AR_ESTATE_EXTERIOR,BEC_WP_AFTER_BRIBE);
                break;
            }
            case BEC_MAIN_VAUGHAN_COMBAT_BEGINS:
            {
                // -----------------------------------------------------
                // //Combat begins with Vaughan
                // -----------------------------------------------------

                SetPlaceableState(oArlBedroom,PLC_STATE_DOOR_LOCKED);
                SetObjectInteractive(oShianni,FALSE);
                UT_TeamGoesHostile(BEC_TEAM_ESTATE_VAUGHNS_MEN, TRUE);

                break;
            }
            case BEC_MAIN_PC_JUMP_OUTSIDE_OF_CASTLE:
            {
                // -----------------------------------------------------
                // //Player, servant and Soris are warped to outside the Arl's Palace. Keys next conversation.
                // -----------------------------------------------------
//                AudioTriggerPlotEvent(44);
                UT_DoAreaTransition(BEC_AR_ESTATE_EXTERIOR,BEC_WP_FROM_ALIENAGE_TO_ESTATE_EXTERIOR);
                break;
            }
            case BEC_MAIN_PC_JOINED_GREY_WARDENS:
            {
                // -----------------------------------------------------
                // //ACTION: Captain and Guards exit. NPCS spread out.
                // -----------------------------------------------------
                SetObjectInteractive(oGuard,FALSE);
                SetObjectInteractive(oSoldier,FALSE);
                SetObjectInteractive(oCaptain,FALSE);


                // //If Soris wasn't saved then remove him from the area.
                // -----------------------------------------------------
                int nSaved = WR_GetPlotFlag(PLT_BEC100PT_SORIS,BEC_SORIS_SAVED);
                if((nSaved == FALSE) && (GetObjectActive(oSoris) == TRUE))
                {
                    SetObjectInteractive(oSoris,FALSE);
                }

                break;
            }
            case BEC_MAIN_GIRLS_RESCUED:
            {
                // -----------------------------------------------------
                //  //Teleport out to alienage center
                // -----------------------------------------------------
                if(WR_GetPlotFlag(PLT_GEN00PT_CLASS_RACE_GEND,GEN_GENDER_MALE))
                {
                    WR_SetPlotFlag(PLT_BEC100PT_WEDDING,BEC_WEDDING_NESIARA_RESCUED,TRUE,TRUE);
                }


                UT_DoAreaTransition(BEC_AR_ELVEN_ALIENAGE,BEC_WP_RESCUED_PLAYER);


                // -----------------------------------------------------
                // //If male: jump Velora, Shiani, bridemaid1 and Nesaira
                // If female: jump Velora, Shiani and bridemaid1
                // -----------------------------------------------------
                break;
            }
            case BEC_MAIN_START_PRELUDE:
            {
                // -----------------------------------------------------
                // //Start Chapter 1.
                // -----------------------------------------------------

                // FAB 7/2: Adding achievements
                UT_FireFollower(oSoris,TRUE);
                int bCondition1 = WR_GetPlotFlag(PLT_BEC000PT_TALKED_TO, BEC_TALKED_TO_FAMILY_FRIENDS);
                int bCondition2 = WR_GetPlotFlag(PLT_BEC000PT_TALKED_TO, BEC_TALKED_TO_HOMELESS);
                int bCondition3 = WR_GetPlotFlag(PLT_BEC000PT_TALKED_TO, BEC_TALKED_TO_TAEODOR);

                // Grant achievement: elf city completed
                WR_UnlockAchievement(ACH_ADVANCE_CONSCRIPTED);
                // If the Player hasn't died, grant achievement: Bloodied
                ACH_CheckForSurvivalAchievement(ACH_FEAT_BLOODIED);

                if ( bCondition1 && bCondition2 && bCondition3 ) Acv_Grant(29);
                // END 7/2

                Log_Plot("JUMP TO PRELUDE");
                int nShianniLeft = WR_GetPlotFlag(PLT_BEC110PT_SHIANNI,BEC_SHIANNI_LEFT_AT_PALACE,TRUE);
                int nShianniFarewell = WR_GetPlotFlag(PLT_BEC110PT_SHIANNI,BEC_SHIANNI_SPOKE_AFTER_GREY_WARDEN,TRUE);
                if((nShianniLeft == FALSE) && (nShianniFarewell == FALSE))
                {
                    WR_SetPlotFlag(PLT_BEC110PT_SHIANNI,BEC_SHIANNI_LEFT_BEHIND_IN_ALIENAGE,TRUE,TRUE);
                }
                //remove plot items from inventory

                object oCheap = GetItemPossessedBy(oPC,BEC_IM_CHEAP_BRANDY);
                object oGood = GetItemPossessedBy(oPC, BEC_IM_BRANDY);
                object oPoison = GetItemPossessedBy(oPC,BEC_IM_RAT_POISON);
                object oCleanser = GetItemPossessedBy(oPC,BEC_IM_CLEANSER);
                object oSorisWedding = GetItemPossessedBy(oPC,BEC_IM_SORIS_WEDDING);

                if(IsObjectValid(oSorisWedding) == TRUE)
                {
                    // Don't remove the wedding clothes in case they are being worn, we wouldn't
                    //   want to appear naked in front of the king
                    // UT_RemoveItemFromInventory(rBEC_IM_SORIS_WEDDING); 
                }

                if(IsObjectValid(oCheap) == TRUE)
                {
                     UT_RemoveItemFromInventory(rBEC_IM_CHEAP_BRANDY);
                }
                if(IsObjectValid(oGood) == TRUE)
                {
                    UT_RemoveItemFromInventory(rBEC_IM_BRANDY);
                }
                if(IsObjectValid(oPoison) == TRUE)
                {
                    UT_RemoveItemFromInventory(rBEC_IM_RAT_POISON);
                }
                if(IsObjectValid(oCleanser) == TRUE)
                {
                    UT_RemoveItemFromInventory(rBEC_IM_CLEANSER);
                }
                //jump to king's camp
                UT_DoAreaTransition(PRE_AR_KINGS_CAMP, PRE_WP_START);

                //percentage complete plot tracking
                ACH_TrackPercentageComplete(ACH_FAKE_BEC_1);

                break;
            }
            case BEC_MAIN_PLOT_ACCEPTED:
            {
                // -----------------------------------------------------
                // //servant goes to Palace district door
                // -----------------------------------------------------
                AudioTriggerPlotEvent(44);

                Rubber_GoHome(oDilwyn);
                Rubber_GoHome(oCommonerF);
                Rubber_GoHome(oGethon);
                Rubber_GoHome(oBoy);
                Rubber_GoHome(oTaeodor);
                WR_SetObjectActive(oBoann,FALSE);

                UT_LocalJump(oFather,BEC_WP_FATHER_GOODBYE);
                UT_LocalJump(oServant,BEC_WP_SERVANT_ALIENAGE);

                if (WR_GetPlotFlag(PLT_BEC000PT_KNOWLEDGE,BEC_KNOWLEDGE_EQUIPMENT_TRAINING) == FALSE)
                {
                    WR_SetPlotFlag(PLT_BEC000PT_KNOWLEDGE,BEC_KNOWLEDGE_EQUIPMENT_TRAINING, TRUE);

                    BeginTrainingMode(TRAINING_SESSION_EQUIPMENT);
                }

                break;
            }
            case BEC_MAIN_WEDDING_TIME:
            {
                //stop the wandering people
                SetLocalInt(oAmbientF1,AMBIENT_SYSTEM_STATE,0);
                SetLocalInt(oAmbientM2,AMBIENT_SYSTEM_STATE,0);
                UT_TeamAppears(BEC_TEAM_ANIMAL_NONINTERACTIVE,FALSE);

                WR_SetObjectActive(oValendrian,TRUE);

                UT_LocalJump(oValendrian,BEC_WP_WEDDING_VALENDRIAN);
                UT_LocalJump(oShianni,BEC_WP_WEDDING_SHIANNI);

                //set the journal entry for Soris's plot as well.

                WR_SetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_AFTER_DUNCAN,TRUE,TRUE);
                // -----------------------------------------------------
                // Set the grey warden related codex entries
                // -----------------------------------------------------
                WR_SetPlotFlag(PLT_COD_CHA_DUNCAN,COD_CHA_DUNCAN_MAIN,TRUE,TRUE); //signed
                WR_SetPlotFlag(PLT_COD_HST_WARDENS,COD_HST_WARDENS,TRUE,TRUE);//signed
                WR_SetPlotFlag(PLT_COD_MGC_CHANT_BLIGHT,COD_MGC_CHANT_OF_LIGHT_BLIGHTS,TRUE,TRUE);//signed
                WR_SetPlotFlag(PLT_COD_MGC_DARKSPAWN,COD_MGC_DARKSPAWN,TRUE,TRUE);//signed
                break;
            }
            case BEC_MAIN_WEDDING_PARTY_APPROACHED:
            {
                UT_SetTeamInteractive(BEC_TEAM_ALIENAGE_CUTSCENE,TRUE);
                SetObjectInteractive(oLaborer,FALSE);
                break;
            }
            case BEC_MAIN_FIND_SORIS:
            {
                //set up tutorial
                WR_SetPlotFlag(PLT_TUT_PLOT_MAP,TUT_PLOT_MAP_1,TRUE,TRUE);
                break;
            }
            case BEC_MAIN_AFTER_DUNCAN:
            {
                // -----------------------------------------------------
                // Take an automatic screenshot
                // -----------------------------------------------------
                WR_SetPlotFlag(PLT_MNP000PT_AUTOSS_ORIGINS, AUTOSS_BEC_MEETING_DUNCAN,TRUE,TRUE);
                break;
            }
            case BEC_MAIN_DUNCAN_EJECTED:
            {
                UT_LocalJump(oLaborer,BEC_WP_AFTER_VAUGHAN_LABORER);
                break;
            }
        }
     }
     else // EVENT_TYPE_GET_PLOT -> defined conditions only
     {
        switch(nFlag)
        {
            case BEC_MAIN_GIRLS_KIDNAPPED_AND_PC_MALE:
            {
                int nMale = WR_GetPlotFlag(PLT_GEN00PT_CLASS_RACE_GEND,GEN_GENDER_MALE,TRUE);
                int nKidnapped = WR_GetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_GIRLS_KIDNAPPED,TRUE);
                // -----------------------------------------------------
                // if PC male and girls kidnapped
                // -----------------------------------------------------
                if((nKidnapped == TRUE) && (nMale == TRUE))
                {
                    nResult = TRUE;
                }
                break;
            }
            case BEC_MAIN_BRIBE_ACCEPTED_AND_NOT_HIDDEN:
            {
                int nAccept = WR_GetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_BRIBE_ACCEPTED);
                int nHidden = WR_GetPlotFlag(PLT_BEC000PT_MAIN,BEC_MAIN_BRIBE_HIDDEN);
                // -----------------------------------------------------
                // if bribe accepted and not hidden
                // -----------------------------------------------------
                if((nAccept == TRUE) && (nHidden == FALSE))
                {
                    nResult = TRUE;
                }
                break;
            }
        }
    }

    return nResult;
}