#region Attributes 

attribute vec2 in_Position;

#endregion
#region Varyings

varying vec2 v_vScreenPos;
varying mat4 world_mat;

#endregion
#region Main

void main() {
    gl_Position = vec4(in_Position, 1., 1.);
	v_vScreenPos = in_Position;
	world_mat = gm_Matrices[MATRIX_WORLD];
}

#endregion