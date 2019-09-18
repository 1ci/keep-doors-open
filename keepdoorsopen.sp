#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.00"

#pragma semicolon 1 // Warn me if I missed a semicolon from now on

public Plugin:myinfo =
{
	name = "Kepp Doors Open!",
	author = "ici",
	version = PLUGIN_VERSION,
	url = "http://steamcommunity.com/id/1ci"
};

public OnPluginStart()
{
	// Plugin version
	CreateConVar("sm_keepdoorsopen_version", PLUGIN_VERSION, "Keep Doors Open Version",
		FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
}

public OnMapStart()
{
	// m_eSpawnPosition (spawnpos)
	// m_flWait (wait)
	// InputOpen (Offset 0) (Input)(0 Bytes) - Open
	// InputLock (Offset 0) (Input)(0 Bytes) - Lock
	// m_bLocked (Offset 996) (Save)(1 Bytes)
	// m_spawnflags (Offset 252) (Save|Key)(4 Bytes) - spawnflags (spawnflags)
	
	CreateTimer(5.0, Timer_Perform, INVALID_HANDLE, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Timer_Perform(Handle:timer)
{
	new ent = -1;
	while ((ent = FindEntityByClassname(ent, "func_door_rotating")) != -1)
	{
		DispatchKeyValue(ent, "spawnpos", "1"); // Make it start Open by default
		DispatchKeyValue(ent, "spawnflags", "1"); // The same as above, also don't let clients open it
		
		//Amount of time, in seconds, after the door has opened before it closes. Once it has closed, it can be used again. If the value is set to -1, the door never closes itself.
		DispatchKeyValue(ent, "wait", "-1"); // Don't let it close
		
		AcceptEntityInput(ent, "Open"); // Open the door
		AcceptEntityInput(ent, "Lock"); // Lock it so that it stays open and clients can't use it
	}
	// return value doesn't matter
}

