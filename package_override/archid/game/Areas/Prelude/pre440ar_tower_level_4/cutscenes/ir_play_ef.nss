#include "events_h"
#include "utility_h"
#include "wrappers_h"

void main ()
{

    object oPC = GetHero();
    int nGender = GetCreatureGender(oPC);

    resource rCutscene = R"ir_ef_a.cut";
    if(nGender == GENDER_MALE) rCutscene = R"ir_em_a.cut";

    CS_LoadCutscene(rCutscene);

}