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
	
	drawPhong_multi_fs4x.glsl
	Draw Phong shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variables for textures; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Phong shading model
//	Note: test all data and inbound values before using them!

const int NUM_LIGHTS = 4;

in vec4 outTexCoord;
in vec4 outNormal;
in vec4 viewPos;

uniform int uLightCt;
uniform vec4 uLightPos[NUM_LIGHTS];
uniform vec4 uLightCol[NUM_LIGHTS];
uniform float uLightSz[NUM_LIGHTS];
uniform float uLightSzInvSq[NUM_LIGHTS];	
uniform sampler2D uTex_dm;
uniform sampler2D uTex_sm;

out vec4 rtFragColor;


vec4 getNormalizedLight(vec4 lightPos, vec4 objPos)
{
	vec4 lightVec = lightPos - objPos;
	return normalize(lightVec);
}

// Returns the dot product of the passed normal and light vector
// Make sure to pass normalized values in
float getDiffuseCoeff(vec4 normal, vec4 lightVector)
{
	return max(0.0, dot(normal, lightVector));
}

void main()
{
	
	vec4 texD = texture2D(uTex_dm, outTexCoord.xy);
	vec4 texS = texture2D(uTex_sm, outTexCoord.xy);
	vec4 outColor;

	for (int i = 0; i < uLightCt; ++i)
	{
		//Calculate Normals
		vec4 lightNormal = getNormalizedLight(uLightPos[i], viewPos);
		vec4 surfaceNormal = normalize(outNormal);

		//Lighting calculations
		vec4 reflection = 2.0 * getDiffuseCoeff(surfaceNormal, lightNormal) * surfaceNormal - lightNormal;
		vec4 diffuseCoeff = max(0.0, dot(surfaceNormal, lightNormal)) * texD;
		float specularCoeff = max(0.0, dot(-normalize(viewPos), reflection));
		vec4 specular = pow(specularCoeff, 128) * texS;

		//add lighting to fragment
		outColor += (diffuseCoeff + specular) * uLightCol[i];
	}

	rtFragColor = outColor;
}
