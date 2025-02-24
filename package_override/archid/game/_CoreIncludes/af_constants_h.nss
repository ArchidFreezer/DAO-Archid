/*
* Set of constants that are useful across multiple mod components
*
* This file should not contain component specific values to reduce the need for recompilation
*/

/* Popup Types */
const int AF_POPUP_INVALID                 = 0;
const int AF_POPUP_QUESTION                = 1;   // Yes/No
const int AF_POPUP_RENAME_DOG              = 2;   // Confirm
const int AF_POPUP_BLOCKING_PLACEABLE      = 3;   // OK
const int AF_POPUP_MESSAGE                 = 4;   // OK
const int AF_POPUP_RESPEC_CHAR             = 5;   // Yes/No

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
const string AF_NOHELM_FLAG = "AF_NOHELM_FLAG";
const string AF_GENERAL_FLAG = "AF_GENERAL_FLAG";
const string AF_DAOAREA1_FLAG = "AF_DAOAREA1_FLAG";
const string AF_DAOAREA2_FLAG = "AF_DAOAREA2_FLAG";

/* Follower flag masks */
const int AF_PARTY_FLAG_HERO      = 0x00000001;
const int AF_PARTY_FLAG_ALISTAIR  = 0x00000002;
const int AF_PARTY_FLAG_DOG       = 0x00000004;
const int AF_PARTY_FLAG_LELIANA   = 0x00000008;
const int AF_PARTY_FLAG_LOGHAIN   = 0x00000010;
const int AF_PARTY_FLAG_MORRIGAN  = 0x00000020;
const int AF_PARTY_FLAG_OGHREN    = 0x00000040;
const int AF_PARTY_FLAG_SHALE     = 0x00000080;
const int AF_PARTY_FLAG_STEN      = 0x00000100;
const int AF_PARTY_FLAG_WYNNE     = 0x00000200;
const int AF_PARTY_FLAG_ZEVRAIN   = 0x00000400;

/* One time area list flags
* These are used in the prcsscr scripts to run code a single time against the area list */
const int AF_DAOAREA1_ARL100AR    = 0x00000001;
const int AF_DAOAREA1_ARL220AR    = 0x00000002;
const int AF_DAOAREA1_ARL230AR    = 0x00000004;
const int AF_DAOAREA1_CAM100AR    = 0x00000008;
const int AF_DAOAREA1_CIR200AR    = 0x00000010;
const int AF_DAOAREA1_CIR210AR    = 0x00000020;
const int AF_DAOAREA1_CIR220AR    = 0x00000040;
const int AF_DAOAREA1_CIR230AR    = 0x00000080;
const int AF_DAOAREA1_CIR310AR    = 0x00000100;
const int AF_DAOAREA1_DEN200AR    = 0x00000200;
const int AF_DAOAREA1_DEN960AR    = 0x00000400;
const int AF_DAOAREA1_DEN100AR    = 0x00000800;
const int AF_DAOAREA1_DEN920AR    = 0x00001000;
const int AF_DAOAREA1_DEN961AR    = 0x00002000;
const int AF_DAOAREA1_DEN971AR    = 0x00004000;
const int AF_DAOAREA1_DRK500AR    = 0x00008000;
const int AF_DAOAREA1_GIB000AR    = 0x00010000;
const int AF_DAOAREA1_GWB100AR    = 0x00020000;
const int AF_DAOAREA1_INT100AR    = 0x00040000;
const int AF_DAOAREA1_KCC100AR    = 0x00080000;
const int AF_DAOAREA1_LOT100AR    = 0x00100000;
const int AF_DAOAREA1_LOT110AR    = 0x00200000;
const int AF_DAOAREA1_NTB100AR    = 0x00400000;
const int AF_DAOAREA1_NTB200AR    = 0x00800000;
const int AF_DAOAREA1_NTB310AR    = 0x01000000;
const int AF_DAOAREA1_NTB330AR    = 0x02000000;
const int AF_DAOAREA1_NTB340AR    = 0x08000000;
const int AF_DAOAREA1_ORZ100AR    = 0x04000000;
const int AF_DAOAREA1_ORZ200AR    = 0x10000000;
const int AF_DAOAREA1_ORZ310AR    = 0x20000000;
const int AF_DAOAREA1_ORZ260AR    = 0x40000000;
const int AF_DAOAREA1_ORZ510AR    = 0x80000000;

