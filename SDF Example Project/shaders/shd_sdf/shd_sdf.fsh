#region Settings

// Enable Depth Writing
#extension GL_EXT_frag_depth : enable

// Enable Standard Derivates
#extension GL_OES_standard_derivatives: enable

// Precision
precision highp float;

// Minimum Render distance to a SDFs boundry
#define surf_dist .01

// Max Steps the raymarcher will do
#define max_steps 100 

// Max Distance for ray marcher to travel
#define max_dist 1000. 

// SDF Array Length
#define max_array_length 2000

// Header Data Size to Skip in Shape Loop
#define array_header_size 15

// Grid Pattern Line Thickness Ratio
#define grid_thickness_ratio 10.0

#endregion
#region Structs

struct hit_info {
	bool did_hit;
	vec3 normal;
	vec3 hit_point;
	float dist;
};

#endregion
#region Varyings

// Varyings
varying vec2 v_vScreenPos;
varying mat4 world_mat;

#endregion
#region Uniforms

// Camera Matrices
uniform mat4 view_mat;
uniform mat4 proj_mat;

// Input Array
uniform float sdf_input_array[max_array_length];

// Grab Render Settings from Array
int render_style = int(sdf_input_array[0]);
vec3 light_dir = vec3(sdf_input_array[1], sdf_input_array[2], sdf_input_array[3]);
bool shadows_enabled = bool(sdf_input_array[4]);
bool ambient_occlusion_enabled = bool(sdf_input_array[5]);
bool fog_enabled = bool(sdf_input_array[6]);
vec3 fog_color = vec3(sdf_input_array[7], sdf_input_array[8], sdf_input_array[9]);
float fog_dist = sdf_input_array[10];
bool debug_enabled = bool(sdf_input_array[11]);
bool specular_enabled = bool(sdf_input_array[12]);
float shadow_alpha = sdf_input_array[13];
float ao_alpha = sdf_input_array [14];

// Toon Shading texture
uniform sampler2D tex_toonramp;

#endregion
#region Flags

// Shapes
#define _sdf_sphere							0
#define _sdf_box								1
#define	_sdf_round_box					2
#define _sdf_box_frame					3
#define _sdf_torus								4
#define _sdf_capped_torus				5
#define _sdf_link									6
#define _sdf_cone								7
#define _sdf_round_cone				8
#define _sdf_plane								9
#define _sdf_hex_prism					10
#define _sdf_tri_prism						11
#define _sdf_capsule							12
#define _sdf_cylinder						13
#define _sdf_capped_cone				14
#define _sdf_solid_angle					15
#define _sdf_cut_sphere					16
#define _sdf_cut_hollow_sphere	17
#define _sdf_death_star					18
#define _sdf_ellipsoid						19
#define _sdf_rhombus						20
#define _sdf_octahedron					21
#define _sdf_pyramid						22
#define _sdf_triangle							23						
#define _sdf_quad								24
#define _sdf_egg								25

// Shading Types
#define _sdf_default_shading		0
#define _sdf_toon_shading			1

// Intersection Operations
#define _op_union							0
#define _op_sub								1
#define _op_int								2
#define _op_xor								3
#define _op_smooth_union		4
#define _op_smooth_sub			5
#define _op_smooth_int				6

// Array Flags
#define _sdf_array_end				-1

// Data Type Flags
#define _sdf_entry_len					-2
#define _sdf_type							-3
#define _sdf_blending_type			-4
#define _sdf_pos_0						-5
#define _sdf_pos_1						-6
#define _sdf_pos_2						-7
#define _sdf_pos_3						-8
#define _sdf_scale_0						-9
#define _sdf_rotation					-10
#define _sdf_float_0						-11
#define _sdf_float_1						-12
#define _sdf_float_2						-13
#define _sdf_float_3						-14
#define _sdf_color_0						-15
#define _sdf_smoothing				-16
#define _sdf_pattern						-17

// Patterns
#define _pattern_none									0
#define _pattern_checkered						1
#define _pattern_checkered_filtered		2
#define _pattern_xor									3
#define _pattern_xor_filtered						4
#define _pattern_grid									5
#define _pattern_grid_filtered					6
#define _pattern_crosses							7
#define _pattern_crosses_filtered				8

#endregion
#region Math Functions

// Rounding
float round(float a) {
return floor(a+0.5);	
}

// Dot Products
float dot2( in vec2 v ) { return dot(v,v); }
float dot2( in vec3 v ) { return dot(v,v); }
float ndot( in vec2 a, in vec2 b ) { return a.x*b.x - a.y*b.y; }

// Rotate with Quaternion
vec3 rotate_quaternion(vec3 vec, vec4 q) {
	return vec + 2.0*cross(cross(vec, q.xyz ) + q.w*vec, q.xyz);
}

// Transform using Quaternion
vec3 transform_vertex(vec3 vec, vec3 pos, vec4 rot, vec3 scale) {
	vec3 vertex = rotate_quaternion(vec * scale, rot);
	return vertex + pos;
}

// Trianglular Modulation
vec3 tri( in vec3 x ) {
    vec3 h = fract(x/2.0)-0.5;
    return 1.0-2.0*abs(h);
}

#endregion
#region 2D to 3D Conversion Operations

// Revolution
vec2 op_revolution(vec3 pos, float revolve_amt) {
	return vec2( length(pos.xz) - revolve_amt, pos.y );
}

// TODO: 
// - Extrusion

// Not sure if this feature will come, we only use revolution for the egg shape.
// Would be cool to expand the list of primitives by having 2D shapes
// but we would have to require they be used with one of these operations
// We already have a pretty extensive list of primitives

