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
			
				jar_show_x = lerp_float(jar_show_x, jar_x, 5 / run_speed, 4);
				jar_show_y = lerp_float(jar_show_y, jar_y, 5 / run_speed, 4);
				
				return (jar_show_x == jar_x && jar_show_y == jar_y);
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
					if(runner == 0) action();
					runner += TIME_SEC * run_speed;
					if(runner > 1)
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
			return draw_ext(_x, _y, color);	
		}
		
		static draw_trigger = function(_x, _y) {
			var size = getSize();
			var tx = _x + size[0] / 2 + 20;
			var ty = _y;
			
			var aa = 1;
			if(point_in_circle(mx, my, tx, ty, 16)) {
				if(mouse_check_button_pressed(mb_left)) trigger_action();
			} else
				aa = 0.5;
			
			draw_sprite_ext(s_trigger, 0, tx, ty, .75, .75, 0, c_ui_blue_grey, aa);
		}
		
		static getSize = function() {
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(getDesp()) + 32;
			var hh = 50;
			
			return [ll, hh];
		}
		
		static getDesp = function() {
			return desp;	
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
		
		static action = function() {
			obj.candy_count++;
			controller.candy_expected++;
		}
	}
	
	function action_event_remove(_obj) : action_event(_obj) constructor {
		desp  = "Remove candy";
		color = c_ui_red;
		
		static action = function() {
			obj.candy_count--;
			controller.candy_expected--;
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
			return desp + " " + string(turn);
		}
		
		static trigger_action = function() { turn = (turn + 1) % 2; }
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
			return desp + " " + string(turn);
		}
		
		static trigger_action = function() { turn = (turn + 1) % 2; }
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
	}
#endregion