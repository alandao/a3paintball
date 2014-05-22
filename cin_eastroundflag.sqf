private "_camera";
showCinemaBorder true;


_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [-46029.38,-38414.32,-43545.64];
_camera camSetPos [23481.96,18777.71,8.27];
_camera camSetFOV 0.700;
_camera camCommit 0;


_camera camSetTarget [70926.73,-57709.76,-43532.69];
_camera camSetPos [23460.02,18781.05,8.06];
_camera camSetFOV 0.700;
_camera camCommit 20;

sleep 10;
camDestroy _camera;