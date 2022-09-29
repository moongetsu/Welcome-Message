
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

ConVar g_cServerName;
ConVar g_cDiscordServer;

public Plugin myinfo = 
{
	name = "Welcome Messages", 
	author = "Markie, Moongetsu", 
	description = "Print text when a player connects on the server.", 
	version = "1.0", 
	url = "https://discord.gg/csgamers"
};

public void OnPluginStart()
{
	g_cServerName = CreateConVar("sm_mmsg_servername", "AWP.CSGAMERS.RO", "Your server IP/DNS.");
	g_cDiscordServer = CreateConVar("sm_mmsg_discordserver", "discord.gg/csgamers", "Link to your Discord Server");

	HookEvent("player_spawn", Event_OnPlayerSpawn);
	
	AutoExecConfig(true, "moongetsu_welcomemessages");
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

	char sServerName[128];
	char sDiscordServer[128];

	g_cServerName.GetString(sServerName, sizeof(sServerName));
	g_cDiscordServer.GetString(sDiscordServer, sizeof(sDiscordServer));
	CPrintToChat(client, "{orchid}-----------------------------------------------------------------------------------------", client);
	CPrintToChat(client, "{orchid}» {default}Hey, {orchid}%N{default}, welcome to {orchid}%s{default}.", client, sServerName);
	CPrintToChat(client, "{orchid}» {default}Before playing please make sure to read our rules by typing {orchid}!rules {default}in the chat!", client);
	CPrintToChat(client, "{orchid}» {default}Don't forget to join our Discord server: {orchid}%s{default}.", sDiscordServer, client);
	CPrintToChat(client, "{orchid}» {default}Have Fun ^^", client);
	CPrintToChat(client, "{orchid}-----------------------------------------------------------------------------------------", client);

	g_bMessagesShown[client] = true;
	
	return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
	g_bMessagesShown[client] = false;
}
