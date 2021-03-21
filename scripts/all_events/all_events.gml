function draw_candybox(_x, _y, _candy) {
	var cx1 = _x - 75;
	var cx2 = _x + 75;
	var cy1 = _y - 100;
	var cy2 = _y + 100;
	
	draw_set_alpha(0.5);
	draw_set_color($342626);
	draw_roundrect_ext(cx1, cy1, cx2, cy2, 32, 32, false);
	draw_set_alpha(1);
		
	var line = 0;
	var indx = 0;
	draw_set_color(c_white);
		
	for(var i = 0; i < _candy; i++) {
		var cx = cx1 + 36 + indx * 40 + (line % 2) * 20;
		var cy = cy2 + 6 - line * 40 - 40;
			
		draw_circle(cx, cy, 16, false);
		if(++indx > (line + 1) % 2 + 1) {
			line++;
			indx = 0;
		}
	}
}

#region actions
	function action_event(_obj) constructor {
		step = 0;
		obj = _obj;
		
		desp  = "";
		color = c_ltgray;
		
		static jar_pick = function() {
			with(obj) {
				candy_count = controller.candy_count;
			
				jar_show_x = lerp_float(jar_show_x, jar_x, 5 / run_speed, 1);
				jar_show_y = lerp_float(jar_show_y, jar_y, 5 / run_speed, 1);
				
				return (jar_show_x == jar_x && jar_show_y == jar_y);
			}
		}
		static jar_return = function() {
			with(obj) {
				jar_show_x = lerp_float(jar_show_x, jar_x_start, 5 / run_speed, 1);
				jar_show_y = lerp_float(jar_show_y, jar_y_start, 5 / run_speed, 1);
				
				if(jar_show_x == jar_x_start && jar_show_y == jar_y_start) {
					controller.candy_count = candy_count;
					return true;
				}
				return false;
			}
		}
		static action = function() {}
		
		runner = 0;
		static run = function() {
			switch(step) {
				case 0 : 
					if(jar_pick()) {
						step = 1; 
						runner = 0;
					}
					break;
				case 1 : 
					if(runner == 0) action();
					runner += delta_time / 1000000 * run_speed;
					if(runner > 1)
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
		
		draw_alpha = 1;
		
		static draw_ext = function(_x, _y, _color) {
			if(step == 1 || !is_running) 
				draw_alpha = lerp_float(draw_alpha, 1, 3);
			else
				draw_alpha = lerp_float(draw_alpha, 0.2, 3);
			
			draw_set_alpha(draw_alpha);
			draw_set_color(merge_color(color, _color, 0.5));
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(desp) + 32;
			var hh = string_height(desp) + 16;
			var x1 = _x - ll / 2;
			var x2 = _x + ll / 2;
			var y1 = _y - hh / 2;
			var y2 = _y + hh / 2;
			draw_roundrect_ext(x1, y1, x2, y2, hh, hh, false);
			draw_set_alpha(1);
			
			draw_set_color(c_black);
			draw_text(_x, _y, desp);
			
			return [x1, x2, y1, y2];
		}
		static draw_left = function(_x, _y) {
			return draw_left_color(_x, _y, color);
		}
		
		static draw_left_color = function(_x, _y, _color) {
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(desp) + 32;
			
			return draw_ext(_x + ll / 2, _y, _color);
		}
		static draw = function(_x, _y) {
			return draw_ext(_x, _y, color);	
		}
		
		static getSize = function() {
			draw_set_text(f_p0, fa_center, fa_center);
			var ll = string_width(desp) + 32;
			var hh = string_height(desp) + 16;
			
			return [ll, hh];
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
		}
	}
	
	function action_event_remove(_obj) : action_event(_obj) constructor {
		desp  = "Remove candy";
		color = c_ui_red;
		
		static action = function() {
			obj.candy_count--;
		}
	}
#endregion