// -----------------------------------------------------------------------------
// effect_dispel_magic
// -----------------------------------------------------------------------------
/*
    Effect: Effect Dispel Magic


    */
// -----------------------------------------------------------------------------
// Owner: Georg Zoeller
// -----------------------------------------------------------------------------

#include "2da_constants_h"
#include "events_h"
#include "effect_constants_h"
#include "attributes_h"


effect EffectDispelMagic(int nNoSpells = 1)
{
    effect eEffect = Effect( EFFECT_TYPE_DISPEL_MAGIC );
    eEffect = SetEffectInteger(eEffect,0,nNoSpells);
    return eEffect;
}


int Effects_HandleApplyEffectDispelMagic(effect eEffect)
{
    int nNoSpells = GetEffectInteger(eEffect,0);


    // -------------------------------------------------------------------------
    // First Remove all Upkeep Effects.
    // -------------------------------------------------------------------------
    effect[] arSpell = GetEffects(OBJECT_SELF,EFFECT_TYPE_UPKEEP);
    int nSize = GetArraySize (arSpell);
    int i;
    int nId;
    for (i = 0; i < nSize; i++)
    {
        nId = GetEffectAbilityID(arSpell[i]);

        // ---------------------------------------------------------------------
        // We only dispell ABILITY_TYPE_SPELL!
        // ---------------------------------------------------------------------
        if (Ability_GetAbilityType(nId) == ABILITY_TYPE_SPELL)
        {
            RemoveEffect(OBJECT_SELF,arSpell[i]);
        }
    }


    // -------------------------------------------------------------------------
    // Second Remove all other spell effects
    // -------------------------------------------------------------------------

    arSpell = GetEffects(OBJECT_SELF);
    nSize = GetArraySize (arSpell);
    for (i = 0; i < nSize; i++)
    {
        nId = GetEffectAbilityID(arSpell[i]);
        // ---------------------------------------------------------------------
        // We only dispell ABILITY_TYPE_SPELL!
        // ---------------------------------------------------------------------
        if (Ability_GetAbilityType(nId) == ABILITY_TYPE_SPELL)
        {
            RemoveEffect(OBJECT_SELF,arSpell[i]);
        }
    }

    return TRUE;

}


int Effects_HandleRemoveEffectDispelMagic(effect eEffect)
{
    int nAttribute = GetEffectInteger(eEffect,0);

    return TRUE;
}