// Contains:
//	/datum/text_parser/parser

/datum/text_parser/parser
	var/input_line = ""
	var/output_lines[] = new()

/datum/text_parser/parser/proc/print(line)
	if(output_lines.len > 16)
		output_lines.Cut(1, 2)
	output_lines.Add(line)

/datum/text_parser/parser/proc/new_session()
	input_line = ""
	output_lines = new()

/datum/text_parser/parser/proc/process_line()
	print("> " + input_line)
