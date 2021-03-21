/// @description init
#region global
	
#endregion

#region data
	window_w = 0;
	window_h = 0;
	
	candy_count = 4;
	
	globalvar is_running, run_speed;
	is_running = false;
	run_speed = 1;
	
	add_const = [
		action_event_add,
		action_event_remove
	];
	for(var i = 0; i < array_length(add_const); i++)
		add_items[i] = new add_const[i](self);		
	
	adding = -1;
	drag_object = 0;
#endregion

#region UI
	draw_set_circle_precision(64);
#endregion