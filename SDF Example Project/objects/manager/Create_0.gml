// Welcome to Derik's Signed Distance Framework Example Project
// Here you will find a solid template or example project for how to get started.

#region Enable 3D and Setup Camera

// GPU Settings
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_alphatestenable(true);
gpu_set_alphatestref(0);
gpu_set_blendenable(true);

// Camera 
cam = camera_create();

// The Position of our Camera
cam_x = 0;
cam_y = 0; 
cam_z = 0;

// The Position our Camera will Look At
target_x = 0; 
target_y = 0; 
target_z = 0;

// The Distance our Camera should be from the Target
cam_dist = 100;

// Our Cameras Up Vector
xup = 0;
yup = 0;
zup = 1;

// View Matrix 
view_mat = matrix_build_lookat(cam_x, cam_y, cam_z, target_x, target_y, target_z, xup, yup, zup);

// Projection Settings
fov = 60;
aspect = window_get_width() / window_get_height();
znear = 1.0;
zfar = 1000.0;

//Projection Matrix
proj_mat = matrix_build_projection_perspective_fov(fov, aspect, znear, zfar);

#endregion
#region Signed Distance Framework

// I've setup my Example Scene to be a simplified recreation of https://www.shadertoy.com/view/Xds3zN
// with a few additional bits to help show off the systems capabilities

// Decide our Shading Type
sdf_style = sdf_default_shading;
// The other option is sdf_toon_shading

// Create a Batch to Store our Shapes in
sdf_batch = sdf_create_batch(sdf_style);

// Render Settings
sdf_batch.fog(true, zfar * 0.75, 0, 0, 0);
sdf_batch.shadows(true);
sdf_batch.ambient_occlusion(true);
sdf_batch.specular(true);
//sdf_batch.debug(true);

// Plane
var plane = sdf_plane(0, 0, -10, 0, 0, 1, 1);
sdf_batch.add(plane);

// Sphere
var sphere = sdf_sphere(-40, 0, 0, 5);
sdf_batch.add(sphere);

// Box
var box = sdf_box(-20, 0, 0, 5, 5, 5);
sdf_batch.add(box);

// Round
var round_box = sdf_round_box(0, 0, 0, 5, 5, 5, 2.5);
sdf_batch.add(round_box);

// Box Frame
var box_frame = sdf_box_frame(20, 0, 0, 5, 5, 5, 1);
sdf_batch.add(box_frame);

// Torus
var torus = sdf_torus(40, 0, 0, 5, 1);
sdf_batch.add(torus);

// Capped Torus
var torus = sdf_capped_torus(-40, -20, 0, 135, 5, 1);
sdf_batch.add(torus);

// Link
var link = sdf_link(-20, -20, 0, 4, 3, 1);
sdf_batch.add(link);

// Cone
var cone = sdf_cone(0, -15, 0, 35, 10);
sdf_batch.add(cone);

// Rounded Cone
var cone = sdf_round_cone(20, -15, 0, 20, -25, 0, 5, 1);
sdf_batch.add(cone);

// Hex Prism
var hex_prism = sdf_hex_prism(40, -20, 0, 5, 5);
sdf_batch.add(hex_prism);

// Tri Prism
var tri_prism = sdf_triangle_prism(-40, 20, 5, 5);
sdf_batch.add(tri_prism);

// Capsule
var capsule = sdf_capsule(-20, 20, 0, -20, 20, 5, 5);
sdf_batch.add(capsule);

// Cylinder
var cylinder = sdf_cylinder(0, 20, 0, 0, 20, 10, 5);
sdf_batch.add(cylinder);

// Capped Cone
var capped_cone = sdf_capped_cone(20, 20, 0, 20, 20, 10, 5, 2.5);
sdf_batch.add(capped_cone);

// Solid Angle
var solid_angle = sdf_solid_angle(40, 15, 0, 30, 10);
sdf_batch.add(solid_angle);

// Cut Sphere
var cut_sphere = sdf_cut_sphere(-40, 40, 0,  5, 0.5);
sdf_batch.add(cut_sphere);

// Cut Hollow Sphere
var cut_hollow_sphere = sdf_cut_hollow_sphere(-20, 40, 0,  5, 0.5, 0.1);
sdf_batch.add(cut_hollow_sphere);

// Death Star
var death_star = sdf_death_star(0, 40, 0,  5, 4, 5);
sdf_batch.add(death_star);

// Ellipsoid
var ellipsoid = sdf_ellipsoid(20, 40, 0,  5, 5, 3.5);
sdf_batch.add(ellipsoid);

// Rhombus
var rhombus = sdf_rhombus(40, 40, 0, 5, 2.5, 1, 3);
sdf_batch.add(rhombus);

// Octahedron
var octahedron = sdf_octahedron(-40, -40, 0, 5);
sdf_batch.add(octahedron);

// Pyramid
var pyramid = sdf_pyramid(-20, -40, 0, 5, 5, 5);
sdf_batch.add(pyramid);

// Triangle
var triangle = sdf_triangle(-5, -35, 0, 0, -45, 5, 5, -35, 0);
sdf_batch.add(triangle);

// Quad
var quad = sdf_quad(15, -45, 0, 15, -35, 0, 25, -35, 0, 25, -45, 0);
sdf_batch.add(quad);

// Egg
var egg = sdf_egg(40, -40, 0, 5, 5, 2.25);
sdf_batch.add(egg);

#endregion
