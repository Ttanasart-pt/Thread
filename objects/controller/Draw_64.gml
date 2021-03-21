/// @description init
#region scale
	if(os_browser == browser_not_a_browser) {
		if(window_w != window_get_width() || window_h != window_get_height()) {
			window_w = window_get_width();
			window_h = window_get_height();
			room_width = window_w;
			room_height = window_h;
			
			surface_resize(application_surface, window_w, window_h);
		}
	} else {
		if(window_w != browser_width || window_h != browser_height - 4) {
			window_w = browser_width;
			window_h = browser_height - 4;
			window_set_size(window_w, window_h);
			room_width = window_w;
			room_height = window_h;
		}	
	}
	
	var cw = window_get_width();
	var ch = window_get_height();

	var mx = window_mouse_get_x();
	var my = window_mouse_get_y();
#endregion

#region process
	draw_set_text(f_p2, fa_center, fa_top);
	draw_set_color(c_white);
	draw_text(cw / 2, 50, "Candy jar\nin parallel universes");
	
	if(is_running) {
		draw_set_color(c_white);
		draw_text(cw / 2, ch - 50, "Running");
	}
#endregion

#region canday jar
	draw_candybox(cw / 2, 300, candy_count);
#endregion

#region add action
	var add_y1 = ch - 72;
	var add_y2 = ch;
	
	draw_set_color($342626);
	draw_set_alpha(0.5);
	draw_rectangle(0, add_y1, cw, add_y2, false);
	draw_set_alpha(1);
	
	var xx = 16;
	var yy = (add_y1 + add_y2) / 2;
	for(var i = 0; i < array_length(add_items); i++) {
		var size = add_items[i].draw_left(xx, yy);
		if(in_range(mouse_x, size[0], size[1]) && in_range(mouse_y, size[2], size[3])) {
			add_items[i].draw_left_color(xx, yy, c_white);
			if(mouse_check_button_pressed(mb_left)) {
				drag_object = new add_const[i](self);
			}
		}
		xx = size[1] + 8;
	}
	
	if(drag_object != 0) {
		var thread_target = noone;
		
		with(thread) {
			draw();
			
			if(in_range(mouse_x, area[0], area[1]) && in_range(mouse_y, area[2], area[3])) {
				thread_target = self;
				var yy = 200;				
				for(var i = 0; i < ds_list_size(actions); i++) {
					var size = actions[| i].getSize();
					
					if(in_range(mouse_y, yy + size[1] / 2, yy + size[1] * 1.5)) {
						space = i;
					}
					
					yy += size[1] + 12;
				}
				if(space == -1) space = ds_list_size(actions) - 1;
			}
		}
		
		drag_object.draw(mouse_x, mouse_y);
		if(mouse_check_button_released(mb_left)) {
			if(thread_target != noone) {
				drag_object.obj = thread_target;
				ds_list_insert(thread_target.actions, thread_target.space + 1, drag_object);
			}
			
			drag_object = 0;
		}
	}
#endregion