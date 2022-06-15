import os
import rand
import term

[params]
struct WordleConfig {
	word_length     int    = 5
	max_guesses     int    = 6
	answers_file    string = './word-lists/wordle-nyt-answers-alphabetical.txt'
	dictionary_file string = './word-lists/wordle-nyt-dictionary.txt'
	show_letters    bool
	answer          string
}

struct WordleState {
	config     WordleConfig
	dictionary []string
	answer     string
mut:
	guesses           []string
	remaining_answers []string
}

enum LetterColor {
	gray = 0x2c3032
	green = 0x42713e
	yellow = 0x917f2f
}

fn print_guess(colors []LetterColor, guess string, show_letters bool) {
	for i, color in colors {
		if show_letters {
			print(term.bg_hex(int(color), guess[i].ascii_str()))
		} else {
			print(term.bg_hex(int(color), ' '))
		}
	}
}

fn new_wordle(wc WordleConfig) WordleState {
	mut answer := wc.answer
	answers := os.read_lines(wc.answers_file) or { [] }
	if wc.answer == '' {
		random_answer_index := rand.int_in_range(0, answers.len) or { 0 }
		answer = answers[random_answer_index]
	}
	dictionary := os.read_lines(wc.dictionary_file) or { [] }
	ws := WordleState{
		config: wc
		dictionary: dictionary
		answer: answer
		remaining_answers: answers
	}
	return ws
}

fn (ws WordleState) color_guess(guess string) []LetterColor {
	mut letter_colors := []LetterColor{len: ws.config.word_length, init: LetterColor.gray}
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

fn (mut ws WordleState) submit_guess(guess string) {
	assert ws.guesses.len < ws.config.max_guesses
	assert guess.runes().len == ws.config.word_length
	assert guess in ws.dictionary
	ws.guesses << guess

	letter_colors := ws.color_guess(guess)
	print_guess(letter_colors, guess, ws.config.show_letters)
	println('')
	ws.eliminate_invalid_answers()
	ws.print_leftover_words()
}

fn (mut ws WordleState) eliminate_invalid_answers() {
	mut answers := ws.remaining_answers
	for guess in ws.guesses {
		letter_colors := ws.color_guess(guess)
		for i, color in letter_colors {
			if color == .green {
				answers = answers.filter(guess[i] == it[i])
			} else if color == .yellow {
				answers = answers.filter(guess[i] in it.bytes())
			} else if color == .gray {
				// TODO: obviously this is a buggy implementation that would fail if there were duplicates of a letter
				answers = answers.filter(guess[i] !in it.bytes())
			}
		}
	}
	ws.remaining_answers = answers
}

fn (ws WordleState) print_leftover_words() {
	println('Words left:')
	println(ws.remaining_answers.len)
	if ws.remaining_answers.len < 40 {
		for word in ws.remaining_answers {
			println(word)
		}
	}
}

fn main() {
	show_letters := '--show-letters' in os.args[1..]
	println("Hi, I'm gonna be a wordle solver!")
	mut ws := new_wordle(show_letters: show_letters, answer: 'atone')
	ws.submit_guess('steal')
	ws.submit_guess('atone')

	// TODO: looping over all possible wordles to apply different AIs
	// TODO: scoring wordles after they are done to evaluate which AI is best
	// TODO: not crashing on guess 7, i.e. stopping on guess 6 or before if it's solved early
}
