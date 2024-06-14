// Shapes
#macro _sdf_sphere							0
#macro _sdf_box								1
#macro	_sdf_round_box					2
#macro _sdf_box_frame					3
#macro _sdf_torus							4
#macro _sdf_capped_torus				5
#macro _sdf_link								6
#macro _sdf_cone								8
#macro _sdf_round_cone				9
#macro _sdf_plane							10
#macro _sdf_hex_prism					11
#macro _sdf_tri_prism						12
#macro _sdf_capsule						13
#macro _sdf_cylinder						14
#macro _sdf_capped_cone				15
#macro _sdf_solid_angle					16
#macro _sdf_cut_sphere					17
#macro _sdf_cut_hollow_sphere	18
#macro _sdf_death_star					19
#macro _sdf_ellipsoid						20
#macro _sdf_rhombus						21
#macro _sdf_octahedron				22
#macro _sdf_pyramid						23
#macro _sdf_triangle						24						
#macro _sdf_quad								25
#macro _sdf_egg								26

// Shading Types
#macro sdf_smooth_shading		0
#macro sdf_toon_shading			1
#macro sdf_diffuse_shading		2

// Intersection Operations
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
#macro _sdf_intersection			-4
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
#macro _sdf_smoothing				-16

// Textures
global._sdf_tex_toonramp	= sprite_get_texture(spr_sdf_toonramp, 0);

// Uniforms
global._u_sdf_view_mat		= shader_get_uniform(shd_sdf, "view_mat");
global._u_sdf_proj_mat			= shader_get_uniform(shd_sdf, "proj_mat");
global._u_sdf_input_array	= shader_get_uniform(shd_sdf, "sdf_input_array");
global._u_toonramp				= shader_get_sampler_index(shd_sdf, "tex_toonramp");
