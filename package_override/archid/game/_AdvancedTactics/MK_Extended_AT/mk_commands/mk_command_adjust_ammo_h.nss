#ifndef MK_COMMAND_ADJUST_AMMO_H
#defsym MK_COMMAND_ADJUST_AMMO_H

//==============================================================================
//                              INCLUDES
//==============================================================================
// Core
#include "ai_main_h_2"
#include "combat_damage_h"
// MkBot
#include "mk_print_to_log_h"

//==============================================================================
//                          DECLARATIONS
//==============================================================================
command _MK_AI_AdjustAmmo();
command _MK_AI_UnequipAmmo();
command _MK_AI_AdjustCrystal();  
float MK_Max_Combat_Damage_GetAttackDamage(object oAttacker, object oTarget, object oWeapon, int nAttackResult, float fArmorPenetrationBonus = 0.0);
string MK_ItemTypeToString(int nItemType);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
command _MK_AI_AdjustAmmo()//works only for bows
{
    
    int nAppearanceType = GetAppearanceType(OBJECT_SELF);
    if (nAppearanceType == 10100) // new shale type
        return _MK_AI_AdjustCrystal();
    
    float resistThreshold = 33.0;
    command cInvalid;
    if( _AI_GetWeaponSetEquipped() != AI_WEAPON_SET_RANGED )//check if ranged weapon equipped
    {
        //DisplayFloatyMessage(OBJECT_SELF, "Melee", FLOATY_MESSAGE, 0x888888, 5.0f);
        return cInvalid;
    }
    object oTarget = GetAttackTarget(OBJECT_SELF);
    if( _AI_IsHostileTargetValid(oTarget) == FALSE )//check if target is hostile
    {
        //DisplayFloatyMessage(OBJECT_SELF, "Not Hostile", FLOATY_MESSAGE, 0x888888, 5.0f);
        return cInvalid;
    }
    object oEquippedAmmo = GetItemInEquipSlot(INVENTORY_SLOT_RANGEDAMMO);
    string tagEquippedAmmo = GetTag(oEquippedAmmo);

    if( tagEquippedAmmo == "gen_im_wep_rng_amm_elf"
    ||  tagEquippedAmmo == "gen_im_wep_rng_amm_and")// check if player equipped special ammo
    {
        //DisplayFloatyMessage(OBJECT_SELF, "Special ammo equipped", FLOATY_MESSAGE, 0x888888, 5.0f);
        return cInvalid;
    }

    string[] arrArrowsTag;
    arrArrowsTag[0] = "gen_im_wep_rng_amm_iar";
    arrArrowsTag[1] = "gen_im_wep_rng_amm_far";
    arrArrowsTag[2] = "gen_im_wep_rng_amm_fil";

    int[] arrArrowCount;
    arrArrowCount[0] = CountItemsByTag(OBJECT_SELF, arrArrowsTag[0]);
    arrArrowCount[1] = CountItemsByTag(OBJECT_SELF, arrArrowsTag[1]);
    arrArrowCount[2] = CountItemsByTag(OBJECT_SELF, arrArrowsTag[2]);

    if(arrArrowCount[0]==0 && arrArrowCount[1]==0 && arrArrowCount[2]==0)//check if you have any ammo
    {
        //DisplayFloatyMessage(OBJECT_SELF, "No ammo", FLOATY_MESSAGE, 0x888888, 5.0f);
        return cInvalid;
    }
    float resBase;
    float resMod;
    //float fDiffMod = Diff_GetDRMod(oTarget);
    float[] arrResist;

    resBase = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD, PROPERTY_VALUE_BASE);
    resMod = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_COLD, PROPERTY_VALUE_MODIFIER);
    arrResist[0] = resBase + resMod;

    //resBase = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC, PROPERTY_VALUE_BASE);
    //resMod = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_ELEC, PROPERTY_VALUE_MODIFIER);
    //arrResistances[arrSize++] = resBase + resMod;

    resBase = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE, PROPERTY_VALUE_BASE);
    resMod = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_FIRE, PROPERTY_VALUE_MODIFIER);
    arrResist[1] = resBase + resMod;

    resBase = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE, PROPERTY_VALUE_BASE);
    resMod = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_NATURE, PROPERTY_VALUE_MODIFIER);
    arrResist[2] = resBase + resMod;

    //resBase = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT, PROPERTY_VALUE_BASE);
    //resMod = GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_DAMAGE_RESISTANCE_SPIRIT, PROPERTY_VALUE_MODIFIER);
    //arrResistances[arrSize++] = resBase + resMod;

    int[] bestIdx;
    if(arrResist[0] > arrResist[1] && arrResist[0] > arrResist[2])
    {
       bestIdx[0] = 0;
       if(arrResist[1] > arrResist[2])
       {
            bestIdx[1] = 1;
            bestIdx[2] = 2;
       }else
       {
            bestIdx[1] = 2;
            bestIdx[2] = 1;
       }
    }else if(arrResist[1] > arrResist[0] && arrResist[1] > arrResist[2])
    {
       bestIdx[0] = 1;
       if(arrResist[0] > arrResist[2])
       {
            bestIdx[1] = 0;
            bestIdx[2] = 2;
       }else
       {
            bestIdx[1] = 2;
            bestIdx[2] = 0;
       }
    }else
    {
       bestIdx[0] = 2;
       if(arrResist[0] > arrResist[1])
       {
            bestIdx[1] = 0;
            bestIdx[2] = 1;
       }else
       {
            bestIdx[1] = 1;
            bestIdx[2] = 0;
       }
    }

    int i;
    for(i = 2; 0 <= i; i--)
    {
        if( arrResist[bestIdx[i]] < resistThreshold && arrArrowCount[bestIdx[i]] )
        {
            if(tagEquippedAmmo != arrArrowsTag[bestIdx[i]])
            {
                DisplayFloatyMessage(OBJECT_SELF, "Ammo Adjusted:"+FloatToString(arrResist[bestIdx[i]],4,0), FLOATY_MESSAGE, 0x888888, 5.0f);
                //DisplayFloatyMessage(OBJECT_SELF, "Cold Resist="+FloatToString(arrResist[0],18,0), FLOATY_MESSAGE, 0x888888, 5.0f);
                //DisplayFloatyMessage(OBJECT_SELF, "Fie Resist="+FloatToString(arrResist[1],18,0), FLOATY_MESSAGE, 0x888888, 5.0f);
                //DisplayFloatyMessage(OBJECT_SELF, "Natue Resist="+FloatToString(arrResist[2],18,0), FLOATY_MESSAGE, 0x888888, 5.0f);
                oEquippedAmmo = GetItemPossessedBy(OBJECT_SELF, arrArrowsTag[bestIdx[i]]);
                EquipItem(OBJECT_SELF, oEquippedAmmo);
                return cInvalid;//_AT_AI_DoNothing(TRUE);
            }else
            {
                //DisplayFloatyMessage(OBJECT_SELF, "Already equipped", FLOATY_MESSAGE, 0x888888, 5.0f);
                return cInvalid;
            }
        }
    }
    UnequipItem(OBJECT_SELF, oEquippedAmmo);// if there is no ammo below threshold then unequip ammo
    //DisplayFloatyMessage(OBJECT_SELF, "End of script", FLOATY_MESSAGE, 0x888888, 5.0f);
    return cInvalid;
}

