function sdf_box(_x, _y, _z, _x_scale, _y_scale, _z_scale) {
	var _data = [_sdf_type, _sdf_box, _sdf_pos_0, _x, _y, _z, _sdf_scale_0, _x_scale, _y_scale, _z_scale];
	return new _sdf_shape(_data);
}