/*
* Set of constants that are useful across multiple mod components
*
* This file should not contain component specific values to reduce the need for recompilation
*/

/* Log groups */
const int AF_LOGGROUP_DLCINT = 1;

/** Options table constants */
const int AF_OPT_INCLUDE_SCRIPT = 0;          // Should the script name be included in logging statements
const int AF_OPT_ALWAYS_PRINT = 1;            // Should all logging be written to file
const int AF_OPT_NORMALISE_CRITS = 2;
const int AF_OPT_MISDIRECT_BACKSTABS = 3;     // Misdirect backstabs on critical rolls
const int AF_OPT_MESSY_KILLS = 4;
const int AF_OPT_DUAL_STRIKING_TIMING = 5;
const int AF_OPT_REMOVE_EVASION_DODGE = 6;
const int AF_OPT_RUNE_STACKING = 7;
const int AF_OPT_INVENTORY_DAMAGE = 8;
const int AF_OPT_CRITS_IN_DAMAGE = 9;
const int AF_OPT_ONHIT_IN_DAMAGE = 10;
const int AF_OPT_FIX_DOT_DURATIONS = 11;
const int AF_OPT_RECEIVED_ITEM_DURATION = 12;
const int AF_OPT_RECEIVED_ITEM_COLOUR = 13;

/* M2DA Table IDs */
// These are ones to be used across mulitple scripts
const int AF_TABLE_REMOVABLE_EQUIP = 6610007;

/* Creature properties */
const int AF_CRE_PROPERTY_SIMPLE_SPECIALIZATION_POINTS = 38;

/* Custom effects */
const int AF_EFFECT_TYPE_MESSY_KILLS = 6610000;
const int AF_EFFECT_TYPE_HOSTILITY_INTIMIDATION = 6610004;

/* The following colours are used by the game */
const int AF_COLOUR_WHITE = 0xffffff;      // General
const int AF_COLOUR_RED_BRIGHT = 0xff0000; // Death, traps, etc.
const int AF_COLOUR_RED = 0xcc0000;        // Follower damage
const int AF_COLOUR_YELLOW = 0xffff00;     // Special attacks
const int AF_COLOUR_GREEN = 0x00cc00;      // Healing
const int AF_COLOUR_MAGENTA = 0xff33ff;    // Debug
const int AF_COLOUR_BLUE = 0x6699ff;       // Mana damage
const int AF_COLOUR_ORANGE = 0xff6600;     //
const int AF_COLOUR_GREY = 0x888888;       // Archid debug

/* Module variables containing flags */
const string AF_PARTYFLAG_LUCKY = "AF_PARTYFLAG_LUCKY";
const string AF_DLCITEMS_FLAG1 = "AF_DLCITEMS_FLAG1";
const string AF_DLCITEMS_FLAG2 = "AF_DLCITEMS_FLAG2";
const string AF_FEASTITEMS_FLAG = "AF_FEASTITEMS_FLAG";
const string AF_GENERAL_FLAG = "AF_GENERAL_FLAG";
const string AF_NOHELM_FLAG = "AF_NOHELM_FLAG";

/* Follower flag masks */
const int AF_PARTY_FLAG_HERO          = 0x00000001;
const int AF_PARTY_FLAG_ALISTAIR      = 0x00000002;
const int AF_PARTY_FLAG_DOG           = 0x00000004;
const int AF_PARTY_FLAG_LELIANA       = 0x00000008;
const int AF_PARTY_FLAG_LOGHAIN       = 0x00000010;
const int AF_PARTY_FLAG_MORRIGAN      = 0x00000020;
const int AF_PARTY_FLAG_OGHREN        = 0x00000040;
const int AF_PARTY_FLAG_SHALE         = 0x00000080;
const int AF_PARTY_FLAG_STEN          = 0x00000100;
const int AF_PARTY_FLAG_WYNNE         = 0x00000200;
const int AF_PARTY_FLAG_ZEVRAIN       = 0x00000400;

