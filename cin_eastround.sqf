private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [23510.29,-74515.86,-35998.49];
_camera camSetPos [23468.78,18774.26,11.47];
_camera camSetFOV 0.700;
_camera camCommit 0;



playMusic "pointEast";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;