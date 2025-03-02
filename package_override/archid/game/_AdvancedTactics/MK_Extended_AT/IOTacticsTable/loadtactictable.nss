#include "ai_main_h_2"
#include "iotactictable_h"

void main()
{  
    string sM2DA = GetLocalString(GetModule(),"RUNSCRIPT_VAR");    
    string[] arColNames = ColumnNamesIO();
    
    int size = GetM2DARows(-1, sM2DA);
    
    int i;
    for (i = 0; i < size; i++)
    {
        int nTacticID   = GetM2DAInt(-1, arColNames[0], i, sM2DA);
        int nEnabled    = GetM2DAInt(-1, arColNames[1], i, sM2DA);        
        int nTargetType = GetM2DAInt(-1, arColNames[2], i, sM2DA);
        int nCondition  = GetM2DAInt(-1, arColNames[3], i, sM2DA);
        int nCommand    = GetM2DAInt(-1, arColNames[4], i, sM2DA);
        int nSubCommand = GetM2DAInt(-1, arColNames[5], i, sM2DA);
        SetTacticEntry(OBJECT_SELF, nTacticID, nEnabled, nTargetType, nCondition, nCommand, nSubCommand); 
    }
}