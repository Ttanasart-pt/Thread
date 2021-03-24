function draw_candybox(_x, _y, _candy) {
	var cx1 = _x - 75;
	var cy2 = _y + 100;
	
	draw_sprite_ext(s_candy_jar, 0, _x, _y, 1, 1, 0, c_ui_blue, .7);
		
	var line = 0;
	var indx = 0;
	draw_set_color(c_white);
		
	for(var i = 0; i < _candy; i++) {
		var cx = cx1 + 36 + indx * 40 + (line % 2) * 20;
		var cy = cy2 + 6 - line * 40 - 40;
		var cc = make_color_hsv(i * 67, 180, 255);
		
		draw_sprite_ext(s_candy, i, cx, cy, 1, 1, i * 28, cc, 1);
		if(++indx > (line + 1) % 2 + 1) {
			line++;
			indx = 0;
		}
	}
}

function get_candy_position(_index) {
	var cx1 = -75;
	var cy1 = +100;
	var line = 0;
	var indx = 0;
	var res = [0, 0];
				
	for(var i = 0; i <= _index; i++) {
		res[0] = cx1 + 36 + indx * 40 + (line % 2) * 20;
		res[1] = cy1 + 6 - line * 40 - 40;
					
		if(++indx > (line + 1) % 2 + 1) {
			line++;
			indx = 0;
		}
	}
	
	return res;
}

