
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
	player addMagazines["30Rnd_65x39_caseless_mag_Tracer",3];
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

fnc_hintEastFlag = {
	hint "East side has the flag!";
	sleep 5;
	hint "";
};

fnc_hintWestFlag = {
	hint "West side has the flag!";
	sleep 5;
	hint "";
};

if (isServer) then
{
	_null = execVM "mission_server.sqf";

} else {
	_null = execVM "mission_client.sqf";
};



