/// @description init
#region draw action
	var ay1 = 200;
	var yy = ay1;
	var del = -1;
	
	for(var i = 0; i < ds_list_size(actions); i++) {
		var size = actions[| i].draw(jar_x, yy);
		
		#region connect
			var ly1 = size[2];
			var ly2 = size[3];
			
			if(i == space) {
				draw_set_color(actions[| i].color);
				draw_circle(jar_x, ly2 + 6, 12, false);
				draw_set_color(c_white);
				draw_circle(jar_x, ly2 + 6, 6, false);
				
				yy += 32;
			} else {
				draw_set_color(actions[| i].color);
				draw_circle(jar_x, ly2 + 6, 8, false);
				draw_set_color(c_white);
				draw_circle(jar_x, ly2 + 6, 4, false);
			}
		#endregion
		#region drag
			if(in_range(mouse_x, size[0], size[1]) && in_range(mouse_y, size[2], size[3])) {
				if(i && mouse_check_button_pressed(mb_left)) {
					controller.drag_object = actions[| i];
					del = i;
				}
			}
		#endregion
		
		yy += size[3] - size[2] + 12;
	}
	if(del > -1) 
		ds_list_delete(actions, del);
	space = -1;
#endregion

#region draw jar
	if(is_running) {
		draw_candybox(jar_show_x, jar_show_y, candy_count);
	}
#endregion