#region actions
	function action_event(_obj) constructor {
		step		 = 0;
		running		 = false;
		obj			 = _obj;
		show_trigger = false;
		condition	 = false;
		
		desp  = "";
		color = c_ltgray;
		
		static jar_pick = function() {
			with(obj) {
				candy_count = controller.candy_count;
			
				jar_show_x = lerp_float(jar_show_x, jar_pos_x, 5 / run_speed, 4);
				jar_show_y = lerp_float(jar_show_y, jar_y, 5 / run_speed, 4);
				
				return (jar_show_x == jar_pos_x && jar_show_y == jar_y);
			}
		}
		static jar_return = function() {
			with(obj) {
				jar_show_x = lerp_float(jar_show_x, jar_x_start, 5 / run_speed, 4);
				jar_show_y = lerp_float(jar_show_y, jar_y_start, 5 / run_speed, 4);
				
				if(jar_show_x == jar_x_start && jar_show_y == jar_y_start) {
					controller.candy_count = candy_count;
					return true;
				}
				return false;
			}
		}
		static action = function() {}
		static trigger_action = function() {}
		
		runner = 0;
		static run = function() {
			running = true;
			switch(step) {
				case 0 : 
					if(jar_pick()) {
						step = 1; 
						runner = 0;
					}
					break;
				case 1 : 
					if(action())
						step = 2; 
					break;
				case 2 : 
					if(jar_return()) {
						step = 0; 
						running = false;
						return true;
					}
					break;
			}
			return false;
		}
		
		draw_alpha = 1;
		
		static draw_ext = function(_x, _y, _color) {
			if(running || !is_running) 
				draw_alpha = lerp_float(draw_alpha, 1, 3);
			else
				draw_alpha = lerp_float(draw_alpha, 0.2, 3);
			
			draw_set_alpha(draw_alpha);
			var cc = merge_color(color, _color, 0.5);
			
			draw_set_text(f_p0, fa_center, fa_center);
			var _desp = getDesp();
			var ll = string_width(_desp) + 32;
			var hh = 50;
			var x1 = _x - ll / 2;
			var x2 = _x + ll / 2;
			var y1 = _y - hh / 2;
			var y2 = _y + hh / 2;
			draw_sprite_ext(s_roundrect, 0, x1, y1, 1, 1, 0, cc, draw_alpha);
			draw_sprite_ext(s_roundrect, 1, x1 + 25, y1, (ll - 50) / 25, 1, 0, cc, draw_alpha);
			draw_sprite_ext(s_roundrect, 2, x2 - 25, y1, 1, 1, 0, cc, draw_alpha);
			draw_set_alpha(1);
			
			draw_set_color(c_black);
			draw_text(_x, _y, _desp);
			
			return [x1, x2, y1, y2];
		}
		static draw_left = function(_x, _y) {
			return draw_left_color(_x, _y, color);
		}
		static draw_left_color = function(_x, _y, _color) {
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(getDesp()) + 32;
			
			return draw_ext(_x + ll / 2, _y, _color);
		}
		static draw = function(_x, _y) {
			if(show_trigger) draw_trigger(_x, _y);
			if(running) draw_UI(_x, _y);
			var size = draw_ext(_x, _y, color);
			
			return size;	
		}
		
		static draw_trigger = function(_x, _y) {
			var size = getSize();
			var tx = _x + size[0] / 2 + 20;
			var ty = _y;
			
			var aa = 0.9;
			if(point_in_circle(mx, my, tx, ty, 16)) {
				if(mouse_check_button_pressed(mb_left)) trigger_action();
			} else
				aa = 0.3;
			
			draw_sprite_ext(s_trigger, 0, tx, ty, .8, .8, 0, c_white, aa);
		}
		
		static draw_UI = function(_x, _y) {}
		
		static getSize = function() {
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(getDesp()) + 32;
			var hh = 50;
			
			return [ll, hh];
		}
		
		static getDesp = function() {
			return desp;	
		}
		
		
		dot_runner = 0;
		static draw_dotted_to = function(x1, y1, x2, y2, shift) {
			var size = getSize();
			
			draw_set_color(color);
			draw_set_alpha(0.3);
			
			var xx = x1 + size[0] / 2 * (obj.count? -1 : 1);
			draw_line_sprite(xx, y1, x2, y2, s_dot, 20, dot_runner);
				
			draw_set_alpha(1);
			
			dot_runner += shift * TIME_SEC * 60;
		}
	}
	
	
	function action_event_start(_obj) : action_event(_obj) constructor {
		desp  = "Universe begin";
		color = c_gray;	
		
		static run = function() {
			return true;	
		}
	}
	
	function action_event_add(_obj) : action_event(_obj) constructor {
		desp  = "Add candy";
		color = c_ui_lime;
		
		candy_draw_x = 0;
		candy_draw_y = 0;
		candy_target_x = 0;
		candy_target_y = 0;
		candy_draw_index = 0;
		candy_draw_color = 0;
		candy_draw_rotation = 0;
		candy_drawing = false;
		
		static action = function() {
			if(runner == 0) {
				candy_drawing = false;
				candy_draw_x = obj.jar_show_x;
				candy_draw_y = obj.jar_show_y - 150;
				candy_draw_index = obj.candy_count;
				candy_draw_color = make_color_hsv(obj.candy_count * 67, 180, 255);
				candy_draw_rotation = obj.candy_count * 28;
				
				var candy_pos = get_candy_position(obj.candy_count);
				candy_target_x = candy_pos[0];
				candy_target_y = candy_pos[1];
			} else {
				candy_drawing = true;
				candy_draw_x = lerp_float(candy_draw_x, obj.jar_show_x + candy_target_x, 10);
				candy_draw_y = lerp_float(candy_draw_y, obj.jar_show_y + candy_target_y, 10);
				
				if(candy_draw_x == obj.jar_show_x + candy_target_x && candy_draw_y == obj.jar_show_y + candy_target_y) {
					obj.candy_count++;
					controller.candy_expected++;
					candy_drawing = false;
					return true;
				}
			}
			runner++;
			return false;
		}
		
		static draw_UI = function(_x, _y) {
			if(candy_drawing) {
				draw_sprite_ext(s_candy, candy_draw_index, candy_draw_x, candy_draw_y, 1, 1, candy_draw_rotation, candy_draw_color, 1);
			}
		}
	}
	
	function action_event_remove(_obj) : action_event(_obj) constructor {
		desp  = "Remove candy";
		color = c_ui_red;
		
		candy_draw_x = 0;
		candy_draw_y = 0;
		candy_target_x = 0;
		candy_target_y = 0;
		candy_draw_index = 0;
		candy_draw_color = 0;
		candy_draw_rotation = 0;
		candy_drawing = false;
		
		static action = function() {
			if(runner == 0) {
				candy_drawing = false;
				
				var candy_pos = get_candy_position(obj.candy_count - 1);
				candy_draw_x = obj.jar_show_x + candy_pos[0];
				candy_draw_y = obj.jar_show_y + candy_pos[1];
				
				candy_draw_index = obj.candy_count - 1;
				candy_draw_color = make_color_hsv((obj.candy_count - 1) * 67, 180, 255);
				candy_draw_rotation = (obj.candy_count - 1) * 28;
				
				obj.candy_count--;
				controller.candy_expected--;
			} else {
				candy_drawing = true;
				candy_draw_x = lerp_float(candy_draw_x, obj.jar_show_x, 10);
				candy_draw_y = lerp_float(candy_draw_y, obj.jar_show_y - 150, 10);
				
				if(candy_draw_x == obj.jar_show_x && candy_draw_y == obj.jar_show_y - 150) {
					candy_drawing = false;
					return true;
				}
			}
			runner++;
			return false;
		}
		
		static draw_UI = function(_x, _y) {
			if(candy_drawing) {
				draw_sprite_ext(s_candy, candy_draw_index, candy_draw_x, candy_draw_y, 1, 1, candy_draw_rotation, candy_draw_color, 1);
			}
		}
	}
	
	function action_event_wait_turn(_obj) : action_event(_obj) constructor {
		desp		 = "Wait for turn";
		color		 = c_ui_blue;
		turn		 = 0;
		show_trigger = true;
		condition	 = true
		cond_mode    = 0;
		
		static run = function() {
			running = true;
			if(TURN == turn) running = false;
			return TURN == turn;
		}
		
		static getDesp = function() {
			return "Wait for " + (turn? "Left" : "Right") + " turn";
		}
		
		static trigger_action = function() { turn = (turn + 1) % 2; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 480, -1);
		}
	}
	
	function action_event_set_turn(_obj) : action_event(_obj) constructor {
		desp		 = "Set turn to";
		color		 = c_ui_blue;
		turn		 = 0;
		show_trigger = true;
		
		static run = function() {
			switch(step) {
				case 0 :
					running = true;
					TURN = turn;
					runner = 0;
					step = 1;
					break;
				case 1 :
					runner += TIME_SEC * run_speed;
					if(runner > run_delay) {
						running = false;
						step = 0;
						return true;
					}
					break;
			}
			
			return false;
		}
		
		static getDesp = function() {
			return desp + " " + (turn? "Left" : "Right");
		}
		
		static trigger_action = function() { turn = (turn + 1) % 2; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 480, 1);
		}
	}
	
	function action_event_wait_flag(_obj) : action_event(_obj) constructor {
		desp		 = "Wait for flag";
		color		 = c_ui_aqua;
		flag		 = 0;
		show_trigger = true;
		condition	 = true;
		cond_mode    = 0;
		
		static run = function() {
			running = true;
			var res = (FLAG & (1 << flag)) == 0;
			
			if(res) running = false;
			return res;
		}
		
		static getDesp = function() {
			return desp + " " + string(flag);
		}
		
		static trigger_action = function() { flag = (flag + 1) % 2; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2 + (28 * (flag * 2 - 1)), 600, -1);
		}
	}
	
	function action_event_set_flag(_obj) : action_event(_obj) constructor {
		desp		 = "Set flag";
		color		 = c_ui_aqua;
		flag		 = 0;
		show_trigger = true;
		
		static run = function() {
			switch(step) {
				case 0 :
					running = true;
					FLAG |= (1 << flag);
					runner = 0;
					step = 1;
					break;
				case 1 :
					runner += TIME_SEC * run_speed;
					if(runner > run_delay) {
						running = false;
						step = 0;
						return true;
					}
					break;
			}
			
			return false;
		}
		
		static getDesp = function() {
			return "Set flag " + string(flag);
		}
		
		static trigger_action = function() { flag = (flag + 1) % 2; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2 + (28 * (flag * 2 - 1)), 600, 1);
		}
	}
	
	function action_event_reset_flag(_obj) : action_event(_obj) constructor {
		desp		 = "Reset flag";
		color		 = c_ui_aqua;
		flag		 = 0;
		show_trigger = true;
		
		static run = function() {
			switch(step) {
				case 0 :
					running = true;
					FLAG &= ~(1 << flag);
					runner = 0;
					step = 1;
					break;
				case 1 :
					runner += TIME_SEC * run_speed;
					if(runner > run_delay) {
						running = false;
						step = 0;
						return true;
					}
					break;
			}
			
			return false;
		}
		
		static getDesp = function() {
			return "Reset flag " + string(flag);
		}
		
		static trigger_action = function() { flag = (flag + 1) % 2; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2 + (28 * (flag * 2 - 1)), 600, 1);
		}
	}
	
	function action_event_wait_semaphore(_obj) : action_event(_obj) constructor {
		desp		 = "Wait for counter";
		color		 = c_ui_yellow;
		mode		 = 0;
		show_trigger = true;
		condition	 = true;
		cond_mode    = 0;
		
		static run = function() {
			running = true;
			var res;
			switch(mode) {
				case 0 : res = SEMAPHORE == 0; break;	
				case 1 : res = SEMAPHORE > 0; break;	
				case 2 : res = SEMAPHORE < 0; break;	
			}
			USE_SEMAPHORE = true;
			if(res) running = false;
			return res;
		}
		
		static getDesp = function() {
			switch(mode) {
				case 0 : return desp + " = 0";
				case 1 : return desp + " > 0";
				case 2 : return desp + " < 0";
			}
		}
		
		static trigger_action = function() { mode = (mode + 1) % 3; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 680, -1);
		}
	}
	
	function action_event_add_semaphore(_obj) : action_event(_obj) constructor {
		desp		 = "Add counter";
		color		 = c_ui_yellow;
		
		static run = function() {
			switch(step) {
				case 0 :
					running = true;
					SEMAPHORE++;
					runner = 0;
					step = 1;
					break;
				case 1 :
					runner += TIME_SEC * run_speed;
					if(runner > run_delay) {
						running = false;
						step = 0;
						return true;
					}
					break;
			}
			USE_SEMAPHORE = true;
			return false;
		}
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 680, 1);
		}
	}
	
	function action_event_reduce_semaphore(_obj) : action_event(_obj) constructor {
		desp		 = "Reduce counter";
		color		 = c_ui_yellow;
		
		static run = function() {
			switch(step) {
				case 0 :
					running = true;
					SEMAPHORE--;
					runner = 0;
					step = 1;
					break;
				case 1 :
					runner += TIME_SEC * run_speed;
					if(runner > run_delay) {
						running = false;
						step = 0;
						return true;
					}
					break;
			}
			USE_SEMAPHORE = true;
			return false;
		}
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 680, 1);
		}
	}
	
	function action_event_wait_semaphore_then_add(_obj) : action_event(_obj) constructor {
		desp		 = "Wait for counter then add";
		color		 = c_ui_yellow;
		show_trigger = true;
		condition	 = true;
		cond_mode    = 0;
		
		static run = function() {
			running = true;
			var res = SEMAPHORE == 0;
			USE_SEMAPHORE = true;
			if(res) {
				running = false;
				SEMAPHORE++;
			}
			return res;
		}
		
		static trigger_action = function() { mode = (mode + 1) % 3; }
		
		static draw_UI = function(_x, _y) {
			draw_dotted_to(_x, _y, window_get_width() / 2, 680, 1);
		}
	}
#endregion