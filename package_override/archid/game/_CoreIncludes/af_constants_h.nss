/*
* Set of constants that are useful across multiple mod components
*
* This file should not contain component specific values to reduce the need for recompilation
*/

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
