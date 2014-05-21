roundOver = false;
westRound = false;
eastRound = false;
gameStart = false;

flagTaken = false;
detach flagWhite;
flagWhite setPos [23469.3,18741.1,0];
flagWest setPos [23468.9,18716.7,0];
flagEast setPos [23468.8,18766.9,0];

//needed to kill all units
PaintBallers = [west1,west2,west3,west4,east1,east2,east3,east4];


//kill all
{ _x setPos [0,0,0]; _x setDamage 1;} forEach PaintBallers;
//remove bodies
{if (_x isKindOf "Man") then {hidebody _x}} forEach allDead;

//wait until all players alive
waitUntil {
	sleep 0.1;
	({!_x } count [alive west1, alive west2, alive west3, alive west4, alive east1, alive east2, alive east3, alive east4]) == 0;
};

PaintBallers = [west1,west2,west3,west4,east1,east2,east3,east4];
PaintBallersInGame = [alive west1, alive west2, alive west3, alive west4, alive east1, alive east2, alive east3, alive east4];
PaintBallersWest = [west1,west2,west3,west4];
PaintBallersEast = [east1,east2,east3,east4];
PaintBallersWestInGame = [alive west1,alive west2,alive west3,alive west4];
PaintBallersEastInGame = [alive east1,alive east2,alive east3,alive east4];
PaintBallersCarryingFlag = [false,false,false,false,false,false,false,false];

{
	_x enableSimulation False;
	_x setPos (PaintBallersSpawnPoints select _forEachIndex);
	removeAllWeapons _x;
	_x unassignItem "NVGoggles";
	_x removeItem "NVGoggles";
	_x addMagazines ["30Rnd_556x45_Stanag",3];
	_x addWeapon "arifle_TRG20_F";
	_x allowDamage True;
} forEach PaintBallers;

//reset waypoints
deleteWaypoint westgetFlag;
deleteWaypoint westscoreFlag;
deleteWaypoint eastgetFlag;
deleteWaypoint eastscoreFlag;

//ai objectives
westgetFlag = (group west1) addWaypoint [(getPos flagWhite),1];
westgetFlag setWayPointDescription "Get the flag.";
westgetFlag setWaypointBehaviour "COMBAT";
westgetFlag setWaypointCompletionRadius 1;

westscoreFlag = (group west1) addWaypoint [(getPos flagWest),0];
westscoreFlag setWayPointDescription "Return the flag.";
westscoreFlag setWaypointBehaviour "COMBAT";
westscoreFlag setWaypointCompletionRadius 1;



eastgetFlag = (group east1) addWaypoint [(getPos flagWhite),1];
eastgetFlag setWayPointDescription "Get the flag.";
eastgetFlag setWaypointBehaviour "COMBAT";
eastgetFlag setWaypointCompletionRadius 1;

eastscoreFlag = (group east1) addWaypoint [(getPos flagEast),0];
eastscoreFlag setWayPointDescription "Return the flag.";
eastscoreFlag setWaypointBehaviour "COMBAT";
eastscoreFlag setWaypointCompletionRadius 1;

gameStart = True;
{ _x enableSimulation True; } forEach PaintBallers;