#endregion
#region Deform Operations

// TODO:
// - Elongation
// - Rounding
// - Onion 
// - Displacement
// - Twist
// - Bend

#endregion
#region Blending Operations

// Union (Default)
float op_union( float d1, float d2 ) {
    return min( d1, d2 );
}

// Subtraction 
float op_sub( float d1, float d2 ) {
    return max(-d1,d2);
}

// Intersection
float op_int( float d1, float d2 ) {
    return max(d1,d2);
}

// Xor
float op_xor(float d1, float d2 ) {
    return max(min(d1,d2),-max(d1,d2));
}

// Smooth Union
float op_smooth_union( float d1, float d2, float k ) {
    float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) - k*h*(1.0-h);
}

// Smooth Subtraction
float op_smooth_sub( float d1, float d2, float k ) {
    float h = clamp( 0.5 - 0.5*(d2+d1)/k, 0.0, 1.0 );
    return mix( d2, -d1, h ) + k*h*(1.0-h);
}

// Smooth Intersection
float op_smooth_int( float d1, float d2, float k ){
    float h = clamp( 0.5 - 0.5*(d2-d1)/k, 0.0, 1.0 );
    return mix( d2, d1, h ) + k*h*(1.0-h);
}

// TODO:
// - Smooth Max
// - Max
// - Project Neo Repel
// - Project Neo Avoid

#endregion
#region Shape Distance Functions

// Sphere
float sdf_sphere( vec3 p, float s ) {
	return length(p)-s;
}

