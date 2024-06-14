function sdf_cut_sphere(_x, _y, _z, _radius, _cut_off_amt) {
	var _data = [_sdf_type, _sdf_cut_sphere, _sdf_pos_0, _x, _y, _z, _sdf_float_0, _radius, _sdf_float_1, _cut_off_amt];
	return new _sdf_shape(_data);
}