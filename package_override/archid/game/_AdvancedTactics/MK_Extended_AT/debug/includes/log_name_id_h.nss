#ifndef MK_LOG_CREATURE_ID
#defsym MK_LOG_CREATURE_ID

string MK_LogCreatureId(object oCreature)
{
 int nNameStrref = GetNameStrref(oCreature);

 string sMsg;
 sMsg = sMsg + GetTlkTableString(nNameStrref) + ";"; // oObjectToLog name
 sMsg = sMsg + ObjectToString(oCreature) + ";" ; // oObjectToLog id
 return sMsg;
}   

#endif