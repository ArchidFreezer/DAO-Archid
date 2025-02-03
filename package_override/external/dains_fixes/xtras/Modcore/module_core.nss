// All module events

#include "ability_h"
#include "log_h"
#include "utility_h"
#include "wrappers_h"
#include "events_h"
#include "approval_h"
#include "events_h"
#include "world_maps_h"
#include "placeable_h"
#include "ai_main_h_2"
#include "sys_soundset_h"
#include "tutorials_h"
#include "plt_gen00pt_party"
#include "plt_tut_combat_basic"
#include "plt_tut_combat_basic_magic"
#include "plt_tut_codex_item"
#include "plt_tut_aicontrol"
#include "plt_tut_areamap"
#include "plt_tut_crafting"
#include "plt_tut_journal"
#include "plt_tut_store"
#include "plt_tut_worldmap"
#include "plt_tut_overload"
#include "plt_tut_chanters_board"
#include "plt_tut_item_upgrade"
#include "achievement_core_h"
#include "stats_core_h"
void main()
{
    event ev   = GetCurrentEvent();
    int nEvent = GetEventType(ev);

    Log_Events("", ev);

    switch (nEvent)
    {
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The module starts. This can happen only once for a single
        //       game instance.
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_MODULE_START:
        {
            TrackModuleEvent(nEvent, OBJECT_SELF);

            TrackSendGameId(TRUE);

            break;
        }
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The module loads from a save game, or for the first time. This event can fire more than
        //       once for a single module or game instance.
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_MODULE_LOAD:
        {
            //Log_InitSystem(LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG, OBJECT_SELF);

//            Log_InitSystem(LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG, LOG_LEVEL_DEBUG);
            Approval_Init();

            // Hostility setups
            SetGroupHostility(GROUP_PC, GROUP_HOSTILE, TRUE);
            SetGroupHostility(GROUP_FRIENDLY, GROUP_HOSTILE, TRUE);

            TrackModuleEvent(nEvent, OBJECT_SELF);

            TrackSendGameId(FALSE);

            break;
        }
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The player changes a game option from the options menu
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_OPTIONS_CHANGED:
        {

        }
        break;
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The player completes the final step of a quest
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_PLOT_COMPLETED:
        {
            // Increment "finished quests" counter
            ACH_LogTrace(LOG_CHANNEL_REWARDS, "A quest was completed.");
            ACH_TrackCompletedQuests();
        }
        break;
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: The party's money changes
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_PARTY_MONEY_CHANGED:
        {
            int nMoney = GetEventInteger(ev, 0);
            // Track the new money value
            STATS_HandleMaxMoney(nMoney);
            // Track money spent
            STATS_TrackMoneySpent(nMoney);
        }
        break;
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: A codex was added or changed (excludes tutorial codex)
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_CODEX_CHANGED:
        {
            int iPrevious = GetEventInteger(ev, 0); //1 if the codex is unlocked, else it is an update
            int iTitle = GetEventInteger(ev, 1); //strref of the codex title
            int iDesc = GetEventInteger(ev, 2); //strref of the codex desc

            //Send the description resref of the codex as the eventID to the server
            LogStoryEvent(iDesc);

            // Track the number of codex entries, only if this is the first unlock
            if(iPrevious) STATS_TrackCodexEntries();
        }
        break;
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: A player objects enters the module
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_ENTER:
        {
            object oCreature = GetEventObject(ev, 0);
            //TrackModuleEvent(nEventType, OBJECT_SELF, oCreature);

            break;
        }
        ////////////////////////////////////////////////////////////////////////
        // Sent by: The engine
        // When: the player clicks on a destination in the world map
        ////////////////////////////////////////////////////////////////////////
        case EVENT_TYPE_WORLD_MAP_USED:
        {
            int nFrom = GetEventInteger(ev, 0); // travel start location
            int nTo = GetEventInteger(ev, 1); // travel target location

            TrackModuleEvent(nEvent, OBJECT_SELF);

            break;
        }

        case 95 /*EVENT_CHARACTER_SHEET_DISPLAYED*/:
        {
            object oChar = GetEventObject(ev,0);

            if (IsObjectValid(oChar))
            {
                // -------------------------------------------------------------
                // This updates the damage number of the display.
                // -------------------------------------------------------------
                RecalculateDisplayDamage(oChar);

                //Update stats
                STATS_HandlePercentDamageDealt(oChar);
                STATS_SetGameTimePlayed();
                ACH_CalculatePercentageComplete();
            }

            break;
        }

        case 102: /*ITEM CRAFTED*/
        {
            object oChar = GetEventObject(ev,0);

            //An item has been crafted, add it to the running total for ach. and stats
            ACH_CraftAchievement(oChar);
            STATS_TrackItemsCrafted();

            break;
        }

        // ---------------------------------------------------------------------
        // Game Mode Switch
        //      int(0) - New Game Mode (GM_* constant)
        //      int(1) - Old Game Mode (GM_* constant)
        // ---------------------------------------------------------------------
        case EVENT_TYPE_GAMEMODE_CHANGE:
        {
            int nNewGameMode = GetEventInteger(ev,0);
            int nOldGameMode = GetEventInteger(ev,1);

            //------------------------------------------------------------------
            // 2008-Feb-29 - EV 89889 by Georg
            // We don't care about the new game mode being GUI and other
            // non gameplay related modes
            //------------------------------------------------------------------
            if (nNewGameMode == GM_GUI || nNewGameMode == GM_FLYCAM || nNewGameMode == GM_INVALID || nNewGameMode == GM_PREGAME)
            {
                return;
            }

            if(nNewGameMode != GM_COMBAT)
            {
                // prevent party members from attacking until allowed to do so
                AI_SetPartyAllowedToAttack(FALSE);

                if (nNewGameMode == GM_EXPLORE) {
                    //Check for levelup tutorial if in Explore mode
                    //don't show if chargen has been skipped
                    if (ReadIniEntry("DebugOptions", "SkipCharGen") != "1") {
                        object oModule = GetModule();
                        //1 means show the tutorial, 2 means it has been seen
                        if (GetLocalInt(oModule, "TUTORIAL_HAVE_SEEN_LEVEL_UP") == 1)
                        {
                            SetLocalInt(oModule, "TUTORIAL_HAVE_SEEN_LEVEL_UP", 2);
                            BeginTrainingMode(TRAINING_SESSION_LEVEL_UP);
                        }
                    }
                }
            }
            Ability_OnGameModeChange(nNewGameMode, nOldGameMode);

            // ----------------------------------------------------------------
            // Remove party soundset restrictions
            // -----------------------------------------------------------------
            SSPartyResetSoundsetRestrictions();

            // -----------------------------------------------------------------
            // If new game mode is combat, set CombatState on each Party Member
            // -----------------------------------------------------------------
            SetCombatStateParty(nNewGameMode == GM_COMBAT);

            if (nNewGameMode == GM_COMBAT)
            {
                // Tutorial message
                if(GetLocalInt(GetModule(), TUTORIAL_ENABLED))
                {
                    if(GetCreatureCoreClass(GetHero()) == CLASS_WIZARD)
                    {
                        WR_SetPlotFlag(PLT_TUT_COMBAT_BASIC_MAGIC, TUT_COMBAT_BASIC_MAGIC_1, TRUE);
                    }
                    else
                        WR_SetPlotFlag(PLT_TUT_COMBAT_BASIC, TUT_COMBAT_BASIC_1, TRUE);
                }
            }
            // else below

            // <rant>
            // Georg Sept 10, 2008:
            //        If we are going into dialog mode, we always revive the party.
            //        Note: I am not happy about this. The core problem is that we have to
            //              requirements fighting with each other.
            //
            //              a) Don't have people jump up immediately after combat
            //              b) Before a dialog starts, people need to be revived and it has to happen
            //                 inline in the currently executing context because once it ends, we're
            //                 no longer in control of what happens, the dialog/cutscene engine takes over.
            //
            //              This lends itself to a host of issues, including race coditions.
            //
            //              The real solution is to have the writers stop writing 'combat ends,
            //              force dialog situations' but that's not gonna happen for DA.
            //
            //              The following 3 lines will force all party members alive - immediately
            //              in-line. Implicitly, this will cause termination of the delayed gamemode
            //              change event loop in the event queue next time it gets processed.
            //
            //
            else if (nNewGameMode == GM_DIALOG)
            {
                ResurrectPartyMembers();
            }
            // </rant>



            break;
        }

        // ---------------------------------------------------------------------
        // Party Resurrection button (cheat, death UI)
        // ---------------------------------------------------------------------
        case EVENT_TYPE_DEATH_RES_PARTY:
        {
            TrackModuleEvent(nEvent, OBJECT_SELF,OBJECT_INVALID);

            ResurrectPartyMembers(TRUE);

            DelayEvent(0.5 ,OBJECT_SELF, Event(EVENT_TYPE_DEBUG_RESURRECTION ));

            break;
        }


        case EVENT_TYPE_DELAYED_GM_CHANGE:
        {

            int gm = GetGameMode();
            if (!IsPartyPerceivingHostiles(GetHero()))
            {
                if (!IsPartyDead())
                {

                    if (gm == GM_COMBAT)
                    {
                        if (CheckResurrection())
                        {
                            // ------------------------------------------------------------------
                            // ... we switch the game back to explore mode.
                            // Note: This switches CombatState on all party members as party of
                            //       the GameModeChange Module Level Event
                            // ------------------------------------------------------------------
                            WR_SetGameMode(GM_EXPLORE);
                        }
                        else
                        {
                            // Player out of range, try again later.
                            DelayEvent(1.0f, OBJECT_SELF, Event(EVENT_TYPE_DELAYED_GM_CHANGE));
                        }
                    }
                    else if (gm == GM_EXPLORE)
                    {
                        if (CheckForDeadPartyMembers())
                        {
                           if (!CheckResurrection())
                           {
                                DelayEvent(2.0f, OBJECT_SELF, Event(EVENT_TYPE_DELAYED_GM_CHANGE));
                           }
                        }
                    }
                    else
                    {
                         // Lets try again in two seconds
                        DelayEvent(2.0f, OBJECT_SELF, Event(EVENT_TYPE_DELAYED_GM_CHANGE));
                    }
                 }
            }

            break;
        }


        case EVENT_TYPE_AUTOPAUSE:
        {
             if (GetGameMode() == GM_EXPLORE || GetGameMode() == GM_COMBAT)
                 ToggleGamePause();

             SetLocalInt(OBJECT_SELF, "MODULE_COUNTER_2", 0);
             break;
        }

        //----------------------------------------------------------------------
        // Game Mode Changed.
        //----------------------------------------------------------------------
        case EVENT_TYPE_SET_GAME_MODE:
        {
            int nGameMode = GetEventInteger(ev, 0);

            // -----------------------------------------------------------------
            // Signal Pause event to the game when hitting combat
            // -----------------------------------------------------------------
            if (nGameMode == GM_COMBAT && GetGameMode() == GM_EXPLORE)
                if (ConfigIsAutoPauseEnabled() && !GetLocalInt(OBJECT_SELF, "MODULE_COUNTER_2")) {
                    DelayEvent(0.5f,OBJECT_SELF, Event(EVENT_TYPE_AUTOPAUSE));
                    SetLocalInt(OBJECT_SELF, "MODULE_COUNTER_2", 1);
                }

            if (nGameMode != GM_EXPLORE || !IsNoExploreArea())
                SetGameMode(nGameMode);

            break;
        }

        // ---------------------------------------------------------------------
        // This makes the resurrection button work.
        // ---------------------------------------------------------------------
        case EVENT_TYPE_DEBUG_RESURRECTION :
        {
            if (GetGameMode() == GM_DEAD)
            {
                if (!IsPartyDead())
                {
                    if (!IsPartyPerceivingHostiles(GetHero()))
                    {
                        SetGameMode(GM_EXPLORE);
                    }
                }
            }

            break;
        }
        case EVENT_TYPE_CAMPAIGN_ITEM_ACQUIRED:
        {
            object oItem = GetEventObject(ev, 0);
            string sItemTag = GetTag(oItem);
            object oAcquirer = GetEventCreator(ev);

            /// ----------------------------------------------------------------
            // Handle specialization traiers
            /// ----------------------------------------------------------------
            int nSpec = GetLocalInt(oItem,ITEM_SPECIALIZATION_FLAG);
            if (nSpec > 0)
            {
                RW_UnlockSpecializationTrainer(nSpec);
                WR_DestroyObject(oItem);
            }

            int nCodexItem = GetLocalInt(oItem, ITEM_CODEX_FLAG);
            if (nCodexItem > -1 && IsFollower(oAcquirer))
            {

                WR_SetPlotFlag(PLT_TUT_CODEX_ITEM, TUT_CODEX_ITEM, TRUE);
                Log_Trace(LOG_CHANNEL_SYSTEMS, GetCurrentScriptName(), "Got a codex item: " + GetTag(oItem));
                WR_SetPlotFlag(GetTag(oItem), nCodexItem, TRUE, TRUE);
                WR_DestroyObject(oItem);
            }

            if (GetTag(oItem) == "gen_im_misc_backpack")
            {
                if (IsFollower(oAcquirer) == TRUE)
                {
                    int nSize = GetMaxInventorySize(oAcquirer);
                    nSize += 10;
                    SetMaxInventorySize(nSize, oAcquirer);
                    WR_DestroyObject(oItem);
                }
            }

            break;
        }


        case EVENT_TYPE_CREATURE_ENTERS_DIALOGUE:
        {
            object oCreature = GetEventObject(ev, 0);

            RemoveEffectsDueToPlotEvent(oCreature);




            DEBUG_PrintToScreen("Enter Dialog:" + ToString(oCreature));

            break;
        }


        case EVENT_TYPE_COMBO_IGNITE:
        {
            HandleEvent(ev, R"sys_comboeffects.ncs");
            break;
        }


        // Party member added to active party using the party GUI
        case EVENT_TYPE_PARTYMEMBER_ADDED:
        {
            object oFollower = GetEventObject(ev, 0);
            Log_Trace(LOG_CHANNEL_EVENTS, GetCurrentScriptName(), "EVENT_TYPE_PARTYMEMBER_ADDED, follower: " + GetTag(oFollower));

            WR_SetObjectActive(oFollower, TRUE);

            string sTag = GetTag(oFollower);
            if(sTag == GEN_FL_ALISTAIR) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_ALISTAIR_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_DOG) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_LELIANA) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_LELIANA_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_LOGHAIN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_LOGHAIN_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_MORRIGAN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_MORRIGAN_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_OGHREN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_OGHREN_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_SHALE) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_SHALE_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_STEN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_STEN_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_WYNNE) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_WYNNE_IN_PARTY, TRUE, TRUE);
            else if(sTag == GEN_FL_ZEVRAN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_ZEVRAN_IN_PARTY, TRUE, TRUE);

            break;
        }
        // Party member removed from active party using the party GUI
        case EVENT_TYPE_PARTYMEMBER_DROPPED:
        {
            object oFollower = GetEventObject(ev, 0);
            Log_Trace(LOG_CHANNEL_EVENTS, GetCurrentScriptName(), "EVENT_TYPE_PARTYMEMBER_DROPPED, follower: " + GetTag(oFollower));

            string sTag = GetTag(oFollower);
            if(sTag == GEN_FL_ALISTAIR) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_ALISTAIR_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_DOG) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_DOG_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_LELIANA) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_LELIANA_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_LOGHAIN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_LOGHAIN_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_MORRIGAN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_MORRIGAN_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_OGHREN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_OGHREN_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_SHALE) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_SHALE_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_STEN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_STEN_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_WYNNE) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_WYNNE_IN_CAMP, TRUE, TRUE);
            else if(sTag == GEN_FL_ZEVRAN) WR_SetPlotFlag(PLT_GEN00PT_PARTY, GEN_ZEVRAN_IN_CAMP, TRUE, TRUE);

            WR_SetObjectActive(oFollower, FALSE);
            break;
        }
        case EVENT_TYPE_WORLD_MAP_CLOSED:
        {
            WM_SetWorldMapGuiStatus();
            break;
        }
        case EVENT_TYPE_PARTYPICKER_CLOSED:
        {
            WM_SetPartyPickerGuiStatus();
            break;
        }

        case EVENT_TYPE_POPUP_RESULT:
        {
            object oOwner = GetEventObject(ev, 0);      // owner of popup
            int nPopupID  = GetEventInteger(ev, 0);     // popup ID
            int nButton   = GetEventInteger(ev, 1);     // button result (1 - 4)

            switch (nPopupID)
            {
                case 1:     // Placeable area transition
                    SignalEvent(oOwner, ev);
                    break;
            }
            break;
        }


        //GUI tutorial calls
        case EVENT_TYPE_GUI_OPENED:
        {
            int nGUIID = GetEventInteger(ev, 0);
            switch (nGUIID)
            {

                case GUI_INVENTORY: //Inventory ScreenOpened
                WR_SetPlotFlag(PLT_TUT_INVENTORY, TUT_INVENTORY_1, TRUE);
                {
                    object[] arParty = GetPartyPoolList();
                    int i, nSize = GetArraySize(arParty);
                    for (i = 0; i < nSize; i++) {
                        RecalculateDisplayDamage(arParty[i]);
                    }
                }
                break;
                case GUI_JOURNAL: //Journal
                WR_SetPlotFlag(PLT_TUT_JOURNAL, TUT_JOURNAL_1, TRUE);
                break;
                case GUI_MAP: //Area Map
                WR_SetPlotFlag(PLT_TUT_AREAMAP, TUT_AREA_MAP_1, TRUE);
                break;
                case GUI_WORLD_MAP: //World Map
                WR_SetPlotFlag(PLT_TUT_WORLDMAP, TUT_WORLDMAP_1, TRUE);
                break;
                case GUI_TACTICS: //AI Tactics screen
                WR_SetPlotFlag(PLT_TUT_AICONTROL, TUT_AI_CONTROL_1, TRUE);
                break;
                case GUI_STORE: //Store GUI
                WR_SetPlotFlag(PLT_TUT_STORE, TUT_FIRST_STORE_1, TRUE);
                break;
                case GUI_CRAFTING: //Crafting
                WR_SetPlotFlag(PLT_TUT_CRAFTING, TUT_CRAFTING_1, TRUE);
                break;
                case GUI_CHANTERS: //Chanter's Board
                WR_SetPlotFlag(PLT_TUT_CHANTERS_BOARD, TUT_CHANTERS_BOARD, TRUE);
                break;
                case GUI_ITEM_UPGRADE: //Enchanter Upgrade
                WR_SetPlotFlag(PLT_TUT_ITEM_UPGRADE, TUT_ITEM_UPGRADE_SCREEN_OPEN, TRUE);
                break;
             }
            break;
        }

        case EVENT_TYPE_INVENTORY_FULL:
        {
            WR_SetPlotFlag(PLT_TUT_OVERLOAD, TUT_INVENTORY_OVERLOAD_1, TRUE);
            break;
        }

        case EVENT_TYPE_ACHIEVEMENT:
        {
            ACH_ProcessAchievementModuleEvent(ev);
            break;
        }
        case EVENT_TYPE_PARTYPICKER_INIT:
        {
            // Match follower XP to player (in case the player can open the party picker in this area
            object [] arParty = GetPartyPoolList();
            arParty = GetPartyPoolList();
            int nSize = GetArraySize(arParty);
            int i;
            object oCurrent;

            for(i = 0; i < nSize; i++)
            {
                oCurrent = arParty[i];
                RW_CatchUpToPlayer(oCurrent);
            }

            break;
        }

        default:
        {
            // -----------------------------------------------------------------
            // Handle character generation events sent by the engine.
            // -----------------------------------------------------------------
            if ((nEvent >= EVENT_TYPE_CHARGEN_START && nEvent <= EVENT_TYPE_CHARGEN_END) || nEvent == EVENT_TYPE_PLAYERLEVELUP )
            {
                HandleEvent(ev, R"sys_chargen.ncs");
            }
            else
            {
                Log_Trace(LOG_CHANNEL_EVENTS, GetCurrentScriptName(), Log_GetEventNameById(nEvent) + " (" + ToString(nEvent) + ") *** Unhandled event ***");
            }
            break;
        }

    }
}