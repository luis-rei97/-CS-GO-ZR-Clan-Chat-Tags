#include <sourcemod>
#include <cstrike>
#include <zombiereloaded>
#include <scp>

#undef REQUIRE_PLUGIN
#include <leader>
#include <zrcommander>
#define REQUIRE_PLUGIN

#pragma newdecls required

ConVar g_CVAR_EnableChatTags;
ConVar g_CVAR_EnableClanTags;
ConVar g_CVAR_MotherZombie_Prefix;
ConVar g_CVAR_Zombie_Prefix;
ConVar g_CVAR_Human_Prefix;
ConVar g_CVAR_Leader_Prefix;

int g_EnableChatTags;
int g_EnableClanTags;
char g_MotherZombie_Prefix[20];
char g_Zombie_Prefix[20];
char g_Human_Prefix[20];
char g_Leader_Prefix[20];

bool MotherZombie[MAXPLAYERS+1];

bool leader = false;
bool commander = false;

public Plugin myinfo =
{
	name = "[CS:GO ZR] Tags for Zombie Reloaded",
	description = "Chat and Clan Tags for Zombie Reloaded",
	author = "Hallucinogenic Troll",
	version = "1.3",
	url = "PTFun.net"
};

public void OnPluginStart()
{
	HookEvent("round_start", Event_RoundStart);
	
	g_CVAR_EnableChatTags = CreateConVar("zr_chattags_enable", "1", "Enables the Chat Tags for Zombies, Mother Zombies, Humans, and possibly, Leader/Commander", _, true, 0.0, true, 1.0);
	g_CVAR_EnableClanTags = CreateConVar("zr_clantags_enable", "1", "Enables the Clan Tags for Zombies, Mother Zombies, Humans, and possibly, Leader/Commander", _, true, 0.0, true, 1.0);
	g_CVAR_MotherZombie_Prefix = CreateConVar("zr_motherzombie_prefix", "[MotherZombie]", "Prefix to set on players which are Mother Zombies");
	g_CVAR_Zombie_Prefix = CreateConVar("zr_zombie_prefix", "[Zombie]", "Prefix to set on players which are Zombies");
	g_CVAR_Human_Prefix = CreateConVar("zr_human_prefix", "[Human]", "Prefix to set on players which are Humans");
	g_CVAR_Leader_Prefix = CreateConVar("zr_leader_prefix", "[Leader]", "Prefix to set on players which are Leaders or Commanders");
	AutoExecConfig(true, "zr_chat_clan_tags");
}

public void OnConfigsExecuted()
{
	g_EnableChatTags = g_CVAR_EnableChatTags.IntValue;
	g_EnableClanTags = g_CVAR_EnableClanTags.IntValue;
	
	if(g_EnableClanTags)
		CreateTimer(0.1, Timer_CheckDelay, _, TIMER_REPEAT);
		
	g_CVAR_MotherZombie_Prefix.GetString(g_MotherZombie_Prefix, sizeof(g_MotherZombie_Prefix));
	g_CVAR_Zombie_Prefix.GetString(g_Zombie_Prefix, sizeof(g_Zombie_Prefix));
	g_CVAR_Human_Prefix.GetString(g_Human_Prefix, sizeof(g_Human_Prefix));
	g_CVAR_Leader_Prefix.GetString(g_Leader_Prefix, sizeof(g_Leader_Prefix));
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	MarkNativeAsOptional("Leader_CurrentLeader");
	MarkNativeAsOptional("zrc_is");
	return APLRes_Success;
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "leader"))
		leader = false;
		
	if(StrEqual(name, "zrcommander"))
		commander = false;
}
 
public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "leader"))
		leader = true;
		
	if(StrEqual(name, "zrcommander"))
		commander = true;
}

public void OnClientPostAdminCheck(int client)
{
	if(!IsValidClient(client))
		return;
	
	MotherZombie[client] = false;
}

public Action Timer_CheckDelay(Handle timer)
{
	if(g_EnableClanTags)	
		for (int i = 0; i < MaxClients; i++)
			if(IsValidClient(i))
				CheckTag(i);
}

public void CheckTag(int client)
{
	if(IsValidClient(client) && IsPlayerAlive(client))
	{
		char tag[40];
		if(ZR_IsClientHuman(client))
		{
			if(leader && Leader_CurrentLeader() == client)
				Format(tag, sizeof(tag), "%s ", g_Leader_Prefix);	
			else if(commander && zrc_is(client))
				Format(tag, sizeof(tag), "%s ", g_Leader_Prefix);			
			else		
				Format(tag, sizeof(tag), "%s ", g_Human_Prefix);
		}
		else if(ZR_IsClientZombie(client))
		{
			if(MotherZombie[client])
				Format(tag, sizeof(tag), "%s ", g_MotherZombie_Prefix)
			else	
				Format(tag, sizeof(tag), "%s ", g_Zombie_Prefix);
		}
		
		CS_SetClientClanTag(client, tag);
	}
}

public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	for(int client = 0; client < MaxClients; client++)
		MotherZombie[client] = false;
}

public int ZR_OnClientInfected(int client, int attacker, bool motherInfect, bool respawnOverride, bool respawn)
{
	if(IsValidClient(client))
	{
		if(motherInfect)
			MotherZombie[client] = true;
		else
			MotherZombie[client] = false;
	}
}

public Action OnChatMessage(int &client, Handle hRecipients, char[] name, char[] message)
{
	if(g_EnableChatTags)
	{
		if(IsValidClient(client) && IsPlayerAlive(client))
		{
			char tag[40];
			if(ZR_IsClientHuman(client))
			{
				if(leader && Leader_CurrentLeader() == client)
					Format(tag, sizeof(tag), "\x0E%s\x01", g_Leader_Prefix);
				else if(commander && zrc_is(client))
					Format(tag, sizeof(tag), "\x0E%s\x01", g_Leader_Prefix);				
				else
					Format(tag, sizeof(tag), "\x0B%s\x01", g_Human_Prefix);
			}
			else if(ZR_IsClientZombie(client))
			{
				if(MotherZombie[client])
					Format(tag, sizeof(tag), "\x07%s\x01", g_MotherZombie_Prefix)
				else	
					Format(tag, sizeof(tag), "\x02%s\x01", g_Zombie_Prefix);
			}
			else
				return Plugin_Continue;
			
			Format(name, MAXLENGTH_MESSAGE, " %s %s", tag, name);
			return Plugin_Changed;
		}
	}
	
	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client))
		return true;
	
	return false;
}