//added by MkBot
command _MK_AI_UnequipAmmo()//works only for bows
{
    command cInvalid;
    if( _AI_GetWeaponSetEquipped() != AI_WEAPON_SET_RANGED )//check if ranged weapon equipped
    {
        //DisplayFloatyMessage(OBJECT_SELF, "Melee", FLOATY_MESSAGE, 0x888888, 5.0f);
        return cInvalid;
    }
    object oEquippedAmmo = GetItemInEquipSlot(INVENTORY_SLOT_RANGEDAMMO);
    UnequipItem(OBJECT_SELF, oEquippedAmmo);
    return cInvalid;//_AT_AI_DoNothing(TRUE);
} 

command _MK_AI_AdjustCrystal()
{
    int BASE_ITEM_TYPE_SMALL_CRYSTAL = 107;
    command cInvalid;
    
    object oTarget = GetAttackTarget(OBJECT_SELF);
    if( IsObjectValid(oTarget) == FALSE )
        return cInvalid;    

    object[] arCrystals = GetItemsInInventory(OBJECT_SELF, GET_ITEMS_OPTION_ALL, BASE_ITEM_TYPE_SMALL_CRYSTAL);
    int nCrystalsSize = GetArraySize(arCrystals);
    
    object[] arWeapon;
    arWeapon[0] = OBJECT_INVALID;
    int i;
    for(i=0; i<nCrystalsSize; i++)
        arWeapon[i+1] = arCrystals[i];
   
    float[] arDmg;
    int[] arDmgType;        
    
    arDmg[0] = MK_Max_Combat_Damage_GetAttackDamage( OBJECT_SELF, oTarget, OBJECT_INVALID, COMBAT_RESULT_HIT);;
    arDmgType[0] = DAMAGE_TYPE_PHYSICAL;
    int nIdxBest = 0;        

    for(i=1; i<nCrystalsSize+1; i++)
    {
        
        int[] arProperties = GetItemProperties(arWeapon[i], FALSE);
        int nPropertiesSize = GetArraySize(arProperties); 
        int j;
        for(j = 0; j<nPropertiesSize; j++)
        {
            if( arProperties[j] == 10007 ) //Fire
            {
                arDmgType[i] = DAMAGE_TYPE_FIRE;
                //MK_PrintToLog( "arWeapon["+IntToString(i)+"] = " + GetTag(arWeapon[i]) + " arDmgType["+IntToString(i)+"] = DAMAGE_TYPE_FIRE" );
                break;
            }
            if( arProperties[j] == 10008 ) //Spirit
            {
                arDmgType[i] = DAMAGE_TYPE_SPIRIT;
                //MK_PrintToLog( "arWeapon["+IntToString(i)+"] = " + GetTag(arWeapon[i]) + " arDmgType["+IntToString(i)+"] = DAMAGE_TYPE_SPIRIT" );
                break;
            }                
            if( arProperties[j] == 10009 ) //Cold
            {
                arDmgType[i] = DAMAGE_TYPE_COLD; 
                //MK_PrintToLog( "arWeapon["+IntToString(i)+"] = " + GetTag(arWeapon[i]) + " arDmgType["+IntToString(i)+"] = DAMAGE_TYPE_COLD" );
                break;
            }
            if( arProperties[j] == 10010 ) //Nature
            {
                arDmgType[i] = DAMAGE_TYPE_NATURE; 
                //MK_PrintToLog( "arWeapon["+IntToString(i)+"] = " + GetTag(arWeapon[i]) + " arDmgType["+IntToString(i)+"] = DAMAGE_TYPE_NATURE" );
                break;
            }
            if( arProperties[j] == 10011 ) //Lightning
            {
                arDmgType[i] = DAMAGE_TYPE_ELECTRICITY;
                //MK_PrintToLog( "arWeapon["+IntToString(i)+"] = " + GetTag(arWeapon[i]) + " arDmgType["+IntToString(i)+"] = DAMAGE_TYPE_ELECTRICITY" );
                break;
            }            
        }
        
        if( DamageIsImmuneToType(oTarget, arDmgType[i]) )
        {
            arDmg[i] = -1.0;
        }else
        {
            arDmg[i] = MK_Max_Combat_Damage_GetAttackDamage( OBJECT_SELF, oTarget, arWeapon[i], COMBAT_RESULT_HIT);
            arDmg[i] = ResistDamage(OBJECT_SELF, oTarget, ABILITY_INVALID, arDmg[i], arDmgType[i]);
        }
        if( arDmg[i] > arDmg[nIdxBest] )
            nIdxBest = i;

    }
    
    object oEquippedCrystal = GetItemInEquipSlot(INVENTORY_SLOT_SHALE_RIGHTARM); 
    if( arWeapon[nIdxBest] != oEquippedCrystal )
    {
        if( nIdxBest == 0 )
            UnequipItem(OBJECT_SELF, oEquippedCrystal); 
        else
            EquipItem(OBJECT_SELF, arWeapon[nIdxBest]); 
    }
    //MK_PrintToLog( "I choose: "+IntToString(nIdxBest)); 
    return cInvalid;
}


