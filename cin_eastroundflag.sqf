private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [24252.26,-80098.75,-14954.54];
_camera camSetPos [23468.77,18772.91,2.21];
_camera camSetFOV 0.3;
_camera camCommit 0;



_camera camSetTarget [24055.24,-71948.27,-42048.76];
_camera camSetPos [23468.77,18774.34,8.21];
_camera camSetFOV 0.700;
_camera camCommit 10;

playMusic "pointEast";
cutText [format ["%1 - %2", westWins, eastWins], "PLAIN", 2];
sleep 8;

cutText ["", "PLAIN", 2];
camDestroy _camera;