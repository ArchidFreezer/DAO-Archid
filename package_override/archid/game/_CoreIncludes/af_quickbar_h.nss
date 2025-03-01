/*
    Advanced Quickbar tools
*/

#include "core_h"

/* Advanced Quickbar */
#include "af_ability_h"
#include "af_log_h"

const int AF_QUICKBAR_SLOTS_COUNT = 50;
const int AF_STRREF_PAUSE = 6610169;


void AF_QuickbarPlaceNextPrevious(int nNext, int nPrevious, int nPaused) {
    if (nNext >= 0) {
        int nNewNext = GetQuickslot(OBJECT_SELF, nNext);
        if ((nNewNext != AF_ABILITY_NEXT_QUICKBAR) && (nNewNext != AF_ABILITY_PREVIOUS_QUICKBAR))
            SetQuickslot(OBJECT_SELF, nNext, AF_ABILITY_NEXT_QUICKBAR);
    }

    if (nPrevious >= 0) {
        int nNewPrevious = GetQuickslot(OBJECT_SELF, nPrevious);
        if ((nNewPrevious != AF_ABILITY_PREVIOUS_QUICKBAR) && (nNewPrevious != AF_ABILITY_NEXT_QUICKBAR))
            SetQuickslot(OBJECT_SELF, nPrevious, AF_ABILITY_PREVIOUS_QUICKBAR);
    }

    if (nPaused >= 0) {
        int nNewPaused = GetQuickslot(OBJECT_SELF, nPaused);
        if ((nNewPaused != AF_ABILITY_PREVIOUS_QUICKBAR) && (nNewPaused != AF_ABILITY_NEXT_QUICKBAR))
            SetQuickslot(OBJECT_SELF, nPaused, AF_ABILITY_GAME_PAUSED);
    }
}

int AF_QuickbarFindNext() {
    int i;
    for (i = 0; i < AF_QUICKBAR_SLOTS_COUNT; i++) {
        if (GetQuickslot(OBJECT_SELF, i) == AF_ABILITY_NEXT_QUICKBAR)
            return i;
    }

    return -1;
}

int AF_QuickbarFindPrevious() {
    int i;
    for (i = 0; i < AF_QUICKBAR_SLOTS_COUNT; i++) {
        if (GetQuickslot(OBJECT_SELF, i) == AF_ABILITY_PREVIOUS_QUICKBAR)
            return i;
    }

    return -1;
}

int AF_QuickbarFindPaused() {
    int i;
    for (i = 0; i < AF_QUICKBAR_SLOTS_COUNT; i++) {
        if (GetQuickslot(OBJECT_SELF, i) == AF_ABILITY_GAME_PAUSED)
            return i;
    }

    return -1;
}
