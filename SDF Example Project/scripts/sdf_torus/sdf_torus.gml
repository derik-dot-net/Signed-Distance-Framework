function sdf_torus(_x, _y, _z, _radius, _thickness) {
	var _data = [_sdf_type, _sdf_torus, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _radius, _sdf_float_1, _thickness];
	return new _sdf_shape(_data);
}