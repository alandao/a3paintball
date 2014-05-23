private "_camera";
showCinemaBorder true;

_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];



_camera camSetTarget [17946.58,117589.21,-13859.79];
_camera camSetPos [23469.29,18709.33,2.24];
_camera camSetFOV 0.300;
_camera camCommit 0;

_camera camSetTarget [22596.41,106798.98,-47302.97];
_camera camSetPos [23469.04,18706.60,11.78];
_camera camSetFOV 0.700;
_camera camCommitPrepared 10;

playMusic "pointWest";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;
	
cutText ["", "PLAIN", 2];
camDestroy _camera;