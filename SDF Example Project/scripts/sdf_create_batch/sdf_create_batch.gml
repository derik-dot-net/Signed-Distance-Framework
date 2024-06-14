/// @ param shading_type
function sdf_create_batch(shading_type = sdf_smooth_shading) {
	return new _sdf_batch(shading_type);
}