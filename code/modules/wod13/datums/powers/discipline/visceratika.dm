/datum/discipline/visceratika
	name = "Visceratika"
	desc = "The Discipline of Visceratika is the exclusive possession of the Gargoyle bloodline and is an extension of their natural affinity for stone, earth, and things made thereof."
	icon_state = "visceratika"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/visceratika

/datum/discipline_power/visceratika
	name = "Visceratika power name"
	desc = "Visceratika power description"

	activate_sound = 'code/modules/wod13/sounds/visceratika.ogg'

//WHISPERS OF THE CHAMBER
/datum/discipline_power/visceratika/whispers_of_the_chamber
	name = "Whispers of the Chamber"
	desc = "Sense everyone in the same area as you."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE

	cooldown_length = 5 SECONDS

/datum/discipline_power/visceratika/whispers_of_the_chamber/activate()
	. = ..()
	for(var/mob/living/player in GLOB.player_list)
		if(get_area(player) == get_area(owner))
			var/their_name = player.name
			if(ishuman(player))
				var/mob/living/carbon/human/human_player = player
				their_name = human_player.true_real_name
			to_chat(owner, "- [their_name]")

//SCRY THE HEARTHSTONE
/datum/discipline_power/visceratika/scry_the_hearthstone
	name = "Scry the Hearthstone"
	desc = "Sense the exact locations of individuals around you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SEE

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/scry_the_hearthstone/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, "Visceratika Scry the Hearthstone")

/datum/discipline_power/visceratika/scry_the_hearthstone/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, "Visceratika Scry the Hearthstone")

//BOND WITH THE MOUNTAIN
/datum/discipline_power/visceratika/bond_with_the_mountain
	name = "Bond with the Mountain"
	desc = "Merge with your surroundings and become difficult to see."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE | DISC_CHECK_LYING

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/bond_with_the_mountain/activate()
	. = ..()
	owner.alpha = 10

/datum/discipline_power/visceratika/bond_with_the_mountain/deactivate()
	. = ..()
	owner.alpha = 255

//ARMOR OF TERRA
/datum/discipline_power/visceratika/armor_of_terra
	name = "Armor of Terra"
	desc = "Solidify into stone and become invulnerable."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	violates_masquerade = TRUE

	toggled = TRUE
	cooldown_length = 1 MINUTES
	duration_length = 1 MINUTES

/datum/discipline_power/visceratika/armor_of_terra/activate()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(try_deactivate), null, TRUE), duration_length * 2) //failsafe (no, you can't stay in statue mode forever, 2 mins is enough)
	to_chat(owner, span_warning("You harden your skin far more than you're able to take for long!"))
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_MUTE, STATUE_MUTE)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)

	owner.name_override = "Statue of [owner.real_name]"
	owner.status_flags |= GODMODE
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	owner.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)

	for(var/obj/stuff in owner.contents) //no stealing
		ADD_TRAIT(stuff, TRAIT_NODROP, MAGIC)

/datum/discipline_power/visceratika/armor_of_terra/deactivate()
	. = ..()
	to_chat(owner, span_warning("You soften your skin, to your normal hardness."))
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_MUTE, STATUE_MUTE)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, MAGIC_TRAIT)

	owner.name_override = null
	owner.status_flags &= GODMODE
	owner.remove_atom_colour(FIXED_COLOUR_PRIORITY)

	for(var/obj/item/stuff in owner.contents)
		REMOVE_TRAIT(stuff, TRAIT_NODROP, MAGIC)

//FLOW WITHIN THE MOUNTAIN
/datum/discipline_power/visceratika/flow_within_the_mountain
	name = "Flow Within the Mountain"
	desc = "Merge with solid stone, and move through it without disturbing it."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE

	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 15 SECONDS
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/flow_within_the_mountain/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "Visceratika Flow Within the Mountain")
	owner.alpha = 10

/datum/discipline_power/visceratika/flow_within_the_mountain/deactivate()
	. = ..()
	owner.alpha = 255
	REMOVE_TRAIT(owner, TRAIT_PASS_THROUGH_WALLS, "Visceratika Flow Within the Mountain")

/turf/closed/Enter(atom/movable/mover, atom/oldloc)
	if(isliving(mover))
		var/mob/living/moving_mob = mover
		if(HAS_TRAIT(moving_mob, TRAIT_PASS_THROUGH_WALLS) && (get_area(moving_mob) == get_area(src)))
			return TRUE
	return ..()

