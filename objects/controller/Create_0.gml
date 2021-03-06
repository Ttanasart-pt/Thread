/// @description init
#region simulaiton
	function simulation_toggle() {
		warning_type = 0;
		if(!is_running) {
			if(reset_jar) reset();
			is_running = true;	
			with(thread) 
				run();
		} else {
			is_running = false;
			with(thread) {
				for(var i = 0; i < ds_list_size(actions); i++) {
					actions[| i].running = false;
				}
			}
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
	gen_names = ["Turn", "Peterson", "Semaphore\nsoftware", "Semaphore\nhardware"];
	gen_tooltips = [
		["Turn only",
			"Swapping turn on each thread works, but it can be slow since each thread need to wait for other thread even if there's no instruction on other thread."],
		["Peterson's algorithm", 
			"Invented by Gary L. Peterson, this algorithm relies on turn and flags to solve a problem from turn only system.\n\nA thread will flag up only if they have some instruction to run preventing wait for nothing event."],
		["Software implemented semaphore", 
			"Semaphore is a counter that can be compared and add in one instruction (atomic operation).\n\nImplementing semaphore require hardware support, this example show what happened if you use software to implement it."],
		["Hardward implemented semaphore", 
			"Here use hardware implemented special instruction 'test_and_set' to run semaphore correctly."]
	]
#endregion

#region data
	window_w = 0;
	window_h = 0;
	
	count = 0;
	warning_runner = 0;
	turn_angle = 0;
	
	globalvar TURN, FLAG, SEMAPHORE;
	globalvar USE_SEMAPHORE;
	
	reset();
	
	globalvar is_running, run_speed, run_delay;
	is_running = false;
	run_speed = 1;
	run_delay = 0.5;
	run_speeds = [0.5, 1, 2, 4];
	run_speeds_index = 1;
	
	reset_jar = true;
	
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
	
	globalvar tooltip, tooltip_sub;
	tooltip = "";
	tooltip_sub = "";
	
	info = @"Candy jar vs Parallel universes is a visualization of a common synchronization problem in a multithreaded system. 

Each universe runs in parallel trying to add or remove candy from a candy jar by copying the jar to their universe, modify it, and return the jar into shared space.

The problem is when two universes modify the jar differently and return it at the same time, this will cause synchronization problems. 

On the top left you will see different solutions proposed by different people, each with pros and cons. You can also drag different actions to each universe to build your own algorithm.";

	show_setting = false;
	setting_angle = 0;
#endregion

#region UI
	draw_set_circle_precision(64);
#endregion