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

	a3_Demo_Shading_initialize.c
	Demo mode implementations: shading initialization.

	********************************************
	*** INITIALIZATION FOR SHADING DEMO MODE ***
	********************************************
*/

//-----------------------------------------------------------------------------

#include "../a3_Demo_Shading.h"

typedef struct a3_DemoState a3_DemoState;
// #include "../a3_DemoState.h"


//-----------------------------------------------------------------------------

void a3shading_init(a3_DemoState const* demoState, a3_Demo_Shading* demoMode)
{
	demoMode->pipeline = shading_back;
	demoMode->target_back = shading_back_composite;
	demoMode->target_fbo = shading_fbo_composite;
	demoMode->render = shading_renderSolid;
	demoMode->display = shading_displayTexture;
	demoMode->activeCamera = shading_cameraSceneViewer;
}


//-----------------------------------------------------------------------------
