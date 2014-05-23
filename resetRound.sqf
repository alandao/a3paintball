roundOver = false;
westRound = false;
eastRound = false;
gameStart = false;
publicVariable "gameStart";

detach flagWhite;
flagWhite setPos [23469.3,18741.1,0];



//respawn and freeze
[nil, "fnc_resetMP"] call BIS_fnc_MP;



paintBallers = [];
paintBallersWest = [];
paintBallersEast = [];
flagBearer = nil;
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
sleep 5;
[nil, "fnc_soundThree"] call BIS_fnc_MP;
sleep 1;
[nil, "fnc_soundTwo"] call BIS_fnc_MP;
sleep 1;
[nil, "fnc_soundOne"] call BIS_fnc_MP;
sleep 1;
//gogogo!
[nil, "fnc_startMP"] call BIS_fnc_MP;

gameStart = true;
publicVariable "gameStart";
