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
	} else if(RESIZE) {
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
	
	var show_info = false;
	draw_sprite_ext(logo, 0, cw / 2, 80, .75, .75, 0, c_white, 1);
	if(in_range(mx, cw / 2 - 200, cw / 2 + 200) && in_range(my, 80 - 60, 80 + 60)) 
		show_info = true;
	
	#region simulation
		var sx = cw / 2;
		var sy = ch - 110;
		
		if(point_in_circle(mx, my, sx, sy, 24)) {
			if(mouse_check_button_pressed(mb_left)) 
				simulation_toggle();
			tooltip = is_running? "Stop simulation" : "Start simulation";
			tooltip_sub = "";
		}
		draw_sprite_ext(s_simulation, is_running, sx, sy, 1, 1, 0, c_white, 1);
		
		/*if(is_running) {
			draw_sprite_ext(s_simulation, 2, sx - 48, sy, .75, .75, 0, c_white, 1);
		} else {
			draw_sprite_ext(s_simulation, 2, sx - 48, sy, .75, .75, 0, c_white, 0.25);		
		}
		
		draw_sprite_ext(s_simulation, 3, sx + 48, sy, .75, .75, 0, c_white, 1);
		*/
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
					draw_sprite_ext(s_complete, 0, wx, wy, 1, 1, sin(warning_runner) * 7, c_white, 1);
					warning_runner += 0.15;
					
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
		var aa = 0.9;
		var tx = cw / 2;
		var ty = 300 - 125;
		if(point_in_circle(mx, my, tx, ty, 20)) {
			if(mouse_check_button_pressed(mb_left)) {
				reset();
				with(thread) {
					ds_list_clear(actions);
					ds_list_add(actions, new action_event_start(self));
				}
			}
			tooltip = "Reset universes";
			tooltip_sub = "";
		} else
			aa = 0.3;
			
		draw_sprite_ext(s_reset, 0, tx, ty, 1, 1, 0, c_white, aa);
	#endregion
	
	#region turn
		draw_set_color(c_white);
		draw_set_text(f_p1, fa_center, fa_top);
		draw_text(cw / 2, 430, "Turn");
		draw_sprite_ext(s_turn, 0, cw / 2, 480, .8, .8, turn_angle, c_white, 1);
		turn_angle = lerp_float(turn_angle, TURN * 180, 5);
	#endregion
	
	draw_set_color(c_ui_blue_dark);
	draw_line_width(cw / 2 - 50, 520, cw / 2 + 50, 520, 3);
	
	#region flags
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
	#endregion
	
	draw_set_color(c_ui_blue_dark);
	draw_line_width(cw / 2 - 50, 640, cw / 2 + 50, 640, 3);
	
	#region counter
		draw_set_color(c_white);
		draw_set_text(f_p1, fa_center, fa_top);
		draw_text(cw / 2, 650, "Counter");
		draw_set_text(f_p2, fa_center, fa_top);
		draw_text(cw / 2, 680, string(SEMAPHORE));
	#endregion
	
	draw_set_color(c_ui_blue_dark);
	draw_set_text(f_p0, fa_right, fa_center);
	draw_text(cw - 64, 32, "For CSS225 Operating System\nBy Tanasart Phuangtong");
#endregion

#region settings
	var sx = cw - 32;
	var sy = 32;
	
	draw_sprite_ext(s_settings, 0, sx, sy, .5, .5, 0, c_white, 0.3);
	if(point_in_circle(mx, my, sx, sy, 24)) {
		draw_sprite_ext(s_settings, 0, sx, sy, .5, .5, setting_angle, c_white, 0.6);
		if(mouse_check_button_pressed(mb_left)) {
			show_setting = !show_setting;
		}
	}
	
	if(show_setting) {
		setting_angle = lerp_float(setting_angle, 60, 5);
		var sx2 = cw - 64;
		var sx1 = sx2 - 300;
		var sy1 = 8;
		var sy2 = sy1 + 100;
		
		draw_set_color(c_ui_blue_dark);
		draw_roundrect_ext(sx1, sy1, sx2, sy2, 32, 32, false);
		draw_set_color(c_ui_blue_black);
		draw_roundrect_ext(sx1 + 2, sy1 + 2, sx2 - 2, sy2 - 2, 28, 28, false);
		
		#region speed
			draw_set_text(f_p0, fa_left, fa_center);
			draw_set_color(c_white);
			draw_text(sx1 + 28, sy1 + 32, "Execute speed");
				var ex = sx1 + 240;
				var ey = sy1 + 32;
				
				if(point_in_rectangle(mx, my, ex - 40, ey - 15, ex + 40, ey + 15)) {
					draw_set_color(c_ui_blue_dark);
					draw_roundrect_ext(ex - 40, ey - 15, ex + 40, ey + 15, 30, 30, false);
					
					if(mouse_check_button_pressed(mb_left)) {
						run_speeds_index = (run_speeds_index + 1) % array_length(run_speeds);
						run_speed = run_speeds[run_speeds_index];
					}
				}
				draw_set_text(f_p0, fa_center, fa_center);
				draw_set_color(c_ui_blue);
				draw_text(ex, ey, string(run_speed) + "x");
		#endregion
		#region reset
			draw_set_color(c_white);
			draw_set_text(f_p0, fa_left, fa_center);
			draw_text(sx1 + 28, sy1 + 64, "Reset jar on start");
			
			var ex = sx1 + 240;
			var ey = sy1 + 64;
			
			if(point_in_rectangle(mx, my, ex - 15, ey - 15, ex + 15, ey + 15)) {
				if(mouse_check_button_pressed(mb_left))
					reset_jar = !reset_jar;
			}
			
			draw_sprite_ext(s_widget_toggler, reset_jar, ex, ey, 1, 1, 0, c_ui_blue, 1);
		#endregion
	} else {
		setting_angle = lerp_float(setting_angle, 0, 5);	
	}
#endregion

#region generation
	var gx = 16;
	var gy = 16;
	var ww;
	
	draw_set_text(f_p0, fa_center, fa_left);
	for(var i = 0; i < array_length(gen_names); i++) {
		ww = string_width(gen_names[i]);
		hh = string_height(gen_names[i]);
		
		if(point_in_rectangle(mx, my, gx, gy, gx + ww + 20, gy + hh + 20)) {
			draw_set_alpha(1);
			if(mouse_check_button_pressed(mb_left)) {
				switch(i) {
					case 0 : set_turn();				break;	
					case 1 : set_peterson();			break;	
					case 2 : set_semaphore_software();	break;	
					case 3 : set_semaphore_hardware();	break;	
				}
			}
			
			tooltip     = gen_tooltips[i][0];
			tooltip_sub = gen_tooltips[i][1];
		} else
			draw_set_alpha(0.5);
		draw_set_color(c_ui_blue);
		draw_text(gx + 10 + ww / 2, gy + 10, gen_names[i])
		
		gx += ww + 24;
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
			draw(0.25);
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
		var w_max = 360;
		
		draw_set_text(f_p1, fa_left, fa_top);
		var wt = string_width_ext(tooltip, -1, w_max);
		var ht = string_height_ext(tooltip, -1, w_max);
		
		draw_set_text(f_p0, fa_left, fa_top);
		var ws = string_width_ext(tooltip_sub, -1, w_max);
		
		var ww = 32 + max(wt, ws);
		var hh = 32 + ht;
		draw_set_text(f_p0, fa_left, fa_top);
		
		if(tooltip_sub != "")
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

#region show info
	if(show_info) {
		draw_set_text(f_p1, fa_center, fa_top);
		var ww = 800;
		var hh = string_height_ext(info, -1, ww - 64) + 40;
		var x1 = cw / 2 - ww / 2;
		var x2 = cw / 2 + ww / 2;
		var y1 = 160;
		var y2 = y1 + hh;
		
		draw_set_color(c_ui_blue_dark);
		draw_roundrect_ext(x1, y1, x2, y2, 32, 32, false);
		draw_set_color(c_ui_blue_black);
		draw_roundrect_ext(x1 + 2, y1 + 2, x2 - 2, y2 - 2, 28, 28, false);
		
		draw_set_text(f_p1, fa_center, fa_top);
		draw_set_color(c_ui_blue);
		
		draw_text_ext(cw / 2, y1 + 20, info, -1, ww - 64);
	}
#endregion