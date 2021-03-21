/// @description init
#region actions
	actions = ds_list_create();
	ds_list_add(actions, new action_event_start(self));
	
	if(count)
		ds_list_add(actions, new action_event_add(self));
	else
		ds_list_add(actions, new action_event_remove(self));
	
	action_index = 0;
	runner = 0;
	
	candy_count = 0;
	
	var side = (window_get_width() / 2 - 150) / 2;
	jar_x = !count? side : window_get_width() - side;
	jar_y = window_get_height() / 2;
	jar_x_start = window_get_width() / 2;
	jar_y_start = 300;
	jar_show_x = jar_x_start;
	jar_show_y = jar_y_start;
	
	area = [jar_x - 200, jar_x + 200, 100, window_get_height() - 160];
	
	space = -1;
#endregion

#region method
	function run() {
		action_index = 0;
		runner = 0;
	}
	
	function draw() {
		draw_set_color($342626);
		draw_set_alpha(0.25);
		
		draw_roundrect_ext(area[0], area[2], area[1], area[3], 32, 32, false);
		
		draw_set_alpha(1);
	}
#endregion