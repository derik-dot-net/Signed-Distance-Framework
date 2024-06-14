function sdf_sphere(_x, _y, _z, _radius) {
	var _data = [_sdf_type, _sdf_sphere, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _radius];
	return new _sdf_shape(_data);
}