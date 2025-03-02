#ifndef MK_LOG_COMMANDS_H
#defsym MK_LOG_COMMANDS_H

//==============================================================================
//                              INCLUDES
//==============================================================================
#include "var_constants_h"
#include "log_name_id_h"
#include "mk_abilityidtostring_h"

//==============================================================================
//                          CONSTANTS
//==============================================================================
const int MK_NUM_OF_CMD_PARAMETERS_TO_PRINT = 10;

//==============================================================================
//                          DECLARATIONS
//==============================================================================
void MK_LogCommandQueue(object oCreature);
string MK_GetCmdHeader();
string MK_CmdTypeToString(int nCmdType);
string MK_GetCmdLog(command cCmdToLog, object oOwner, int nQueueIdx = -10);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
void MK_LogCommandQueue(object oCreature)
{
    //object oCreature = OBJECT_SELF;

    command cCmdToLog;
    string sLogMsg;


    cCmdToLog = GetPreviousCommand(oCreature);
    sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, -2);
    PrintToLog(sLogMsg);

    cCmdToLog = GetCurrentCommand(oCreature);
    sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, -1);
    PrintToLog(sLogMsg);

    int i;
    int nSize = GetCommandQueueSize(oCreature);
    for(i=0; i < nSize; i++)
    {
        cCmdToLog = GetCommandByIndex(oCreature, i);
        sLogMsg = MK_GetCmdLog(cCmdToLog, oCreature, i);
        PrintToLog(sLogMsg);
    }

}

string MK_GetCmdHeader()
{
//QueueIdx OwnerName OwnerId IsPlayerIssued CmdType float1 float2 float3 float4 float5 int1 int2 int3 int4 int5 ObjectId1 ObjectId2 ObjectId3 ObjectId4 ObjectId5
    string sHeader;

    sHeader = ";QueueIdx;Name;Id;" ;
    sHeader = sHeader + "IsPlayerIssued;" ;
    sHeader = sHeader + "CmdType;" ;

    int i;
    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "float" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }

    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "int" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }

    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        string sLabel = "object" + IntToString(i);
        sHeader = sHeader + sLabel + ";" ;
    }
    return sHeader;
}

string MK_CmdTypeToString(int nCmdType)
{
    switch(nCmdType)
    {
        case COMMAND_TYPE_INVALID:
        {
            return "COMMAND_TYPE_INVALID";
            break;
        }
        case COMMAND_TYPE_ATTACK:
        {
            return "COMMAND_TYPE_ATTACK";
            break;
        }
        case COMMAND_TYPE_DO_FUNCTION:
        {
            return "COMMAND_TYPE_DO_FUNCTION";
            break;
        }
        case COMMAND_TYPE_JUMP_TO_OBJECT:
        {
            return "COMMAND_TYPE_JUMP_TO_OBJECT";
            break;
        }
        case COMMAND_TYPE_JUMP_TO_LOCATION:
        {
            return "COMMAND_TYPE_JUMP_TO_LOCATION";
            break;
        }
        case COMMAND_TYPE_WAIT:
        {
            return "COMMAND_TYPE_WAIT";
            break;
        }
        case COMMAND_TYPE_PLAY_ANIMATION:
        {
            return "COMMAND_TYPE_PLAY_ANIMATION";
            break;
        }
        case COMMAND_TYPE_START_CONVERSATION:
        {
            return "COMMAND_TYPE_START_CONVERSATION";
            break;
        }
        case COMMAND_TYPE_MOVE_TO_LOCATION:
        {
            return "COMMAND_TYPE_MOVE_TO_LOCATION";
            break;
        }
        case COMMAND_TYPE_MOVE_TO_OBJECT:
        {
            return "COMMAND_TYPE_MOVE_TO_OBJECT";
            break;
        }
        case COMMAND_TYPE_RECOVER:
        {
            return "COMMAND_TYPE_RECOVER";
            break;
        }
        case COMMAND_TYPE_USE_ABILITY:
        {
            return "COMMAND_TYPE_USE_ABILITY";
            break;
        }
        case COMMAND_TYPE_EQUIP_ITEM:
        {
            return "COMMAND_TYPE_EQUIP_ITEM";
            break;
        }
        case COMMAND_TYPE_UNEQUIP_ITEM:
        {
            return "COMMAND_TYPE_UNEQUIP_ITEM";
            break;
        }
        case COMMAND_TYPE_USE_OBJECT:
        {
            return "COMMAND_TYPE_USE_OBJECT";
            break;
        }
        case COMMAND_TYPE_DRIVE:
        {
            return "COMMAND_TYPE_DRIVE";
            break;
        }
        case COMMAND_TYPE_INTERACT:
        {
            return "COMMAND_TYPE_INTERACT";
            break;
        }
        case COMMAND_TYPE_DEATHBLOW:
        {
            return "COMMAND_TYPE_DEATHBLOW";
            break;
        }
        case COMMAND_TYPE_SWITCH_WEAPON_SETS:
        {
            return "COMMAND_TYPE_SWITCH_WEAPON_SETS";
            break;
        }
        case COMMAND_TYPE_FLY:
        {
            return "COMMAND_TYPE_FLY";
            break;
        }
    }
    return "UNKNOWN";
}

