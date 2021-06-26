#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

#define WATER_LVL 1

ConVar g_cvEnabled;
ConVar g_cvAutoBhop;
ConVar g_cvMaxSpeed;

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
    g_cvEnabled = CreateConVar("sm_bunnyhop_enabled", "1", "Enable the SM Bunnyhop plugin");
    g_cvAutoBhop = CreateConVar("sm_bunnyhop_auto", "1", "Enable Auto Bhop");
    g_cvMaxSpeed = CreateConVar("sm_bunnyhop_maxspeed", "0", "Set Max Speed (0 = Unlimited)");
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
    if (g_cvEnabled.BoolValue && IsClientInGame(client) && IsPlayerAlive(client))
    {
        int flags = GetEntityFlags(client);
        
        if (!(flags & FL_ONGROUND))
        {
            int water = GetEntProp(client, Prop_Data, "m_nWaterLevel");
            
            if (g_cvAutoBhop.BoolValue && (buttons & IN_JUMP) && !(GetEntityMoveType(client) & MOVETYPE_LADDER) && water <= WATER_LVL)
                buttons &= ~IN_JUMP;
        }
        
        else if (g_cvMaxSpeed.FloatValue != 0.0)
        {
            float velocity[3];
            GetEntPropVector(client, Prop_Data, "m_vecVelocity", velocity);
            float old_z = velocity[2];
            velocity[2] = 0.0;
            
            float speed = GetVectorLength(velocity);
            
            if (speed > g_cvMaxSpeed.FloatValue)
            {
                NormalizeVector(velocity, velocity);
                ScaleVector(velocity, g_cvMaxSpeed.FloatValue);
                velocity[2] = old_z;
                TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velocity);
            }
        }
    }
}
