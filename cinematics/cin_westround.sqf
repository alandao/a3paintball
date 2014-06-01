private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [25815.16,116696.99,-19756.79];
_camera camSetPos [23466.30,18698.28,7.09];
_camera camSetFOV 0.7;
_camera camCommit 0;


playMusic "pointWest";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;