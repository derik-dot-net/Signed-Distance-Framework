function sdf_cut_hollow_sphere(_x, _y, _z, _radius, _cut_off_amt, _thickness) {
	var _data = [_sdf_type, _sdf_cut_hollow_sphere, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _radius, _sdf_float_1, _cut_off_amt, _sdf_float_2, _thickness];
	return new _sdf_shape(_data);
}