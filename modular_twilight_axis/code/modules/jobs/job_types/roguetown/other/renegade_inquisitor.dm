// Renegade Inquisitor — standalone antag job & outfit.
// No input() during spawn; weapon choice is handled by /obj/item/renegade_weapon_kit in backpack.

/datum/job/roguetown/renegade_inquisitor
	title = "Renegade Inquisitor"
	flag = RENEGADE_INQUISITOR

/datum/job/roguetown/renegade_inquisitor/New()
	. = ..()
	log_game("RENEGADE DEBUG: job datum created, title=[title]")
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	antag_job = TRUE

	tutorial = "Once a puritan of unmatched aptitude, you abandoned the Orthodoxy during a distant mission when you found a holy cross of Psydon. The Allfather speaks to you now, granting you strength and purpose beyond the dogma of the church. You are hunted by your former brothers, yet you walk a higher path—one of ascension through divine will."

	outfit = /datum/outfit/job/roguetown/renegade_inquisitor
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_RENEGADE_INQUISITOR
	announce_latejoin = FALSE
	min_pq = 25
	max_pq = null
	round_contrib_points = null

	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 30 MINUTES
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_SELF_SUSTENANCE, TRAIT_TEMPO)
	cmode_music = 'sound/music/inquisitorcombat.ogg'

/datum/job/roguetown/renegade_inquisitor/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	log_game("RENEGADE DEBUG: after_spawn called")
	if(!ishuman(L))
		log_game("RENEGADE DEBUG: not human, aborting")
		return
	var/mob/living/carbon/human/H = L
	var/datum/job/J = SSjob.GetJob("Renegade Inquisitor")
	log_game("RENEGADE DEBUG: GetJob('Renegade Inquisitor') = [J]")

	// Force-move to Wretch spawn landmarks
	if(latejoin)
		var/obj/effect/landmark/start/S = locate(/obj/effect/landmark/start/wretchlate) in GLOB.start_landmarks_list
		if(S)
			H.forceMove(S.loc)
		else if(SSjob.latejoin_trackers.len)
			var/atom/destination = pick(SSjob.latejoin_trackers)
			destination.JoinPlayerHere(H, TRUE)
	else
		var/obj/effect/landmark/start/S = locate(/obj/effect/landmark/start/wretch) in GLOB.start_landmarks_list
		if(S)
			H.forceMove(S.loc)
		else if(SSjob.latejoin_trackers.len)
			var/atom/destination = pick(SSjob.latejoin_trackers)
			destination.JoinPlayerHere(H, TRUE)

	// Assign antag datum
	if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/renegade_inquisitor))
		var/datum/antagonist/new_antag = new /datum/antagonist/renegade_inquisitor()
		H.mind.add_antag_datum(new_antag)

	// Rename
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/inq = "Fallen Magister"
	H.real_name = "[inq] [prev_real_name]"
	H.name = "[inq] [prev_name]"

	if(H.mind)
		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/job/roguetown/renegade_inquisitor/on_round_removal(mob/M)
	if(same_job_respawn_delay && M?.ckey)
		GLOB.job_respawn_delays[M.ckey] = world.time + same_job_respawn_delay

// -------------------------------------------------------------------------
// Outfit — fixed gear, no input(), no choose_loadout.
// Weapon selection is deferred to the /obj/item/renegade_weapon_kit in backpack.
// -------------------------------------------------------------------------
/datum/outfit/job/roguetown/renegade_inquisitor
	name = "Renegade Inquisitor"
	jobtype = /datum/job/roguetown/renegade_inquisitor
	allowed_patrons = list(/datum/patron/old_god)

/datum/outfit/job/roguetown/renegade_inquisitor/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_patron(/datum/patron/old_god)

	H.verbs |= /mob/living/carbon/human/proc/faith_test
	H.verbs |= /mob/living/carbon/human/proc/torture_victim

	// Common tattered base
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver/exalted
	id = /obj/item/clothing/ring/signet/psy
	backr = /obj/item/storage/backpack/rogue/satchel/otavan

	backpack_contents = list(
		/obj/item/storage/keyring/inquisitor = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
		/obj/item/rope/inqarticles/inquirycord = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/ritechalk = 1,
		/obj/item/renegade_weapon_kit = 1,
	)

	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	head = /obj/item/clothing/head/roguetown/inqhat
	mask = /obj/item/clothing/mask/rogue/spectacles/inq/spawnpair
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat

	// Fixed ranged loadout — no input(), no crash risk
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/psydon
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/quiver/bolt/standard

	// Stats
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_SPD, 3)

	// Skills
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)

	// Traits
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RITUALIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

	// Devotion
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T3, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)

	// Spells
	H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
	H.mind?.AddSpell(new /datum/action/cooldown/spell/miracle/intervention)

	// Initialize ascension progress
	if(H.mind)
		H.mind.renegade_progress = new /datum/renegade_inquisitor_progress()

	renegade_inquisitor_bounty(H)

// Bounty proc
/proc/renegade_inquisitor_bounty(mob/living/carbon/human/H)
	if(!H)
		return
	var/race = H.dna?.species || "Unknown"
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%"
	) || "of average height"
	var/descriptor_body = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%"
	) || "average build"
	var/descriptor_voice = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%"
	) || "ordinary voice"
	var/bounty_total = rand(300, 400)
	add_bounty(
		H.real_name, race, gender,
		descriptor_height, descriptor_body, descriptor_voice,
		bounty_total, FALSE,
		"Desertion and heresy against the Otavan Orthodoxy",
		GLOB.bounty_posters["OTAVAN"]
	)
	GLOB.excommunicated_players += H.real_name
	to_chat(H, span_danger("The Otavan Orthodoxy has placed a bounty on your head for your treasonous desertion. You are excommunicated."))

// Dedicated landmark for mappers (optional; after_spawn handles spawn without it)
/obj/effect/landmark/start/renegade_inquisitor
	name = "Renegade Inquisitor"
	icon_state = "arrow"
	jobspawn_override = list("Renegade Inquisitor")
