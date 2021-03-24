function set_turn() {
	with(thread) {
		ds_list_clear(actions);
		ds_list_add(actions, new action_event_start(self));
		
		var a = new action_event_wait_turn(self)
		a.turn = (count + 1) % 2;
		ds_list_add(actions, a);
		
		var a = count? new action_event_add(self) : new action_event_remove(self);
		ds_list_add(actions, a);
		
		var a = new action_event_set_turn(self)
		a.turn = count;
		ds_list_add(actions, a);
	}
}

function set_peterson() {
	with(thread) {
		ds_list_clear(actions);
		ds_list_add(actions, new action_event_start(self));
		
		var a = new action_event_set_flag(self)
		a.flag = count;
		ds_list_add(actions, a);
		
		var a = new action_event_set_turn(self)
		a.turn = (count + 1) % 2;
		ds_list_add(actions, a);
		
		var a = new action_event_wait_flag(self)
		a.flag = (count + 1) % 2;
		ds_list_add(actions, a);
		
		var a = new action_event_wait_turn(self)
		a.turn = (count + 1) % 2;
		ds_list_add(actions, a);
		
		var a = count? new action_event_add(self) : new action_event_remove(self);
		ds_list_add(actions, a);
		
		var a = new action_event_reset_flag(self)
		a.flag = count;
		ds_list_add(actions, a);
	}
}

function set_semaphore_software() {
	with(thread) {
		ds_list_clear(actions);
		ds_list_add(actions, new action_event_start(self));
		
		var a = new action_event_wait_semaphore(self)
		ds_list_add(actions, a);
		
		var a = new action_event_add_semaphore(self)
		ds_list_add(actions, a);
		
		var a = count? new action_event_add(self) : new action_event_remove(self);
		ds_list_add(actions, a);
		
		var a = new action_event_reduce_semaphore(self)
		ds_list_add(actions, a);
	}
}

function set_semaphore_hardware() {
	with(thread) {
		ds_list_clear(actions);
		ds_list_add(actions, new action_event_start(self));
		
		var a = new action_event_wait_semaphore_then_add(self)
		ds_list_add(actions, a);
		
		var a = count? new action_event_add(self) : new action_event_remove(self);
		ds_list_add(actions, a);
		
		var a = new action_event_reduce_semaphore(self)
		ds_list_add(actions, a);
	}
}