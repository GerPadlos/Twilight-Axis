/obj/structure/ritualcircle/psydon_exalted
	name = "Rune of Psydon's Voice"
	icon_state = "psydon_chalky"
	desc = "A holy rune of Psydon, whispered into existence by the Allfather himself. It thirsts for proof of faith—souls turned and truths extracted."
	var/psydonrites = list("Rite of Exaltation")

/obj/structure/ritualcircle/psydon_exalted/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/old_god)
		to_chat(user, span_warning("The rune is silent. It does not know me."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_warning("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user, span_warning("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of the Allfather", src) as null|anything in psydonrites
	switch(riteselection)
		if("Rite of Exaltation")
			perform_exaltation(user)

/obj/structure/ritualcircle/psydon_exalted/proc/perform_exaltation(mob/living/carbon/human/user)
	if(!user.mind?.renegade_progress)
		to_chat(user, span_warning("The cross has not yet awakened within me..."))
		return
	var/datum/renegade_inquisitor_progress/P = user.mind.renegade_progress
	if(P.ascension_level >= 4)
		to_chat(user, span_notice("The cross is fully exalted. I have reached the peak of divine power."))
		return

	switch(P.ascension_level)
		if(0)
			if(P.convert_count < 1)
				to_chat(user, span_warning("The Allfather demands proof of your evangel. Convert one lost soul to His faith through words and will."))
				return
		if(1)
			if(P.torture_count < 1)
				to_chat(user, span_warning("The Allfather demands truth extracted through pain. Perform the rite of revelation upon one who hides their sins."))
				return
		if(2)
			if(P.convert_count < 3)
				to_chat(user, span_warning("The Allfather's flock must grow. Convert two more souls to His faith."))
				return
		if(3)
			if(P.torture_count < 3)
				to_chat(user, span_warning("The Allfather demands the truth from three sinners in total. Break them, and ascend."))
				return

	to_chat(user, span_cultsmall("I begin the Rite of Exaltation..."))
	if(!do_after(user, 5 SECONDS))
		return
	user.say("Allfather, witness my devotion!")
	if(!do_after(user, 5 SECONDS))
		return
	user.say("Their souls bend, their tongues loosen—grant me the strength I have earned!")
	if(!do_after(user, 5 SECONDS))
		return

	icon_state = "psydon_active"
	playsound(src, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
	loc.visible_message(span_userdanger("The rune flares with blinding silver light as [user] channels Psydon's wrath!"))
	P.ascend(user)
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	spawn(120)
		icon_state = "psydon_chalky"
