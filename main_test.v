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
