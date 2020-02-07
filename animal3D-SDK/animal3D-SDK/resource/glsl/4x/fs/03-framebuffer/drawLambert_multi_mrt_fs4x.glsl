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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

const int NUM_LIGHTS = 4;

in vec4 outNormal;
in vec4 viewPos;
in vec2 vTexCoord;

uniform sampler2D uTex_dm;
uniform int uLightCt;
uniform vec4 uLightPos[NUM_LIGHTS];
uniform vec4 uLightCol[NUM_LIGHTS];

layout (location = 0) out vec4 rtFragColor;
layout (location = 1) out vec4 rtViewPos;
layout (location = 2) out vec4 rtViewNormal;
layout (location = 3) out vec4 rtTexCoord;
layout (location = 4) out vec4 rtDiffuseMap;
layout (location = 6) out vec4 rtDiffuseLightTotal;

void main()
{
	vec4 outColor;
	vec4 litTotal;
	vec4 surfaceNormal = normalize(outNormal);
	vec4 tex = texture(uTex_dm, vTexCoord.xy);

	for (int i = 0; i < uLightCt; ++i)
	{
		//Calculate light direction
		vec4 lightNormal = normalize(uLightPos[i] - viewPos);
		//Lighting calculations
		float diffuseCoeff = max(0.0, dot(surfaceNormal, lightNormal));

		vec4 lambert = diffuseCoeff * tex;
		
		litTotal += diffuseCoeff;
		//Add lighting and color to fragment
		outColor += lambert * uLightCol[i];
	}

	rtFragColor = outColor;
	rtTexCoord = vec4(vTexCoord, 0.0, 0.0);
	rtViewPos = viewPos;
	rtViewNormal = surfaceNormal;
	rtDiffuseMap = tex;
	rtDiffuseLightTotal = litTotal;
}