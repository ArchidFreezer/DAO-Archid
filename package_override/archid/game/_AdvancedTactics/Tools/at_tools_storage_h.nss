#ifndef AT_TOOLS_STORAGE_H
#defsym AT_TOOLS_STORAGE_H

/*
    Advanced Tactics temporary storage tools

    Based on talmud storage. I need to write my own because I don't have
    a module core file and just need temporary storage.
*/

#include "effects_h"
#include "utility_h"

/* Advanced Tactics */
#include "at_tools_log_h" 
#include "mk_storage_h"

const string AT_STORAGE_AREA_TAG = "char_stage";
const string AT_STORAGE_AREA_TAG_GXA = "gxa_char_stage"; 

const string AT_STORAGE_TAG = "at_storage";

const resource AT_STORAGE_PLACEABLE_RESOURCE = R"genip_invisible_wide.utp";
const resource AT_STORAGE_ITEM_RESOURCE = R"gen_im_treas_silvchal.uti";

object _AT_GetStorage();
effect[] _AT_GetStorageEffects(string sTag);
void _AT_AddStorageEffect(string sTag, effect eEffect);
void _AT_RemoveStorageEffect(effect eEffect);


/** @brief *DEPRECIATED* use MK_FixInvisibleWall instead
**/
void _AT_FixInvisibleWall()
{
    int i;
    for (i = 0; i < 5; i++)
    {
        object oStorage = GetObjectByTag(AT_STORAGE_TAG, i);

        if (IsObjectValid(oStorage) == TRUE)
        {
            if (i == 0)
            {
                object oArea = GetArea(oStorage);
                string sTag = GetTag(oArea);

                if ((sTag != AT_STORAGE_AREA_TAG)
                && (sTag != AT_STORAGE_AREA_TAG_GXA))
                {
                    object oArea = GetObjectByTag(AT_STORAGE_AREA_TAG);

                    if (IsObjectValid(oArea) != TRUE)
                    {
                        oArea = GetObjectByTag(AT_STORAGE_AREA_TAG_GXA);
                    }

                    if (IsObjectValid(oArea) == TRUE)
                    {
                        location lLoc = Location(oArea, Vector(), 0.0f);
                        SetLocation(oStorage, lLoc);
                    }
                    else
                    {
                        DestroyObject(oStorage);
                    }
                }
            }
            else
            {
                DestroyObject(oStorage);
            }
        }
    }
}

object _AT_GetStorage()
{
    object oStorage = GetObjectByTag(AT_STORAGE_TAG);

    if (IsObjectValid(oStorage) != TRUE)
    {   
        object oArea = MK_GetCharStage();
        if (IsObjectValid(oArea) == TRUE)
        {
            location lLoc = Location(oArea, Vector(), 0.0f);
            oStorage = CreateObject(OBJECT_TYPE_PLACEABLE, AT_STORAGE_PLACEABLE_RESOURCE, lLoc, " ");

            EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_ADDED);
            EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_REMOVED);
            EnablevEvent(oStorage, FALSE, EVENT_TYPE_INVENTORY_FULL);

            SetTag(oStorage, AT_STORAGE_TAG);
            SetObjectInteractive(oStorage, FALSE);
            SetLocation(oStorage, lLoc);
        }
    }

    return oStorage;
}

effect[] _AT_GetStorageEffects(string sTag)
{
    effect[] eEffects;

    object oStorage = _AT_GetStorage();

    if (IsObjectValid(oStorage) == TRUE)
    {
        object oItem = GetItemPossessedBy(oStorage, sTag);

        if (IsObjectValid(oItem) == TRUE)
        {
            eEffects = GetEffects(oStorage, 1, 0, oItem);
        }
    }

    return eEffects;
}

void _AT_AddStorageEffect(string sTag, effect eEffect)
{
    object oStorage = _AT_GetStorage();

    if (IsObjectValid(oStorage) == TRUE)
    {
        object oItem = GetItemPossessedBy(oStorage, sTag);

        if (IsObjectValid(oItem) != TRUE)
        {
            oItem = CreateItemOnObject(AT_STORAGE_ITEM_RESOURCE, oStorage, 1, sTag, TRUE, FALSE);
        }

        Engine_ApplyEffectOnObject(EFFECT_DURATION_TYPE_PERMANENT, eEffect, oStorage, 0.0f, oItem);
    }
}

void _AT_RemoveStorageEffect(effect eEffect)
{
    object oStorage = _AT_GetStorage();

    if (IsObjectValid(oStorage) == TRUE)
    {
        RemoveEffect(oStorage, eEffect);
    }
}

#endif