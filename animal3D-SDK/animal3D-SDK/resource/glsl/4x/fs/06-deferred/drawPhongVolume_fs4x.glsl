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
	
	drawPhongVolume_fs4x.glsl
	Draw Phong lighting components to render targets (diffuse & specular).
*/

#version 410

#define MAX_LIGHTS 1024

// ****TO-DO: 
//	0) copy deferred Phong shader
//	1) declare g-buffer textures as uniform samplers
//	2) declare lighting data as uniform block
//	3) calculate lighting components (diffuse and specular) for the current 
//		light only, output results (they will be blended with previous lights)
//			-> use reverse perspective divide for position using scene depth
//			-> use expanded normal once sampled from normal g-buffer
//			-> do not use texture coordinate g-buffer

in vec4 vBiasedClipCoord;
flat in int vInstanceID;

// (2)
// simple point light (modified version of a3d point light)
struct uPointLight
{
	vec4 worldPos;						// position in world space
	vec4 viewPos;						// position in viewer space
	vec4 color;							// RGB color with padding
	float radius;						// radius (distance of effect from center)
	float radiusInvSq;					// radius inverse squared (attenuation factor)
	float pad[2];						// padding
};

uniform ubPointLight {
	uPointLight uLight[MAX_LIGHTS];
};


uniform sampler2D uImage01; // g-buffer position (vViewPos)
uniform sampler2D uImage02; // g-buffer normal (vViewNormal)
uniform sampler2D uImage03; // g-buffer texcoord (vTexcoord)
uniform mat4 uPB_inv;

layout (location = 6) out vec4 rtDiffuseLight;
layout (location = 7) out vec4 rtSpecularLight;

float getDiffuseCoeff(vec4 surfaceNormal, vec4 lVecNorm);
float getSpecularCoeff(vec4 surfaceNormal, vec4 lVecNorm, vec4 viewPosition);

void main()
{
	vec2 biasedLightPos = (vBiasedClipCoord / vBiasedClipCoord.w).xy;

	//info from gb
	vec4 gbPosition = texture(uImage01, biasedLightPos);
	vec4 gbNormal = texture(uImage02, biasedLightPos);
	
	uPointLight uPLight = uLight[vInstanceID]; //Light to process
	//Perspective divide
	gbPosition *= uPB_inv;
	gbPosition /= gbPosition.w;
	gbNormal = (gbNormal - 0.5) * 2.0;
	
	//Normals for calculations
	vec4 viewNormal = normalize(gbPosition);
	vec4 surfaceNormal = normalize(gbNormal);

	vec4 lightVector = vec4(vec3(uPLight.worldPos - gbPosition), 1.0);

	//Lighting coefficients
	float diffuseCoeff = getDiffuseCoeff(surfaceNormal, uPLight.worldPos);
	float specularCoeff = getSpecularCoeff(surfaceNormal, uPLight.worldPos, uPLight.viewPos);

	//output
	rtDiffuseLight = vec4(vec3(diffuseCoeff), 1.0);
	rtSpecularLight = vec4(vec3(specularCoeff), 1.0);
}

float getDiffuseCoeff(vec4 surfaceNormal, vec4 lVecNorm)
{
	return max(0.0, dot(surfaceNormal, lVecNorm));
}

float getSpecularCoeff(vec4 surfaceNormal, vec4 lVecNorm, vec4 viewPosition)
{

	float specularCoeff = max(0.0, dot(normalize(viewPosition), vec4(reflect(lVecNorm, surfaceNormal).xyz, 1.0)));//Thanks OpenGL
	
	//fuck pow
	specularCoeff *= specularCoeff; 	specularCoeff *= specularCoeff; 
	specularCoeff *= specularCoeff;		specularCoeff *= specularCoeff;
	specularCoeff *= specularCoeff;		specularCoeff *= specularCoeff;

	return specularCoeff;
}