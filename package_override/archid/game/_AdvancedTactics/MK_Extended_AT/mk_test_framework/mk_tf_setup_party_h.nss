#ifndef MK_TEST_FRAMEWORK_SETUP_PARTY_H
#defsym MK_TEST_FRAMEWORK_SETUP_PARTY_H

//==============================================================================
//                                INCLUDES
//==============================================================================
#include "sys_autoscale_h"
#include "mk_tf_locations_h"

//==============================================================================
//                              DECLARATIONS
//==============================================================================
object TF_AddFollowerToParty(resource rTemplate);
void TF_RemoveFromParty(object oFollower);
void TF_RemoveAllFromParty();

object TF_AddAlistairToParty();
object TF_AddDogToParty();
object TF_AddLelianaToParty();
object TF_AddLoghainToParty();
object TF_AddMorriganToParty();
object TF_AddOghrenToParty();
object TF_AddShaleToParty();
object TF_AddStenToParty();
object TF_AddWynneToParty();
object TF_AddZevranToParty();

//==============================================================================
//                              DEFINITIONS
//==============================================================================
//******************************************************************************
void TF_RemoveAllFromParty()
{
    object[] arFollowers = GetPartyPoolList();
    int nSize = GetArraySize(arFollowers);
    int i;
    for (i = 0; i < nSize; i++)   
    {
        if (!IsHero(arFollowers[i]))
            TF_RemoveFromParty(arFollowers[i]);
    }
}

//******************************************************************************
void TF_RemoveFromParty(object oFollower)
{
    WR_SetFollowerState(oFollower, FOLLOWER_STATE_INVALID);
    DestroyObject(oFollower);
}

//******************************************************************************
object TF_AddAlistairToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_alistair.utc");
}

//******************************************************************************
object TF_AddDogToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_dog.utc");
}

//******************************************************************************
object TF_AddLelianaToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_leliana.utc");
}

//******************************************************************************
object TF_AddLoghainToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_loghain.utc");
}

//******************************************************************************
object TF_AddMorriganToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_morrigan.utc");
}

//******************************************************************************
object TF_AddOghrenToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_oghren.utc");
}

//******************************************************************************
object TF_AddShaleToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_shale.utc");
}

//******************************************************************************
object TF_AddStenToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_sten.utc");
}

//******************************************************************************
object TF_AddWynneToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_wynne.utc");
}

//******************************************************************************
object TF_AddZevranToParty()
{
    return TF_AddFollowerToParty(R"gen00fl_zevran.utc");
}

//******************************************************************************
object TF_AddFollowerToParty(resource rTemplate)
{
    object oFollower = CreateObject(OBJECT_TYPE_CREATURE, rTemplate, GetLocation(GetHero()), "empty_ai");
    SetLocation(oFollower, GetFollowerWouldBeLocation(oFollower));

    SetCreatureProperty(oFollower, PROPERTY_SIMPLE_EXPERIENCE, 0.0f);
    AS_InitCreature(oFollower, 1);

    WR_SetFollowerState(oFollower, FOLLOWER_STATE_ACTIVE);
    ClearAllCommands(oFollower);
    WR_SetObjectActive(oFollower, TRUE);

    return oFollower;
}

//******************************************************************************
//void main(){TF_AddZevranToParty();TF_AddWynneToParty();TF_RemoveAllFromParty();}
#endif
