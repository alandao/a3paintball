playerList = [];
botsEnabled = true;
botList = [];
groupWest = createGroup west;
groupEast = createGroup east;

flagTakenOnce = false;

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

respawnWest = getMarkerPos "respawn_west";
respawnEast = getMarkerPos "respawn_east";




flagWhite = createVehicle ["Flag_Green_F", [0,0,0], [], 0, "CAN_COLLIDE"]; 
flagWest = 	 createVehicle ["Flag_US_F",[respawnWest select 0, (respawnWest select 1) + 5, respawnWest select 2],[],0,"CAN_COLLIDE"];
flagEast =  createVehicle ["Flag_CSAT_F",[respawnEast select 0, (respawnEast select 1) - 5, respawnEast select 2],[],0, "CAN_COLLIDE"];


_null = execVM "resetRound.sqf";



//200 is how big our map is going to be
objectsToMirror = [];

waitUntil{ ({alive _x} count playableUnits) == (count playerList) };


//mirror the objects on the other side of the flag
{
	[_x, flagWhite] call paintball_fnc_mirrorVehicle;
} forEach objectsToMirror;


//MISSION LOGIC
[] spawn
{
	while {true} do
	{
		//get amount for player HUD
		countWest = {alive _x} count paintBallersWest;
		countEast = {alive _x} count paintBallersEast;
		
		publicVariable "countWest";
		publicVariable "countEast";
		
		if (gameStart) then
		{
			
			//if flagbearer died, detach flag and let it be available again. lazy evaluation magic here
			if (!(isNil "flagBearer") and {!(alive flagBearer)}) then
			{
				flagBearer = nil;
				detach flagWhite;
				flagWhite setPos [(getPos flagWhite) select 0, (getPos flagWhite) select 1,0];
			};
			
			//if the flag hasn't been taken yet, paintballers will pick it up.
			{
				if ((isNil "flagBearer") and (alive _x) and {(_x distance flagWhite < 4.5)}) then
				{
					flagTakenOnce = true;
					flagWhite attachTo [_x, [0,0,0.5]];
					flagBearer = _x;
					[nil, "fnc_soundFlagTaken"] spawn BIS_fnc_MP;
					if (side flagBearer == WEST) then
					{
						[nil, "fnc_hintWestFlag"] spawn BIS_fnc_MP;
						
					} else
					{
						[nil, "fnc_hintEastFlag"] spawn BIS_fnc_MP;
					};
					
				};
			} forEach paintBallers;
			
			//WIN CONDITIONS
			//there is no elseif in sqf, gotta use switch case syntax instead...
			switch (true) do {
				//if all west paintballers died.
				case ((({alive _x} count paintBallersWest) == 0) and (count paintBallersWest > 0)): 
				{
					gameStart = false;
					publicVariable "gameStart";
					sleep 2;
					eastRound = true;
					eastWins = eastWins + 1;
					publicVariable "eastWins";
					
					//cinematic
					["cin_eastround.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
					
					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;

					sleep 10;
					_null = execVM "resetRound.sqf";

				};
				
				//if all east paintballers died
				case ((({alive _x} count paintBallersEast) == 0) and (count paintBallersEast > 0)):
				{
					gameStart = false;
					publicVariable "gameStart";
					sleep 2;
					westRound = true;
					westWins = westWins + 1;
					publicVariable "westWins";
					
					["cin_westround.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					_null = execVM "resetRound.sqf";

				};
				
				//if west side caps flag, give them one point and reset round.
				case (!(isNil "flagBearer") and {(side flagBearer == WEST)} and {flagWhite distance flagWest < 5}):
				{
					gameStart = false;
					publicVariable "gameStart";
					westRound = true;
					westWins = westWins + 1;
					publicVariable "westWins";
					
					["cin_westroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
					
					//freeze all bots if there are any
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					_null = execVM "resetRound.sqf";			
					
				};
				
				//if east side caps flag, give em one point and reset round.
				case (!(isNil "flagBearer") and {(side flagBearer == EAST)} and {flagWhite distance flagEast < 5}):
				{
					gameStart = false;
					publicVariable "gameStart";
					eastRound = true;
					eastWins = eastWins + 1;
					publicVariable "eastWins";
					
					["cin_eastroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					_null = execVM "resetRound.sqf";
					
				};

				//if time ran out, give point to the side the flag is closest to.
				case (serverTime > timeRoundOver):
				{
					gameStart = false;
					publicVariable "gameStart";
					
					//if flag wasn't taken, the round is a draw
					if (flagTakenOnce) then
					{
						if (flagWest distance flagWhite < flagEast distance flagWhite) then
						{
							westRound = true;
							westWins = westWins + 1;
							publicVariable "westWins";
							
							["cin_westroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
							
							//freeze all bots if there are any
							{ _x enableSimulation false;} forEach botList;
							
							sleep 10;
							_null = execVM "resetRound.sqf";			
													
						} else {
							//east wins
							eastRound = true;
							eastWins = eastWins + 1;
							publicVariable "eastWins";
							
							["cin_eastroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

							//freeze all the bots
							{ _x enableSimulation false;} forEach botList;
							
							sleep 10;
							_null = execVM "resetRound.sqf";
							
						};
						
					} else {
						//round draw
						
					}; 

				};
			
			
			};

		};
		

		sleep 0.06;
	};
};


