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
	var xst = 80;
	var yst = 100 + 50;
#endregion

#region canday jar
	draw_candybox(cw / 2, 300, candy_count);
#endregion