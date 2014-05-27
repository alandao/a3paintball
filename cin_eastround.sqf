private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [22504.71,-80568.84,-11373.03];
_camera camSetPos [23468.83,18776.45,7.24];
_camera camSetFOV 0.7;
_camera camCommit 0;




playMusic "pointEast";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;