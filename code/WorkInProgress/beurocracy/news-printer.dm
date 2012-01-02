// CONTAINS:
// the actual printing press

/obj/machinery/news_printer
	name = "Printing Press"
	icon = 'beurocracy.dmi'
	icon_state = "news-printer"
	density = 1
	anchored = 1
	var/p_amt = 30			// amount of paper
	var/num_copies = 1		// number of papers to print, will be maintained between jobs
	var/printing = 0		// are we printing
	var/job_num_copies = 0	// number of copies remaining in job

	var/datum/news/paper/template	// newspaper being edited

	var/obj/item/weapon/paper/t_buffer		// the paper scanned
	var/obj/item/weapon/paper/i_buffer		// the photo scanned

	var/print_wait = 0		// wait for current page to finish printing

/obj/machinery/news_printer/New()
	..()
	template = new()
	update()

/obj/machinery/news_printer/attackby(obj/item/weapon/O as obj, mob/user as mob)
	if (istype(O, /obj/item/weapon/paper) && !t_buffer)
		t_buffer = O
		usr.drop_item()
		O.loc = src

		spawn(5)
			usr << "Paper scanned."
			flick("news-printer_p", src)
			O.loc = src.loc
			updateDialog()

	if (istype(O, /obj/item/weapon/photo) && !i_buffer)
		// put it inside
		i_buffer = O
		usr.drop_item()
		O.loc = src

		spawn(5)
			usr << "Photo scanned."
			flick("news-printer_p", src)
			O.loc = src.loc
			updateDialog()

/obj/machinery/news_printer/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/news_printer/attack_ai(user as mob)
	return src.attack_hand(user)

/obj/machinery/news_printer/attack_hand(user as mob)
	// da UI
	var/dat
	if(..())
		return

	if(src.stat)
		user << "[name] does not seem to be responding to your button mashing."
		return

	dat = "<HEAD><TITLE>Printing Press</TITLE></HEAD><TT><b>Xeno Corp. Printing Press</b><hr>"

	if(printing)
		dat += "[job_num_copies] papers remaining."
	else
		dat += "<div style=\"border:2px etched #888\">"

		// general settings
		dat += "Title: <a href='?src=\ref[src];title=1'>[template.title]</a><br>"
		dat += "Subtitle: <a href='?src=\ref[src];subtitle=1'>[template.subtitle]</a><br>"
		dat += "Footer: <a href='?src=\ref[src];footer=1'>[template.footer]</a><br><hr>"

		// articles
		dat += "<ol>"

		for(var/datum/news/article/A in template.articles)
			var/ID = template.articles.Find(A)
			dat += "<li><a href='?src=\ref[src];a_title=[ID]'>[A.title]</a>"
			dat += " <a href='?src=\ref[src];a_full=[ID]'>[A.full ? "Full Page" : "Column"]</a>"
			dat += " <a href='?src=\ref[src];a_content=[ID]'>Edit</a>"

		dat += "</ol><a href='?src=\ref[src];add_new=1'>Add New</a>"
		dat += " <a href='?src=\ref[src];add_buff=1'>Add From Buffer</a><hr>"

		// print
		dat += "<A href='?src=\ref[src];num=-10'>-</a>"
		dat += "<A href='?src=\ref[src];num=-1'>-</a>"
		dat += " [num_copies] "
		dat += "<A href='?src=\ref[src];num=1'>+</a>"
		dat += "<A href='?src=\ref[src];num=10'>+</a><br><br>"

		dat += "<A href='?src=\ref[src];print=1'>Print</a><hr>"

		// templates
		dat += "Title Template: <a href=\"\">[template.title_template]</a><br>"
		dat += "Header Template: <a href=\"\">[template.header_template]</a><br>"
		dat += "Footer Template: <a href=\"\">[template.footer_template]</a><br>"
		dat += "Article Template: <a href=\"\">[template.article_template]</a>"

		dat += "</div>"

	dat += "<hr></TT>"

	user << browse(dat, "window=news_printer")
	onclose(user, "news_printer")

/obj/machinery/news_printer/proc/update()
	if(printing && !stat)
		icon_state = "news-printer_p"
	else
		icon_state = "news-printer"

/obj/machinery/news_printer/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)

	if(href_list["num"])
		num_copies += text2num(href_list["num"])
		if(num_copies < 1)
			num_copies = 1
		else if(num_copies > 20)
			num_copies = 20
		updateDialog()
	if(href_list["print"])
		printing = 1
		job_num_copies = num_copies
		template.update()
		update()
		updateDialog()
	if(href_list["add_new"])
		var/datum/news/article/A = new()
		template.articles += A
		updateDialog()
	if(href_list["add_buff"])
		var/datum/news/article/A = new()
		A.title = t_buffer.name
		A.content = t_buffer.info
		template.articles += A
		updateDialog()
	if(href_list["a_title"])
		var/datum/news/article/A = template.articles[text2num(href_list["a_title"])]
		var/n_name = input(usr, "What would you like to label the article?", "Article Labelling", null) as text
		A.title = copytext(n_name, 1, 32)
		updateDialog()
	if(href_list["a_full"])
		var/datum/news/article/A = template.articles[text2num(href_list["a_full"])]
		A.full = !A.full
		updateDialog()
	if(href_list["a_content"])
		var/datum/news/article/A = template.articles[text2num(href_list["a_content"])]
		var/t = A.content
		do
			t = input(usr, "What text do you wish to add?", A.title, t) as message

			if(lentext(t) >= MAX_PAPER_MESSAGE_LEN)
				var/cont = input(usr, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
				if(cont == "no")
					break
		while(lentext(t) > MAX_PAPER_MESSAGE_LEN)

		A.content = copytext(t, 1, MAX_PAPER_MESSAGE_LEN)
	if(href_list["title"])
		var/n_name = input(usr, "What would you like to title the newspaper?", "Title", template.title) as text
		template.title = copytext(n_name, 1, 32)
	if(href_list["subtitle"])
		var/n_name = input(usr, "What would you like to subtitle the newspaper?", "Subtitle", template.subtitle) as text
		template.subtitle = copytext(n_name, 1, 32)
	if(href_list["footer"])
		var/n_name = input(usr, "What would you like to write in the footer?", "Footer", template.footer) as text
		template.footer = copytext(n_name, 1, 32)

/obj/machinery/news_printer/process()
	if(src.stat)
		usr << "[name] does not seem to be responding to your button mashing."
		return

	if(printing && !print_wait)
		print_wait = 1
		// make noise
		playsound(src, 'polaroid1.ogg', 50, 1)
		spawn(5)
			// make newpaper
			var/obj/item/weapon/newspaper/P = new(src.loc)
			P.pages = template.pages

			// copy counting stuff
			job_num_copies -= 1
			if(job_num_copies == 0)
				usr << "[name] beeps happily."
				printing = 0
				update()
			updateDialog()
			print_wait = 0
