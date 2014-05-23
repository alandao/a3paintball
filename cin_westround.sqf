private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [23334.86,109632.57,-41608.02];
_camera camSetPos [23468.95,18706.40,11.04];
_camera camSetFOV 0.700;
_camera camCommit 0;

playMusic "pointWest";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;