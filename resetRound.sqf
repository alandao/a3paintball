roundOver = false;
westRound = false;
eastRound = false;
flagTakenOnce = false;
publicVariable "gameStart";

detach flagWhite;
//set between flagWest and flagEast
flagWhite setPos [23467.3,(((getPos flagWest) select 1) + ((getPos flagEast) select 1)) / 2,0];

{
	_x setDamage 1;
	deleteVehicle _x;
} forEach botList;

paintBallers = [];
paintBallersWest = [];
paintBallersEast = [];
botList = [];
flagBearer = nil;

//respawn and freeze
[nil, "fnc_resetMP"] call BIS_fnc_MP;

//wait until everyone is alive before..
waitUntil{ ({alive _x} count playableUnits) == (count playerList) };

//we recreate the paintballer lists!
{
	_player = _x call host_fnc_findPlayer;
	paintBallers set [count paintBallers, _player];
	
	if (side _player == WEST) then
	{
		paintBallersWest set [count paintBallersWest, _player];
	};
	if (side _player == EAST) then
	{
		paintBallersEast set [count paintBallersEast, _player];
	};
	
} forEach playerList;



["cin_resetround.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
sleep 5;
["cin_three.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
sleep 1;
["cin_two.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
sleep 1;
["cin_one.sqf","BIS_fnc_execVM"] spawn BIS_fnc_MP;
sleep 1;
//gogogo!
[nil, "fnc_startMP"] call BIS_fnc_MP;

gameStart = true;
publicVariable "gameStart";

timeRoundOver = serverTime + 90;

//count up players;
_countWest = count paintBallersWest;
_countEast = count paintBallersEast;


//spawn bots if they are enabled.
if (botsEnabled) then
{
	//make west bots
	for [{_i = 0}, {_i< 5 - _countWest}, {_i = _i + 1}] do
	{
		_x = groupWest createUnit ["B_Soldier_F", getMarkerPos "respawn_west", [], 0, "CAN_COLLIDE"];
		removeAllWeapons _x;
		_x addMagazines["30Rnd_65x39_caseless_mag_Tracer",3];
		_x addWeapon "arifle_MXC_ACO_F";
		_x setSkill 0.9;
		botList = botList + [_x];
		
		//bots are paintballers too!
		paintBallers = paintBallers + [_x];
		paintBallersWest = paintBallersWest +  [_x];
	};

	//make east bots
	for [{_i = 0}, {_i< 5 - _countEast}, {_i = _i + 1}] do
	{
		_x = groupEast createUnit ["O_Soldier_F", getMarkerPos "respawn_east", [], 0, "CAN_COLLIDE"];
		removeAllWeapons _x;
		_x addMagazines["30Rnd_65x39_caseless_mag_Tracer",3];
		_x addWeapon "arifle_MXC_ACO_F";
		
		botList = botList + [_x];
		
		//bots are paintballers too!
		paintBallers = paintBallers + [_x];
		paintBallersEast = paintBallersEast +  [_x];
	};
};

//flag waypoint
_wp = groupWest addWaypoint [getPos flagWhite , 0];
_wpE = groupEast addWaypoint [getPos flagWhite, 0];

//go back to base waypoint
_wp1 = groupWest addWaypoint [getPos flagWest , 0];
_wpE1 = groupEast addWaypoint [getPos flagEast, 0];

groupWest setBehaviour "COMBAT";
groupEast setBehaviour "COMBAT";