/* DLC Item Integration */
/* AF_DLCITEMS_FLAG1 */
const int AF_DLC_AMULET_OF_THE_WAR_MAGE              = 0x00000001;
const int AF_DLC_BAND_OF_FIRE                        = 0x00000002;
const int AF_DLC_BATTLEDRESS_OF_THE_PROVOCATEUR      = 0x00000004;
const int AF_DLC_BERGENS_HONOUR                      = 0x00000008;
const int AF_DLC_BLOOD_DRAGON_PLATE                  = 0x00000010;
const int AF_DLC_BLOOD_DRAGON_PLATE_BOOTS            = 0x00000020;
const int AF_DLC_BLOOD_DRAGON_PLATE_GAUNTLETS        = 0x00000040;
const int AF_DLC_BLOOD_DRAGON_PLATE_HELMET           = 0x00000080;
const int AF_DLC_BREGANS_BOW                         = 0x00000100;
const int AF_DLC_BLIGHTBLOOD                         = 0x00000200;
const int AF_DLC_BULWARK_OF_THE_TRUE_KING            = 0x00000400;
const int AF_DLC_CINCH_OF_SKILLFULL_MANOEUVERING     = 0x00000800;
const int AF_DLC_DALISH_PROMISE_RING                 = 0x00001000;
const int AF_DLC_DARKSPAWN_CHRONICLES                = 0x00002000;
const int AF_DLC_DRAGONBONE_CLEAVER                  = 0x00004000;
const int AF_DLC_EDGE                                = 0x00008000;
const int AF_DLC_EMBRIS_MANY_POCKETS                 = 0x00010000;
const int AF_DLC_FERAL_WOLF_CHARM                    = 0x00020000;
const int AF_DLC_FINAL_REASON                        = 0x00040000;
const int AF_DLC_FORMATI_TOME                        = 0x00080000;
const int AF_DLC_GRIMOIRE_OF_THE_FROZEN_WASTES       = 0x00100000;
const int AF_DLC_GUILDMASTERS_BELT                   = 0x00200000;
const int AF_DLC_HELM_OF_THE_DEEP                    = 0x00400000;
const int AF_DLC_HIGH_REGARD_OF_HOUSE_DACE           = 0x00800000;
const int AF_DLC_LIONS_PAW                           = 0x01000000;
const int AF_DLC_LUCKY_STONE                         = 0x02000000;
const int AF_DLC_MARK_OF_VIGILANCE                   = 0x04000000;
const int AF_DLC_MEMORY_BAND_OSTAGAR                 = 0x08000000;
const int AF_DLC_PEARL_OF_THE_ANOINTED               = 0x10000000;
const int AF_DLC_REAPERS_CUDGEL                      = 0x20000000;
const int AF_DLC_SASH_OF_FORBIDDEN_SECRETS           = 0x40000000;
const int AF_DLC_SORROWS_OF_ARLATHAN                 = 0x80000000;
/* AF_DLCITEMS_FLAG2 */
const int AF_DLC2_VESTMENTS_OF_THE_SEER              = 0x00000001;
const int AF_DLC2_WICKED_OATH                        = 0x00000002;
const int AF_DLC2_BATTLEDRESS_IMPORT                 = 0x00000004;
const int AF_DLC2_BLIGHTBLOOD_IMPORT                 = 0x00000008;
const int AF_DLC2_BREGANS_BOW_IMPORT                 = 0x00000010;
const int AF_DLC2_BULWARK_IMPORT                     = 0x00000020;
const int AF_DLC2_CINCH_IMPORT                       = 0x00000040;
const int AF_DLC2_DRAGONBONE_CLEAVER_IMPORT          = 0x00000080;
const int AF_DLC2_FORBIDDEN_SECRETS_IMPORT           = 0x00000100;
const int AF_DLC2_HIGH_REGARD_IMPORT                 = 0x00000200;
const int AF_DLC2_PEARL_IMPORT                       = 0x00000400;
const int AF_DLC2_REAPERS_CUDGEL_IMPORT              = 0x00000800;
const int AF_DLC2_SORROWS_ARLATHAN_IMPORT            = 0x00001000;
const int AF_DLC2_VESTMENTS_IMPORT                   = 0x00002000;
const int AF_DLC2_MEMORY_BAND_RETURN                 = 0x00004000;

