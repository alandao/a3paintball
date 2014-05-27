private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [59160.86,-73844.64,-12031.28];
_camera camSetPos [23465.71,18788.40,6.48];
_camera camSetFOV 0.700;
_camera camCommit 0;


playMusic "pointEast";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;