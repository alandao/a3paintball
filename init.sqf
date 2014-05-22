waitUntil {!isNull player};

enableSentences false;
enableSaving [false, false];

//MP function dump

//credit to BangaBob
//freezes people
fnc_simulationMP = {
	private ["_object","_simStatus"];
	_object = (_this select 0);
	_simStatus =(_this select 1);
	
	_object  enableSimulation _simStatus; 
};

//respawns, freezes player, give him his kit.
fnc_resetMP = {
	setPlayerRespawnTime -1;
	waitUntil{ alive player };
	setPlayerRespawnTime 99999999;
	player cameraEffect ["terminate","back"];
	player setDamage 0;
	removeAllWeapons player;
	player addMagazines["30Rnd_556x45_Stanag",3];
	player addWeapon "arifle_TRG20_F";
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
	playMusic "Gogo";
};

fnc_soundPointEast = {
	playMusic "pointEast";
};

fnc_soundPointWest = {
	playMusic "pointWest";
};

fnc_soundThree = {
	playMusic "Three";
};

fnc_soundTwo = {
	playMusic "Two";
};

fnc_soundOne = {
	playMusic "One";
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
	//for JIP
	if (isNil "gameStart") then
	{
		gameStart = False;
	};
	_null = execVM "mission_client.sqf";
};