string MK_GetCmdLog(command cCmdToLog, object oOwner, int nQueueIdx)
{
    int nWidth = 8;
    int nDecimals = 3;

    string sLog;
    int nCmdType = GetCommandType(cCmdToLog);

    sLog = ";";
    sLog = sLog + IntToString(nQueueIdx) + ";" ;
    sLog = sLog + MK_LogCreatureId(oOwner);
    sLog = sLog + IntToString( GetCommandIsPlayerIssued(cCmdToLog) ) + ";" ;
    sLog = sLog + MK_CmdTypeToString( nCmdType ) + ";" ;

    int i;
    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        float fLocal = GetCommandFloat(cCmdToLog, i);
        sLog = sLog + FloatToString(fLocal, nWidth, nDecimals) + ";" ;
    }

    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        int nLocal = GetCommandInt(cCmdToLog, i);
        if( nCmdType == COMMAND_TYPE_USE_ABILITY && i == 0)
            sLog = sLog + MK_AbilityIdToString(nLocal) + ";" ;
        else
            sLog = sLog + IntToString(nLocal) + ";" ;
    }

    for(i=0; i<MK_NUM_OF_CMD_PARAMETERS_TO_PRINT; i++)
    {
        object oLocal = GetCommandObject(cCmdToLog, i);
        sLog = sLog + ObjectToString(oLocal) + ";" ;
    }

    return sLog;

}
/*
void MK_LogCmd(command cCmdToPrint, object oOwner = OBJECT_INVALID)
{
//OwnerId IsPlayerIssued CmdType int1 int2 int3 int4 int5 float1 float2 float3 float4 float5 ObjectId1 ObjectId2 ObjectId3 ObjectId4 ObjectId5



    //command cCmdToPrint = GetCurrentCommand(OBJECT_SLEF);
    string sLogCmdMsg;
    sLogCmdMsg = ";" ;
    sLogCmdMsg = sLogCmdMsg +

    sLogCmdMsg = sLogCmdMsg + ObjectToString(oOwner) + "\t";
    sLogCmdMsg = sLogCmdMsg + GetCommandIsPlayerIssued(cCmdToPrint) + "\t";
    sLogCmdMsg = sLogCmdMsg + GetCommandType(cCmdToPrint);
    int i;
    for(i=0; i < nNumOfParametersToPrint; i++)
    {
        int nIntX = GetCommandInt(cCmdToPrint, i);
        sLogCmdMsg = sLogCmdMsg + IntToString(nIntX) + "\t";
    }

    for(i=0; i < nNumOfParametersToPrint; i++)
    {
        float fFloatX = GetCommandFloat(cCmdToPrint, i);
        sLogCmdMsg = sLogCmdMsg + FloatToString(fFloatX) + "\t";
    }

    for(i=0; i < nNumOfParametersToPrint; i++)
    {
        object oObjectX = GetCommandObject(cCmdToPrint, i);
        sLogCmdMsg = sLogCmdMsg + ObjectToString(oObjectX) + "\t";
    }
}
  */
#endif