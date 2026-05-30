/datum/objective/ascend
	name = "ascend"
	explanation_text = "Complete the tasks given by Psydon's cross and ascend to divine power through the Rite of Exaltation."
	triumph_count = 5

/datum/objective/ascend/check_completion()
	if(!owner || !owner.current)
		return FALSE
	var/mob/living/carbon/human/H = owner.current
	var/obj/item/clothing/neck/roguetown/psicross/silver/exalted/cross = H.get_item_by_slot(SLOT_WRISTS)
	if(!istype(cross))
		cross = H.get_item_by_slot(SLOT_NECK)
	if(!istype(cross))
		return FALSE
	var/datum/renegade_inquisitor_progress/P = H.mind?.renegade_progress
	if(P && P.ascension_level >= 4)
		return TRUE
	return FALSE
