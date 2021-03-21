/// @description init
#region actions
	action_event = function() constructor {
		step = 0;
		
		static jar_pick = function() {
			candy_count = controller.candy_count;
			
			jar_show_x = lerp_float(jar_show_x, jar_x, 10);
			jar_show_y = lerp_float(jar_show_y, jar_y, 10);
				
			return (jar_show_x == jar_x && jar_show_y == jar_y);
		}
		static jar_return = function() {
			jar_show_x = lerp_float(jar_show_x, jar_x_start, 10);
			jar_show_y = lerp_float(jar_show_y, jar_y_start, 10);
			
			return (jar_show_x == jar_x_start && jar_show_y == jar_y_start);
		}
		
		static run = function() {}
	}
	
	action_event_add = function() : action_event() constructor {
		static run = function() {
			switch(step) {
				case 0 : 
					if(jar_pick()) 
						step = 1; 
					break;
				case 1 : 
					step = 2; 
					break;
				case 2 : 
					if(jar_return()) {
						step = 0; 
						return true;
					}
					break;
			}
			return false;
		}
	}
#endregion

#region actions
	actions = [
		new action_event_add()
	];
	
	action_index = 0;
	runner = 0;
	
	candy_count = 0;
	
	jar_x = (count + 1) * window_get_width() / 3;
	jar_y = window_get_height() / 2;
	jar_x_start = window_get_width() / 2;
	jar_y_start = 300;
	jar_show_x = jar_x_start;
	jar_show_y = jar_y_start;
#endregion