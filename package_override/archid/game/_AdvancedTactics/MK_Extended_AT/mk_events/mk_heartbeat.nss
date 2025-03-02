#include "mk_command_move_to_hero_h"

void main()
{

    command cMoveTo = _MK_AI_MoveToTarget(GetHero(), COMMAND_SUCCESSFUL, 1.5, TRUE);
    int nQueueSize = GetCommandQueueSize(OBJECT_SELF);
    if( nQueueSize < 2 )
        AddCommand(OBJECT_SELF, cMoveTo, FALSE, FALSE, COMMAND_ADDBEHAVIOR_DONTCLEAR );

    DisplayFloatyMessage(OBJECT_SELF, "heartbeat "+IntToString(nQueueSize));


}