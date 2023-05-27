
// ███╗░░░███╗░█████╗░░█████╗░███╗░░██╗░██████╗░███████╗████████╗░██████╗██╗░░░██╗
// ████╗░████║██╔══██╗██╔══██╗████╗░██║██╔════╝░██╔════╝╚══██╔══╝██╔════╝██║░░░██║
// ██╔████╔██║██║░░██║██║░░██║██╔██╗██║██║░░██╗░█████╗░░░░░██║░░░╚█████╗░██║░░░██║
// ██║╚██╔╝██║██║░░██║██║░░██║██║╚████║██║░░╚██╗██╔══╝░░░░░██║░░░░╚═══██╗██║░░░██║
// ██║░╚═╝░██║╚█████╔╝╚█████╔╝██║░╚███║╚██████╔╝███████╗░░░██║░░░██████╔╝╚██████╔╝
// ╚═╝░░░░░╚═╝░╚════╝░░╚════╝░╚═╝░░╚══╝░╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░░╚═════╝░

//Sourcemod Includes
#include <sourcemod>
#include <multicolors>

//Pragma
#pragma semicolon 1
#pragma newdecls required

//Globals
bool g_bMessagesShown[MAXPLAYERS + 1];

public Plugin myinfo = 
{
	name = "Welcome Messages", 
	author = "Markie, Moongetsu", 
	description = "Print text when a player connects on the server.", 
	version = "2.0", 
	url = "https://discord.gg/moon"
};

public void OnPluginStart()
{
	HookEvent("player_spawn", Event_OnPlayerSpawn);
	
	LoadTranslations("moon_welcome.phrases");
}

public void OnMapStart()
{
	for (int i = 1; i <= MaxClients; i++)
	{
		g_bMessagesShown[i] = false;
	}
}

public void Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (client == 0 || IsFakeClient(client))
	{
		return;
	}
	
	CreateTimer(0.2, Timer_DelaySpawn, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_DelaySpawn(Handle timer, any data)
{
	int client = GetClientOfUserId(data);
	
	if (client == 0 || !IsPlayerAlive(client) || g_bMessagesShown[client])
	{
		return Plugin_Continue;
	}

	CPrintToChat(client, "-----------------------------------------------------------------------------------------");
	CPrintToChat(client, "%t", "Message 1", client);
	CPrintToChat(client, "%t", "Message 2");
	CPrintToChat(client, "%t", "Message 3");
	CPrintToChat(client, "%t", "Message 4");
	CPrintToChat(client, "-----------------------------------------------------------------------------------------");

	g_bMessagesShown[client] = true;
	
	return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
	g_bMessagesShown[client] = false;
}
