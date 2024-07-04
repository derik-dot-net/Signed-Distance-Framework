// Shapes
#macro _sdf_sphere							0
#macro _sdf_box								1
#macro	_sdf_round_box					2
#macro _sdf_box_frame					3
#macro _sdf_torus							4
#macro _sdf_capped_torus				5
#macro _sdf_link								6
#macro _sdf_cone								7
#macro _sdf_round_cone				8
#macro _sdf_plane							9
#macro _sdf_hex_prism					10
#macro _sdf_tri_prism						11
#macro _sdf_capsule						12
#macro _sdf_cylinder						13
#macro _sdf_capped_cone				14
#macro _sdf_solid_angle					15
#macro _sdf_cut_sphere					16
#macro _sdf_cut_hollow_sphere	17
#macro _sdf_death_star					18
#macro _sdf_ellipsoid						19
#macro _sdf_rhombus						20
#macro _sdf_octahedron				21
#macro _sdf_pyramid						22
#macro _sdf_triangle						23						
#macro _sdf_quad								24
#macro _sdf_egg								25

// Shading Types
#macro sdf_default_shading		0
#macro sdf_toon_shading			1

// Blending Operations
#macro op_union							0
#macro op_sub								1
#macro op_int								2
#macro op_xor								3
#macro op_smooth_union			4
#macro op_smooth_sub				5
#macro op_smooth_int				6

// Array Flags
#macro _sdf_array_end_flag		-1

// Data Type Flags
#macro _sdf_entry_len					-2
#macro _sdf_type							-3
#macro _sdf_blending					-4
#macro _sdf_pos_0						-5
#macro _sdf_pos_1						-6
#macro _sdf_pos_2						-7
#macro _sdf_pos_3						-8
#macro _sdf_scale_0						-9
#macro _sdf_rotation					-10
#macro _sdf_float_0						-11
#macro _sdf_float_1						-12
#macro _sdf_float_2						-13
#macro _sdf_float_3						-14
#macro _sdf_color_0						-15
#macro _sdf_blend_str					-16
#macro _sdf_pattern					-17

#macro _sdf_error_tag_str	"SDF ERROR: "
#macro _sdf_inf 99999

// Pattern Flags
#macro sdf_pattern_none								0
#macro sdf_pattern_checkered						1
//#macro sdf_pattern_checkered_filtered	2
#macro sdf_pattern_xor									3
//#macro sdf_pattern_xor_filtered				4
#macro sdf_pattern_grid									5
//#macro sdf_pattern_grid_filtered				6

// Textures
global._sdf_tex_toonramp	= sprite_get_texture(spr_sdf_toonramp, 0);

// Uniforms
global._u_sdf_view_mat		= shader_get_uniform(shd_sdf, "view_mat");
global._u_sdf_proj_mat			= shader_get_uniform(shd_sdf, "proj_mat");
global._u_sdf_input_array	= shader_get_uniform(shd_sdf, "sdf_input_array");
global._u_toonramp				= shader_get_sampler_index(shd_sdf, "tex_toonramp");

// Notes
// A "Modifier" is anything that is not a default data type to the shape.
// In my system even color and rotation is not a default data type.
// We keep the defaults minimal for optimization but also so that down
// the line we can add functions that'll set values for either the entire batch,
// or for a defined part of the batch.

// Vertex Buffer Format
vertex_format_begin();
vertex_format_add_position();
global._sdf_vformat = vertex_format_end();

// Converts 2D Coordinates to 3D Space
function _sdf_2d_to_3d(V, P, _x, _y)  {
	var mx = -(2 * (_x / window_get_width() - .5) / P[0]);
	var my = (2 * (_y / window_get_height() - .5) / P[5]);
	var camX = - (V[12] * V[0] + V[13] * V[1] + V[14] * V[2]);
	var camY = - (V[12] * V[4] + V[13] * V[5] + V[14] * V[6]);
	var camZ = - (V[12] * V[8] + V[13] * V[9] + V[14] * V[10]);
	if (P[15] == 0) {
	    return [V[2]  + mx * V[0] + my * V[1],
	            V[6]  + mx * V[4] + my * V[5],
	            V[10] + mx * V[8] + my * V[9],
	            camX,
	            camY,
	            camZ];
	} else {  
	    return [V[2],
	            V[6],
	            V[10],
	            camX + mx * V[0] + my * V[1],
	            camY + mx * V[4] + my * V[5],
	            camZ + mx * V[8] + my * V[9]];
	}
}