#include "core_h"
#include "log_h"
#include "af_constants_h"
#include "af_option_h"
                                
/** Logging table constants */
const int AF_TABLE_LOGGING = 6610004;         // 2DA table ID
const int AF_LOGGROUP_GLOBAL = 0;             // 2DA row with the global log level
const string AF_LOGGROUP_COL = "GroupName";
const string AF_LOGLEVEL_COL = "LogLevel";
           
/** Options table constants */
const int AF_INCLUDE_SCRIPT = 0; // 2DA row in options table with log script inclusion enabled
const int AF_ALWAYS_PRINT = 1;

// Defined log levels
const int AF_LOG_NONE  = 0;
const int AF_LOG_INFO  = 1;
const int AF_LOG_LOG = 2;
const int AF_LOG_WARN = 3;
const int AF_LOG_DEBUG = 4;

/**
* @brief get the max log level for a log group
*
* Checks the module variables to see if the log group is defined, if it is then
* the maximum level it is configured for is returned, otherwise it assumes that
* there are no constraints and returns the maximum level (AF_LOG_DEBUG).
*
* @param nLogGroup ID of the log group to check against
**/
int _AF_GetGroupLogLevel(int nLogGroup = 0) {
    // Get the maximum logging level for all groups
    int nMaxLevel = GetM2DAInt(AF_TABLE_LOGGING, AF_LOGLEVEL_COL, AF_LOGGROUP_GLOBAL);
    // Thgis will return 0 if the log group is not defined, turning off logging
    int nLogGroupLevel = GetM2DAInt(AF_TABLE_LOGGING, AF_LOGLEVEL_COL, nLogGroup);

    // If the log group is not defined then use the max, otherwise get the lower of the global/group
    if (nLogGroupLevel >= 0 && nLogGroupLevel <= 4) {
        return Min(nMaxLevel, nLogGroupLevel);
    } else {
        return nMaxLevel;
    }
}

/**
* @brief returns the string to print to the log file
*
* Builds the string to print to log from the various components. Adds the script name if that
* is configured in the global options 2da.
*
* @param sMsg Log string from the initial calling function
* @param nLogLevel The level of logging requested
* @param nLogGroup   The log group the message is for, defaults to the Global group
**/
string _AF_GetLogMessage(string sMsg, int nLogLevel, int nLogGroup = 0) {
    string sReturn;
    switch (nLogLevel) {
        case AF_LOG_INFO:
            sReturn = "[INFO ";
            break;
        case AF_LOG_LOG:
            sReturn = "[LOG ";
            break;
        case AF_LOG_WARN:
            sReturn = "[WARN ";
            break;
        case AF_LOG_DEBUG:
            sReturn = "[DEBUG ";
            break;
        default:
            sReturn = " ";
            break;
    }
    sReturn = sReturn + GetM2DAString(AF_TABLE_LOGGING, AF_LOGGROUP_COL, nLogGroup) + "] ";
    if (AF_IsOptionEnabled(AF_INCLUDE_SCRIPT)) sReturn = sReturn + "[" + GetCurrentScriptName() + "] ";
    sReturn = sReturn + sMsg;
    return sReturn;
}

/**
* @brief check whether a log group should write logs
*
* Checks whether the log group specified should write out logs of the given level, based on both
* the global permitted level and the log groups specific config. If no log group is specified
* then the check is only agains the global logging level.
* return TRUE if the level should be logged; otherwise FALSE
*
* @param nLogLevel logging level to check
* @param nLogGroup log group to check; default check global level only
**/
int _AF_IsLoggingLevel(int nLogLevel, int nLogGroup = 0) {
    return (_AF_GetGroupLogLevel(nLogGroup) >= nLogLevel);
}

/**
* @brief writes an info string to DragonAge_1.log
*
* The string will only be written if af_constants_h.AF_LOG_ACTIVE == TRUE
*
* @param sMsg        The string to write to the log
* @param nLogGroup   The log group the message is for, defaults to the Global group
*
**/
void AF_LogInfo(string sMsg, int nLogGroup = 0) {
    if (_AF_IsLoggingLevel(AF_LOG_INFO, nLogGroup)) PrintToLog(_AF_GetLogMessage(sMsg, AF_LOG_INFO, nLogGroup));
}

/**
* @brief writes a warning string to DragonAge_1.log
*
* The string will only be written if af_constants_h.AF_LOG_ACTIVE == TRUE
*
* @param sMsg        The string to write to the log
* @param nLogGroup   The log group the message is for, defaults to the Global group
*
**/
void AF_LogLog(string sMsg, int nLogGroup = 0) {
    if (_AF_IsLoggingLevel(AF_LOG_LOG, nLogGroup)) PrintToLog(_AF_GetLogMessage(sMsg, AF_LOG_LOG, nLogGroup));
}

