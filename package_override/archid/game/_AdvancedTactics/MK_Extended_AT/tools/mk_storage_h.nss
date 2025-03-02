#ifndef MK_STORAGE_H
#defsym MK_STORAGE_H

#include "utility_h"

const string MK_STORAGE_AREA_TAG        = "char_stage";
const string MK_STORAGE_AREA_TAG_GXA    = "gxa_char_stage";
const string MK_PLAYER_TAG              = "char_player";

const string MK_AT_STORAGE_TAG  = "at_storage";
const string MK_TAL_STORAGE_TAG = "t2lmud_storage_cach3";

object MK_GetCharStage();
void MK_FixInvisibleWall();
void _MK_FixInvisibleWall(string sStorageTag);

object MK_GetCharStage()
{
    object oResult = GetArea(GetObjectByTag(MK_PLAYER_TAG));
    if (IsObjectValid(oResult) == TRUE)
        return oResult;
    else
        return OBJECT_INVALID;
}

void MK_FixInvisibleWall()
{
    _MK_FixInvisibleWall(MK_AT_STORAGE_TAG);

    int i;
    for(i = 0; i < 5; i++)
    {
        string sTag = MK_TAL_STORAGE_TAG + IntToString(i);
        _MK_FixInvisibleWall(sTag);
    }
}

void _MK_FixInvisibleWall(string sStorageTag)
{
    int i;
    for (i = 0; i < 5; i++)
    {
        object oStorage = GetObjectByTag(sStorageTag, i);

        if (IsObjectValid(oStorage) == TRUE)
        {
            if (i == 0)
            {
                object oCharStage = MK_GetCharStage();
                if (IsObjectValid(oCharStage))
                {
                    object oArea = GetArea(oStorage);
                    string sTag = GetTag(oArea);
                    if (sTag != GetTag(oCharStage))
                    {
                        location lLoc = Location(oCharStage, Vector(), 0.0f);
                        SetLocation(oStorage, lLoc);
                    }
                }
                else
                {
                    DestroyObject(oStorage);
                }
            }
            else
            {
                DestroyObject(oStorage);
            }
        }
    }
}
#endif
