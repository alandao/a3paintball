private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [-54302.53,-43616.30,-7941.90];
_camera camSetPos [23471.47,18737.28,6.78];
_camera camSetFOV 0.700;
_camera camCommit 0;


sleep 10;
camDestroy _camera;