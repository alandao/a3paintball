playerList = [];
botsEnabled = true;
pointLimit = 5;
botList = [];
objectsToMirror = [];
groupWest = createGroup west;
groupEast = createGroup east;

flagTakenOnce = false;
gameOver = false;

//when player connects.
_playerConnects = ["id1", "onPlayerConnected", {

	playerList set [count playerList, _uid];
	playerList = playerList - [""];
}] call BIS_fnc_addStackedEventHandler;

//when player disconnects.
_playerDisconnects = ["id2", "onPlayerDisconnected", {

	playerList = playerList - [_uid];
	playerList = playerList - [""];
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



//MISSION LOGIC
[] spawn
{

	//mirror the objects on the other side of the flag
	{
		[_x, flagWhite] call paintball_fnc_mirrorVehicle;
	} forEach objectsToMirror;
	
	while {!gameOver} do
	{
	

		//get amount for player HUD
		countWest = {alive _x} count paintBallersWest;
		countEast = {alive _x} count paintBallersEast;
		
		publicVariable "countWest";
		publicVariable "countEast";
		

		
		if (gameStart) then
		{
			roundTime = timeRoundOver - time;
			publicVariable "roundTime";
			
			//if flagbearer died, detach flag and let it be available again. lazy evaluation magic here
			if (!(isNil "flagBearer") and {!(alive flagBearer)}) then
			{
				flagBearer = nil;
				publicVariable "flagBearer";
				detach flagWhite;
				flagWhite setPos [(getPos flagWhite) select 0, (getPos flagWhite) select 1,0];
				
				//get updated positions for client.
				posFlagWhite = getPos flagWhite;
				publicVariable "posFlagWhite";
				posFlagWest = getPos flagWest;
				publicVariable "posFlagWest";
				posFlagEast = getPos flagEast;
				publicVariable "posFlagEast";
			};
			
			//if the flag hasn't been taken yet, paintballers will pick it up.
			{
				if ((isNil "flagBearer") and (alive _x) and {(_x distance flagWhite < 4.5)}) then
				{
					flagTakenOnce = true;
					publicVariable "flagTakenOnce";
					flagWhite attachTo [_x, [0,0,0.5]];
					flagBearer = _x;
					publicVariable "flagBearer";
					[nil, "fnc_soundFlagTaken"] spawn BIS_fnc_MP;

					
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
					publicVariable "eastRound";
					publicVariable "eastWins";
					
					//cinematic
					["cinematics\cin_eastround.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
					
					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;

					sleep 10;
					if ((westWins == pointLimit) or (eastWins == pointLimit)) then
					{
						gameOver = true;
					} else
					{
						_null = execVM "resetRound.sqf";
					};
					

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
					publicVariable "westRound";
					
					["cinematics\cin_westround.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					if ((westWins == pointLimit) or (eastWins == pointLimit)) then
					{
						gameOver = true;
					} else
					{
						_null = execVM "resetRound.sqf";
					};

				};
				
				//if west side caps flag, give them one point and reset round.
				case (!(isNil "flagBearer") and {(side flagBearer == WEST)} and {flagWhite distance flagWest < 5}):
				{
					gameStart = false;
					publicVariable "gameStart";
					westRound = true;
					westWins = westWins + 1;
					publicVariable "westWins";
					publicVariable "westRound";
					
					["cinematics\cin_westroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
					
					//freeze all bots if there are any
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					if ((westWins == pointLimit) or (eastWins == pointLimit)) then
					{
						gameOver = true;
					} else
					{
						_null = execVM "resetRound.sqf";
					};
					
				};
				
				//if east side caps flag, give em one point and reset round.
				case (!(isNil "flagBearer") and {(side flagBearer == EAST)} and {flagWhite distance flagEast < 5}):
				{
					gameStart = false;
					publicVariable "gameStart";
					eastRound = true;
					eastWins = eastWins + 1;
					publicVariable "eastWins";
					publicVariable "eastRound";
					
					["cinematics\cin_eastroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

					//freeze all the bots
					{ _x enableSimulation false;} forEach botList;
					
					sleep 10;
					if ((westWins == pointLimit) or (eastWins == pointLimit)) then
					{
						gameOver = true;
					} else
					{
						_null = execVM "resetRound.sqf";
					};
					
				};

				//if time ran out, give point to the side the flag is closest to.
				case (time > timeRoundOver):
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
							publicVariable "westRound";
							
							["cinematics\cin_westroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
							
							//freeze all bots if there are any
							{ _x enableSimulation false;} forEach botList;
							
							sleep 10;
							if ((westWins == pointLimit) or (eastWins == pointLimit)) then
							{
								gameOver = true;
							} else
							{
								_null = execVM "resetRound.sqf";
							};	
													
						} else {
							//east wins
							eastRound = true;
							eastWins = eastWins + 1;
							publicVariable "eastWins";
							publicVariable "eastRound";
							
							["cinematics\cin_eastroundflag.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;

							//freeze all the bots
							{ _x enableSimulation false;} forEach botList;
							
							sleep 10;
							if ((westWins == pointLimit) or (eastWins == pointLimit)) then
							{
								gameOver = true;
							} else
							{
								_null = execVM "resetRound.sqf";
							};
							
						};
						
					} else {
						//round draw
						roundDraw = true;
						publicVariable "roundDraw";
						["cinematics\cin_rounddraw.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
						sleep 10;
						_null = execVM "resetRound.sqf";
						
					}; 

				};
			
			
			};

		};
		

		sleep 0.06;
	};
	//west wins
	if (westWins == pointLimit) then
	{
		["cinematics\cin_westwins.sqf", "BIS_fnc_execVM"] spawn BIS_fnc_MP;
	} else // east wins
	{
		["cinematics\cin_eastwins.sqf", "BIS_fnc_execVM"] spawn BIS_fnc_MP;
	};
};
