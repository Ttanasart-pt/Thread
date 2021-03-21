/// @description init
#region run
	if(is_running) {
		if(action_index < ds_list_size(actions)) {
			if(actions[| action_index].condition)  {
				var cond = actions[| action_index].run();
				var ind = action_index;
				while(++ind < ds_list_size(actions)) {
					if(actions[| ind].condition) {
						var c = actions[| ind].run();
						switch(actions[| ind - 1].cond_mode) {
							case 0 : cond = cond || c; break;	
							case 1 : cond = cond && c; break;	
						}
					} else
						break;
				}
				
				if(cond) {
					ind = action_index - 1;
					while(++ind < ds_list_size(actions)) {
						if(!actions[| ind].condition) break;
						actions[| ind].running = false;
					}
					action_index = ind;
				}
			} else if(actions[| action_index].run())
				action_index++;
		}
	}
#endregion