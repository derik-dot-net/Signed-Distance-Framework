function sdf_plane(_x, _y, _z, _nx, _ny, _nz, _thickness) {
	var _data = [_sdf_type, _sdf_plane, _sdf_pos_0, _x, _y, _z, _sdf_pos_1, _nx, _ny, _nz, _sdf_float_0, _thickness];
	return new _sdf_shape(_data);
}