#include "ai_main_h_2"
#include "iotactictable_h"

void main()
{    
    int nNameStrref = GetNameStrref(OBJECT_SELF);
    string sName = GetTlkTableString(nNameStrref);
    string sOpenTag = "<Tactics Name=" + sName + ">";
    string sCloseTag = "</Tactics>";          
    
    PrintToLog(sOpenTag);
    PrintToLog(ColumnNamesIO_CSV());
    PrintToLog(ColumnTypesIO_CSV());

    int i;
    int nTacticsNum = GetNumTactics(OBJECT_SELF);
    for (i = 1; i <= nTacticsNum; i++)
    {
        int nTacticID = i;
        int nEnabled  = IsTacticEnabled(OBJECT_SELF, i);
        int nTacticTargetType = GetTacticTargetType(OBJECT_SELF, i);
        int nTacticCondition  = GetTacticCondition(OBJECT_SELF, i);
        int nTacticCommand    = GetTacticCommand(OBJECT_SELF, i);
        int nTacticSubCommand = GetTacticCommandParam(OBJECT_SELF, i);

        string sMsg;
        sMsg  = SEPARATOR + IntToString(nTacticID);
        sMsg += SEPARATOR + IntToString(nEnabled);
        sMsg += SEPARATOR + IntToString(nTacticTargetType);
        sMsg += SEPARATOR + IntToString(nTacticCondition);
        sMsg += SEPARATOR + IntToString(nTacticCommand);
        sMsg += SEPARATOR + IntToString(nTacticSubCommand);

        PrintToLog(sMsg);
    }

    PrintToLog(sCloseTag);
}
