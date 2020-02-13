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

	a3_Demo_Shading.h
	Demo mode interface: shading.

	********************************************
	*** THIS IS ONE DEMO MODE'S HEADER FILE  ***
	********************************************
*/

#ifndef __ANIMAL3D_DEMO_SHADING_H
#define __ANIMAL3D_DEMO_SHADING_H


//-----------------------------------------------------------------------------

#include "animal3D/animal3D.h"


//-----------------------------------------------------------------------------

#ifdef __cplusplus
extern "C"
{
#else	// !__cplusplus
	typedef struct a3_Demo_Shading						a3_Demo_Shading;
	typedef enum a3_Demo_Shading_RenderProgramName		a3_Demo_Shading_RenderProgramName;
	typedef enum a3_Demo_Shading_DisplayProgramName		a3_Demo_Shading_DisplayProgramName;
	typedef enum a3_Demo_Shading_ActiveCameraName		a3_Demo_Shading_ActiveCameraName;
	typedef enum a3_Demo_Shading_PipelineName			a3_Demo_Shading_PipelineName;
	typedef enum a3_Demo_Shading_TargetName				a3_Demo_Shading_TargetName;
#endif	// __cplusplus


//-----------------------------------------------------------------------------

	// program to use for rendering
	enum a3_Demo_Shading_RenderProgramName
	{
		shading_renderSolid,		// solid color
		shading_renderTexture,		// texture sample
		shading_renderLambert,		// Lambert shading
		shading_renderPhong,		// Phong shading
		shading_renderNonphoto,		// nonphotorealistic shading

		shading_render_max
	};

	// program to use for display
	enum a3_Demo_Shading_DisplayProgramName
	{
		shading_displayTexture,
		shading_displayTextureManipColor,
		shading_displayTextureManipTexcoord,

		shading_display_max
	};

	// active camera names
	enum a3_Demo_Shading_ActiveCameraName
	{
		shading_cameraSceneViewer,	// scene viewing camera

		shading_camera_max
	};


	// shading pipeline names
	enum a3_Demo_Shading_PipelineName
	{
		shading_back,				// on-screen rendering with back buffer
		shading_fbo,				// off-screen rendering with MRT FBO

		shading_pipeline_max
	};

	// render target names
	enum a3_Demo_Shading_TargetName
	{
		shading_back_composite = 0,	// final composite color
		shading_target_back_max,

		shading_fbo_composite = 0,	// final composite color
		shading_fbo_position,		// position attribute
		shading_fbo_normal,			// normal attribute
		shading_fbo_texcoord,		// texcoord attribute
		shading_fbo_diffuseTex,		// diffuse texture sample
		shading_fbo_specularTex,	// specular texture sample
		shading_fbo_diffuseLight,	// diffuse light total
		shading_fbo_specularLight,	// specular light total
		shading_fbo_fragdepth,		// fragment depth
		shading_target_fbo_max,
	};


//-----------------------------------------------------------------------------

	// demo mode for basic shading
	struct a3_Demo_Shading
	{
		a3_Demo_Shading_RenderProgramName render;
		a3_Demo_Shading_DisplayProgramName display;
		a3_Demo_Shading_ActiveCameraName activeCamera;

		a3_Demo_Shading_PipelineName pipeline;
		a3_Demo_Shading_TargetName targetIndex[shading_pipeline_max], targetCount[shading_pipeline_max];
	};


//-----------------------------------------------------------------------------


#ifdef __cplusplus
}
#endif	// __cplusplus


#endif	// !__ANIMAL3D_DEMO_SHADING_H