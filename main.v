import arrays

[params]
struct WordleConfig {
	word_length int = 5
	max_guesses int = 6
	// TODO dictionary?
}

struct WordleState {
	config WordleConfig
	answer string
mut:
	guesses []string
}

fn new_wordle(wc WordleConfig) WordleState {
	ws := WordleState{}
	return ws
}

fn (mut ws WordleState) check_guess(guess string) {
	assert ws.guesses.len < ws.config.max_guesses // TODO raise an error if this is false
	assert guess.runes().len == ws.config.word_length
	ws.guesses << guess

	arrays.map(fn (a, b) bool { a == b}, arrays.group<rune>(guess.runes(), ws.answer.runes()))
}

fn main() {
	print("Hi, I'm gonna be a wordle solver!")
	mut ws := new_wordle()
	ws.check_guess('purse')
	ws.check_guess('steak')
	ws.check_guess('class')
	ws.check_guess('floss')
	ws.check_guess('fetch')
	ws.check_guess('churn')
}
