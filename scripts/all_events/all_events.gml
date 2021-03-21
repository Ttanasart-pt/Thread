function draw_candybox(_x, _y, _candy) {
	var cx1 = _x - 75;
	var cx2 = _x + 75;
	var cy1 = _y - 100;
	var cy2 = _y + 100;
		
	draw_set_color($342626);
	draw_roundrect_ext(cx1, cy1, cx2, cy2, 32, 32, false);
		
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