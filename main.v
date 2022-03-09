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

enum LetterColor {
	gray
	green
	yellow
}

fn new_wordle(wc WordleConfig) WordleState {
	ws := WordleState{
		answer: 'happy' // TODO make this be random
	}
	return ws
}

fn (mut ws WordleState) check_guess(guess string) []LetterColor {
	assert ws.guesses.len < ws.config.max_guesses
	assert guess.runes().len == ws.config.word_length
	ws.guesses << guess

	mut letter_colors := []LetterColor{len: ws.config.word_length}
	for i, guess_rune in guess.runes() {
		answer_rune := ws.answer.runes()[i]
		if guess_rune == answer_rune {
			letter_colors[i] = .green
		}
	}
	for i, guess_rune in guess.runes() {
		if letter_colors[i] == .gray {
			for j in 0 .. ws.config.word_length {
				if i == j || letter_colors[j] == .green {
					continue
				}
				answer_rune := ws.answer.runes()[j]
				if guess_rune == answer_rune {
					letter_colors[i] = .yellow
					break
				}
			}
		}
	}
	return letter_colors
}

fn main() {
	println("Hi, I'm gonna be a wordle solver!")
	mut ws := new_wordle()
	ws.check_guess('purse')
	ws.check_guess('steak')
	ws.check_guess('class')
	ws.check_guess('floss')
	ws.check_guess('fetch')
	ws.check_guess('churn')
}
