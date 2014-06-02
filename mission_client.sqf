
//will get updated by publicvariable
//BOILERPLATE CODE INBOUND
if (isNil "countWest") then
{
	countWest = 0;
};
if (isNil "countEast") then
{
	countEast = 0;
};
if (isNil "eastWins") then
{
	eastWins = 0;
};
if (isNil "westWins") then
{
	westWins = 0;
};
if (isNil "flagBearer") then
{
	flagBearer = nil;
};
if (isNil "flagTakenOnce") then
{
	flagTakenOnce = false;
};

if (isNil "posFlagWhite") then
{
	posFlagWhite = [0,0,0];
};

if (isNil "posFlagWest") then
{
	posFlagWest = [0,0,0];
};

if (isNil "posFlagEast") then
{
	posFlagEast = [0,0,0];
};
if (isNil "westRound") then
{
	westRound = false;
};
if (isNil "eastRound") then
{
	eastRound = false;
};
if (isNil "roundTime") then
{
	roundTime = 0;
};
if (isNil "roundDraw") then
{
	roundDraw = false;
};
if (isNil "gameStart") then
{
	gameStart = true;
};
//end of boilerplate code

//for JIP
if (isNull player) then
{
	waitUntil {alive player;};
	player enableSimulation false;
	cutText ["A round is still in progress, please wait...","BLACK"];
	waitUntil { sleep 0.1; !gameStart };
};

//removes bodies on respawn
_null = player addMPEventHandler ["MPRespawn", {deleteVehicle (_this select 1)}];



//hud
[] spawn {
	while {true} do
	{
		cutRsc["PAINTBALL_HUD","PLAIN"];
		
		//time
		_roundTimeArray = [(roundTime/60), "ARRAY"] call BIS_fnc_timetostring;
		_roundTimeFormatted = format ["%1:%2", _roundTimeArray select 0, _roundTimeArray select 1];
		((uiNamespace getVariable "paint_hud") displayCtrl 1003) ctrlSetText _roundTimeFormatted;
		
		//west alive
		_westAlive = format["West alive: %1", countWest];
		//east alive
		_eastAlive = format["East alive: %1", countEast];
		((uiNamespace getVariable "paint_hud") displayCtrl 1000) ctrlSetText _westAlive;
		((uiNamespace getVariable "paint_hud") displayCtrl 1002) ctrlSetText _eastAlive;
		
		_scoreWest = format["%1", westWins];
		_scoreEast = format["%1", eastWins];
		//set score
		((uiNamespace getVariable "paint_hud") displayCtrl 1004) ctrlSetText _scoreWest;
		((uiNamespace getVariable "paint_hud") displayCtrl 1005) ctrlSetText _scoreEast;
		
		//hud hint
	
		if (!(isNil "flagBearer") and {(alive flagBearer)}) then
		{
			if (side flagBearer == west) then
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "The West has the flag.";
			} else
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1001) ctrlSetText "The East has the flag.";
			};
		
		} else
		{
			if (flagTakenOnce) then
			{
				if (posFlagWhite distance posFlagWest < posFlagWhite distance posFlagEast) then
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
			case (westRound):
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "One point for the West!";
			};
			case (eastRound):
			{
				((uiNamespace getVariable "paint_hud") displayCtrl 1006) ctrlSetText "One point for the East!";
			};
			case (roundDraw):
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
	

};
