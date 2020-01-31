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
	
	drawLambert_multi_fs4x.glsl
	Draw Lambert shading model for multiple lights.
*/

#version 410
//https://learnopengl.com/Lighting/Basic-Lighting
//http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/
//http://www.opengl-tutorial.org/beginners-tutorials/tutorial-8-basic-shading/#the-diffuse-part

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!

const int NUM_LIGHTS = 4;

uniform sampler2D uTex_dm;
uniform int uLightCt;
uniform float uLightSz[NUM_LIGHTS];
uniform float uLightSzInvSq[NUM_LIGHTS];
uniform vec4 uLightPos[NUM_LIGHTS];
uniform vec4 uLightCol[NUM_LIGHTS];

in vec4 outTexCoord;
in vec4 outNormal;
in vec4 viewPos;

out vec4 rtFragColor;

void main()
{
	vec4 texD = texture(uTex_dm, outTexCoord.xy);
	
	vec4 outColor;

	for (int i = 0; i < uLightCt; ++i)
	{
		//Calculate normals
		vec4 lightNormal = normalize(uLightPos[i] - viewPos);
		vec4 surfaceNormal = normalize(outNormal);

		//Lighting calculations
		float diffuseCoeff = max(0.0, dot(surfaceNormal, lightNormal));
		vec4 lambert = diffuseCoeff * texD;

		//Add lighting and color to fragment
		outColor += lambert * uLightCol[i];
	}

	// Output calculated sum of colors
	rtFragColor = outColor;
}

