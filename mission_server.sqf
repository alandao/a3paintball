roundOver = false;
gameStart = false;
westWins = false;
eastWins = false;
westRound = false;
eastRound = false;

westGrp = group west1;
eastGrp = group east1;

flagTaken = false;
flagWhite = "Flag_Green_F" createVehicle [23468.9,18740.4,0];
flagWest = 	"Flag_US_F" createVehicle [23468.9,18716.7,0];
flagEast = "Flag_CSAT_F" createVehicle [23468.8,18766.9,0];

PaintBallersSpawnPoints = [getPos west1, getPos west2, getPos west3, getPos west4, getPos east1, getPos east2, getPos east3, getPos east4];

_null = execVM "resetRound.sqf";



[] spawn
{
	while {true} do
	{
		if (gameStart) then
		{
			//WIN CONDITIONS
			
			//west round by flag capture
			if (((flagWhite distance flagWest) < 4.5) and !roundOver) then
			{
				roundOver = true;
				westRound = true;
				publicVariable "roundOver";
			};
			//east round by flag capture
			if (((flagWhite distance flagEast) < 4.5) and !roundOver) then
			{
				roundOver = true;
				eastRound = true;
				publicVariable "roundOver";
			};
			//west round by all east out of game
			if ( ({ _x } count PaintBallersEastInGame) == 0) then
			{
				roundOver = true;
				westRound = true;
				publicVariable "roundOver";
			};
			//east round by all west out of game
			if ( ({ _x } count PaintBallersWestInGame) == 0) then
			{
				roundOver = true;
				eastRound = true;
				publicVariable "roundOver";
			};
			
			//GAME LOGIC
			
			//for west paintballers
			{
				//if west paintballers are dead, they are out of the game
				if ((!alive _x) and (PaintBallersWestInGame select _forEachIndex)) then
				{
					PaintBallersWestInGame set [_forEachIndex, False];
				};
				
			} forEach PaintBallersWest;
			
			//for east paintballers
			{
				//if east paintballers are dead, they are out of the game
				if ((!alive _x) and (PaintBallersEastInGame select _forEachIndex)) then
				{
					PaintBallersEastInGame set [_forEachIndex, False];
				};
				
			} forEach PaintBallersEast;
			
			//for all paintballers
			{	
							
				//if paintballers are dead, they are out of the game, they drop the flag if they carried it too
				if ((!alive _x) and (PaintBallersInGame select _forEachIndex)) then
				{

					detach flagWhite;
					flagTaken = false;
						
					//reset height
					flagWhite setPos [(getPos flagWhite) select 0, (getPos flagWhite) select 1, 0];
					PaintBallersCarryingFlag set [_forEachIndex, False];

					PaintBallersInGame set [_forEachIndex, False];

				};
				
				
				//if paintballers are near the flag, they grab it!
				if (((_x distance flagWhite) < 4.5) and !flagTaken) then
				{
					flagWhite attachTo [_x, [0.25,0.25,1]];
					flagTaken = true;
					PaintBallersCarryingFlag set [_forEachIndex, True];
					publicVariable "flagTaken";
				};
				
				//paintballers in field?
				_boundary = [triggerBoundaryDead , (getPos _x)] call BIS_fnc_inTrigger;

				//if paintballers are out of game, remove weapons
				if (!(PaintBallersInGame select _forEachIndex) and (alive _x)) then
				{
					removeAllWeapons _x;
					_x setCaptive True;
					_x allowDamage False;
					//if they're in the boundary, teleport em back to respawn
					if (_boundary) then
					{
						_x setPos (getMarkerPos "respawn_west");
					};
				};
			
						

					
			} forEach PaintBallers;

		};



		 
		
		//hack, needed when players die
		PaintBallers = [west1,west2,west3,west4,east1,east2,east3,east4];
		PaintBallersWest = [west1,west2,west3,west4];
		PaintBallersEast = [east1,east2,east3,east4];
		

		sleep 0.06;
	};

};


