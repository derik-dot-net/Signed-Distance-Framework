function sdf_quad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _x4, _y4, _z4) {
	var _data = [_sdf_type, _sdf_quad, _sdf_pos_0, _x1, _y1, _z1, _sdf_pos_1, _x2, _y2, _z2, _sdf_pos_2, _x3, _y3, _z3, _sdf_pos_3, _x4, _y4, _z4];
	return new _sdf_shape(_data);
}