// Box
float sdf_box( vec3 p, vec3 b ) {
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

// Rounded Box
float sdf_round_box( vec3 p, vec3 b, float r ) {
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
}

// Box Frame
float sdf_box_frame( vec3 p, vec3 b, float e ) {
	p = abs(p  )-b;
	vec3 q = abs(p+e)-e;

	return min(min(
	length(max(vec3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
	length(max(vec3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)),
	length(max(vec3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0));
}

// Torus 
float sdf_torus( vec3 p, vec2 t ) {
    return length( vec2(length(p.xz)-t.x,p.y) )-t.y;
}

// Capped Torus
float sdf_capped_torus(in vec3 p, in vec2 sc, in float ra, in float rb) {
	p.x = abs(p.x);
	float k = (sc.y*p.x>sc.x*p.y) ? dot(p.xy,sc) : length(p.xy);
	return sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
}

// Link
float sdf_link( vec3 p, float le, float r1, float r2 ) {
	vec3 q = vec3( p.x, max(abs(p.y)-le,0.0), p.z );
	return length(vec2(length(q.xy)-r1,q.z)) - r2;
}

// Cone
float sdf_cone( vec3 p, vec2 c, float h ) {
	vec2 q = h*vec2(c.x/c.y,-1.0);
	vec2 w = vec2( length(p.xz), p.y );
	vec2 a = w - q*clamp( dot(w,q)/dot(q,q), 0.0, 1.0 );
	vec2 b = w - q*vec2( clamp( w.x/q.x, 0.0, 1.0 ), 1.0 );
	float k = sign( q.y );
	float d = min(dot( a, a ),dot(b, b));
	float s = max( k*(w.x*q.y-w.y*q.x),k*(w.y-q.y)  );
	return sqrt(d)*sign(s);
}

// Round Cone
float sdf_round_cone(vec3 p, vec3 a, vec3 b, float r1, float r2) {
	vec3  ba = b - a;
	float l2 = dot(ba,ba);
	float rr = r1 - r2;
	float a2 = l2 - rr*rr;
	float il2 = 1.0/l2;
	vec3 pa = p - a;
	float y = dot(pa,ba);
	float z = y - l2;
	float x2 = dot2( pa*l2 - ba*y );
	float y2 = y*y*l2;
	float z2 = z*z*l2;
	float k = sign(rr)*rr*rr*x2;
	if( sign(z)*a2*z2>k ) return  (sqrt(x2 + z2)        *il2 - r2);
	if( sign(y)*a2*y2<k ) return  (sqrt(x2 + y2)        *il2 - r1);
	                    return (sqrt(x2*a2*il2)+y*rr)*il2 - r1;
}

// Plane
float sdf_plane( vec3 p, vec3 n, float h ) {
	return dot(p,n) + h;
}

// Hex Prism
float sdf_hex_prism( vec3 p, vec2 h ) {
	const vec3 k = vec3(-0.8660254, 0.5, 0.57735);
	p = abs(p);
	p.xy -= 2.0*min(dot(k.xy, p.xy), 0.0)*k.xy;
	vec2 d = vec2(
	    length(p.xy-vec2(clamp(p.x,-k.z*h.x,k.z*h.x), h.x))*sign(p.y-h.x),
	    p.z-h.y );
	return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}

// Tri Prism
float sdf_tri_prism( vec3 p, vec2 h ) {
	vec3 q = abs(p);
	return max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
}

// Capsule
float sdf_capsule( vec3 p, vec3 a, vec3 b, float r ) {
	vec3 pa = p - a, ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length( pa - ba*h ) - r;
}

// Cylinder
float sdf_cylinder( vec3 p, vec3 a, vec3 b, float r ) {
    vec3  ba = b - a;
    vec3  pa = p - a;
    float baba = dot(ba,ba);
    float paba = dot(pa,ba);
    float x = length(pa*baba-ba*paba) - r*baba;
    float y = abs(paba-baba*0.5)-baba*0.5;
    float x2 = x*x;
    float y2 = y*y*baba;
    float d = (max(x,y)<0.0)?-min(x2,y2):(((x>0.0)?x2:0.0)+((y>0.0)?y2:0.0));
    return sign(d)*sqrt(abs(d))/baba; 
}

// Capped Cone
float sdf_capped_cone(vec3 p, vec3 a, vec3 b, float ra, float rb) {
	float rba  = rb-ra;
	float baba = dot(b-a,b-a);
	float papa = dot(p-a,p-a);
	float paba = dot(p-a,b-a)/baba;

	float x = sqrt( papa - paba*paba*baba );

	float cax = max(0.0,x-((paba<0.5)?ra:rb));
	float cay = abs(paba-0.5)-0.5;

	float k = rba*rba + baba;
	float f = clamp( (rba*(x-ra)+paba*baba)/k, 0.0, 1.0 );

	float cbx = x-ra - f*rba;
	float cby = paba - f;
    
	float s = (cbx < 0.0 && cay < 0.0) ? -1.0 : 1.0;
    
	return s*sqrt( min(cax*cax + cay*cay*baba,
	                    cbx*cbx + cby*cby*baba) );
}

// Solid Angle
float sdf_solid_angle(vec3 pos, vec2 c, float ra) {
	vec2 p = vec2( length(pos.xz), pos.y );
	float l = length(p) - ra;
	float m = length(p - c*clamp(dot(p,c),0.0,ra) );
	return max(l,m*sign(c.y*p.x-c.x*p.y));
}

// Cut Sphere
float sdf_cut_sphere( vec3 p, float r, float h ) {
  float w = sqrt(r*r-h*h);
  vec2 q = vec2( length(p.xz), p.y );
  float s = max( (h-r)*q.x*q.x+w*w*(h+r-2.0*q.y), h*q.x-w*q.y );
  float result = (s<0.0) ? length(q)-r :
         (q.x<w) ? h - q.y     :
                   length(q-vec2(w,h));
				   return result;
}

// Cut Hollow Sphere
float sdf_cut_hollow_sphere( vec3 p, float r, float h, float t ) {
	
	// sampling independent computations (only depend on shape)
	float w = sqrt(r*r-h*h);
  
	// sampling dependant computations
	vec2 q = vec2( length(p.xz), p.y );
	return ((h*q.x<w*q.y) ? length(q-vec2(w,h)) : 
	                        abs(length(q)-r) ) - t;
}

// Death Star
float sdf_death_star( vec3 p2, float ra, float rb, float d ) {
	float a = (ra*ra - rb*rb + d*d)/(2.0*d);
	float b = sqrt(max(ra*ra-a*a,0.0));
	vec2 p = vec2( p2.x, length(p2.yz) );
	if( p.x*b-p.y*a > d*max(b-p.y,0.0) )
	return length(p-vec2(a,b));
	else
	return max( (length(p)-ra),
	            -(length(p-vec2(d,0.0))-rb));
}

// Ellipsoid
float sdf_ellipsoid( vec3 p, vec3 r ) {
	float k0 = length(p/r);
	float k1 = length(p/(r*r));
	return k0*(k0-1.0)/k1;
}

// Rhombus
float sdf_rhombus( vec3 p, float la, float lb, float h, float ra ) {
	p = abs(p);
	vec2 b = vec2(la,lb);
	float f = clamp( (ndot(b,b-2.0*p.xz))/dot(b,b), -1.0, 1.0 );
	vec2 q = vec2(length(p.xz-0.5*b*vec2(1.0-f,1.0+f))*sign(p.x*b.y+p.z*b.x-b.x*b.y)-ra, p.y-h);
	return min(max(q.x,q.y),0.0) + length(max(q,0.0));
}

// Octahedron
float sdf_octahedron( vec3 p, float s ) {
	p = abs(p);
	float m = p.x+p.y+p.z-s;
	vec3 q;
	    if( 3.0*p.x < m ) q = p.xyz;
	else if( 3.0*p.y < m ) q = p.yzx;
	else if( 3.0*p.z < m ) q = p.zxy;
	else return m*0.57735027;
    
	float k = clamp(0.5*(q.z-q.y+s),0.0,s); 
	return length(vec3(q.x,q.y-s+k,q.z-k)); 
}

// Pyramid
float sdf_pyramid(vec3 position, float halfWidth, float halfDepth, float halfHeight) {
    position.y += halfHeight;
    position.xz = abs(position.xz);
    vec3 d1 = vec3(max(position.x - halfWidth, 0.0), position.y, max(position.z - halfDepth, 0.0));
    vec3 n1 = vec3(0.0, halfDepth, 2.0 * halfHeight);
    float k1 = dot(n1, n1);
    float h1 = dot(position - vec3(halfWidth, 0.0, halfDepth), n1) / k1;
    vec3 n2 = vec3(k1, 2.0 * halfHeight * halfWidth, -halfDepth * halfWidth);
    float m1 = dot(position - vec3(halfWidth, 0.0, halfDepth), n2) / dot(n2, n2);
    vec3 d2 = position - clamp(position - n1 * h1 - n2 * max(m1, 0.0), vec3(0.0), vec3(halfWidth, 2.0 * halfHeight, halfDepth));
    vec3 n3 = vec3(2.0 * halfHeight, halfWidth, 0.0);
    float k2 = dot(n3, n3);
    float h2 = dot(position - vec3(halfWidth, 0.0, halfDepth), n3) / k2;
    vec3 n4 = vec3(-halfWidth * halfDepth, 2.0 * halfHeight * halfDepth, k2);
    float m2 = dot(position - vec3(halfWidth, 0.0, halfDepth), n4) / dot(n4, n4);    
    vec3 d3 = position - clamp(position - n3 * h2 - n4 * max(m2, 0.0), vec3(0.0), vec3(halfWidth, 2.0 * halfHeight, halfDepth));
    float d = sqrt(min(min(dot(d1, d1), dot(d2, d2)), dot(d3, d3)));
    return max(max(h1, h2), -position.y) < 0.0 ? -d : d;
}


// Triangle 
float sdf_triangle( vec3 p, vec3 a, vec3 b, vec3 c ) {
	vec3 ba = b - a; vec3 pa = p - a;
	vec3 cb = c - b; vec3 pb = p - b;
	vec3 ac = a - c; vec3 pc = p - c;
	vec3 nor = cross( ba, ac );

	return sqrt(
	(sign(dot(cross(ba,nor),pa)) +
	sign(dot(cross(cb,nor),pb)) +
	sign(dot(cross(ac,nor),pc))<2.0)
	?
	min( min(
	dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
	dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
	dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0,1.0)-pc) )
	:
	dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}

// Quad
float sdf_quad( vec3 p, vec3 a, vec3 b, vec3 c, vec3 d ) {
	vec3 ba = b - a; vec3 pa = p - a;
	vec3 cb = c - b; vec3 pb = p - b;
	vec3 dc = d - c; vec3 pc = p - c;
	vec3 ad = a - d; vec3 pd = p - d;
	vec3 nor = cross( ba, ad );

	return sqrt(
	(sign(dot(cross(ba,nor),pa)) +
	sign(dot(cross(cb,nor),pb)) +
	sign(dot(cross(dc,nor),pc)) +
	sign(dot(cross(ad,nor),pd))<3.0)
	?
	min( min( min(
	dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
	dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
	dot2(dc*clamp(dot(dc,pc)/dot2(dc),0.0,1.0)-pc) ),
	dot2(ad*clamp(dot(ad,pd)/dot2(ad),0.0,1.0)-pd) )
	:
	dot(nor,pa)*dot(nor,pa)/dot2(nor) );
}

// Egg
float sdf_egg(vec3 p, float a, float b, float h) {
	vec3 p2 = p; p2.z = p.y; p2.y = p.z; // Z+ Up
	vec2 _p = op_revolution(p2, 0.0); // Make it 3D
    _p.x = abs(_p.x);
    float r = (a-b);
    h+=r;
    float l=(h*h - r*r)/(2.*r);  
    return ((_p.y <= 0.)          ? length(_p)   - a :
           ((_p.y-h)*l > _p.x*h)   ? length(_p-vec2(0.,h)) - ((a+l)-length(vec2(h,l))) : 
                                   length(_p+vec2(l,0.)) - (a+l));
}

#endregion
#region Colors

// Stores the Color determined by the Shape Distance Loop
vec3 nearest_color = vec3(0.0, 0.0, 0.0);

// Stores the Color but blended with other Shapes based on Distance
vec3 nearest_color_blended = vec3(0.0, 0.0, 0.0);

#endregion
#region Patterns

// Checkered
float checkers( in vec3 p ) {
    vec3 q = floor(p);
    return mod(q.x + q.y + q.z, 2.0);
}

// Checkered (Filtered)
float checkers_filtered( in vec3 p, in vec3 ddx, in vec3 ddy ) {
    vec3 w = max(abs(ddx), abs(ddy)) + 0.001; 
    vec3 i = (tri(p + 0.5 * w) - tri(p - 0.5 * w)) / w;   
    return 0.5 - 0.5 * i.x * i.y * i.z;            
}

// Xor
float xor_pattern( in vec2 pos ) {
    float xor = 0.0;
    for( int i=0; i<8; i++ ) {
        xor += mod( floor(pos.x)+floor(pos.y), 2.0 );

        pos *= 0.5;
        xor *= 0.5;
    }
    return xor;
}

// Xor (Filtered)
float xor_pattern_filtered( in vec2 pos, in vec2 ddx, in vec2 ddy ) {
    float xor = 0.0;
    for( int i=0; i<8; i++ ) {
        vec2 w = max(abs(ddx), abs(ddy)) + 0.01;  
        vec2 f = 2.0*(abs(fract((pos-0.5*w)/2.0)-0.5)-abs(fract((pos+0.5*w)/2.0)-0.5))/w;
        xor += 0.5 - 0.5*f.x*f.y;     
        ddx *= 0.5;
        ddy *= 0.5;
        pos *= 0.5;
        xor *= 0.5;
    }
    return xor;
}

// Grid
float grid( in vec2 p ) {
    vec2 i = step( fract(p), vec2(1.0/grid_thickness_ratio) );
    return (1.0-i.x)*(1.0-i.y); 
}

//Grid (Filtered)
float grid_filtered( in vec2 p, in vec2 ddx, in vec2 ddy ) {
    vec2 w = max(abs(ddx), abs(ddy)) + 0.01;
    vec2 a = p + 0.5*w;                        
    vec2 b = p - 0.5*w;           
    vec2 i = (floor(a)+min(fract(a)*grid_thickness_ratio,1.0)-
              floor(b)-min(fract(b)*grid_thickness_ratio,1.0))/(grid_thickness_ratio*w);
    return (1.0-i.x)*(1.0-i.y);
}

#endregion
#region Shape Distance Loop

// Avoid Excess Calculations in Subsequent Rays 
bool distance_only = false;

// Return distance to the closest SDF in the Array
float get_dist(vec3 p) {
	
	//Store Distance Traveled
	float sum_dist = 0.0;
	
	// Minimum Distance
	float min_dist = max_dist;
		
	// Step For
	int loop_step = 0;
			
	// Loop through All Shapes in the Input Array
	for (int i = array_header_size; i < max_array_length; i+= loop_step) {
	
		// Distance
		float shape_dist = 0.0;
	
		// Array Position
		int array_pos = i;
		
		// Store Number of Array Entries this Shape Uses
		int shape_array_entries= int(sdf_input_array[array_pos]);

		// Detect End of Input Array Flag
		if (shape_array_entries == _sdf_array_end) {
			break;
		}
			
		#region Store Shape Data
		
		// All Possible Data Types
		int sdf_type = _sdf_sphere;
		int blending_type = _op_union;
		int pattern_type = _pattern_none;
		float pattern_scale = 0.1;
		float pattern_alpha = 1.0;
		vec3 pos_0 = vec3(0.0, 0.0, 0.0);
		vec3 pos_1 = vec3(0.0, 0.0, 0.0);
		vec3 pos_2 = vec3(0.0, 0.0, 0.0);
		vec3 pos_3 = vec3(0.0, 0.0, 0.0);
		vec3 scale_0 = vec3(0.0, 0.0, 0.0);
		vec4 rotation = vec4(0.0, 0.0, 0.0, 1.0);
		float float_0 = 0.0;
		float float_1 = 0.0;
		float float_2 = 0.0;
		float float_3 = 0.0;
		vec3 color_0 = vec3(0.0, 0.0, 0.0);
		float blend_strength = 0.0;
		vec3 rotated_p = p;
		bool has_rotation = false;
		
		#endregion
		#region Read Through Entry Data
		
		int j = 1; 
		while(j < shape_array_entries) {
			
			// Amount to Step Forward after Reading
			int read_steps = 0;
			
			// Current Positon
			int read_pos = array_pos + j;
			
			// Entry Value
			int flag_value = int(sdf_input_array[read_pos]);
			
			if (flag_value >= -9) {
				if (flag_value == _sdf_type) { // SDF Type
					sdf_type = int(sdf_input_array[read_pos + 1]);
					read_steps = 2;
				} else if (flag_value == _sdf_blending_type) { // Intersection Type
					blending_type = int(sdf_input_array[read_pos + 1]);
					read_steps = 2;
				} else if (flag_value == _sdf_pos_0) { // Position 0
					pos_0 = vec3(sdf_input_array[read_pos + 1], 
											 sdf_input_array[read_pos + 2], 
											 sdf_input_array[read_pos + 3]);
					read_steps = 4;
				} else if (flag_value == _sdf_pos_1) { // Position 1
					pos_1 = vec3(sdf_input_array[read_pos + 1], 
											 sdf_input_array[read_pos + 2], 
											 sdf_input_array[read_pos + 3]);
					read_steps = 4;
				} else if (flag_value == _sdf_pos_2) { // Position 2
					pos_2 = vec3(sdf_input_array[read_pos + 1], 
											 sdf_input_array[read_pos + 2], 
											 sdf_input_array[read_pos + 3]);
					read_steps = 4;
				} else if (flag_value == _sdf_pos_3) { // Position 3
					pos_3 = vec3(sdf_input_array[read_pos + 1], 
											 sdf_input_array[read_pos + 2], 
											 sdf_input_array[read_pos + 3]);
					read_steps = 4;
				} else if (flag_value == _sdf_scale_0) { // Scale 0
					scale_0 = vec3(sdf_input_array[read_pos + 1], 
												sdf_input_array[read_pos + 2], 
												sdf_input_array[read_pos + 3]);
					read_steps = 4;
				}
			} else { 
				if (flag_value == _sdf_rotation) { // Rotation
					rotation = vec4(sdf_input_array[read_pos + 1], 
												  sdf_input_array[read_pos + 2], 
												  sdf_input_array[read_pos + 3],
												  sdf_input_array[read_pos + 4]);
					rotated_p = transform_vertex(p - pos_0, pos_0, normalize(rotation), vec3(1.0, 1.0, 1.0));
					has_rotation = true;
					read_steps = 5;
				} else if (flag_value == _sdf_float_0) { // Float 0
					float_0 = sdf_input_array[read_pos + 1];
					read_steps = 2;
				} else if (flag_value == _sdf_float_1) { // Float 1
					float_1 = sdf_input_array[read_pos + 1];
					read_steps = 2;
				} else if (flag_value == _sdf_float_2) { // Float 2
					float_2 = sdf_input_array[read_pos + 1];
					read_steps = 2;
				} else if (flag_value == _sdf_float_3) { // Float 3
					float_3 = sdf_input_array[read_pos + 1];
					read_steps = 2;
				} else if (flag_value == _sdf_color_0) { // Color 0
					color_0 = vec3(sdf_input_array[read_pos + 1], 
												sdf_input_array[read_pos + 2], 
												sdf_input_array[read_pos + 3]);
					read_steps = 4;
				} else if (flag_value ==  _sdf_smoothing) { // Smoothing
					blend_strength = sdf_input_array[read_pos + 1];
					read_steps = 2;
				} else if (flag_value ==  _sdf_pattern) { // Patterns
					pattern_type = int(sdf_input_array[read_pos + 1]);
					pattern_scale = sdf_input_array[read_pos + 2];
					pattern_alpha = sdf_input_array[read_pos + 3];
					read_steps = 4;
				}
			}
			
			// Step Forward through Data
			j += read_steps;

		}		
		
		#endregion			
		#region Shape Distance
		
		// Apply Rotation
		vec3 shape_p = p;
		if (has_rotation) {
			shape_p = rotated_p;
		}
		
		if (sdf_type <= 13) {
			if (sdf_type <= 6) {
				if (sdf_type <= 3) {
					if (sdf_type == _sdf_sphere) { // Sphere
						shape_dist = sdf_sphere(shape_p - pos_0, float_0);
					} else if (sdf_type == _sdf_box) { // Box
						shape_dist = sdf_box(shape_p - pos_0, scale_0);
					} else if (sdf_type == _sdf_round_box) { // Round Box
						shape_dist = sdf_round_box(shape_p - pos_0, scale_0, float_0);
					} else if (sdf_type == _sdf_box_frame) { // Box Frame
						shape_dist = sdf_box_frame(shape_p - pos_0, scale_0, float_0);
					}
				} else {
					if (sdf_type == _sdf_torus) { // Torus
						shape_dist = sdf_torus(shape_p - pos_0, vec2(float_0, float_1));
					} else if (sdf_type == _sdf_capped_torus) { // Capped Torus
						shape_dist = sdf_capped_torus(shape_p - pos_0, vec2(sin(float_0), cos(float_0)), float_1, float_2);
					} else if (sdf_type == _sdf_link) { // Link
						shape_dist = sdf_link(shape_p - pos_0, float_0, float_1, float_2);
					} 
				}
			} else {
				if (sdf_type <= 10) {
					if (sdf_type == _sdf_cone) { // Cone
						shape_dist = sdf_cone(shape_p - pos_0, vec2(sin(float_0), cos(float_0)), float_1);
					} else if (sdf_type == _sdf_round_cone) { // Round Cone
						shape_dist = sdf_round_cone(shape_p, pos_0, pos_1, float_0, float_1);
					} else if (sdf_type == _sdf_plane) { // Plane
						shape_dist = sdf_plane(shape_p - pos_0, normalize(pos_1), float_0);
					} else if (sdf_type == _sdf_hex_prism) { // Hex Prism
						shape_dist = sdf_hex_prism(shape_p - pos_0, vec2(float_0, float_1));
					}
				} else {
					if (sdf_type == _sdf_tri_prism) { // Tri Prism 
						shape_dist = sdf_tri_prism(shape_p - pos_0, vec2(float_0, float_1));	
					} else if (sdf_type == _sdf_capsule) { // Capsule
						shape_dist = sdf_capsule(shape_p, pos_0, pos_1, float_0);
					} else if (sdf_type == _sdf_cylinder) { // Cylinder
						shape_dist = sdf_cylinder(shape_p, pos_0, pos_1, float_0);
					}
				}
			}
		} else {
			if (sdf_type <= 19) {
				if (sdf_type <= 16) {
					if (sdf_type == _sdf_capped_cone) { // Capped Cone
						shape_dist = sdf_capped_cone(shape_p, pos_0, pos_1, float_0, float_1);
					} else if (sdf_type == _sdf_solid_angle) { // Solid Angle
						shape_dist = sdf_solid_angle(shape_p - pos_0, vec2(sin(float_0), cos(float_0)), float_1);
					} else if (sdf_type == _sdf_cut_sphere) { // Cut Sphere
						shape_dist = sdf_cut_sphere(shape_p - pos_0, float_0, float_1);
					}
				} else {
					if (sdf_type == _sdf_cut_hollow_sphere) { // Cut Hollow Sphere
						shape_dist = sdf_cut_hollow_sphere(shape_p - pos_0, float_0, float_1, float_2);
					} else if (sdf_type == _sdf_death_star) { // Death Star
						shape_dist = sdf_death_star(shape_p - pos_0, float_0, float_1, float_2);
					} else if (sdf_type == _sdf_ellipsoid) { // Ellipsoid
						shape_dist = sdf_ellipsoid(shape_p - pos_0, scale_0);
					}
				}
			} else {
				if (sdf_type <= 22) {
					if (sdf_type == _sdf_rhombus) { // Rhombus
						shape_dist = sdf_rhombus(shape_p - pos_0, scale_0.x, scale_0.y, scale_0.z, float_0);
					} else if (sdf_type == _sdf_octahedron) { // Octahedron
						shape_dist = sdf_octahedron(shape_p - pos_0, float_0);
					} else if (sdf_type == _sdf_pyramid) { // Pyramid
						shape_dist = sdf_pyramid(shape_p - pos_0, scale_0.x / 2.0, scale_0.y / 2.0, scale_0.z / 2.0);
					}
				} else {
					if (sdf_type == _sdf_triangle) { // Triangle
						shape_dist = sdf_triangle(shape_p, pos_0, pos_1, pos_2);
					} else if (sdf_type == _sdf_quad) { // Quad
						shape_dist = sdf_quad(shape_p, pos_0, pos_1, pos_2, pos_3);
					} else if (sdf_type == _sdf_egg) { // Egg
						shape_dist = sdf_egg(shape_p - pos_0, float_0, float_1, float_2);
					}
				}
			}
		}
		//Cannot combine this, no idea why, causes it to fail to compile
		
		
		#endregion
		#region Patterns
		
		if (pattern_type != _pattern_none && !distance_only) {
			if (pattern_type == _pattern_checkered) { // Checkered
				color_0 = mix(color_0, color_0 * checkers(p * pattern_scale), pattern_alpha);
			} else if (pattern_type == _pattern_checkered_filtered) { // Checkered (Filtered)
				// I will come back to filtered patterns, eventually.
				// Tried to implement without fully understanding.
				// This currently draws the pattern but without any filtering.
				//vec3 ddx_uvw = vec3(dFdx( (v_vScreenPos.x + 1.0) / 2.0 )); 
				//vec3 ddy_uvw = vec3(dFdy( (v_vScreenPos.y + 1.0) / 2.0 )); 
				//color_0 = mix(color_0, color_0 * checkers_filtered(p * pattern_scale, ddx_uvw, ddy_uvw), pattern_alpha);	
			} else if (pattern_type == _pattern_xor) { // Xor
				color_0 = mix(color_0, color_0 * xor_pattern(p.xy * pattern_scale * 200.0), pattern_alpha);
			} else if (pattern_type == _pattern_xor_filtered) { // Xor (Filtered)
				/////////////////////////////////////////////////////////////////////////////
			} else if (pattern_type == _pattern_grid) { // Grid
				color_0 = mix(color_0, color_0 * grid(p.xy * pattern_scale), pattern_alpha);
			} else if (pattern_type == _pattern_grid_filtered) { // Grid (Filtered)
				/////////////////////////////////////////////////////////////////////////////
			}
			
		}

		
		#endregion
		#region Color
		
		// Diffuse
		if (shape_dist < min_dist) {
			nearest_color = color_0;
		}	
		
		// Update Blended Color
		float inv_dist = 1. / (1. + shape_dist);
		sum_dist += inv_dist;
		nearest_color_blended += color_0 * inv_dist;
		
		#endregion
		#region Blend Operation 
		
		if (blending_type == _op_union) { // Union
			min_dist = op_union(min_dist, shape_dist);
		} else if (blending_type == _op_sub) { // Subtraction
			min_dist = op_sub(min_dist, shape_dist);	
		} else if (blending_type == _op_int) { // Intersection
			min_dist = op_int(min_dist, shape_dist);	
		} else if (blending_type == _op_int) { // Xor
			min_dist = op_xor(min_dist, shape_dist);	
		} else if (blending_type == _op_smooth_union) { // Smooth Union
			min_dist = op_smooth_union(min_dist, shape_dist, blend_strength);
		} else if (blending_type == _op_smooth_sub) { // Smooth Subtraction
			min_dist = op_smooth_sub(min_dist, shape_dist, blend_strength);
		} else if (blending_type == _op_smooth_int) { // Smooth Intersection
			min_dist = op_smooth_int(min_dist, shape_dist, blend_strength);
		}
					
		#endregion

		// Skip Forward in Array
		loop_step = shape_array_entries + 1; 
		// Plus one so we move to the next shape
		
	}
	
	// Average Blended Color
	nearest_color_blended /= sum_dist;
	
	// Result
	return min_dist;
}

#endregion 
#region Ray March Loop

// Stores the Total Steps taken across all Rays
int total_steps = 0;

// Return distance to the nearest SDF and the amount of steps taken
vec2 ray_march(vec3 ro, vec3 rd) {
	
	// Store Total Distance Traveled
	float d = 0.0;
		
	// Store Total Steps Traveled
	float steps = float(max_steps);
	
	//Ray March
	for (int i = 0; i < max_steps; i ++) {
		
		// Increment Ray in in the Ray Direction
		vec3 p = ro + rd * d;

		// Reset Color for Check
		nearest_color = vec3(0.0, 0.0, 0.0);
		nearest_color_blended = vec3(0.0, 0.0, 0.0);
		
		// Loop Through Shape Array
		float dist = get_dist(p);
		
		// Add Distance traveled to Total
		d += dist;
		
		// End Ray if Max Distance Traveled or a Shape was Hit
		if (d > max_dist || dist < surf_dist) {
			
			// Set Steps Traveled
			steps = float(i);
			
			// End Loop
			break;
			
		}
		
	}
	
	// Add Steps to Total
	total_steps += int(steps);
	
	// Result
	return vec2(max(d, 1.), steps);
}

#endregion
#region Normal

// Calculate Normal by Performing Multiple Raymarches
vec3 get_normal(vec3 p) {
    float d = get_dist(p);
    vec2 e = vec2(0.005, 0);
    vec3 n = d - vec3(get_dist(p-e.xyy), get_dist(p-e.yxy), get_dist(p-e.yyx));
    return normalize(n);
}

#endregion
#region Shadows

// https://iquilezles.org/articles/rmshadows
float calculate_soft_shadows( in vec3 ro, in vec3 rd, in float mint, in float tmax, int technique ) {
	float res = 1.0;
    float t = mint;
    float ph = 1e10; // big, such that y = 0 on the first iteration
    
    for( int i=0; i<32; i++ ) {
		float h = get_dist( ro + rd*t );

        // traditional technique
        if( technique==0 ) {
        	res = min( res, 10.0*h/t );
        } else {  // improved technique
            // use this if you are getting artifact on the first iteration, or unroll the
            // first iteration out of the loop
            float y = (i==0) ? 0.0 : h*h/(2.0*ph); 

           // float y = h*h/(2.0*ph);
            float d = sqrt(h*h-y*y);
            res = min( res, 14.0*d/max(0.0,t-y) );
            ph = h;
        }
        
        t += h;
        
        if( res<0.0001 || t>tmax ) break;
        
    }
    res = clamp( res, 0.0, 1.0 );
    return res*res*(3.0-2.0*res);
}


#endregion
#region Ambient Occlusion

// https://iquilezles.org/articles/nvscene2008/rwwtt.pdf
float calculate_ao( in vec3 pos, in vec3 nor ) {
	float occ = 0.0;
    float sca = 1.0;
    for( int i=0; i<5; i++ ) {
        float h = 0.01 + 0.12*float(i)/4.0;
        float d = get_dist( pos + h * nor );
        occ += (h - d)*sca;
        sca *= 0.95;
        if( occ > 0.35 ) break;
    }
    return clamp( 1.0 - 3.0*occ, 0.0, 1.0 ) * (0.5+0.5*nor.y);
}

#endregion
#region Fog

vec3 apply_fog(vec3 col, float dist) {
    float fog_amount = max(min(pow((dist / fog_dist) + 0.5, 5.0), 1.0), 0.0);
    return mix(col, fog_color, fog_amount);
}

#endregion
#region View & Projection 

// Camera Position
vec3 cam_pos = -(view_mat[3] * view_mat).xyz;

// FOV Aspect
vec2 fov_aspect = 1. / vec2(proj_mat[0].x, proj_mat[1].y);

// View Projection
mat4 view_proj = proj_mat * view_mat;

// View Z Position
vec4 view_z = vec4(view_mat[0].z, view_mat[1].z, view_mat[2].z, view_mat[3].z);

#endregion
#region Debug

vec3 shade_steps(int n) {
    const vec3 a = vec3(97, 130, 234) / vec3(255.0);
    const vec3 b = vec3(220, 94, 75) / vec3(255.0);
    const vec3 c = vec3(221, 220, 219) / vec3(255.0);
    float t = float(n) / float(max_steps);   
    if (t < 0.5)
        return mix(a, c, 2.0 * t);
    else
        return mix(c, b, 2.0 * t - 1.0);
}

#endregion
#region Main

void main() {
	int stack[32];
	// Ray Origin and Ray Direction
	vec3 ro;
	vec3 rd; 
	if (proj_mat[3].w != 0.0) { // Orthographic
		ro = cam_pos +
		vec3(view_mat[0].x, view_mat[1].x, view_mat[2].x) * -v_vScreenPos.x / proj_mat[0].x +
		vec3(view_mat[0].y, view_mat[1].y, view_mat[2].y) * -v_vScreenPos.y / proj_mat[1].y;
		rd = vec3(view_z.xyz);
	} else{ // Perspective
		ro = cam_pos;
		rd = normalize((vec4(v_vScreenPos * -fov_aspect, 1., 0.) * view_mat).xyz);
	}
	
	// Cast Ray
	vec2 ray = ray_march(ro, rd);
	
	// Discard if the Ray Misses
	if (ray.x >= max_dist) {discard;}
	
	// Fragment Position
	vec3 frag_pos = ro + rd * ray.x;

	// Store Frag Color
	vec3 diffuse_color = nearest_color;
	vec3 blended_color = nearest_color_blended;
	vec3 frag_color = nearest_color_blended; // mix(diffuse_color, blended_color, color_blending_amount) ??? 
	
	// Avoid Excess Calculations in Subsequent Rays
	distance_only = true;
	
	// Vectors
	vec3 l = -light_dir;
	vec3 n = get_normal(frag_pos);
	vec3 ref_dir = normalize(reflect(rd, n));
	
	// Gamma Correction
	frag_color	= pow(frag_color, vec3(0.4545));
	
	#region Effects
	
	// We want to apply effects even with debug enabled because the debug mode
	// should reflect the extra steps taken with effects enabled
	
	// Shadows
	if (shadows_enabled) {
		float shadow_str = calculate_soft_shadows(ro + rd * ray.x, l, 0.1, 25.0, 0);
		//frag_color *= shadow_str;
		frag_color = mix(frag_color, frag_color * shadow_str, shadow_alpha);
	}
	
	// Ambient Occlusion
	if (ambient_occlusion_enabled) {
		float ao_str = calculate_ao(ro + rd * ray.x, n);
		frag_color = mix(frag_color, frag_color * ao_str, ao_alpha);
	}
	
	// Fog
	if (fog_enabled) {
		frag_color = apply_fog(frag_color, ray.x);
	}
	
	// Specular
	if (specular_enabled)  {
				 
		// Calculate specular component with pow for shininess
		vec3 specular = vec3(0.5) * pow(max(dot(ref_dir, l), 0.0), 10.0) + frag_color * mix(0.2, 1.2, max(0.0, dot(l, n)));
	
		// Blend the final color based on the ray position and max steps
		frag_color = mix(frag_color * 0.2, specular, (1.0 - pow(ray.y / float(max_steps), 2.0)));
		
	}
	
	#endregion
	#region Render Style
	
	// Set color based on the amount of steps taking by the ray
	if (debug_enabled) {
		frag_color = shade_steps(total_steps);
	} else {
			
		// Default Shading is just nearest_color + effects so no need for another conditional here.
		
		// Toon Shading
		if (render_style == _sdf_toon_shading) { 
		//if (v_vScreenPos.x >= 0.0) { 
			float average_brightness = (frag_color.r + frag_color.b + frag_color.g) / 3.0;
			vec3 world_n = normalize(world_mat * vec4(n, 1.0)).xyz;
			float ndotl = max(dot(world_n, l), 0.);
			vec2 toon_ramp_uv = vec2(mix(average_brightness, ndotl, 0.6), 0.0);
			vec3 toon_ramp = texture2D(tex_toonramp, toon_ramp_uv).rgb;
			float brightness_adjustment = (toon_ramp.r + toon_ramp.b + toon_ramp.g) / 3.0;
			frag_color = nearest_color * brightness_adjustment;
		}
		
	}
	
	// Set Fragment Color
	gl_FragColor = vec4(frag_color, 1.0);
	
	#endregion
	#region Depth
		
	// Set The Depth of The Fragment
	#ifdef GL_EXT_frag_depth
		vec4 P = view_proj * vec4(frag_pos, 1.);
		gl_FragDepthEXT = P.z / P.w;	
	#endif
	
	#endregion
	
}

#endregion