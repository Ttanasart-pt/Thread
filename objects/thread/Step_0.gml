/// @description init
#region run
	if(is_running) {
		if(action_index < array_length(actions)) {
			if(actions[action_index].run())
				action_index++;
		}
	}
#endregion