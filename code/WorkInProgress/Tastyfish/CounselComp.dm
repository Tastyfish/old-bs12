// Contains:
//	/obj/machinery/computer/counselor - Counselor Computer

/obj/machinery/computer/counselor
	name = "CounselComp(R) Unit"
	icon = 'computer.dmi'
	icon_state = "console"
	brightnessred = 0
	brightnessgreen = 2
	brightnessblue = 0
	var/long_name = "CounselComp(R) Psychological Counseling Unit"
	var/datum/text_parser/parser/P = new/datum/text_parser/parser/eliza()
	var/emagged = 0

/obj/machinery/computer/counselor/New()
	..()
	P.new_session()

/obj/machinery/computer/counselor/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if(..())
		return

	if(istype(O, /obj/item/weapon/card/emag)) // E-mag
		if (!src.emagged)
			user << "\red You short out [src]'s target intelligence circuits."
			P = new/datum/text_parser/parser/turtles()
		else
			user << "\red You shock some IQ points back into [src]."
			P = new/datum/text_parser/parser/eliza()
		P.new_session()
		emagged = !emagged

/obj/machinery/computer/counselor/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/counselor/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/counselor/attack_hand(mob/user as mob)
	if(..())
		return

	var/dat

	if(src.stat)
		user << "[name] appears to be asleep!"
		return

	dat = "<HEAD><TITLE>[name]</TITLE></HEAD><TT><b>[long_name]</b><hr>"

	dat += "<a href='?src=\ref[src];new=1'>New Session</a><br><br>"

	for(var/i = 1, i <= P.output_lines.len, i++)
		dat += P.output_lines[i] + "<br>"
	dat += "&gt; <a href='?src=\ref[src];input=1'>________________</a>"

	dat += "<hr></TT>"

	user << browse(dat, "window=counselcomp")
	onclose(user, "counselcomp")

/obj/machinery/computer/counselor/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)

	if(href_list["new"])
		P.new_session()
		updateDialog()
	if(href_list["input"])
		P.input_line = input("> ", "[name]", "") as text
		P.process_line()
		updateDialog()
