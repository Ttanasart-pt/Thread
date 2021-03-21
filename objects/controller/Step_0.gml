/// @description init
#region control
	if(keyboard_check_pressed(vk_space)) {
		if(!is_running) {
			is_running = true;	
			with(thread) 
				run();
		}
	}
#endregion

#region run
	if(is_running) {
		var complete = true;
		with(thread)
			if(action_index < ds_list_size(actions))
				complete = false;
		if(complete)
			is_running = false;
	}
#endregion