private "_camera";
showCinemaBorder true;

if !(isNil "cameraCountdown") then
{
	camDestroy cameraCountdown;
};

_camera = "camera" camCreate [0,0,0];
_camera cameraEffect ["internal", "back"];

_camera camSetTarget [117098.86,19038.38,-35029.64];
_camera camSetPos [23440.71,18741.02,10.76];
_camera camSetFOV 0.700;
_camera camCommit 0;

sleep 10;
camDestroy _camera;