const int AF_DAOAREA2_ORZ530AR    = 0x00000001;
const int AF_DAOAREA2_ORZ550AR    = 0x00000002;
const int AF_DAOAREA2_ORZ230AR    = 0x00000004;
const int AF_DAOAREA2_ORZ320AR    = 0x00000008;
const int AF_DAOAREA2_PRE100AR    = 0x00000010;
const int AF_DAOAREA2_PRE200AR    = 0x00000020;
const int AF_DAOAREA2_PRE100AR2   = 0x00000040;
const int AF_DAOAREA2_RAN154AR    = 0x00000080;
const int AF_DAOAREA2_RAN700AR    = 0x00000100;
const int AF_DAOAREA2_RAN800AR    = 0x00000200;
const int AF_DAOAREA2_SHL300AR    = 0x00000400;
const int AF_DAOAREA2_STR200AR    = 0x00000800;
const int AF_DAOAREA2_URN110AR    = 0x00001000;
const int AF_DAOAREA2_URN220AR    = 0x00002000;
const int AF_DAOAREA2_PRE210AR    = 0x00004000;
const int AF_DAOAREA2_ARL101AR    = 0x00008000;
const int AF_DAOAREA2_CIR100AR    = 0x00010000;
const int AF_DAOAREA2_CAM104AR    = 0x00020000;
const int AF_DAOAREA2_CAM110AR    = 0x00040000;
const int AF_DAOAREA2_ARL120AR    = 0x00080000;
const int AF_DAOAREA2_ARL170AR    = 0x00100000;
const int AF_DAOAREA2_DEN220AR    = 0x00200000;
const int AF_DAOAREA2_DEN230AR    = 0x00400000;
const int AF_DAOAREA2_DEN250AR    = 0x00800000;
const int AF_DAOAREA2_DEN260AR    = 0x01000000;
const int AF_DAOAREA2_PRE211AR    = 0x02000000;
const int AF_DAOAREA2_URN130AR    = 0x00001000;

/* No Helmet Hack flags - AF_NOHELM_FLAG */
const int AF_NOHELM_SLOT_ACTIVE   = 0x00000001;
const int AF_NOHELM_PLAYER        = 0x00000002;
const int AF_NOHELM_ALISTAIR      = 0x00000004;
const int AF_NOHELM_ANDERS        = 0x00000008;
const int AF_NOHELM_JUSTICE       = 0x00000010;
const int AF_NOHELM_LELIANA       = 0x00000020;
const int AF_NOHELM_LOGHAIN       = 0x00000040;
const int AF_NOHELM_MHAIRI        = 0x00000080;
const int AF_NOHELM_MORRIGAN      = 0x00000100;
const int AF_NOHELM_NATHANIEL     = 0x00000200;
const int AF_NOHELM_OGHREN        = 0x00000400;
const int AF_NOHELM_SIGRUN        = 0x00000800;
const int AF_NOHELM_STEN          = 0x00001000;
const int AF_NOHELM_UNKNOWN       = 0x00002000;
const int AF_NOHELM_VELANNA       = 0x00004000;
const int AF_NOHELM_WYNNE         = 0x00008000;
const int AF_NOHELM_ZEVRAN        = 0x00010000;

/* General bit flags - AF_GENERAL_FLAG */
const int AF_GENERAL_AWAKENING_INIT  = 0x00000001;
const int AF_GENERAL_ALISTAIR_ROSE   = 0x00000002;
const int AF_GENERAL_RESPEC_USE      = 0x00000004;
