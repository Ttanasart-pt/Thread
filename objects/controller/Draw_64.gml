/// @description init
#region scale
	if(os_browser == browser_not_a_browser) {
		if(window_get_width() * window_get_height())
		if(window_w != window_get_width() || window_h != window_get_height()) {
			window_w = window_get_width();
			window_h = window_get_height();
			room_width = window_w;
			room_height = window_h;
			
			show_debug_message(window_w);
			surface_resize(application_surface, window_w, window_h);
			
			with(thread) init_jar();
		}
	} else {
		if(window_w != browser_width || window_h != browser_height - 4) {
			window_w = browser_width;
			window_h = browser_height - 4;
			window_set_size(window_w, window_h);
			room_width = window_w;
			room_height = window_h;
			
			with(thread) init_jar();
		}	
	}
	
	var cw = window_get_width();
	var ch = window_get_height();
#endregion

#region process
	var add_y1 = 0;
	var add_y2 = 100;
	
	draw_sprite_ext(logo, 0, cw / 2, 80, .75, .75, 0, c_white, 1);
	
	#region simulation
		var sx = cw / 2;
		var sy = ch - 115;
		
		if(point_in_circle(mx, my, sx, sy, 24)) {
			draw_set_color(c_ui_blue);
			draw_set_alpha(0.25);
			draw_circle(sx, sy, 24, false);
			draw_set_alpha(1);
			
			if(mouse_check_button_pressed(mb_left)) 
				simulation_toggle();
		}
		draw_sprite_ext(s_simulation, is_running, sx, sy, 1, 1, 0, is_running? c_ui_red : c_ui_lime, 1);
	#endregion
#endregion

#region canday jar
	draw_candybox(cw / 2, 300, candy_count);
	
	#region warning
		if(warning_title != "") {
			var wx = cw / 2 + 70;
			var wy = 300 + 110;
			var hover = false;
			
			switch(warning_type) {
				case 1 :
					draw_sprite_ext(s_warning, 0, wx, wy, 1, 1, -20 + sin(warning_runner) * 7, c_white, 1);
					warning_runner += 0.35;
					
					if(in_range(mx, wx - 20, wx + 40) && in_range(my, wy - 60, wy + 20)) hover = true;
					break;
				case 2 :
					draw_sprite_ext(s_complete, 0, wx, wy, 1, 1, 0, c_white, 1);
					
					if(in_range(mx, wx - 40, wx + 40) && in_range(my, wy - 40, wy + 40)) hover = true;
					break;
			}
			
			if(hover) {
				tooltip = warning_title;
				tooltip_sub = warning_text;
			}
		}
	#endregion
	
	#region reset
		var aa = 1;
		var tx = cw / 2;
		var ty = 300 - 125;
		if(point_in_circle(mx, my, tx, ty, 20)) {
			if(mouse_check_button_pressed(mb_left)) 
				reset();
		} else
			aa = 0.5;
			
		draw_sprite_ext(s_reset, 0, tx, ty, 1, 1, 0, c_ui_blue_grey, aa);
	#endregion
	
	draw_set_color(c_white);
	draw_set_text(f_p1, fa_center, fa_top);
	draw_text(cw / 2, 450, "Turn");
	draw_set_text(f_p2, fa_center, fa_top);
	draw_text(cw / 2, 480, string(TURN));
	
	draw_set_color(c_ui_blue_dark);
	draw_line_width(cw / 2 - 50, 520, cw / 2 + 50, 520, 3);
	
	draw_set_color(c_white);
	draw_set_text(f_p1, fa_center, fa_top);
	draw_text(cw / 2, 540, "Flags");
	var fg_x = cw / 2 - 28;
	var fg_y = 600;
	for(var i = 0; i < 2; i++) {
		if(FLAG & (1 << i) != 0) {
			draw_sprite_ext(s_flag, 1, fg_x, fg_y, 1, 1, 1, c_ui_blue, 1);
		} else {
			draw_sprite_ext(s_flag, 0, fg_x, fg_y, 1, 1, 1, c_ui_red, 0.5);
		}
			
		fg_x += 28 * 2;
	}
	
	draw_set_color(c_ui_blue_dark);
	draw_line_width(cw / 2 - 50, 640, cw / 2 + 50, 640, 3);
	
	draw_set_color(c_white);
	draw_set_text(f_p1, fa_center, fa_top);
	draw_text(cw / 2, 650, "Counter");
	draw_set_text(f_p2, fa_center, fa_top);
	draw_text(cw / 2, 680, string(SEMAPHORE));
	
	draw_set_color(c_ui_blue_dark);
	draw_set_text(f_p0, fa_right, fa_top);
	draw_text(cw - 8, 8, "For CSS225 Operating System\nBy Tanasart Phuangtong");
