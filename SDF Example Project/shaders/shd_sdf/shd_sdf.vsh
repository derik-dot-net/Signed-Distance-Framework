#region Attributes 

attribute vec2 in_Position;

#endregion
#region Varyings

varying vec2 v_vScreenPos;

#endregion
#region Main

void main() {
    gl_Position = vec4(in_Position, 1., 1.);
	v_vScreenPos = in_Position;
}

#endregion