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

	a3_Demo_Shading_idle-input.c
	Demo mode implementations: shading input.

	********************************************
	*** INPUT PROCESSING FOR SHADING MODE    ***
	********************************************
*/

//-----------------------------------------------------------------------------

#include "../a3_Demo_Shading.h"

typedef struct a3_DemoState a3_DemoState;
//#include "../a3_DemoState.h"

#include "../_a3_demo_utilities/a3_DemoMacros.h"


//-----------------------------------------------------------------------------
// CALLBACKS

// main demo mode callback
void a3shadingCB_input_keyCharPress(a3_DemoState const* demoState, a3_Demo_Shading* demoMode, a3i32 asciiKey)
{
	switch (asciiKey)
	{
		// toggle render program
		a3demoCtrlCasesLoop(demoMode->render, shading_render_max, 'k', 'j'); 
		
		// toggle pipeline mode
		a3demoCtrlCasesLoop(demoMode->pipeline, shading_pipeline_max, ']', '[');

		// toggle target
		a3demoCtrlCasesLoop(demoMode->targetIndex[demoMode->pipeline], demoMode->targetCount[demoMode->pipeline], '}', '{');
	}


	// callback for current mode
	switch (demoMode->pipeline)
	{
	case shading_fbo:
		switch (asciiKey)
		{
			// toggle display program
			a3demoCtrlCasesLoop(demoMode->display, shading_display_max, 'K', 'J');
		}
		break;
	}
}


//-----------------------------------------------------------------------------
