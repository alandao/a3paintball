//removes bodies on respawn
_null = player addMPEventHandler ["MPRespawn", {deleteVehicle (_this select 1)}];

//for JIP
if (gameStart) then
{
	startLoadingScreen ["The round is still in progress, it'll be a minute..."];
	waitUntil { sleep 0.1; !gameStart };
	endLoadingScreen;
} else
{
	_null spawn fnc_resetMP;
};

