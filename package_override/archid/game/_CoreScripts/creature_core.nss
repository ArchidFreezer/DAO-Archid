// -----------------------------------------------------------------------------
// creature_core
// -----------------------------------------------------------------------------
/*

    Handles AI Creature (NPC) events.

    Follower/Player events are handled in player_core.

    Note: this script redirects all events not handled into rules_core.

*/
// -----------------------------------------------------------------------------
// Owner: Yaron Jakobs, Georg Zoeller
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
//             L I M I T E D   E D I T   P E R M I S S I O N S
//
//      If you are not Georg or Yaron, you need permission to edit this file
//      and the changes have to be code reviewed before they are checked
//      in.
//
// -----------------------------------------------------------------------------


#include "rules_h"
#include "log_h"
#include "utility_h"
#include "global_objects_h"
#include "ai_main_h_2"
#include "ai_ballista_h"
#include "design_tracking_h"
#include "sys_rewards_h"
#include "sys_autoscale_h"
#include "sys_rubberband_h"
#include "sys_soundset_h"
#include "sys_ambient_h"
#include "sys_treasure_h"
#include "sys_areabalance"
#include "aoe_effects_h"

void EquipDefaultItem(int nAppType, int nTargetSlot, string s2daColumnName)
{
    // Equip default creature item based on appearance (only if none equipped yet)
    object oItem = GetItemInEquipSlot(nTargetSlot, OBJECT_SELF);
    resource rDefaultCreatureItem;
    object oDefaultCreatureoItem;
    string sItem;
    if(!IsObjectValid(oItem))
    {
        rDefaultCreatureItem = GetM2DAResource(TABLE_APPEARANCE, s2daColumnName, nAppType);
        sItem = ResourceToString(rDefaultCreatureItem);
        #ifdef DEBUG
        Log_Trace(LOG_CHANNEL_EVENTS, "creature_core.EVENT_TYPE_SPAWN", "Default creature item for this appearance: [" + sItem + "] for inventory slot: " +
            IntToString(nTargetSlot));
        #endif
        if(sItem != "")
        {
            oDefaultCreatureoItem = CreateItemOnObject(rDefaultCreatureItem, OBJECT_SELF);
            SetItemDroppable(oDefaultCreatureoItem, FALSE);
            if(IsObjectValid(oDefaultCreatureoItem))
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_EVENTS, "creature_core.EVENT_TYPE_SPAWN", "Creating default item on creature");
                #endif
                EquipItem(OBJECT_SELF, oDefaultCreatureoItem, nTargetSlot);
            }
        }
    }
}

