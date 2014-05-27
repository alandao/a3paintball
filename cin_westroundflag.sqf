private "_camera";
showCinemaBorder true;

_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];



_camera camSetTarget [-27562.33,102014.70,-21242.90];
_camera camSetPos [23479.71,18689.76,6.55];
_camera camSetFOV 0.700;
_camera camCommit 0;


playMusic "pointWest";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;
	
cutText ["", "PLAIN", 2];
camDestroy _camera;