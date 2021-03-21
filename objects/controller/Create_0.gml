/// @description init
#region simulaiton
	function simulation_toggle() {
		warning_type = 0;
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
		warning_type = 0;
	}
#endregion

#region generators
	gen_names = ["Peterson", "Semaphore"];
#endregion

#region data
	window_w = 0;
	window_h = 0;
	
	warning_runner = 0;
	
	globalvar TURN, FLAG, SEMAPHORE;
	globalvar USE_SEMAPHORE;
	
	reset();
	
	globalvar is_running, run_speed, run_delay;
	is_running = false;
	run_speed = 1;
	run_delay = 0.5;
	
	function create_action(index) {
		switch(index) {
			case 0 :  return new action_event_add(self);					 
			case 1 :  return new action_event_remove(self);				 
			case 2 :  return new action_event_wait_turn(self);			 	 
			case 3 :  return new action_event_set_turn(self);				 
			case 4 :  return new action_event_wait_flag(self);			 	 
			case 5 :  return new action_event_set_flag(self);				 
			case 6 :  return new action_event_reset_flag(self);			 
			case 7 :  return new action_event_wait_semaphore(self);		 
			case 8 :  return new action_event_add_semaphore(self);		 	 
			case 9 :  return new action_event_reduce_semaphore(self);		 
			case 10 : return new action_event_wait_semaphore_then_add(self);
		}
	}
	
	for(var i = 0; i < 11; i++) {
		add_items[i] = create_action(i);
	}
	
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