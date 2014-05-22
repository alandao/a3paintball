playerList = [];

//when player connects.
_playerConnects = ["id1", "onPlayerConnected", {

	playerList set [count playerList, _uid];


}] call BIS_fnc_addStackedEventHandler;

//when player disconnects.
_playerDisconnects = ["id2", "onPlayerDisconnected", {

	playerList = playerList - [_uid];

}] call BIS_fnc_addStackedEventHandler;

if (!isDedicated) then
{
	_null = execVM "mission_client.sqf";

};


//function, takes type id and returns player. Thanks Sickboy
host_fnc_findPlayer = {
   private ["_player"];
   _player = objNull;
   {
     if (getPlayerUID _x == _this) exitWith {
          _player = _x;
     };
   } forEach playableUnits; // could also try playableUnits instead of allUnits.
   _player; // return _player
};





bestOf = 7;
westWins = 0;
eastWins = 0;
gameStart = false;
flagBearer = nil;

flagWhite = "Flag_Green_F" createVehicle [23468.9,18740.4,0];
flagWest = 	"Flag_US_F" createVehicle [23468.9,18716.7,0];
flagEast = "Flag_CSAT_F" createVehicle [23468.8,18766.9,0];


_null = execVM "resetRound.sqf";


//MISSION LOGIC
[] spawn
{
	while {true} do
	{
		if (gameStart) then
		{
			
			//if flagbearer died, detach flag and let it be available again. lazy evaluation magic here
			if (!(isNil "flagBearer") and {!(alive flagBearer)}) then
			{
				flagBearer = nil;
				detach flagWhite;
				flagWhite setPos [(getPos flagWhite) select 0, (getPos flagWhite) select 1,0];
			};
			
			
			//WIN CONDITIONS

			//if all west paintballers died.
			if ((({alive _x} count paintBallersWest) == 0) and (count paintBallersWest > 0)) then
			{
				eastRound = true;
				eastWins = eastWins + 1;
				
				//plays music
				[nil, "fnc_soundPointEast"] call BIS_fnc_MP;
				
				sleep 10;
				_null = execVM "resetRound.sqf";

			};
			
			//if all east paintballers died
			if ((({alive _x} count paintBallersEast) == 0) and (count paintBallersEast > 0)) then
			{
				westRound = true;
				westWins = westWins + 1;
				
				//plays music
				[nil, "fnc_soundPointWest"] call BIS_fnc_MP;
				
				sleep 10;
				_null = execVM "resetRound.sqf";

			};
			
			if (!(isNil "flagBearer") and {(side flagBearer == WEST)} and {flagWhite distance flagWest < 4}) then
			{
				westRound = true;
				westWins = westWins + 1;
				
				//plays music
				[nil, "fnc_soundPointWest"] call BIS_fnc_MP;
				
				sleep 10;
				_null = execVM "resetRound.sqf";				
			};
			
			if (!(isNil "flagBearer") and {(side flagBearer == EAST)} and {flagWhite distance flagEast < 4}) then
			{
				eastRound = true;
				eastWins = eastWins + 1;
				
				//plays music
				[nil, "fnc_soundPointEast"] call BIS_fnc_MP;
				["cin_eastroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
				sleep 10;
				_null = execVM "resetRound.sqf";				
			};
			
			{
				if ((isNil "flagBearer") and (alive _x) and {(_x distance flagWhite < 4.5)}) then
				{
					flagWhite attachTo [_x, [0,0,0.5]];
					flagBearer = _x;
					[nil, "fnc_soundFlagTaken"] call BIS_fnc_MP;
					if (side flagBearer == WEST) then
					{
						[nil, "fnc_hintWestFlag"] call BIS_fnc_MP;
						
					} else
					{
						[nil, "fnc_hintEastFlag"] call BIS_fnc_MP;
					};
					
				};
			} forEach paintBallers;
		};
		sleep 0.03;
	};
};


