/**
*    Handle AF_EVENT_TYPE_QB_OPTIONS
*/

#include "ai_conditions_h"

/* Advanced Quickbar */
#include "af_quickbar_h"
#include "af_events_h"
#include "af_log_h"

const string AF_CREATURE_STORAGE_VAR = "AI_CUSTOM_AI_VAR_INT";



void main()
{
    event ev = GetCurrentEvent();
    int nEventType = GetEventType(ev);

    int nBitVar1 = GetLocalInt(OBJECT_SELF, AF_CREATURE_STORAGE_VAR);
    int nBitVar2 = GetLocalInt(GetHero(), AF_CREATURE_STORAGE_VAR);

    int nVar1 = (nBitVar1 & 0x00000070);
    int nVar2 = (nBitVar2 & 0x00000080);

    int nNewBitVar1 = nBitVar1 - nVar1;
    int nNewBitVar2 = nBitVar2 - nVar2;

    int nQuickbar = nVar1 >> 4;
    int nNewQuickbar;

    int nPaused = nVar2 >> 7;

    int nShapeshifted = _AI_HasAIStatus(OBJECT_SELF, AI_STATUS_POLYMORPH);

    int nAbility = GetEventInteger(ev, 0);

    switch (nAbility)
    {
        case AF_ABILITY_NEXT_QUICKBAR:
        {
            if ((nQuickbar == 0) || (nQuickbar == 1))
                nNewQuickbar = 2;
            else if ((nQuickbar == 2) || (nQuickbar == 3))
                nNewQuickbar = nQuickbar + 1;
            else if (nQuickbar == 4)
            {
                if (nShapeshifted != TRUE)
                    nNewQuickbar = 0;
                else
                    nNewQuickbar = 1;
            }
            else // on error
            {
                if (nShapeshifted != TRUE)
                    nNewQuickbar = 0;
                else
                    nNewQuickbar = 1;
            }

            int nNext = AF_QuickbarFindNext();
            int nPrevious = AF_QuickbarFindPrevious();
            int nPause = AF_QuickbarFindPaused();

            SetLocalInt(OBJECT_SELF, AF_CREATURE_STORAGE_VAR, nNewBitVar1 | (nNewQuickbar << 4));

            if (nPaused == 1)
            {
                event evp = Event(AF_EVENT_TYPE_QB_PAUSE);
                SignalEvent(OBJECT_SELF, evp);
                ToggleGamePause(FALSE);
            }

            SetQuickslotBar(OBJECT_SELF, nNewQuickbar);
            
            DisplayStatusMessage(IntToString(nNewQuickbar), 0xFFFFFF);

            AF_QuickbarPlaceNextPrevious(nNext, nPrevious, nPause);

            break;
        }
        case AF_ABILITY_PREVIOUS_QUICKBAR:
        {
            if ((nQuickbar == 1) || (nQuickbar == 0))
                nNewQuickbar = 4;
            else if ((nQuickbar == 4) || (nQuickbar == 3))
                nNewQuickbar = nQuickbar - 1;
            else if (nQuickbar == 2)
            {
                if (nShapeshifted != TRUE)
                    nNewQuickbar = 0;
                else
                    nNewQuickbar = 1;
            }
            else // on error
            {
                if (nShapeshifted != TRUE)
                    nNewQuickbar = 0;
                else
                    nNewQuickbar = 1;
            }

            int nPrevious = AF_QuickbarFindPrevious();
            int nNext = AF_QuickbarFindNext();
            int nPause = AF_QuickbarFindPaused();

            SetLocalInt(OBJECT_SELF, AF_CREATURE_STORAGE_VAR, nNewBitVar1 | (nNewQuickbar << 4));

            if (nPaused == 1)
            {
                event evp = Event(AF_EVENT_TYPE_QB_PAUSE);
                SignalEvent(OBJECT_SELF, evp);
                ToggleGamePause(FALSE);
            }

            SetQuickslotBar(OBJECT_SELF, nNewQuickbar);
            
            DisplayStatusMessage(IntToString(nNewQuickbar), 0xFFFFFF);

            AF_QuickbarPlaceNextPrevious(nNext, nPrevious, nPause);

            break;
        }
        case AF_ABILITY_GAME_PAUSED:
        {
            nPaused = 1 - nPaused;

            string sPause = GetStringByStringId(AF_STRREF_PAUSE);

            DisplayFloatyMessage(OBJECT_SELF, sPause + ": " + (nPaused == 1 ? "ON" : "OFF"), FLOATY_HIT, 0xf0dea7);

            SetLocalInt(GetHero(), AF_CREATURE_STORAGE_VAR, nNewBitVar2 | (nPaused << 7));

            break;
        }
    }
}
