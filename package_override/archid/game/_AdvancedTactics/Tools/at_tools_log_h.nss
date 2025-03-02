#ifndef AT_TOOLS_LOG_H
#defsym AT_TOOLS_LOG_H

/*
    Advanced Tactics log tools
*/

#include "core_h"



void AT_Log(string sText, int nColor = 0x888888, float fTime = 5.0f)
{
    DisplayFloatyMessage(OBJECT_SELF, sText, FLOATY_MESSAGE, nColor, fTime);
}

void AT_ILog(int nInt, int nColor = 0x888888, float fTime = 5.0f)
{
    AT_Log(IntToString(nInt), nColor, fTime);
}

void AT_FLog(float fFloat, int nColor = 0x888888, float fTime = 5.0f)
{
    AT_Log(FloatToString(fFloat), nColor, fTime);
}

void AT_VLog(vector vVec, int nColor = 0x888888, float fTime = 5.0f)
{
    AT_Log(VectorToString(vVec), nColor, fTime);
}

void AT_Print(string sText)
{
    PrintToLog("[AT] " + sText);
}

void AT_IPrint(int nInt)
{
    AT_Print(IntToString(nInt));
}

void AT_FPrint(float fFloat)
{
    AT_Print(FloatToString(fFloat));
}

string ATS(string sText, int nLength)
{
    string sRet;
    int nTextLength = GetStringLength(sText);

    if (nLength >= nTextLength)
    {
        sRet = sText;

        int i;
        for (i = 0; i < (nLength - nTextLength); i++)
            sRet += " ";
    }
    else
    {
        sRet = SubString(sText, 0, nLength);
    }

    return sRet;
}

string ATIS(int nInt, int nLength)
{
    return ATS(IntToString(nInt), nLength);
}

void AT_Print_Tactics_Table(int nTable)
{
    int nRows = GetM2DARows(nTable);
    int nCurrentRow;

    AT_Print("--- Table " + IntToString(nTable) + " (" + IntToString(nRows) + " rows)---");

    int i;
    for (i = 0; i < nRows; ++i)
    {
        nCurrentRow = GetM2DARowIdFromRowIndex(nTable, i);

        int nTargetType = GetM2DAInt(nTable, "TargetType", nCurrentRow);
        int nCondition = GetM2DAInt(nTable, "Condition", nCurrentRow);
        int nCommandType = GetM2DAInt(nTable, "Command", nCurrentRow);
        int nCommandParam = GetM2DAInt(nTable, "SubCommand", nCurrentRow);
        int nUseChance = GetM2DAInt(nTable, "UseChance", nCurrentRow);

        AT_Print(
            ATIS(nCurrentRow, 7)+"|"+
            ATIS(nTargetType, 7)+"|"+
            ATIS(nCondition, 7)+"|"+
            ATIS(nCommandType, 7)+"|"+
            ATIS(nCommandParam, 7)+"|"+
            ATIS(nUseChance, 7)
        );
    }

    AT_Print("--- EOF ---");
}      

#endif