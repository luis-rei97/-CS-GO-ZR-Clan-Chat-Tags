# [CS:GO ZR] Chat and Clan Tags

This is a simple plugin which set Tags on Scoreboard, and in Chat, depending of which team you are representing in the Zombie Reloaded game.

# Tags Available

Currently, it has the following Tags:

* Human;
* Mother Zombie;
* Zombie;
* Leader (Optional);
* Commander (Optional);

## Requirements

* [Sourcemod](https://www.sourcemod.net/) ;
* [Zombie Reloaded](https://forums.alliedmods.net/showthread.php?t=277597);
* [Simple Chat Processor](https://forums.alliedmods.net/showpost.php?p=2629088&postcount=413);

### Optional

These are totally optional, and you can decide which of this you want to choose.
It will activate if you have one of these plugins on the server:

* [Leader](https://forums.alliedmods.net/showthread.php?p=2559021);
* [Commander](https://forums.alliedmods.net/showthread.php?p=2368827);

## Installation:

* Drag the file named *zr_tags.smx* to **addons/sourcemod/plugins**;
* Load the plugin, or change the map;
* Edit the cvars as you like in, *zr_chat_clan_tags.cfg*, located in **cfg/sourcemod**;


## ConVars:
* **zr_chattags_enable** (Default: 1) - Enables the Chat Tags for Zombies, Mother Zombies, Humans, and possibly, Leader/Commander;
* **zr_clantags_enable** (Default: 1) - Enables the Clan Tags for Zombies, Mother Zombies, Humans, and possibly, Leader/Commander;
* **zr_human_prefix** (Default: "[Human]") - Prefix to set on players which are Humans;
* **zr_leader_prefix** (Default: "[Leader]") - Prefix to set on players which are Leaders/Commanders;
* **zr_motherzombie_prefix** (Default: "[MotherZombie]") - Prefix to set on players which are Mother Zombies;
* **zr_zombie_prefix** (Default: "[Zombie]") - Prefix to set on players which are Zombies;


## Screenshots

* ![ExampleOfChatTag](https://i.imgur.com/0bQty5f.png "Example of Chat Tag")
* ![ExampleOfClanTag](https://i.imgur.com/aQihW4a.png "Example of Clan Tag")

# To-Do List

* Possibility to change the color by CVAR;
* Possibility to set a tag if he is a "General"/Commander - **DONE**;

# Changelog

* **1.0** - Release;
* **1.1** - Inverted the CVAR initial values (before, the plugin started with disabled options), and added the CFG file in the repository;
* **1.2** - Added the possibility to have tags for the ***Leader*** or ***Commander*** (depending of the plugin you chose and if they have in the server);
* **1.3** - Added 4 CVARs to change all the prefixes (Human, MotherZombie, Zombie and Leader/Commander);
