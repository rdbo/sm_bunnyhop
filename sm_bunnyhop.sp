#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#define WATER_LVL 1

ConVar g_cvBunnyhopEnabled;

public Plugin my_info =
{
    name = "SM Bunnyhop",
    author = "rdbo",
    description = "Enable Auto Bunnyhop",
    version = "1.0",
    url = ""
}

public void OnPluginStart()
{
    PrintToServer("[SM] Admin Auto Bunnyhop plugin has been loaded");
    g_cvBunnyhopEnabled = CreateConVar("sm_bunnyhop_enabled", "1", "Enables the SM Bunnyhop plugin");
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
    if ((buttons & IN_JUMP) && g_cvBunnyhopEnabled.BoolValue && IsClientInGame(client) && IsPlayerAlive(client))
    {
        int flags = GetEntityFlags(client);
        int water = GetEntProp(client, Prop_Data, "m_nWaterLevel");
        
        if (!(flags & FL_ONGROUND) && !(GetEntityMoveType(client) & MOVETYPE_LADDER) && water < WATER_LVL)
        {
            buttons &= ~IN_JUMP;
        }
    }
}
