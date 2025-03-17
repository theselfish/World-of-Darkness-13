/datum/vampireclane/ministry
	name = CLAN_SETITES
	desc = "The Ministry, also called the Ministry of Set, Followers of Set, or Setites, are a clan of vampires who believe their founder was the Egyptian god Set."
	curse = "Decreased moving speed in lighted areas."
	clane_disciplines = list(
		/datum/discipline/obfuscate,
		/datum/discipline/presence,
		/datum/discipline/serpentis
	)
	male_clothes = /obj/item/clothing/under/vampire/slickback
	female_clothes = /obj/item/clothing/under/vampire/burlesque
	clan_keys = /obj/item/vamp/keys/setite

/datum/vampireclane/ministry/on_gain(mob/living/carbon/human/H)
	. = ..()
	H.physiology.burn_mod = 1.5 // Setites take extra damage from burn.

/datum/vampireclane/ministry/post_gain(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/organ/eyes/night_vision/NV = new()
	NV.Insert(H, TRUE, FALSE)
