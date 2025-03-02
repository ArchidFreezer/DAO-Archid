                                                   /*
    Advanced Tactics options skills script

    Handle AT_EVENT_TYPE_SKILL_OPTIONS
*/

#include "af_ability_h"

/* Advanced Tactics */
#include "at_tools_log_h"



void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    int nBitVar = GetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT");

    int nVar1 = (nBitVar & 0x00000001);
    int nVar2 = (nBitVar & 0x00000002);

    int nNewBitVar1 = nBitVar - nVar1;
    int nNewBitVar2 = nBitVar - nVar2;

    int nPossessed = nVar1;
    int nTraitors = nVar2 >> 1;

    int nAbility = GetEventInteger(ev, 0);

    switch (nAbility) {
        case AF_AT_ABILITY_POSSESSED: {
            nPossessed = 1 - nPossessed;

            /* Hardcoded string ID */
            string sPossessed = GetStringByStringId(6610300);

            DisplayFloatyMessage(OBJECT_SELF, sPossessed + ": " + (nPossessed == 1 ? "ON" : "OFF"), FLOATY_HIT, 0xf0dea7);

            SetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT", nNewBitVar1 | nPossessed);

            break;
        }
        case AF_AT_ABILITY_TRAITORS: {
            nTraitors = 1 - nTraitors;

            /* Hardcoded string ID */
            string sTraitors = GetStringByStringId(6610302);

            DisplayFloatyMessage(OBJECT_SELF, sTraitors + ": " + (nTraitors == 1 ? "ON" : "OFF"), FLOATY_HIT, 0xf0dea7);

            SetLocalInt(GetHero(), "AI_CUSTOM_AI_VAR_INT", nNewBitVar2 | (nTraitors << 1));

            break;
        }
    }
}