/**
* @brief writes a warning string to DragonAge_1.log
*
* The string will only be written if af_constants_h.AF_LOG_ACTIVE == TRUE
*
* @param sMsg        The string to write to the log
* @param nLogGroup   The log group the message is for, defaults to the Global group
*
**/
void AF_LogWarn(string sMsg, int nLogGroup = 0) {
    if (_AF_IsLoggingLevel(AF_LOG_WARN, nLogGroup)) PrintToLog(_AF_GetLogMessage(sMsg, AF_LOG_WARN, nLogGroup));
}

/**
* @brief writes a debug string to DragonAge_1.log
*
* The string will only be written if af_constants_h.AF_LOG_ACTIVE == TRUE
*
* @param sMsg        The string to write to the log
* @param nLogGroup   The log group the message is for, defaults to the Global group
*
**/
void AF_LogDebug(string sMsg, int nLogGroup = 0) {
    if (_AF_IsLoggingLevel(AF_LOG_DEBUG, nLogGroup)) PrintToLog(_AF_GetLogMessage(sMsg, AF_LOG_DEBUG, nLogGroup));
}

/**
* @brief display a floaty message
*
* @param sMsg       The string to display
* @param nLogGroup  The log group the message is for; defaults to the Global group
* @param nLevel     The level to log at; defaults to LOG
* @param oTarget    The object to display the message over; defaults to self
* @param nColour    The colour of the floaty text; defaults to grey
* @param fTime      The duration in seconds the message should be shown; defaults to 3s
*
*/
void AF_LogFloaty(string sMsg, int nLogGroup = 0, int nLevel = AF_LOG_LOG, object oTarget = OBJECT_SELF, int nColour = AF_COLOUR_GREY, float fTime = 3.0f) {
    if (_AF_IsLoggingLevel(nLevel, nLogGroup)) {
        DisplayFloatyMessage(oTarget, sMsg, FLOATY_MESSAGE, nColour, fTime);
        if (AF_IsOptionEnabled(AF_ALWAYS_PRINT)) PrintToLog(_AF_GetLogMessage(sMsg, nLevel, nLogGroup));
    }
}

/**
* @brief display a floaty message at INFO level
*
* @param sMsg       The string to display
* @param nLogGroup  The log group the message is for; defaults to the Global group
* @param oTarget    The object to display the message over; defaults to self
* @param nColour    The colour of the floaty text; defaults to grey
* @param fTime      The duration in seconds the message should be shown; defaults to 3s
*
*/
void AF_LogFloatyInfo(string sMsg, int nLogGroup = 0, object oTarget = OBJECT_SELF, int nColour = AF_COLOUR_GREY, float fTime = 3.0f) {
    AF_LogFloaty(sMsg, nLogGroup, AF_LOG_INFO, oTarget, nColour, fTime);
}

/**
* @brief display a floaty message at LOG level
*
* @param sMsg       The string to display
* @param nLogGroup  The log group the message is for; defaults to the Global group
* @param oTarget    The object to display the message over; defaults to self
* @param nColour    The colour of the floaty text; defaults to grey
* @param fTime      The duration in seconds the message should be shown; defaults to 3s
*
*/
void AF_LogFloatyLog(string sMsg, int nLogGroup = 0, object oTarget = OBJECT_SELF, int nColour = AF_COLOUR_GREY, float fTime = 3.0f) {
    AF_LogFloaty(sMsg, nLogGroup, AF_LOG_LOG, oTarget, nColour, fTime);
}

/**
* @brief display a floaty message at WARN level
*
* @param sMsg       The string to display
* @param nLogGroup  The log group the message is for; defaults to the Global group
* @param oTarget    The object to display the message over; defaults to self
* @param nColour    The colour of the floaty text; defaults to grey
* @param fTime      The duration in seconds the message should be shown; defaults to 3s
*
*/
void AF_LogFloatyWarn(string sMsg, int nLogGroup = 0, object oTarget = OBJECT_SELF, int nColour = AF_COLOUR_GREY, float fTime = 3.0f) {
    AF_LogFloaty(sMsg, nLogGroup, AF_LOG_WARN, oTarget, nColour, fTime);
}
 
/**
* @brief display a floaty message at DEBUG level
*
* @param sMsg       The string to display
* @param nLogGroup  The log group the message is for; defaults to the Global group
* @param oTarget    The object to display the message over; defaults to self
* @param nColour    The colour of the floaty text; defaults to grey
* @param fTime      The duration in seconds the message should be shown; defaults to 3s
*
*/
void AF_LogFloatyDebug(string sMsg, int nLogGroup = 0, object oTarget = OBJECT_SELF, int nColour = AF_COLOUR_GREY, float fTime = 3.0f) {
    AF_LogFloaty(sMsg, nLogGroup, AF_LOG_DEBUG, oTarget, nColour, fTime);
}