float MK_Max_Combat_Damage_GetAttackDamage(object oAttacker, object oTarget, object oWeapon, int nAttackResult, float fArmorPenetrationBonus)
{

    int nHand = HAND_MAIN;
    int nSlot = GetItemEquipSlot(oWeapon);

    // -------------------------------------------------------------------------
    // special case: one hit kill forms generally don't do damage...
    // -------------------------------------------------------------------------
    if (IsShapeShifted(oAttacker))
    {
        if (GetM2DAInt(TABLE_APPEARANCE,"OneShotKills", GetAppearanceType(oAttacker)))
        {
            return 1.0f;
        }
    }

    if (IsObjectValid(oWeapon))
    {
        if (nSlot == INVENTORY_SLOT_MAIN || nSlot == INVENTORY_SLOT_BITE)
        {
            nHand = HAND_MAIN;
        }
        else if (nSlot == INVENTORY_SLOT_OFFHAND)
        {
            nHand = HAND_OFFHAND;
        }

        // Mage staffs have their own rules
        if (nAttackResult != COMBAT_RESULT_DEATHBLOW && GetBaseItemType(oWeapon) == BASE_ITEM_TYPE_STAFF)
        {
            if (!GetHasEffects(oAttacker, EFFECT_TYPE_SHAPECHANGE))
            {
                return Combat_Damage_GetMageStaffDamage(oAttacker, oTarget,oWeapon);
            }
            else
            {
                oWeapon = OBJECT_INVALID;
            }
        }

    }

    // Weapon Attribute Bonus Factor
    float fFactor =     GetWeaponAttributeBonusFactor(oWeapon);

    // Attribute Modifier
    float fStrength =   Combat_Damage_GetAttributeBonus(oAttacker, nHand, oWeapon, TRUE) * fFactor; //MkBot

    // Weapon Damage
    float fWeapon   =   IsObjectValid(oWeapon)? DmgGetWeaponDamage(oWeapon,TRUE) : COMBAT_DEFAULT_UNARMED_DAMAGE ;//MkBot

    // Game Difficulty Adjustments
    float fDiffBonus =  Diff_GetRulesDamageBonus(oAttacker);


    float fDamage   =   fWeapon + fStrength + fDiffBonus ;
    float fDamageScale = GetM2DAFloat(TABLE_AUTOSCALE,"fDamageScale", GetCreatureRank(oAttacker));

    float fAr       =   GetCreatureProperty(oTarget,PROPERTY_ATTRIBUTE_ARMOR); //MkBot

    // GXA Override
    if (HasAbility(oAttacker, 401101) == TRUE) // GXA Spirit Damage
    {
        if (IsModalAbilityActive(oAttacker, 401100) == TRUE) // GXA Spirit Warrior
        {
            // bypass armor for normal attacks
            fAr = 0.0f;
        }
    }
    // GXA Override

    float fAp       =   DmgGetArmorPenetrationRating(oAttacker, oWeapon) + fArmorPenetrationBonus;
    float fDmgBonus =   GetCreatureProperty(oAttacker, PROPERTY_ATTRIBUTE_DAMAGE_BONUS);

    if (nAttackResult == COMBAT_RESULT_CRITICALHIT)
        fDamage *= GetCriticalDamageModifier(oAttacker);
    else if (nAttackResult == COMBAT_RESULT_BACKSTAB)
        fDamage = Combat_Damage_GetBackstabDamage(oAttacker,oWeapon, fDamage);
    else if (nAttackResult == COMBAT_RESULT_DEATHBLOW)
        fDamage = GetMaxHealth(oTarget)+1.0f;

    fDamage = fDamage - MaxF(0.0f,fAr - fAp);

    fDamage += fDmgBonus + Combat_Damage_GetTalentBoni(oAttacker, oTarget, oWeapon);


    // -------------------------------------------------------------------------
    // Damage scale only kicks in on 'significant' damage.
    // -------------------------------------------------------------------------
    if (fDamageScale >0.0 && fDamage> GetDamageScalingThreshold() )
    {
        fDamage *= fDamageScale;
    }

    // -------------------------------------------------------------------------
    // Weapon damage is always at least 1, even with armor. This is intentional
    // to avoid deadlocks of creatures that are both unable to damage each other
    // -------------------------------------------------------------------------
    fDamage = MaxF(1.0f,fDamage);



    return (fDamage);
} 

string MK_ItemTypeToString(int nItemType)
{
  switch(nItemType)
  {
      case ITEM_TYPE_ARMOUR: return "ITEM_TYPE_ARMOUR";
      case ITEM_TYPE_INVALID: return "ITEM_TYPE_INVALID";
      case ITEM_TYPE_MISC: return "ITEM_TYPE_MISC";
      case ITEM_TYPE_SHIELD: return "ITEM_TYPE_SHIELD";
      case ITEM_TYPE_WEAPON_MELEE: return "ITEM_TYPE_WEAPON_MELEE";
      case ITEM_TYPE_WEAPON_RANGED: return "ITEM_TYPE_WEAPON_RANGED";
      case ITEM_TYPE_WEAPON_WAND: return "ITEM_TYPE_WEAPON_WAND";
  }
  return "UNKNOWN";
    
}
#endif