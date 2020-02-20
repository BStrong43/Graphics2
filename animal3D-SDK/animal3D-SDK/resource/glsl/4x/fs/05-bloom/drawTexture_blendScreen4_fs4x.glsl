/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawTexture_blendScreen4_fs4x.glsl
	Draw blended sample from multiple textures using screen function.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare additional texture uniforms
//	2) implement screen function with 4 inputs
//	3) use screen function to sample input textures

in vec2 vTexCoord; // Step 2

uniform sampler2D uTex_dm;
uniform sampler2D uImage00;
uniform sampler2D uImage01;
out vec4 rtFragColor;

vec4 screen(vec4 a, vec4 b) 
{
	return 1.0 - (1.0 - a) * (1.0 - b);
}

void main()
{
	vec4 tex1 = texture(uImage00, vTexCoord);
	vec4 tex2 = texture(uTex_dm, vTexCoord);
	vec4 texBlend = 1.0 - (1.0 - tex1) * (1.0 - tex2);
	rtFragColor = texBlend;
}