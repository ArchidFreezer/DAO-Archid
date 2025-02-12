#include "2da_constants_h"
#include "core_h"
#include "effects_h"
#include "events_h"
/*
* Called after the EVENT_TYPE_DAMAGED standard processing
*
* Used by:
*   Dain's Heroic Attributes
*   Dain's Destroyer xtra
*/

const float DESTROYER_ARMOR_PENALTY = -5.0f;
const float DESTROYER_DURATION = 3.0f;
const int DESTROYER_VFX = 90065;

void main()
{
    event ev = GetCurrentEvent();
    int    nAbility  = GetEventInteger(ev, 1);
    object oDamager = GetEventCreator(ev);
    object oTarget = GetEventTarget(ev);

    if (IsPartyMember(oDamager) && IsPartyMember(oTarget))
    {
        object oHero = GetHero();
        float fDamage = GetEventFloat(ev, 0);

        /* Dain's Heroic attributes */
        float fNewParty = GetCreatureProperty(oHero, 2002) - fDamage; // 2002 is HERO_STAT_PARTY_DAMAGE_DEALT
        SetCreatureProperty(oHero, 2002, fNewParty);
    }

    /* Dain's Destroyer */
    if (HasAbility(oDamager, ABILITY_TALENT_DESTROYER) && IsMeleeWeapon2Handed(GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oDamager))) {
        // autoattack, or else ability requires melee or 2h weapon
        if (nAbility == 0 || (GetM2DAInt(TABLE_ABILITIES_SPELLS,"conditions",nAbility) & 129) > 0) {
            if (!GetHasEffects(oTarget, EFFECT_TYPE_MODIFY_PROPERTY,ABILITY_TALENT_DESTROYER )) {
                effect eDebuff = EffectModifyProperty(PROPERTY_ATTRIBUTE_ARMOR, DESTROYER_ARMOR_PENALTY);
                eDebuff = SetEffectEngineInteger(eDebuff, EFFECT_INTEGER_VFX, DESTROYER_VFX);
                Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, eDebuff, oTarget, DESTROYER_DURATION, oDamager, ABILITY_TALENT_DESTROYER);
            }
        }
    }

    /* Forgotten Fixes Stunning Blows */
    if (HasAbility(oDamager, ABILITY_TALENT_STUNNING_BLOWS) && IsMeleeWeapon2Handed(GetItemInEquipSlot(INVENTORY_SLOT_MAIN, oDamager))) {
        // autoattack, or else ability requires melee or 2h weapon
        if (nAbility == 0 || (GetM2DAInt(TABLE_ABILITIES_SPELLS,"conditions",nAbility) & 129) > 0) {
            if(RandomFloat()<0.5) {     // ~50%
                if (!GetHasEffects(oTarget, EFFECT_TYPE_STUN)) {
                    Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_TEMPORARY, EffectStun(),oTarget,1.5f + (RandomFloat()*2.5),oDamager,ABILITY_TALENT_STUNNING_BLOWS);
                }
            }
        }  
    }

}