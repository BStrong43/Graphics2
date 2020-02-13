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

	a3_Demo_Pipelines_idle-input.c
	Demo mode implementations: shading input.

	********************************************
	*** INPUT PROCESSING FOR SHADING MODE    ***
	********************************************
*/

//-----------------------------------------------------------------------------

#include "../a3_Demo_Pipelines.h"

typedef struct a3_DemoState a3_DemoState;
//#include "../a3_DemoState.h"

#include "../_a3_demo_utilities/a3_DemoMacros.h"


//-----------------------------------------------------------------------------
// CALLBACKS

// pipeline callback
inline void a3pipelinesCB_input_keyCharPress_scene(a3_Demo_Pipelines* demoMode, a3i32 asciiKey)
{
	switch (asciiKey)
	{
		// toggle target
		a3demoCtrlCasesLoop(demoMode->target_scene, pipelines_target_scene_max, '}', '{');
	}
}


// main demo mode callback
void a3pipelinesCB_input_keyCharPress(a3_DemoState const* demoState, a3_Demo_Pipelines* demoMode, a3i32 asciiKey)
{
	switch (asciiKey)
	{
		// toggle active camera
		a3demoCtrlCasesLoop(demoMode->activeCamera, pipelines_camera_max, 'v', 'c');

		// toggle pipeline mode
		a3demoCtrlCasesLoop(demoMode->pipeline, pipelines_pipeline_max, ']', '[');

		// toggle render program
		a3demoCtrlCasesLoop(demoMode->render, pipelines_render_max, 'k', 'j');

		// toggle display program
		a3demoCtrlCasesLoop(demoMode->display, pipelines_display_max, 'K', 'J');

		// toggle pass to display
		a3demoCtrlCasesLoop(demoMode->pass, pipelines_pass_max, ')', '(');
	}


	// callback for current mode
	switch (demoMode->pass)
	{
	case pipelines_passScene:
		a3pipelinesCB_input_keyCharPress_scene(demoMode, asciiKey);
		break;
	}
}


//-----------------------------------------------------------------------------
