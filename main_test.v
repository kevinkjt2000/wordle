module main

fn test_check_guess_produces_correct_colors() {
	mut ws := WordleState{
		answer: 'happy'
	}
	assert ws.check_guess('steak') == [.gray, .gray, .gray, .yellow, .gray]
	assert ws.check_guess('takes') == [.gray, .green, .gray, .gray, .gray]
	assert ws.check_guess('panda') == [.yellow, .green, .gray, .gray, .gray]
	assert ws.check_guess('happy') == [.green, .green, .green, .green, .green]

	ws = WordleState{
		answer: 'sweet'
	}
	assert ws.check_guess('murky') == [.gray, .gray, .gray, .gray, .gray]
	assert ws.check_guess('takes') == [.yellow, .gray, .gray, .green, .yellow]
	assert ws.check_guess('joint') == [.gray, .gray, .gray, .gray, .green]
	assert ws.check_guess('fleet') == [.gray, .gray, .green, .green, .green]
	assert ws.check_guess('sweet') == [.green, .green, .green, .green, .green]
}
