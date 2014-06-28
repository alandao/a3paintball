//parameters
botsEnabled = true;
pointLimit = 5;
roundTime = 90;

playerList = [];
botList = [];
objectsToMirror = [];
groupWest = createGroup west;
groupEast = createGroup east;

westWins = 0;
eastWins = 0;

flagTakenOnce = false;
gameOver = false;
gameStart = false;
timeLeft = 90;
roundDraw = false;
westRound = false;
eastRound = false;
countWest = 0;
countEast = 0;
flagBearer = false;



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






respawnWest = getMarkerPos "respawn_west";
respawnEast = getMarkerPos "respawn_east";




flagWhite = createVehicle ["Flag_Green_F", [0,0,0], [], 0, "CAN_COLLIDE"]; 
flagWest = 	 createVehicle ["Flag_US_F",[respawnWest select 0, (respawnWest select 1) + 5, respawnWest select 2],[],0,"CAN_COLLIDE"];
flagEast =  createVehicle ["Flag_CSAT_F",[respawnEast select 0, (respawnEast select 1) - 5, respawnEast select 2],[],0, "CAN_COLLIDE"];
posFlagWhite = getPos flagWhite;
posFlagWest = getPos flagWest;
posflagEast = getPos flagEast;

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
	
		posFlagWhite = getPos flagWhite;
		posFlagWest = getPos flagWest;
		posflagEast = getPos flagEast;
		
		//get amount for player HUD
		countWest = {alive _x} count paintBallersWest;
		countEast = {alive _x} count paintBallersEast;
		
		
		if (gameStart) then
		{
			timeLeft = timeRoundOver - time;
			
			//if flagbearer died, detach flag and let it be available again. lazy evaluation magic here
			if ((typeName flagBearer != "BOOL")  and {!(alive flagBearer)}) then
			{
				flagBearer = false;
				detach flagWhite;
				flagWhite setPos [(getPos flagWhite) select 0, (getPos flagWhite) select 1,0];
				
			};
			
			//if the flag hasn't been taken yet, paintballers will pick it up.
			{
				if ((typeName flagBearer == "BOOL") and (alive _x) and {(_x distance flagWhite < 4.5)}) then
				{
					flagTakenOnce = true;
					flagWhite attachTo [_x, [0,0,0.5]];
					flagBearer = _x;
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
					sleep 2;
					eastRound = true;
					eastWins = eastWins + 1;
					
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
					sleep 2;
					westRound = true;
					westWins = westWins + 1;
					
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
				case ((typeName flagBearer != "BOOL") and {(side flagBearer == WEST)} and {flagWhite distance flagWest < 5}):
				{
					gameStart = false;
					westRound = true;
					westWins = westWins + 1;
					
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
				case ((typeName flagBearer != "BOOL") and {(side flagBearer == EAST)} and {flagWhite distance flagEast < 5}):
				{
					gameStart = false;
					eastRound = true;
					eastWins = eastWins + 1;
					
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
					
					//if flag wasn't taken, the round is a draw
					if (flagTakenOnce) then
					{
						switch (true) do:
						{
							case ((typeName flagBearer != "BOOL") and {(side flagBearer == WEST)}):
							{
								westRound = true;
								westWins = westWins + 1;
								
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
							
							case ((typeName flagBearer != "BOOL") and {(side flagBearer == EAST)}):
							{
								//east wins
								eastRound = true;
								eastWins = eastWins + 1;
								
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
							
							case ((typeName flagBearer == "BOOL") and {(flagWest distance flagWhite < flagEast distance flagWhite)}):
							{
								westRound = true;
								westWins = westWins + 1;
								
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
							
							case ((typeName flagBearer == "BOOL") and {(flagWest distance flagWhite > flagEast distance flagWhite)}):
							{
								//east wins
								eastRound = true;
								eastWins = eastWins + 1;
								
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
						};
	
					} else {
						//round draw
						roundDraw = true;
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

//broadcast hud information to clients
[] spawn 
{

	while {true } do {
		gameState = [westWins,eastWins,gameStart,timeLeft,roundDraw,westRound,eastRound,flagTakenOnce,countWest,countEast,flagBearer,posFlagWhite,posFlagWest,posFlagEast];
		publicVariable "gameState";
		sleep 0.1;
	};	

};