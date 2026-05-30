// Weapon kit — defers melee weapon selection to in-game usage.
// No input() during spawn, so no roundstart client crash.

/obj/item/renegade_weapon_kit
	name = "weapon cache"
	desc = "A worn leather roll containing the instruments of judgement."
	icon = 'icons/obj/storage.dmi'
	icon_state = "scroll"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/renegade_weapon_kit/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/weapons = list("Psydonic Longsword", "Psydonic Rapier", "Daybreak (Whip)", "Stigmata (Halberd)", "Eucharist (Rapier)")
	var/weapon_choice = input(H, "FLOURISH YOUR SILVER.", "WIELD THEM IN HIS NAME.") as null|anything in weapons
	if(!weapon_choice)
		weapon_choice = "Psydonic Longsword"

	var/obj/item/weapon
	var/obj/item/scabbard
	switch(weapon_choice)
		if("Psydonic Longsword")
			weapon = new /obj/item/rogueweapon/sword/long/psysword/preblessed(get_turf(H))
			scabbard = new /obj/item/rogueweapon/scabbard/sword/noble(get_turf(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Psydonic Rapier")
			weapon = new /obj/item/rogueweapon/sword/rapier/psy/preblessed(get_turf(H))
			scabbard = new /obj/item/rogueweapon/scabbard/sword/noble(get_turf(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Daybreak (Whip)")
			weapon = new /obj/item/rogueweapon/whip/antique/psywhip(get_turf(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
		if("Stigmata (Halberd)")
			weapon = new /obj/item/rogueweapon/halberd/psyhalberd/relic(get_turf(H))
			scabbard = new /obj/item/rogueweapon/scabbard/gwstrap(get_turf(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Eucharist (Rapier)")
			weapon = new /obj/item/rogueweapon/sword/rapier/psy/relic(get_turf(H))
			scabbard = new /obj/item/rogueweapon/scabbard/sword/noble(get_turf(H))
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)

	if(weapon)
		H.put_in_hands(weapon)
	if(scabbard)
		H.put_in_hands(scabbard)

	to_chat(H, span_notice("You retrieve the [weapon_choice] from the cache."))
	qdel(src)
