#include "af_autoloot_h"

void main() {
    event ev = GetCurrentEvent();
    switch (GetEventType(ev)) {
        case EVENT_TYPE_DEATH: {
            object oKiller = GetEventCreator(ev);
            if (IsFollower(oKiller) && HasLootableItems(OBJECT_SELF) && !HasImportantItems(OBJECT_SELF) && !IsFollower(OBJECT_SELF)) {
                object oBag = GetCreatureBodyBag(OBJECT_SELF);
                if (IsObjectValid(oBag)) {
                    LootObject(OBJECT_SELF, oBag);
                    event evi = Event(EVENT_TYPE_INVALID);
                    evi = SetEventCreator(evi, oKiller);
                    DelayEvent(1.0, oBag, evi, "af_death_pr");
                }
            }

            break;
        }

        case EVENT_TYPE_INVALID: {
            if (GetGameMode() != GM_EXPLORE) {
                DelayEvent(1.0, OBJECT_SELF, ev, "af_death_pr");
                return;
            }
            object oKiller = GetEventCreator(ev);

            if (LootObject(OBJECT_SELF, oKiller) == LOOT_RETURN_INV_FULL)
                DisplayFloatyMessage(oKiller, "Inventory Full", FLOATY_MESSAGE, 0xff0000, 2.0);

            break;
        }
    }
}