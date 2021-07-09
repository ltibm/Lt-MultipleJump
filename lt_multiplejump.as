array<int> Jumpedcound(33);
array<bool> DoJump(33);
int max_jump = 2;
CCVar@ cvar_Enabled;
CCVar@ cvar_MjJump;
CCVar@ cvar_AdminOnly;
CCVar@ cvar_MJOnly;
void PluginInit()
{
	g_Module.ScriptInfo.SetAuthor( "AS Upgraded Lt. (amxx owner: twistedeuphoria)" );
	g_Module.ScriptInfo.SetContactInfo( "https://steamcommunity.com/id/ibmlt/" );
	g_Hooks.RegisterHook( Hooks::Player::PlayerPreThink, @PlPreThink );
	g_Hooks.RegisterHook( Hooks::Player::PlayerPostThink, @PlPostThink );
	g_Hooks.RegisterHook( Hooks::Player::ClientPutInServer, @PlPutinServer );
	g_Hooks.RegisterHook( Hooks::Player::PlayerSpawn, @PlayerSpawn );
	@cvar_Enabled = CCVar("mj_enabled", 1, "Enable or Disable MultiJump", ConCommandFlag::AdminOnly);
	@cvar_MjJump = CCVar("mj_maxjump", 2, "Set maximum multiple jump count", ConCommandFlag::AdminOnly);
	@cvar_AdminOnly = CCVar("mj_adminonly", 0, "Set 1 if only used Admins.", ConCommandFlag::AdminOnly);
	@cvar_MJOnly = CCVar("mj_mjonly", 1, "Set 1 if only used mj values is true", ConCommandFlag::AdminOnly);
}
HookReturnCode PlayerSpawn( CBasePlayer@ pPlayer )
{
	KeyValueBuffer@ nPysc = g_EngineFuncs.GetPhysicsKeyBuffer(pPlayer.edict());
	nPysc.SetValue("smj", "0");
	return HOOK_CONTINUE;
}
bool PluginAccessible(CBasePlayer@ cPlayer)
{
	if(cvar_Enabled.GetInt() == 0) return false;
	if(cPlayer is null || !cPlayer.IsConnected()) return false;
	if(!cPlayer.IsAlive())
	{
		return false;
	}
	if(cvar_AdminOnly.GetInt() == 1)
	{
		if(g_PlayerFuncs.AdminLevel(@cPlayer) <= 0) return false;
	}
	if(cvar_MJOnly.GetInt() == 1)
	{
		KeyValueBuffer@ nPysc = g_EngineFuncs.GetPhysicsKeyBuffer(cPlayer.edict());
		string cVal = nPysc.GetValue("smj");
		if(cVal != "1") return false;
	}
	return true;
}
HookReturnCode PlPreThink(CBasePlayer@ cPlayer, uint& out outvar)
{
	if(!PluginAccessible(cPlayer)) return HOOK_CONTINUE;
	max_jump = cvar_MjJump.GetInt();
	int player_id = cPlayer.entindex();
	int nbut = cPlayer.pev.button;
	int obut = cPlayer.pev.oldbuttons;
	int uflags = cPlayer.pev.flags;
	if((nbut & IN_JUMP) == IN_JUMP && (uflags & FL_ONGROUND != FL_ONGROUND) && (obut & IN_JUMP) != IN_JUMP)
	{
		if(Jumpedcound[player_id] < max_jump)
		{
			DoJump[player_id] = true;
			Jumpedcound[player_id]++;
			return HOOK_CONTINUE;
		}
	}
	if((nbut & IN_JUMP) == IN_JUMP && (uflags & FL_ONGROUND) == FL_ONGROUND)
	{
		Jumpedcound[player_id] = 0;
	}
	return HOOK_CONTINUE;
}
HookReturnCode PlPostThink(CBasePlayer@ cPlayer)
{
	if(!PluginAccessible(cPlayer)) return HOOK_CONTINUE;
	int player_id = cPlayer.entindex();
	if(DoJump[player_id])
	{
		Vector velocity;
		velocity = cPlayer.pev.velocity;
		velocity.z = Math.RandomFloat(265, 285);
		cPlayer.pev.velocity = velocity;
		DoJump[player_id] = false;
	}
	return HOOK_CONTINUE;
}
HookReturnCode PlPutinServer( CBasePlayer@ pPlayer )
{
	int player_id = pPlayer.entindex();
	Jumpedcound[player_id] = 0;
	DoJump[player_id] = false;
	return HOOK_CONTINUE;
}