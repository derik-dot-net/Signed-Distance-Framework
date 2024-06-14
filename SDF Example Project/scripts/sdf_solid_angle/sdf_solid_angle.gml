function sdf_solid_angle(_x, _y, _z, _angle_degrees, _radius) {
	var _data = [_sdf_type, _sdf_solid_angle, _sdf_pos_0, _x, _y, _z, _sdf_float_0, degtorad(clamp(_angle_degrees, -89, 89)), _sdf_float_1, _radius];
	return new _sdf_shape(_data);
}