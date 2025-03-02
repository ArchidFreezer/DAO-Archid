#ifndef MK_PRINT_TO_LOG_H
#defsym MK_PRINT_TO_LOG_H
//==============================================================================
//                              INCLUDES
//==============================================================================
//none

//==============================================================================
//                          DECLARATIONS
//==============================================================================
void MK_Error(int nTacticID, string sFunctionName, string sMsg);
void MK_PrintToLog(string sMessage, object oOwner = OBJECT_SELF);
void _MK_PrintToLogCreatures(object[] arCreature, string sTitle = "arCreature = ", int nSplit = 0);
void _MK_PrintToLogIntegers(int[] arIntegers, string sTitle = "arIntegers = ", int nSplit = 0);

//==============================================================================
//                          DEFINITIONS
//==============================================================================
void MK_Error(int nTacticID, string sFunctionName, string sMsg)
{
    string sTacticID;
    //if (nTacticID < 0)
    //    sTacticID = "(?)";
    //else
        sTacticID = "(" + IntToString(nTacticID) + ") : ";

    string sError = sTacticID + " ERROR " + sFunctionName + " : " + sMsg;

    DisplayFloatyMessage(OBJECT_SELF, sError, FLOATY_MESSAGE, 0xFF0000, 5.0);
    MK_PrintToLog(sError);
}

void MK_PrintToLog(string sMessage, object oOwner = OBJECT_SELF)
{
 int nNameStrref = GetNameStrref(oOwner);

 string sMsg;
 sMsg = sMsg + " [ " + IntToString(GetLowResTimer()) + " ] ";
 sMsg = sMsg + GetTlkTableString(nNameStrref) + " [ "; // oObjectToLog name
 sMsg = sMsg + ObjectToString(oOwner) + " ] " ; // oObjectToLog id
 sMsg = sMsg + sMessage;
 PrintToLog(sMsg);
}

void _MK_PrintToLogCreatures(object[] arCreature, string sTitle = "arCreature = ", int nSplit = 0)
{
    int i;
    int nSize = GetArraySize(arCreature);
    string sMsg = "";

    for (i = 0; i < nSize; i++)
    {
        int nNameStrref = GetNameStrref(arCreature[i]);
        sMsg += GetTlkTableString(nNameStrref);

        if (nSplit > 0 && (i+1)%nSplit == 0)
        {
            sMsg = sTitle + "[ " + sMsg +  "]";
            MK_PrintToLog(sMsg);
            sMsg = "";
        }
        else if(i+1 < nSize)
        {
            sMsg += ", ";
        }
    }

    if (GetStringLength(sMsg) > 0 || nSize == 0)
    {
        sMsg = sTitle + "[ " + sMsg +  "]";
        MK_PrintToLog(sMsg);
    }
}

void _MK_PrintToLogIntegers(int[] arIntegers, string sTitle = "arIntegers = ", int nSplit = 0)
{
    int i;
    int nSize = GetArraySize(arIntegers);
    string sMsg = "";

    for (i = 0; i < nSize; i++)
    {
        sMsg += IntToString(arIntegers[i]);

        if (nSplit > 0 && (i+1)%nSplit == 0)
        {
            sMsg = sTitle + "[ " + sMsg +  "]";
            MK_PrintToLog(sMsg);
            sMsg = "";
        }
        else if(i+1 < nSize)
        {
            sMsg += ", ";
        }
    }

    if (GetStringLength(sMsg) > 0 || nSize == 0)
    {
        sMsg = sTitle + "[ " + sMsg +  "]";
        MK_PrintToLog(sMsg);
    }
}
#endif