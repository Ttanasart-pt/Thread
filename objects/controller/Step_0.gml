/// @description init
#region control
	if(keyboard_check_pressed(vk_space)) {
		simulation_toggle();
	}
#endregion

#region run
	if(is_running) {
		var complete = true;
		with(thread)
			if(action_index < ds_list_size(actions))
				complete = false;
		if(complete) {
			is_running = false;
			
			if(candy_count != candy_expected) {
				warning_title = "Synchronization error";
				warning_text = "Candy expected: " + string(candy_expected) + "\nCandy get: " + string(candy_count);
				
				if(USE_SEMAPHORE)
					warning_text += "\n\nImplementing semaphore using software counter is prone to desynchronization. Try using wait then add instead";
			} else {
				warning_title = "";
				warning_text = "";
			}
		}
	}
#endregion