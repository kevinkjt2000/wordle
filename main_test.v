module main

fn test_submit_guess_produces_correct_colors() {
	mut ws := new_wordle(answer: 'happy')
	assert ws.color_guess('steak') == [.gray, .gray, .gray, .yellow, .gray]
	assert ws.color_guess('takes') == [.gray, .green, .gray, .gray, .gray]
	assert ws.color_guess('panda') == [.yellow, .green, .gray, .gray, .gray]
	assert ws.color_guess('happy') == [.green, .green, .green, .green, .green]

	ws = new_wordle(answer: 'sweet')
	assert ws.color_guess('murky') == [.gray, .gray, .gray, .gray, .gray]
	assert ws.color_guess('takes') == [.yellow, .gray, .gray, .green, .yellow]
	assert ws.color_guess('joint') == [.gray, .gray, .gray, .gray, .green]
	assert ws.color_guess('fleet') == [.gray, .gray, .green, .green, .green]
	assert ws.color_guess('sweet') == [.green, .green, .green, .green, .green]
}

fn test_yellow_letters_remove_possible_guesses() {
	mut ws := new_wordle(show_letters: true, answer: 'scald')
	ws.submit_guess('steal')
	assert 'salad' !in ws.remaining_answers
}

fn test_final_answer_remains_at_end() {
	mut ws := new_wordle(answer: 'exist')
	ws.submit_guess('steal')
	ws.submit_guess('round')
	ws.submit_guess('testy')
	ws.submit_guess('might')
	ws.submit_guess('exist')
	assert ws.remaining_answers.len == 1
}
