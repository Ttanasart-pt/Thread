/// @description init
#region run
	if(is_running) {
		if(action_index < ds_list_size(actions)) {
			if(actions[| action_index].run())
				action_index++;
		}
	}
#endregion