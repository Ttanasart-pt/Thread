/// @description init
#region simulaiton
	function simulation_toggle() {
		if(!is_running) {
			reset();
			is_running = true;	
			with(thread) 
				run();
		} else {
			is_running = false;
		}	
	}
	
	function reset() {
		candy_count = 4;
		candy_expected = candy_count;
		TURN = 0;
		FLAG = 0;
		SEMAPHORE = 0;
		USE_SEMAPHORE = false;
		
		warning_text = "";
		warning_title = "";
	}
#endregion

#region generators
	gen_names = ["Peterson", "Semaphore"];
#endregion

#region data
	window_w = 0;
	window_h = 0;
	
	candy_count = 4;
	candy_expected = 0;
	
	warning_title = "";
	warning_text = "";
	warning_runner = 0;
	
	globalvar TURN, FLAG, SEMAPHORE;
	globalvar USE_SEMAPHORE;
	TURN = 0;
	FLAG = 0;
	SEMAPHORE = 0;
	
	globalvar is_running, run_speed, run_delay;
	is_running = false;
	run_speed = 1;
	run_delay = 0.5;
	
	add_const = [
		action_event_add,
		action_event_remove,
		
		action_event_wait_turn,
		action_event_set_turn,
		
		action_event_wait_flag,
		action_event_set_flag,
		action_event_reset_flag,
		
		action_event_wait_semaphore,
		action_event_add_semaphore,
		action_event_reduce_semaphore,
		action_event_wait_semaphore_then_add,
	];
	for(var i = 0; i < array_length(add_const); i++)
		add_items[i] = new add_const[i](self);		
	
	add_x	 = 0;
	add_x_to = 0;
	add_len  = 0;
	
	drag_object = 0;
	
	tooltip = "";
	tooltip_sub = "";
#endregion

#region UI
	draw_set_circle_precision(64);
#endregion