#endregion

#region generation
	var gx = 16;
	var gy = 16;
	var ww;
	
	draw_set_text(f_p0, fa_left, fa_left);
	for(var i = 0; i < array_length(gen_names); i++) {
		ww = string_width(gen_names[i]);
		hh = string_height(gen_names[i]);
		
		if(point_in_rectangle(mx, my, gx, gy, gx + ww + 20, gy + hh + 20)) {
			draw_set_alpha(1);
			if(mouse_check_button_pressed(mb_left)) {
				switch(i) {
					case 0 : set_peterson();	break;	
					case 1 : set_semaphore();	break;	
				}
			}	
		} else
			draw_set_alpha(0.5);
		draw_set_color(c_ui_blue);
		draw_text(gx + 10, gy + 10, gen_names[i])
		
		gx += ww + 20;
	}
#endregion

#region add action
	var add_y1 = ch - 72;
	var add_y2 = ch;
	
	draw_set_color($342626);
	draw_set_alpha(0.5);
	draw_rectangle(0, add_y1, cw, add_y2, false);
	draw_set_alpha(1);
	
	#region scroll
		if(add_len > 0) {
			if(mouse_wheel_down()) add_x_to = clamp(add_x_to + 128, 0, add_len);
			if(mouse_wheel_up())   add_x_to = clamp(add_x_to - 128, 0, add_len);
		} else
			add_x_to = 0;	
		add_x = lerp_float(add_x, add_x_to, 5);
	#endregion
	
	add_len = 32;
	var xx = 16 - add_x;
	var yy = (add_y1 + add_y2) / 2;
	for(var i = 0; i < array_length(add_items); i++) {
		var size = add_items[i].draw_left(xx, yy);
		if(in_range(mx, size[0], size[1]) && in_range(my, size[2], size[3])) {
			add_items[i].draw_left_color(xx, yy, c_white);
			if(mouse_check_button_pressed(mb_left)) {
				drag_object = create_action(i);
			}
		}
		xx = size[1] + 8;
		add_len += size[1] - size[0] + 8;
	}
	add_len -= window_w;
	
	if(drag_object != 0) {
		var thread_target = noone;
		
		with(thread) {
			draw();
			
			if(in_range(mx, area[0], area[1]) && in_range(my, area[2], area[3])) {
				thread_target = self;
				var yy = 200;				
				for(var i = 0; i < ds_list_size(actions); i++) {
					var size = actions[| i].getSize();
					
					if(in_range(my, yy + size[1] / 2, yy + size[1] * 1.5)) {
						space = i;
					}
					
					yy += size[1] + 12;
				}
				if(space == -1) space = ds_list_size(actions) - 1;
			}
		}
		
		drag_object.draw(mx, my);
		if(mouse_check_button_released(mb_left)) {
			if(thread_target != noone) {
				drag_object.obj = thread_target;
				ds_list_insert(thread_target.actions, thread_target.space + 1, drag_object);
			}
			
			drag_object = 0;
		}
	}
#endregion

#region tooltip
	if(tooltip != "") {
		var tx = mx + 8;
		var ty = my + 8;
		var w_max = 300;
		
		draw_set_text(f_p1, fa_left, fa_top);
		var ww = 32 + max(string_width_ext(tooltip, -1, w_max), string_width_ext(tooltip_sub, -1, w_max));
		var hh = 32 + string_height_ext(tooltip, -1, w_max);
		draw_set_text(f_p0, fa_left, fa_top);
		hh += 4 + string_height_ext(tooltip_sub, -1, w_max);
		
		draw_set_color(c_ui_blue_dark);
		draw_roundrect_ext(tx, ty, tx + ww, ty + hh, 32, 32, false);
		draw_set_color(c_ui_blue_black);
		draw_roundrect_ext(tx + 2, ty + 2, tx + ww - 2, ty + hh - 2, 28, 28, false);
		
		var yy = ty + 16;
		draw_set_color(c_white);
		draw_set_text(f_p1, fa_left, fa_top);
		draw_text_ext(tx + 16, yy, tooltip, -1, w_max);
		
		yy += string_height_ext(tooltip, -1, w_max) + 4;
		draw_set_color(c_ui_blue);
		draw_set_text(f_p0, fa_left, fa_top);
		draw_text_ext(tx + 16, yy, tooltip_sub, -1, w_max);
	}
	tooltip = "";
#endregion