/* Feast Day Gifts - AF_FEASTITEMS_FLAG */
const int AF_FEAST_ALISTAIR_DOLL                     = 0x00000001;
const int AF_FEAST_AMUILET_OF_MEMORIES               = 0x00000002;
const int AF_FEAST_BEARD_FLASK                       = 0x00000004;
const int AF_FEAST_BUTTERFLY_SWORD                   = 0x00000008;
const int AF_FEAST_CAT_LADY_HOBBLESTICK              = 0x00000010;
const int AF_FEAST_CHANT_OF_LIGHT                    = 0x00000020;
const int AF_FEAST_CHASTITY_BELT                     = 0x00000040;
const int AF_FEAST_FAT_LUTE                          = 0x00000080;
const int AF_FEAST_GENEAOLOGY_OF_KYNGS               = 0x00000100;
const int AF_FEAST_GREY_WARDEN_PUPPET                = 0x00000200;
const int AF_FEAST_KING_MARICS_SHIELD                = 0x00000400;
const int AF_FEAST_LUMP_OF_CHARCOAL                  = 0x00000800;
const int AF_FEAST_ORLESIAN_MASK                     = 0x00001000;
const int AF_FEAST_PET_ROCK                          = 0x00002000;
const int AF_FEAST_PROTECTIVE_CONE                   = 0x00004000;
const int AF_FEAST_QUNARI_PRAYERS_DEAD               = 0x00008000;
const int AF_FEAST_RARE_ANTIVAN_BRANDY               = 0x00010000;
const int AF_FEAST_ROTTEN_ONION                      = 0x00020000;
const int AF_FEAST_SCENTED_SOAP                      = 0x00040000;
const int AF_FEAST_STICK                             = 0x00080000;
const int AF_FEAST_SUGAR_CAKE                        = 0x00100000;
const int AF_FEAST_THOUGHTFUL_GIFT                   = 0x00200000;
const int AF_FEAST_UGLY_BOOTS                        = 0x00400000;
const int AF_FEAST_UNCRUSHABLE_PIGEON                = 0x00800000;

/* No Helmet Hack flags - AF_NOHELM_FLAG */
const int AF_NOHELM_SLOT_ACTIVE                      = 0x00000001;
const int AF_NOHELM_PLAYER                           = 0x00000002;
const int AF_NOHELM_ALISTAIR                         = 0x00000004;
const int AF_NOHELM_ANDERS                           = 0x00000008;
const int AF_NOHELM_JUSTICE                          = 0x00000010;
const int AF_NOHELM_LELIANA                          = 0x00000020;
const int AF_NOHELM_LOGHAIN                          = 0x00000040;
const int AF_NOHELM_MHAIRI                           = 0x00000080;
const int AF_NOHELM_MORRIGAN                         = 0x00000100;
const int AF_NOHELM_NATHANIEL                        = 0x00000200;
const int AF_NOHELM_OGHREN                           = 0x00000400;
const int AF_NOHELM_SIGRUN                           = 0x00000800;
const int AF_NOHELM_STEN                             = 0x00001000;
const int AF_NOHELM_UNKNOWN                          = 0x00002000;
const int AF_NOHELM_VELANNA                          = 0x00004000;
const int AF_NOHELM_WYNNE                            = 0x00008000;
const int AF_NOHELM_ZEVRAN                           = 0x00010000;

/* General bit flags - AF_GENERAL_FLAG */
const int AF_GENERAL_AWAKENING_SPEC                  = 0x00000001;
const int AF_GENERAL_OWEN_FARSONG                    = 0x00000002;
const int AF_GENERAL_TPSWAP_WH                       = 0x00000004;
const int AF_GENERAL_TPSWAP_BC3                      = 0x00000008;
const int AF_GENERAL_TPSWAP_BC4                      = 0x00000010;
const int AF_GENERAL_TPSWAP_BCF                      = 0x00000020;
const int AF_GENERAL_TPSWAP_RAN154                   = 0x00000040;
const int AF_GENERAL_TPSWAP_RAN800                   = 0x00000080;
const int AF_GENERAL_ORZOUTS_05                      = 0x00000100;
const int AF_GENERAL_ORZOUTS_06                      = 0x00000200;
const int AF_GENERAL_ORZOUTS_230                     = 0x00000400;
const int AF_GENERAL_ALISTAIR_ROSE                   = 0x00000800;
