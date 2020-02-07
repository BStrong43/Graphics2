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
	
	drawPhong_multi_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variables for textures; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

const int NUM_LIGHTS = 4;

in vec4 outTexCoord;
in vec4 outNormal;
in vec4 viewPos;

uniform int uLightCt;
uniform vec4 uLightPos[NUM_LIGHTS];
uniform vec4 uLightCol[NUM_LIGHTS];
	
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

layout(location = 0) out vec4 rtFragColor;
layout(location = 1) out vec4 rtViewPos;
layout(location = 2) out vec4 rtViewNormal;
layout(location = 3) out vec4 rtTexCoord;
layout(location = 4) out vec4 rtDiffuseMap;
layout(location = 5) out vec4 rtSpecularMap;
layout(location = 6) out vec4 rtDiffuseLight;
layout(location = 7) out vec4 rtSpecularLight;

void main()
{
	
	vec4 texD = texture2D(uTex_dm, outTexCoord.xy);
	vec4 texS = texture2D(uTex_sm, outTexCoord.xy);
	vec4 surfaceNormal = normalize(outNormal);
	vec4 outColor;
	vec4 diffuseLight;
	vec4 specLight;

	for (int i = 0; i < uLightCt; ++i)
	{
		//Calculate Normals
		vec4 lightNormal = normalize(uLightPos[i] - viewPos);
		
		//Lighting calculations
		vec4 reflection = max(0.0, dot(surfaceNormal, lightNormal)) * surfaceNormal - lightNormal;
		vec4 diffuseCoeff = max(0.0, dot(surfaceNormal, lightNormal)) * texD;
		vec4 specularCoeff = pow(max(0.0, dot(-normalize(viewPos), reflection)), 128) * texS;

		//add lighting to fragment
		outColor += (diffuseCoeff + specularCoeff) * uLightCol[i];
		diffuseLight += diffuseCoeff;
		specLight += specularCoeff;
	}

	rtFragColor = outColor;
	rtTexCoord = outTexCoord;
	rtViewPos = viewPos;
	rtViewNormal = surfaceNormal;
	rtDiffuseMap = texD;
	rtDiffuseLight = diffuseLight;
	rtSpecularMap = texS;
	rtSpecularLight = specLight;
}