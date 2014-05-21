waitUntil {!isNull player};


enableSaving [false, false];
enableSentences false; //Disables auto spotting radio chatter


if (isServer) then
{
	_null = execVM "mission_server.sqf";

} else {

	_null = execVM "mission_client.sqf";
};



