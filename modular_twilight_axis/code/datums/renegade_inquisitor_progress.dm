/datum/renegade_inquisitor_progress
	var/ascension_level = 0
	var/convert_count = 0
	var/torture_count = 0
	var/list/spells_granted = list()

/datum/renegade_inquisitor_progress/proc/ascend(mob/living/carbon/human/H)
	if(ascension_level >= 4)
		return FALSE
	ascension_level++
	switch(ascension_level)
		if(1)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_WIL, 2)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/smoke_veil)
			to_chat(H, span_userdanger("The cross whispers its first secret. A soul turned is worth more than a soul broken."))
		if(2)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_INT, 2)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/blink)
			to_chat(H, span_userdanger("The cross shares its second secret. Truth extracted through pain is the purest truth."))
		if(3)
			H.change_stat(STATKEY_CON, 2)
			H.change_stat(STATKEY_SPD, 2)
			H.mind?.AddSpell(new /datum/action/cooldown/spell/repulse)
			to_chat(H, span_userdanger("The cross reveals its third secret. The Allfather's flock grows, and so do you."))
		if(4)
			H.change_stat(STATKEY_STR, 3)
			H.change_stat(STATKEY_WIL, 3)
			H.change_stat(STATKEY_CON, 3)
			H.change_stat(STATKEY_SPD, 2)
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_LCK, 1)
			ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
			to_chat(H, span_userdanger("THE CROSS SINGS! PSYDON'S VOICE ROARS WITHIN YOUR MIND! YOU HAVE ASCENDED!"))
			H.visible_message(span_userdanger("[H]'s body radiates blinding divine light! The Allfather's wrath made flesh!"))
			playsound(H, 'sound/magic/holyshield.ogg', 100, FALSE)
	return TRUE

/datum/mind
	var/datum/renegade_inquisitor_progress/renegade_progress
