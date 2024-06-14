function sdf_triangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) {
	var _data = [_sdf_type, _sdf_triangle, _sdf_pos_0, _x1, _y1, _z1, _sdf_pos_1, _x2, _y2, _z2, _sdf_pos_2, _x3, _y3, _z3];
	return new _sdf_shape(_data);
}