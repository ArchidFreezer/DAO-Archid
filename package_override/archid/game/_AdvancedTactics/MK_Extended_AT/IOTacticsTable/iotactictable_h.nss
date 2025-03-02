#ifndef IO_TACTIC_TABLE_H
#defsym IO_TACTIC_TABLE_H

const string SEPARATOR = ",";

/** @brief Returns string array of Column Names for m2da for save/load Tactics Table
*@author MkBot
*/
string[] ColumnNamesIO()
{
    string[] arResult;
    int i = 0;
    arResult[i++] = "ID";
    arResult[i++] = "nEnabled";
    arResult[i++] = "nTacticTargetType";
    arResult[i++] = "nTacticCondition";
    arResult[i++] = "nTacticCommand";
    arResult[i++] = "nTacticSubCommand";

    return arResult;
}

/** @brief Returns CSV string with Column Names for m2da for save/load Tactics Table
*@author MkBot
*/
string ColumnNamesIO_CSV()
{
    string sMsg = "";
    string[] arColNames = ColumnNamesIO();
    int size = GetArraySize(arColNames);

    int i;
    for (i = 0; i < size; i++)
        sMsg += SEPARATOR + arColNames[i];

    return sMsg;
}

string ColumnTypesIO_CSV()
{
    string sMsg = "";
    string[] arColNames = ColumnNamesIO();
    int size = GetArraySize(arColNames);

    int i;
    for (i = 0; i < size; i++)
        sMsg += SEPARATOR + "int";

    return sMsg;
}
#endif