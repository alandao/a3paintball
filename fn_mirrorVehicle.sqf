//function, takes a vehicle and mirrors it on the other side of the flag.

_vehicle = _this select 0;
_origin = _this select 1;

_vehiclePos = getPos _vehicle;
_originPos = getPos _origin;
_xDifference =  ((_vehiclePos select 0) - (_originPos select 0));
_yDifference =  ((_vehiclePos select 1) - (_originPos select 1));
_mirrorVehiclePos = [(_originPos select 0) - _xDifference, (_originPos select 1) - _yDifference, 0];
	
_mirrorVehicle =  createVehicle [(typeOf _vehicle), _mirrorVehiclePos, [], 0, "CAN_COLLIDE"];
_mirrorVehicle setDir ((getDir _vehicle) + 180);
