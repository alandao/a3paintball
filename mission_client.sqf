//removes bodies on respawn
_null = player addMPEventHandler ["MPRespawn", {deleteVehicle (_this select 1)}];

if (isNil "gameState") then
{
	gameState = [0,0,true,0,false,false,false,false,0,0, false,[0,0,0],[0,0,0],[0,0,0],false,false];
};

//gameState = [westWins,eastWins,gameStart,timeLeft,roundDraw,westRound,eastRound,flagTakenOnce,countWest,countEast,flagBearer, posFlagWhite,posFlagWest,posFlageast];



//for JIP
if (isNull player) then
{
	waitUntil {alive player;};
	player enableSimulation false;
	cutText ["A round is still in progress, please wait...","BLACK"];
	waitUntil { sleep 0.1; !(_gameStart)};
	call fnc_resetMP;
};

//hud
while {true} do
{
	_westWins = gameState select 0;
	_eastWins = gameState select 1;
	_gameStart = gameState select 2;
	_timeLeft = gameState select 3;
	_roundDraw = gameState select 4;
	_westRound = gameState select 5;
	_eastRound = gameState select 6;
	_flagTakenOnce = gameState select 7;
	_countWest = gameState select 8;
	_countEast = gameState select 9;
	_flagBearer = gameState select 10;
	_posFlagWhite = gameState select 11;
	_posFlagWest = gameState select 12;
	_posFlagEast = gameState select 13;
	_westClinch = gameState select 14;
	_eastClinch = gameState select 15;
	
	cutRsc["PAINTBALL_HUD","PLAIN"];

	//clock up top
	_roundTimeArray = [(_timeLeft/60), "ARRAY"] call BIS_fnc_timetostring;
	_roundTimeFormatted = format ["%1:%2", _roundTimeArray select 0, _roundTimeArray select 1];
	((uiNamespace getVariable "paint_hud") displayCtrl 1003) ctrlSetText _roundTimeFormatted;
	
	//west alive on left
	_westAlive = format["West alive: %1", _countWest];
	//east alive on right
	_eastAlive = format["East alive: %1", _countEast];
	((uiNamespace getVariable "paint_hud") displayCtrl 1000) ctrlSetText _westAlive;
	((uiNamespace getVariable "paint_hud") displayCtrl 1002) ctrlSetText _eastAlive;
	
	//score below clock
	_scoreWest = format["%1", _westWins];
	_scoreEast = format["%1", _eastWins];
	((uiNamespace getVariable "paint_hud") displayCtrl 1004) ctrlSetText _scoreWest;
	((uiNamespace getVariable "paint_hud") displayCtrl 1005) ctrlSetText _scoreEast;
	
	//for status display up top
	//lazy evaluation magic
	if ((typeName _flagBearer != "BOOL") and {(alive _flagBearer)}) then
	{
		if (side _flagBearer == west) then
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "The West has the flag.";
		} else
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "The East has the flag.";
		};
	
	} else
	{
		if (_flagTakenOnce) then
		{
			if (_posFlagWhite distance _posFlagWest < _posFlagWhite distance _posFlagEast) then
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "Flag is closer to the West side.";
			} else
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "Flag is closer to the East side.";
			};
		} else
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "";
		};
		
	};
	
	switch (true) do {
		case (_westClinch):
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "Game over. The West won!";
		};
		case (_eastClinch):
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "Game over. The East won!";
		};
		case (_westRound):
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "One point for the West!";
		};
		case (_eastRound):
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "One point for the East!";
		};
		case (_roundDraw):
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "No one gets a point! Round draw!";
		};
		default
		{
			((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "";
		}
	};

	
	sleep 0.5;
};



