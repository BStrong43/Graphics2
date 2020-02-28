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
	
	drawPhong_multi_deferred_fs4x.glsl
	Draw Phong shading model by sampling from input textures instead of 
		data received from vertex shader.
*/

#version 410

#define MAX_LIGHTS 4

// ****TO-DO: 
//	0) copy original forward Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare light data as uniform block
//	3) replace geometric information normally received from fragment shader 
//		with samples from respective g-buffer textures; use to compute lighting
//			-> position calculated using reverse perspective divide; requires 
//				inverse projection-bias matrix and the depth map
//			-> normal calculated by expanding range of normal sample
//			-> surface texture coordinate is used as-is once sampled

in vbLightingData {
	vec4 vViewPosition;
	vec4 vViewNormal;
	vec4 vTexcoord;
	vec4 vBiasedClipCoord;
};

uniform sampler2D uImage00;
uniform sampler2D uImage01; 
uniform sampler2D uImage02;
uniform sampler2D uImage03;
uniform sampler2D uImage04;
uniform sampler2D uImage05;

uniform mat4 uPB_inv;

uniform int uLightCt;
uniform vec4 uLightPos[MAX_LIGHTS];
uniform vec4 uLightCol[MAX_LIGHTS];
uniform float uLightSz[MAX_LIGHTS];

layout (location = 0) out vec4 rtFragColor;
layout (location = 4) out vec4 rtDiffuseMapSample;
layout (location = 5) out vec4 rtSpecularMapSample;
layout (location = 6) out vec4 rtDiffuseLightTotal;
layout (location = 7) out vec4 rtSpecularLightTotal;

//Forward Declarations
float getDiffuseCoeff(vec4 surfaceNormal, vec4 lVecNorm);
float getSpecularCoeff(vec4 surfaceNormal, vec4 lVecNorm, vec4 viewPosition);

void main()
{
	//output variables
	vec4 phong = vec4(0.0);
	float dTotal = 0.0;
	float Total = 0.0;

	//info from gb
	vec4 gbPos = texture(uImage01, vTexcoord.xy);
	vec4 gbNorm = texture(uImage02, vTexcoord.xy);
	vec2 gbTexCoord = texture(uImage03, vTexcoord.xy).xy;
 	
	//reverse perspective divide
	gbPos *= uPB_inv;
	gbPos /= gbPos.w;
	gbNorm = (gbNorm - 0.5) * 2.0;
	
	//samples
	vec4 diffuseSample = texture(uImage04, gbTexCoord);
	vec4 specularSample = texture(uImage05, gbTexCoord);

	// Calculate surface normal (optimized, not in every loop)
	vec4 surfaceNormal = normalize(gbNorm);

	//Do your thing phong
	for(int i = 0; i < uLightCt; ++i)
	{
		vec4 lVecNorm = normalize(vec4(vec3(uLightPos[i] - gbPos), 1.0));
		//Diffuse Calc
		float diffuseCoeff = getDiffuseCoeff(surfaceNormal, lVecNorm);
		dTotal += diffuseCoeff;
		vec4 diffuse = diffuseCoeff * diffuseSample;
		//spec calc
		float specularCoeff = getSpecularCoeff(surfaceNormal, lVecNorm, gbPos);
		Total += specularCoeff;
		vec4 specular = specularCoeff * specularSample;
		//Add to output phong with hint of color
		phong += (diffuse + specular) * uLightCol[i];
	}
	//good job phong

	// Output to render targets
	rtFragColor = vec4(phong.xyz, 1.0);
	rtDiffuseMapSample = vec4(diffuseSample.xyz, 1.0);
	rtSpecularMapSample = vec4(specularSample.xyz, 1.0);
	rtDiffuseLightTotal = vec4(vec3(dTotal), 1.0);
	rtSpecularLightTotal = vec4(vec3(Total), 1.0);
}

float getDiffuseCoeff(vec4 surfaceNormal, vec4 lVecNorm)
{
	return max(0.0, dot(surfaceNormal, lVecNorm));
}

float getSpecularCoeff(vec4 surfaceNormal, vec4 lVecNorm, vec4 viewPosition)
{
	float specularCoeff = max(0.0, dot(normalize(viewPosition), vec4(reflect(lVecNorm, surfaceNormal).xyz, 1.0)));//Thanks OpenGL
	
	//fuck pow crank that shit up
	specularCoeff *= specularCoeff; 	specularCoeff *= specularCoeff; 
	specularCoeff *= specularCoeff;		specularCoeff *= specularCoeff;
	specularCoeff *= specularCoeff;		specularCoeff *= specularCoeff;

	return specularCoeff;
}