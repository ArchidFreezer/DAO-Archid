#ifndef MK_SET_COMMAND_TIMEOUT_H
#defsym MK_SET_COMMAND_TIMEOUT_H

command MK_SetCommandTimeout(command cCommand, float fTimeout)
{
    cCommand = SetCommandFloat(cCommand, fTimeout, 5); 
    return cCommand;
}  

#endif