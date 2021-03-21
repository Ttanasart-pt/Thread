/// @description init
#region control
	if(keyboard_check_pressed(vk_space)) {
		is_running = true;	
		thread.action_index = 0;
		thread.runner = 0;
	}
#endregion