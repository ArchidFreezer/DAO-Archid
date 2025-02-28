#include "af_utility_h"

const resource BATH_HUMAN_MALE   = R"hm_leli_bath.cut";
const resource BATH_HUMAN_FEMALE = R"hf_leli_bath.cut";
const resource BATH_ELF_FEMALE = R"ef_leli_bath.cut";
const resource BATH_ELF_MALE = R"em_leli_bath.cut";

void main()
{
    event ev          = GetCurrentEvent();
    int nEventType    = GetEventType(ev);
    int bEventHandled = FALSE;

    switch (nEventType)
    {
        case EVENT_TYPE_USE:
        {
            object oPC = GetHero();
            int nGender = GetCreatureGender(oPC);
            int nRace = GetCreatureRacialType(oPC);
            resource rCutscene;

            switch (GetPlaceableAction(OBJECT_SELF))
            {
                case PLACEABLE_ACTION_EXAMINE:
                {
                    if(nGender == GENDER_FEMALE){
                        if(nRace == RACE_ELF) rCutscene = BATH_ELF_FEMALE;
                        else if(nRace == RACE_HUMAN) rCutscene = BATH_HUMAN_FEMALE;
                    } else {
                        if(nRace == RACE_ELF) rCutscene = BATH_ELF_MALE;
                        else if(nRace == RACE_HUMAN) rCutscene = BATH_HUMAN_MALE;
                    }
                    if(!AF_IsModuleFlagSet(AF_GENERAL_FLAG, AF_GENERAL_LELIANA_BATHE)) {
                        UT_AddItemToInventory(R"af_im_leli_soaps.uti", 1);
                        AF_SetModuleFlag(AF_GENERAL_FLAG, AF_GENERAL_LELIANA_BATHE);
                    }
                    CS_LoadCutscene(rCutscene);
                }
            }
        }
    }
}
