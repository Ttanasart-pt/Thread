function draw_line_sprite(x1, y1, x2, y2, sprite, space, shift) {
	var dirr = point_direction(x1, y1, x2, y2);
	var dist = point_distance(x1, y1, x2, y2);
	var sx = lengthdir_x(space, dirr);
	var sy = lengthdir_y(space, dirr);
	
	var ss = shift % space;
	var xx = x1 + lengthdir_x(ss, dirr);
	var yy = y1 + lengthdir_y(ss, dirr);
	var ds = ss;
	
	while(ds < dist) {
		draw_sprite_ext(sprite, 0, xx, yy, 1, 1, 0, draw_get_color(), draw_get_alpha());
		
		xx += sx;
		yy += sy;
		ds += space;
	}
}