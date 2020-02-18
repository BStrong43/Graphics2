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
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints
in vec2 vTexCoord; // Step 2 - inbound texture coordinate
in vec4 viewPos;
in vec4 vModelViewNorm;


out vec4 rtFragColor;

uniform sampler2D uTex_dm; // Step 1 - found in a3_DemoState_loading

void main()
{
	//https://en.wikibooks.org/wiki/GLSL_Programming/Unity/Toon_Shading
	
	float UnlitOutlineThickness = 0.1;
	float LitOutlineThickness = 0.4;
	vec4 lightDirection;
	vec3 frag = texture2D(uTex_dm, vTexCoord).xyz;
	vec3 outLineColor = vec3(0.0,0.0,0.0);//Black outline

	//calc view direction
	vec4 viewDirection = normalize(vModelViewNorm - viewPos);
	//calc surface normal
	vec4 normalDirection = normalize(vModelViewNorm);
	
	//compare angle of view and model normal
	if(dot(viewDirection, normalDirection) < mix(UnlitOutlineThickness, LitOutlineThickness, max(0.0, dot(normalDirection, viewDirection))))
	{
		frag = outLineColor;
	}

	rtFragColor = vec4(frag, 1.0);
}