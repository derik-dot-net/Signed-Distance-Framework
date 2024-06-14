function sdf_cylinder(_x1, _y1, _z1, _x2, _y2, _z2, _radius) {
	var _data = [_sdf_type, _sdf_cylinder, _sdf_pos_0, _x1, _y1, _z1,  _sdf_pos_1, _x2, _y2, _z2, _sdf_float_0, _radius];
	return new _sdf_shape(_data);
}