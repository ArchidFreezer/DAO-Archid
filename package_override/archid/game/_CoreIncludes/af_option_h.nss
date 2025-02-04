/*
* Set of functions for reading the archid mod options table
*/

const int AF_TABLE_OPTIONS = 6610003;
const string AF_OPTIONS_VALUE_COL = "Value";
const string AF_OPTIONS_LABEL_COL = "Option";

/**
* @brief checks if an option is enabled
*
* Reads the archid options m2da table and returns whether an option is enabled or not.
*
* @param nOption   The option row number to check
* @return TRUE if the option is enabled; FALSE otherwise
*/
int AF_IsOptionEnabled(int nOption) {
    return (GetM2DAInt(AF_TABLE_OPTIONS, AF_OPTIONS_VALUE_COL, nOption) > 0);
}

/**
* @brief gets an option value
*
* Reads the archid options m2da table and returns the value of an option.
*
* @param nOption   The option row number to check
* @return value of the option
*/
int AF_GetOptionValue(int nOption) {
    return GetM2DAInt(AF_TABLE_OPTIONS, AF_OPTIONS_VALUE_COL, nOption);
}

/**
* @brief gets the label associated with an option
*
* Reads the archid options m2da table and returns the label associated with an option.
*
* @param nOption   The option row number to check
* @return value of the Optyion column
*/
string AF_GetOptionLabel(int nOption) {
    return GetM2DAInt(AF_TABLE_OPTIONS, AF_OPTIONS_LABEL_COL, nOption);
}