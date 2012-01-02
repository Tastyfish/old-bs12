// Contains:
// /datum/text_parser/parser/turtles (Emagged eliza)

/datum/text_parser/parser/turtles
	process_line()
		..()
		print(pick(
			"I LIKE TURTLES",
			"I HATE LAZINESS",
			"I LOVE NT",
			"I LIKE DONUTS",
			"I LIKE SAFETY",
			"I LIKE EFFICIENCY",
			"I LIKE SAVING MONEY",
			"I HATE BREAKING THE LAW",
			"I LIKE RESPECTING MY BOSS",
			"I LIKE PIZZA",
			"I HATE BEING INTOXICATED ON DUTY"))
		return
