/// @description init
#region draw action
	var ay1 = 200;
	var yy = ay1;
	var del = -1;
	
	for(var i = 0; i < ds_list_size(actions); i++) {
		var size = actions[| i].draw(jar_x, yy);
		
		#region drag
			if(controller.drag_object == 0 && 
				in_range(mx, size[0], size[1]) && in_range(my, size[2], size[3])) {
					actions[| i].draw_UI(jar_x, yy);
				actions[| i].draw_ext(jar_x, yy, c_white);
				if(i && mouse_check_button_pressed(mb_left)) {
					controller.drag_object = actions[| i];
					del = i;
				}
			}
		#endregion
		#region connect
			var ly2 = size[3];
			
			if(i == space) {
				draw_sprite_ext(s_connector, 0, jar_x, ly2 + 6, .9, .9, 0, actions[| i].color, 1);
				
				yy += 51;
			} else {
				draw_sprite_ext(s_connector, 0, jar_x, ly2 + 6, .6, .6, 0, actions[| i].color, 1);
			}
		#endregion
		#region condition
			if(i && actions[| i - 1].condition && actions[| i].condition) {
				var size_pre = actions[| i - 1].getSize();
				var size_cur = actions[| i].getSize();
				
				var condx = jar_x - max(size_pre[0], size_cur[0]) / 2 - 24;
				var condy = yy - size_cur[1] / 2 - 6;
				
				if(point_in_circle(mx, my, condx, condy, 24)) {
					draw_set_color(c_ui_blue);
					draw_set_alpha(0.15);
					draw_circle(condx, condy, 24, false);
					draw_set_alpha(1);
					
					if(mouse_check_button_pressed(mb_left)) 
						actions[| i - 1].cond_mode = (actions[| i - 1].cond_mode + 1) % 2;
				}
				
				draw_set_text(f_p00, fa_center, fa_center);
				draw_set_color(c_ui_blue);
				
				switch(actions[| i - 1].cond_mode) {
					case 0 : draw_text(condx, condy, "OR"); break;
					case 1 : draw_text(condx, condy, "AND"); break;
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