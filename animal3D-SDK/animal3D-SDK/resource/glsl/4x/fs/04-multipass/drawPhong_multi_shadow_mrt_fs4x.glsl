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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	0) copy existing Phong shader
//	1) receive shadow coordinate
//	2) perform perspective divide
//	3) declare shadow map texture
//	4) perform shadow test

const int NUM_LIGHTS = 4;

in vec4 vModelViewNorm;
in vec4 viewPos;
in vec2 vTexCoord;
in vec4 vShadowCoord;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;
uniform sampler2D uTex_shadow;
uniform int uLightCt;
uniform vec4 uLightPos[NUM_LIGHTS];
uniform vec4 uLightCol[NUM_LIGHTS];
uniform float uLightSz[NUM_LIGHTS];

layout(location = 0) out vec4 rtFragColor;

void main()
{
	vec4 texD = texture2D(uTex_dm, vTexCoord);
	vec4 texS = texture2D(uTex_sm, vTexCoord);
	vec4 surfaceNorm = normalize(vModelViewNorm);	

	//Shadow Test
	vec4 projScreen = vShadowCoord / vShadowCoord.w;
	float shadowSample = texture2D(uTex_shadow, projScreen.xy).r;
	bool fragIsShadowed = projScreen.z > (shadowSample + 0.0025);//no z fighting here

	vec4 phong;
	for (int i = 0; i < uLightCt; ++i) {
		vec4 lightNorm = normalize(uLightPos[i] - viewPos);

		float diffuseCoeff = max(0.0, dot(surfaceNorm, lightNorm));
		
		if(fragIsShadowed)
		{
			diffuseCoeff /= 10; //lower diffuseCoeff if in shadow
		}

		vec4 lambert = diffuseCoeff * texD;
		vec4 reflection = 2.0 * diffuseCoeff * surfaceNorm - lightNorm;

		float specularCoeff = max(0.0, dot(-normalize(viewPos), reflection));
		
		//decided to get rid of pow
		specularCoeff *= specularCoeff; // ks^2
		specularCoeff *= specularCoeff; // ks^4
		specularCoeff *= specularCoeff; // ks^8
		specularCoeff *= specularCoeff; // ks^16
		specularCoeff *= specularCoeff; // ks^32
		specularCoeff *= specularCoeff; // ks^64
		
		vec4 specLight = specularCoeff * texS;

		phong += (lambert + specLight) * uLightCol[i];
	}
	
	rtFragColor = vec4(phong.xyz, 1.0);
}