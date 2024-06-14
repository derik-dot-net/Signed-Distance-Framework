function sdf_egg(_x, _y, _z, _radius, _height, _roundness) {
	var _data = [_sdf_type, _sdf_egg, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _radius, _sdf_float_1, _roundness, _sdf_float_2, _height];
	return new _sdf_shape(_data);
}