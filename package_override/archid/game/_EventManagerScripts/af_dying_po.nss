#include "core_h"
#include "sys_treasure_h"
#include "af_extradogslot_h"

void main() {
    event ev = GetCurrentEvent();
    object oKiller = GetEventObject(ev, 0);

    // Dain's Increases Monetary Gain
    int nMoney = GetCreatureMoney(OBJECT_SELF);
    if (IsFollower(oKiller) && GetLocalInt(OBJECT_SELF, TS_TREASURE_GENERATED) && nMoney > 0) {
        effect[] aRewardBoni = GetEffects(oKiller, EFFECT_TYPE_REWARD_BONUS);
        int nEffects = GetArraySize(aRewardBoni);
        float fMult = 0.0;
        int i;
        for (i=0; i < nEffects; i++) {
            effect eRewardBonus = aRewardBoni[i];
            if (GetEffectInteger(eRewardBonus,EFFECT_REWARD_BONUS_FIELD_TYPE) == EFFECT_REWARD_BONUS_TYPE_CASH)
                fMult += 0.05;
        }
        if (fMult > 0.0)
            AddCreatureMoney(FloatToInt(nMoney*fMult), OBJECT_SELF, FALSE);
    }

    // Dain's Rewards from all kills
    int nProcessKillRewards;
    if (IsPartyMember(OBJECT_SELF) || IsPartyMember(oKiller) || GetLocalInt(OBJECT_SELF, "CREATURE_SPAWN_DEAD") || !IsObjectValid(oKiller)) {
        nProcessKillRewards = FALSE;
    }
    if (nProcessKillRewards) {
        object oHero = GetHero();
        if (IsObjectHostile(OBJECT_SELF, oHero)) RewardXPParty(0, XP_TYPE_COMBAT, OBJECT_SELF, oHero);
        // if this creature is a combatant, pass the event to the treasure function
        if (GetCombatantType(OBJECT_SELF) != CREATURE_TYPE_NON_COMBATANT) HandleEvent(ev, R"sys_treasure.ncs");
    }

    // Extra dog slot
    AF_EDS_EventDying(ev);

}