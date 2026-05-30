/datum/action/cooldown/spell/convert_heretic/cast(atom/cast_on)
	var/result = ..()
	if(result && owner?.mind?.renegade_progress)
		owner.mind.renegade_progress.convert_count++
	return result
