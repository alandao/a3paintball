
enableSentences false;
enableSaving [false, false];

//MP function dump


//respawns, freezes player, give him his kit.
fnc_resetMP = {
	setPlayerRespawnTime -1;
	waitUntil{ alive player };
	setPlayerRespawnTime 99999999;
	player setDamage 0;
	removeAllWeapons player;
	player unassignItem "NVGoggles";
	player removeItem "NVGoggles";
	player unassignItem "NVGoggles_OPFOR";
	player removeItem "NVGoggles_OPFOR";
	player addMagazines["30Rnd_65x39_caseless_mag_Tracer",4];
	player addWeapon "arifle_MXC_ACO_F";
	if (side player == WEST) then
	{
		player setPos (getMarkerPos "respawn_west");
		player setDir 0;
	};
	if (side player == EAST) then
	{
		player setPos (getMarkerPos "respawn_east");
		player setDir 180;		
	};
	player enableSimulation false;
};

fnc_startMP = {
	player enableSimulation true;
	player cameraEffect ["terminate","back"];
	playMusic "Gogo";
};


fnc_soundFlagTaken = {
	playSound "FlagTaken";
};

fnc_gameOverWestWon = {
	if (side player == WEST) then
	{
		["The West won!",true,2] call BIS_fnc_endMission;
	};
	if (side player == EAST) then
	{
		["The East won!",false,2] call BIS_fnc_endMission;
	};
};

fnc_gameOverEastWon = {
	if (side player == WEST) then
	{
		["The East won!",false,2] call BIS_fnc_endMission;
	};
	if (side player == EAST) then
	{
		["The East won!",true,2] call BIS_fnc_endMission;
	};
};



if (isServer) then
{
	_null = execVM "mission_server.sqf";

} else {
	_null = execVM "mission_client.sqf";
};



