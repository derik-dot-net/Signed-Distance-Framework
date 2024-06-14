function sdf_link(_x, _y, _z, _length, _radius, _thickness) {
	var _data = [_sdf_type, _sdf_link, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _length, _sdf_float_1, _radius, _sdf_float_2, _thickness];
	return new _sdf_shape(_data);
}