void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    // If TRUE, we won't redirect to rules core
    int bEventHandled = FALSE;

    #ifdef DEBUG
    Log_Events("", ev);
    #endif

    if (IsPartyMember(OBJECT_SELF))
    {
        Warning("Party member " + ToString(OBJECT_SELF) + " firing events into creature_core. This is a critical bug. Please inform Yaron");
        HandleEvent(ev, R"rules_core.ncs"); // fix it
        return;
    }


    switch (nEventType)
    {
        // -----------------------------------------------------------------
        // Damage over time tick event.
        // This is activated from EffectDOT and keeps rescheduling itself
        // while DOTs are in effect on the creature
        // -----------------------------------------------------------------
        case EVENT_TYPE_DOT_TICK:
        {
            if (!IsDead() && !IsDying())
            {
                Effects_HandleCreatureDotTickEvent();
            }

            // Event was handled - don't fall through to rules_core
            bEventHandled = TRUE;
            break;
        }

        case EVENT_TYPE_PERCEPTION_DISAPPEAR:
        {
            // A creature exits the perception area of creature receiving the event

            object oDisappearer = GetEventObject(ev, 0); //GetEventCreator(ev);
            if (IsObjectHostile(oDisappearer,OBJECT_SELF))
            {
                Combat_HandleCreatureDisappear(OBJECT_SELF, oDisappearer);
            }

            // Event was handled - don't fall through to rules_core
            bEventHandled = TRUE;
            break;
        }

        //----------------------------------------------------------------------
        // EVENT_TYPE_DAMAGED
        //
        //----------------------------------------------------------------------
        case EVENT_TYPE_DAMAGED:
        {
            object oThis = OBJECT_SELF;


            // temp randomizer, this will happen in the engine at some point.
/*            if (Random(5) == 1)
            {
                PlaySoundSet(oThis,SS_COMBAT_PAIN_GRUNT);
            }*/


            // Check surrender conditions
            if (GetLocalInt(oThis, "SURR_SURRENDER_ENABLED"))
            {
                if (!IsDead(oThis) && GetCurrentHealth(oThis) < 2.0)
                {
                    UT_Surrender(oThis);
                }
            }

            // Added by Dain's Fixes to allow custom EVENT_TYPE_DAMAGED override handlers to pass
            //   events through to another script. This is used to have the rules_core event code
            //   applied via a custom af_rules_damaged script that contains the rules_core code
            string sScript = GetEventString(ev, 0);
            if (sScript != "") {
                HandleEvent_String(ev, sScript);
                bEventHandled = TRUE;
            }
            break;
        }

        // ---------------------------------------------------------------------
        // EVENT_TYPE_DYING - Received on the creature getting the killing blow
        // ---------------------------------------------------------------------
        case EVENT_TYPE_DYING:
        {
            object oKiller = GetEventObject(ev, 0);

            #ifdef DEBUG
            Log_Trace( LOG_CHANNEL_EVENTS, "creature_core.EVENT_TYPE_DYING", "Killer: " + ToString(oKiller));
            #endif

            // Dispense death rewards.
            if (IsObjectValid(oKiller) && IsPartyMember(oKiller))
            {
                RewardXPParty(0,XP_TYPE_COMBAT, OBJECT_SELF, oKiller);
                // if this creature is a combatant, pass the event to the treasure function
                if (GetCombatantType(OBJECT_SELF) != CREATURE_TYPE_NON_COMBATANT)
                {
                    HandleEvent(ev, R"sys_treasure.ncs");
                }
            }

            // Last words
            SSPlaySituationalSound(OBJECT_SELF, SOUND_SITUATION_DYING);

            bEventHandled = TRUE;
            break;
        }
        // ---------------------------------------------------------------------
        // EVENT_TYPE_DEATH:
        // The death effect has been applied to this creature, either by losing hit points
        // or by explicit calling of the effect
        // ---------------------------------------------------------------------
        case EVENT_TYPE_DEATH:
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_EVENTS,"creature_core.EVENT_TYPE_DEATH","received death event", OBJECT_SELF);
            #endif


            SetCreatureFlag(OBJECT_SELF,CREATURE_RULES_FLAG_DYING,FALSE);

            // -------------------------------------------------------------
            // Clear the object's perception list
            // -------------------------------------------------------------
            ClearPerceptionList(OBJECT_SELF);


            object oKiller = GetEventCreator(ev);
            #ifdef DEBUG
            Log_Trace_Combat("creature_core.EVENT_TYPE_DEATH", "creature received death event",oKiller, OBJECT_SELF);
            #endif

            // -----------------------------------------------------------------
            // Clear any registed AI waypoints
            // -----------------------------------------------------------------
            object oAIWP = GetLocalObject(OBJECT_SELF, AI_REGISTERED_WP);
            if(IsObjectValid(oAIWP))
            {
                SetTag(oAIWP, AI_WP_MOVE);
                SetLocalObject(OBJECT_SELF, AI_REGISTERED_WP, OBJECT_INVALID);
            }

            // -----------------------------------------------------------------
            // Killer may play a victory sound...
            // -----------------------------------------------------------------
            SSPlaySituationalSound(oKiller, SOUND_SITUATION_ENEMY_KILLED);

            if (GetCanDiePermanently(OBJECT_SELF))
            {


                if (HasAbility(OBJECT_SELF, 450000) == TRUE)
                {
                    Effect_DoOnDeathExplosion(OBJECT_SELF, TRUE, 4.0, 110109, DAMAGE_TYPE_PHYSICAL, 0.0f, 0.25f);

                    SetObjectActive(OBJECT_SELF, 0, 0, 0);
                    Safe_Destroy_Object(OBJECT_SELF, 1500);
                }
                else if (HasAbility(OBJECT_SELF, ABILITY_TRAIT_EXPLOSIVE))
                {
                    Effect_DoOnDeathExplosion(OBJECT_SELF, TRUE, 4.0, 93091, DAMAGE_TYPE_FIRE);

                    SetObjectActive(OBJECT_SELF, 0, 0, 0);// 93091);
                    Safe_Destroy_Object(OBJECT_SELF, 1500);
                }
                else if (HasAbility(OBJECT_SELF,ABILITY_TRAIT_GHOST))
                {
                    Engine_ApplyEffectAtLocation(EFFECT_DURATION_TYPE_INSTANT, EffectVisualEffect(93095), GetLocation(OBJECT_SELF), 0.0f, OBJECT_SELF, 0);
                    SetObjectActive(OBJECT_SELF, 0, 0,0);
                    Safe_Destroy_Object(OBJECT_SELF, 1500);
                }
                else if (IsSummoned(OBJECT_SELF))
                {
                    //PATL: Fallback: Looks bad but gets the job done.
                    //SetObjectActive(OBJECT_SELF, 0, 0,0);
                    //Safe_Destroy_Object(OBJECT_SELF, 1500);

                    // PATL - Insert favorite creature unsummon fun here.
                    SpawnBodyBag(OBJECT_SELF,TRUE);
                    object oBodyBag = GetCreatureBodyBag(OBJECT_SELF);

                    if (oBodyBag != OBJECT_INVALID)
                    {
                        SetBodybagDecayDelay(oBodyBag,3000);
                        SetObjectInteractive(oBodyBag,FALSE);
                        SetObjectActive(oBodyBag, 0, 0,0);
                        DestroyObject(oBodyBag,20000);
                    }
                }
                else
                {
                    SpawnBodyBag(OBJECT_SELF);

                    if (Random(CONFIG_CONSTANT_BLOODPOOL_FREQ)+1 < 100 || GetCreatureRank(OBJECT_SELF) == CREATURE_RANK_BOSS)
                    {
                        int nAppr = GetM2DAInt(TABLE_APPEARANCE,"bloodpool", GetAppearanceType(OBJECT_SELF));

                        int nBloodPoolVfx = 0;
                        switch (nAppr)
                        {
                          case 0: break;
                          case 1: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_S; break;
                          case 2: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_M; break;
                          case 3: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_L; break;
                        }

                        if (nBloodPoolVfx >0)
                        {
                            float fDur = (nAppr == 3) ? 600.0f : RandFF(CONFIG_CONSTANT_BLOODPOOL_DURATION,CONFIG_CONSTANT_BLOODPOOL_DURATION);
                            Engine_ApplyEffectAtLocation(EFFECT_DURATION_TYPE_TEMPORARY, EffectVisualEffect(nBloodPoolVfx), GetLocation(OBJECT_SELF), fDur,GetArea(OBJECT_SELF));
                        }

                    }

                }
            } else if ((HasAbility(OBJECT_SELF, ABILITY_TRAIT_EXPLOSIVE) == FALSE) && (HasAbility(OBJECT_SELF, ABILITY_TRAIT_GHOST) == FALSE))
            {
                SpawnBodyBag(OBJECT_SELF);


                if (Random(CONFIG_CONSTANT_BLOODPOOL_FREQ)+1 < 100 || GetCreatureRank(OBJECT_SELF) == CREATURE_RANK_BOSS)
                {
                    int nAppr = GetM2DAInt(TABLE_APPEARANCE,"bloodpool", GetAppearanceType(OBJECT_SELF));

                    int nBloodPoolVfx = 0;
                    switch (nAppr)
                    {
                      case 0: break;
                      case 1: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_S; break;
                      case 2: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_M; break;
                      case 3: nBloodPoolVfx = VFX_GROUND_BLOODPOOL_L; break;
                    }

                    if (nBloodPoolVfx >0)
                    {
                        float fDur = (nAppr == 3) ? 600.0f : RandFF(CONFIG_CONSTANT_BLOODPOOL_DURATION,CONFIG_CONSTANT_BLOODPOOL_DURATION);
                        Engine_ApplyEffectAtLocation(EFFECT_DURATION_TYPE_TEMPORARY, EffectVisualEffect(nBloodPoolVfx), GetLocation(OBJECT_SELF), fDur,GetArea(OBJECT_SELF));
                    }

                }

            }
            #ifdef SKYNET
            TrackObjectDeath(ev);
            #endif

            AI_Threat_UpdateDeath(OBJECT_SELF);

            // Team handling: fire team destroyed event if all team members are dead
            int nTeamID = GetTeamId(OBJECT_SELF);
            if(nTeamID != -1)
            {
                SetTeamId(OBJECT_SELF, -1); // this de-registers the creature from the team
                object [] arTeam = GetTeam(nTeamID);
                int nSize = GetArraySize(arTeam);
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core.EVENT_TYPE_DEATH","Handling death of team member, team ID: " + IntToString(nTeamID) + ", # of team members left: " + IntToString(nSize), OBJECT_SELF);
                #endif
                if(nSize == 0) // no more team members
                {
                    // send team death event to self
                    SendEventTeamDestroyed(GetArea(OBJECT_SELF), nTeamID);
                }
            }


            AI_Ballista_HandleDeath();


            // Codex
            if(GetLocalInt(OBJECT_SELF, CREATURE_SPAWN_DEAD) == 0 && GetLocalInt(OBJECT_SELF, SPAWN_HOSTILE_LYING_ON_GROUND) ==0)
            {
                int nApp = GetAppearanceType(OBJECT_SELF);
                string sCodexPlot = GetM2DAString(TABLE_APPEARANCE, "CodexPlot", nApp);
                int nCodexFlag = GetM2DAInt(TABLE_APPEARANCE, "CodexFlag", nApp);
                //string sCodexCounter = GetM2DAString(TABLE_APPEARANCE, "CodexCounter", nApp);
                if(sCodexPlot != "")
                {
                    string sCodexGUID = GetPlotGUID(sCodexPlot);
                    if (sCodexGUID != "")
                    {
                        WR_SetPlotFlag(sCodexGUID, nCodexFlag, TRUE);
                    }
                }
            }
            break;
        }

        case EVENT_TYPE_SPAWN:
        {
            // Georg: Not needed anymore but left for backwards compat reasons for now
            if (GetLocalInt(OBJECT_SELF, CREATURE_SPAWNED))
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_EVENTS, "creature_core.EVENT_TYPE_SPAWN", "Creature spawned before - NOT triggering spawn routine again.");
                #endif
                break;
            }
            SetLocalInt(OBJECT_SELF, CREATURE_SPAWNED, 1);

            // -----------------------------------------------------------------
            // Creatures spawning with 0 health will die instantly
            // This is handled in engine, the script here just ensures
            // some gore on them
            // ------------------------------------------------------------------
            if (GetLocalInt(OBJECT_SELF, CREATURE_SPAWN_DEAD) == 1)
            {

                float fRandGore = RandomFloat();
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_EVENTS,"creature_core.EVENT_TYPE_SPAWN","gore: " + FloatToString(fRandGore));
                Log_Trace(LOG_CHANNEL_EVENTS,"creature_core.EVENT_TYPE_SPAWN","Character spawned with CREATURE_SPAWN_DEAD set, killing...",OBJECT_SELF);
                #endif
                SetCreatureGoreLevel(OBJECT_SELF, fRandGore);
                bEventHandled = TRUE;
                return;
            }

            // -----------------------------------------------------------------
            // Handle OnSpawn appearance based crust specified in apr_base
            // -----------------------------------------------------------------
            int nAppType = GetAppearanceType(OBJECT_SELF);
            int nCrustEffect = GetM2DAInt(TABLE_APPEARANCE, "CRUST_EFFECT", nAppType);
            if(nCrustEffect > 0)
            {
                // -------------------------------------------------------------
                // Georg: I am using ENGINE_INNATE here to apply the effect
                //        permanently, unremovable
                // -------------------------------------------------------------
                ApplyEffectVisualEffect(OBJECT_SELF, OBJECT_SELF, nCrustEffect, 5 /*EFFECT_DURATION_TYPE_INNATE*/, 0.0);
            }

            // -----------------------------------------------------------------
            // One-hit-kill check (read area value from 2da)
            // One-Hit rank creatures, in special areas, run specific, limited
            // AI for mass battles.
            // -----------------------------------------------------------------
            int nAreaID = GetLocalInt(GetArea(OBJECT_SELF), AREA_ID);
            int nOneHitKillArea = GetM2DAInt(TABLE_AREA_DATA, "OneHitKillArea", nAreaID);
            if( (nAppType == APP_TYPE_HURLOCK || nAppType == APP_TYPE_GENLOCK || nAppType == 74 /* blight wolf*/) && nOneHitKillArea)
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core.EVENT_TYPE_SPAWN","Hurlock/Genlock appearance in a one-hit-kill area - changing rank to one-hit-kill");
                #endif
                SetCreatureRank(OBJECT_SELF, CREATURE_RANK_ONE_HIT_KILL);
            }

            // -----------------------------------------------------------------
            // Large creatures that can bump smaller ones out of their way
            // -----------------------------------------------------------------

            if(nAppType == APR_TYPE_OGRE || nAppType == APP_TYPE_PRIDE_DEMON)
                ApplyKnockbackAoe(OBJECT_SELF);

            // -----------------------------------------------------------------
            // Support for Yaron's ambush type monsters that rise from the ground
            // -----------------------------------------------------------------
            if(GetLocalInt(OBJECT_SELF, SPAWN_HOSTILE_LYING_ON_GROUND) == 1)
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core.EVENT_TYPE_SPAWN", "Spawning creature as lying on the ground");
                #endif

                // NOTE: the death animaiton should be handled by using the CREATURE_SPAWN flag set to 2

                // If the creature is hostile: give him a temp non-hostile group so the player won't get into
                // combat stance when he's near. Perception will change the group again.
                if(GetGroupId(OBJECT_SELF) == GROUP_HOSTILE)
                    SetGroupId(OBJECT_SELF, GROUP_HOSTILE_ON_GROUND);
                SetObjectInteractive(OBJECT_SELF, FALSE);

            }

              // Creatures with a ranged weapon in their default slot, prefer
            // ranged weapon
            if (_AI_GetWeaponSetEquipped() == AI_WEAPON_SET_RANGED)
                _AI_SetFlag(AI_FLAG_PREFERS_RANGED, TRUE);


            // -----------------------------------------------------------------
            // Force default item equip from the 2da
            // -----------------------------------------------------------------
            EquipDefaultItem(nAppType, INVENTORY_SLOT_BITE, "DefaultWeapon");
            EquipDefaultItem(nAppType, INVENTORY_SLOT_CHEST, "DefaultArmor");

            // -----------------------------------------------------------------
            // START AutoScaling Block
            // Important - do not change the order of function calls in this
            // block
            // >>---------------------------------------------------------------

            // Autoscaling
            // All ranks will be scaled her, including player ranks.
            int nLevelToScale = AS_GetCreatureLevelToScale(OBJECT_SELF, AB_GetAreaTargetLevel(OBJECT_SELF));
            AS_InitCreature(OBJECT_SELF, nLevelToScale);

            // scale items (based on current level)
            ScaleEquippedItems(OBJECT_SELF, nLevelToScale);

            // -----------------------------------------------------------------
            // This enables spawn tracking on the db. High volume event,
            // disabled by default
            // Georg's SkyNet uses this to create fancy maps of where
            // each object is located in an area.
            // -----------------------------------------------------------------
            #ifdef SKYNET
            if (TRACKING_TRACK_SPAWN_EVENTS)
            {
                TrackCreatureEvent(nEventType, OBJECT_SELF,OBJECT_INVALID,GetAppearanceType(OBJECT_SELF));
            }
            #endif

            // Store start location for homing "rubberband" system
            Rubber_SetHome(OBJECT_SELF);

            // Check whether ambient behaviour should start on spawn.
            Ambient_SpawnStart();


            // -----------------------------------------------------------------
            // If the creature has the SpawnGhost flag set,
            // setup transparency and vfx.
            // -----------------------------------------------------------------
            if (HasAbility(OBJECT_SELF,ABILITY_TRAIT_GHOST))
            {
               MakeCreatureGhost(OBJECT_SELF, 1);
            }

            // If has stealth and in combat and hostile to the player then trigge stealth
            if(HasAbility(OBJECT_SELF, ABILITY_TALENT_STEALTH) && GetCombatState(OBJECT_SELF) == FALSE
                && GetGroupHostility(GROUP_PC, GetGroupId(OBJECT_SELF)) == TRUE )
            {
                #ifdef DEBUG
                Log_Trace_AI("creature_core", "TRIGGERING STEALTH");
                #endif
                Ambient_Stop(OBJECT_SELF);
                command cStealth = CommandUseAbility(ABILITY_TALENT_STEALTH, OBJECT_SELF);
                WR_AddCommand(OBJECT_SELF, cStealth);

            }

            // -----------------------------------------------------------------
            // Deal with creatures that start out with % of health
            // as defined in creature var
            // -----------------------------------------------------------------
            float fHealthMod = MinF(GetLocalFloat(OBJECT_SELF,CREATURE_SPAWN_HEALTH_MOD),0.9f);
            if (fHealthMod > 0.0f)
            {
                float fHealth = GetCurrentHealth(OBJECT_SELF);
                fHealth = MinF(1.0f, fHealth * fHealthMod);
                SetCurrentHealth(OBJECT_SELF,fHealth);
            }

            // -----------------------------------------------------------------
            // Creature with roaming enabled.
            // -----------------------------------------------------------------           //
            float fRoamDistance = GetLocalFloat(OBJECT_SELF,"ROAM_DISTANCE");
            if ( fRoamDistance > 25.0f )
            {
                location lRoamLocation = Location(GetArea(OBJECT_SELF),GetPosition(OBJECT_SELF),0.0f);

                SetRoamLocation(OBJECT_SELF,lRoamLocation);
                SetRoamRadius(OBJECT_SELF,fRoamDistance);
            }

            // Event was handled - don't fall through to rules_core
            bEventHandled = TRUE;
            break;
        }



        //----------------------------------------------------------------------
        // EVENT_TYPE_COMBAT_END
        // Sent when a creature doesn't perceive any more hostiles
        //----------------------------------------------------------------------
        case EVENT_TYPE_COMBAT_END:
        {

            object oThis = OBJECT_SELF;

            //------------------------------------------------------------------
            // If the creature is set to surrender have them initiate dialog
            // - Grant, Oct 30, 2007
            //------------------------------------------------------------------
            if ( GetLocalInt(oThis, SURR_SURRENDER_ENABLED) && !IsPartyDead() )
            {

                // Verify that combat is ending due to creature surrender.
                if (GetLocalInt(oThis, SURR_SURRENDER_ENABLED) == SURR_STATUS_ACTIVE)
                {

                    // Set plot flag and trigger post-surrender dialog
                    string sPlotName = GetLocalString(oThis, SURR_PLOT_NAME);

                    if (sPlotName != "")
                    {

                        int nPlotFlag = GetLocalInt(oThis, SURR_PLOT_FLAG);

                        WR_SetPlotFlag(sPlotName, nPlotFlag, TRUE, TRUE);

                    }

                    int bInit = GetLocalInt(oThis, SURR_INIT_CONVERSATION);

                    if (bInit)
                    {
                        UT_Talk(oThis, GetHero());
                        SetLocalInt(oThis, SURR_INIT_CONVERSATION, FALSE);
                    }

                    // Reset the surrender flag to enabled status.
                    SetLocalInt(oThis, SURR_SURRENDER_ENABLED, TRUE);

                } // Verify

            }

            // Return to home location.
            Rubber_GoHome(OBJECT_SELF);
            break;

        }

        case EVENT_TYPE_RESURRECTION:
        {
            // -------------------------------------------------------------
            // Event handled, do not fall through to rules_core
            // -------------------------------------------------------------
            bEventHandled = TRUE;
            break;
        }

        case EVENT_TYPE_DELAYED_SHOUT:
        {
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_EVENTS,"creature_core", "DELAYED SHOUT EVENT START", OBJECT_SELF, LOG_LEVEL_CRITICAL);
            #endif

            // Triggering a shouts dialog with a delay
            int nShoutsActive = GetLocalInt(OBJECT_SELF, SHOUTS_ACTIVE);
            resource rDialogOverride = GetLocalResource(OBJECT_SELF, SHOUTS_DIALOG_OVERRIDE);
            float fDelay = GetLocalFloat(OBJECT_SELF, SHOUTS_DELAY);
            if (fDelay < 3.0)
                fDelay = 3.0; // so it doesn't happen too often

            if (!nShoutsActive)
                break;

            resource rDialog = R"";
            if(rDialogOverride != "NONE")
                rDialog = rDialogOverride;

            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core_h.EVENT_TYPE_DELAYED_SHOUT", "delay= " + FloatToString(fDelay) + ", dialog override: " +
                ResourceToString(rDialogOverride));
            #endif


            // Check perception list: if no party members are in it - stop shouting
            object [] arPerceived = GetPerceivedCreatureList(OBJECT_SELF);
            int nSize = GetArraySize(arPerceived);
            int i;
            object oCurrent;
            int bPerceingPartyMembers = FALSE;

            for(i = 0; i < nSize; i++)
            {
                oCurrent = arPerceived[i];
                if(IsFollower(oCurrent))
                {
                    bPerceingPartyMembers = TRUE;
                    break;
                }

            }

            if(!bPerceingPartyMembers)
            {
                #ifdef DEBUG
                Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core_h.EVENT_TYPE_DELAYED_SHOUT", "Not perceiving any party members - stopping shouts");
                #endif
                UT_SetShoutsFlag(OBJECT_SELF, FALSE); // This will break the delayed event loop
            }
            else
            {
                UT_Talk(OBJECT_SELF, OBJECT_SELF, rDialog);
                DelayEvent(fDelay, OBJECT_SELF, ev);
            }

            // -------------------------------------------------------------
            // Event handled, do not fall through to rules_core
            // -------------------------------------------------------------
            bEventHandled = TRUE;
            break;
        }

        case EVENT_TYPE_REACHED_WAYPOINT:
        {
            bEventHandled = Ambient_ReachedWaypoint(ev);
            break;
        }

        case EVENT_TYPE_AMBIENT_CONTINUE:
        {
            // If the event was fired because the party is near a creature,
            // the 'instigator' is the nearest party member. If the event was
            // fired at the end of a conversation, the 'instigator' is the creature
            // conversing.
            object oInstigator = GetEventObject(ev, 0);
            Ambient_DoSomething(OBJECT_SELF, IsObjectValid(oInstigator));
            bEventHandled = TRUE;
            return;
        }

        case EVENT_TYPE_APPROACH_TRAP:
        {
            object oTrap = GetEventObject(ev, 0);
            #ifdef DEBUG
            Log_Trace(LOG_CHANNEL_SYSTEMS,"creature_core_h.EVENT_TYPE_APPROACH_TRAP", "Got approach-trap event: " + GetTag(oTrap));
            #endif

            if(GetCombatState(OBJECT_SELF) == FALSE)
            {
                if(GetObjectActive(OBJECT_SELF) == FALSE)
                    WR_SetObjectActive(OBJECT_SELF, TRUE);

                WR_ClearAllCommands(OBJECT_SELF, TRUE);
                command cMove = CommandMoveToObject(oTrap, TRUE);
                WR_AddCommand(OBJECT_SELF, cMove);
            }
            break;
        }

        case EVENT_TYPE_ROAM_DIST_EXCEEDED:
        {
            //DisplayFloatyMessage(OBJECT_SELF,"GOING HOME!");

            ClearAllCommands(OBJECT_SELF,TRUE);

            location lRoamLocation = GetRoamLocation(OBJECT_SELF);

            effect e = EffectModifyMovementSpeed(1.5);
            ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT,e,OBJECT_SELF,0.0f,OBJECT_SELF,0);

            command cmd = CommandMoveToLocation(lRoamLocation,TRUE,FALSE);
            AddCommand(OBJECT_SELF,cmd,TRUE,FALSE);
        }

    }

    // -------------------------------------------------------------------------
    // Any event not handled falls through to rules_core:
    // -------------------------------------------------------------------------
    if (!bEventHandled)
    {
        HandleEvent(ev, RESOURCE_SCRIPT_RULES_CORE);
    }

}