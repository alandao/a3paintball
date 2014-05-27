//will get updated by publicvariable
countWest = 0;
countEast = 0;

//removes bodies on respawn
_null = player addMPEventHandler ["MPRespawn", {deleteVehicle (_this select 1)}];

//for JIP
if (isNull player) then
{
	waitUntil { !(isNull player) };
	startLoadingScreen ["The round is still in progress, it'll be a minute..."];
	if (isNil "gameStart") then
	{
		gameStart = true;
	};
	waitUntil { sleep 0.1; !gameStart };
	endLoadingScreen;
};


//hud
[] spawn {
	while {true} do
	{
		cutRsc["PAINTBALL_HUD","PLAIN"];
		//west alive
		_westAlive = format["West alive: %1", countWest];
		//east alive
		_eastAlive = format["East alive: %1", countEast];
		((uiNamespace getVariable "paint_hud") displayCtrl 1000) ctrlSetText _westAlive;
		((uiNamespace getVariable "paint_hud") displayCtrl 1003) ctrlSetText _eastAlive;
		
		sleep 0.5;
	};


};
