#ifndef MK_COMMAND_INVALID_H
#defsym MK_COMMAND_INVALID_H   
#include "ai_constants_h" 

/** @brief Returns command of type AI_COMMAND_INVALID
* Invalid Command is required to indicate failure of functions that return command object.
* @author MkBot
**/
command MK_CommandInvalid()
{
 command cInvalid;
 return cInvalid;
}

/** @brief Is command object valid?
*
* This function DOES NOT check cooldown, mana/stamina, target etc.
* For such a purpose use _AI_IsCommandValid() instead.
*
* @returns True/False
* @author Function Author
**/  
int MK_IsCommandValid(command cCommand)
{
    return GetCommandType(cCommand) != AI_COMMAND_INVALID;
}

//void main(){MK_IsCommandValid(MK_CommandInvalid());}
#endif
