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
	guesses []string
}

enum LetterColor {
	gray
	green
	yellow
}

pub fn (color LetterColor) int() int {
	match color {
		.gray { return 0x2c3032 }
		.green { return 0x42713e }
		.yellow { return 0x917f2f }
	}
}

fn print_guess(colors []LetterColor, guess string, show_letters bool) {
	for i, color in colors {
		if show_letters {
			print(term.bg_hex(color.int(), guess[i].ascii_str()))
		} else {
			print(term.bg_hex(color.int(), ' '))
		}
	}
}

fn new_wordle(wc WordleConfig) WordleState {
	mut answer := wc.answer
	if wc.answer == '' {
		answers := os.read_lines(wc.answers_file) or { [] }
		random_answer_index := rand.int_in_range(0, answers.len) or { 0 }
		answer = answers[random_answer_index]
	}
	dictionary := os.read_lines(wc.dictionary_file) or { [] }
	ws := WordleState{
		config: wc
		dictionary: dictionary
		answer: answer
	}
	return ws
}

fn (mut ws WordleState) check_guess(guess string) []LetterColor {
	assert ws.guesses.len < ws.config.max_guesses
	assert guess.runes().len == ws.config.word_length
	assert guess in ws.dictionary
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
	print_guess(letter_colors, guess, ws.config.show_letters)
	println('')
	return letter_colors
}

fn main() {
	show_letters := '--show-letters' in os.args[1..]
	println("Hi, I'm gonna be a wordle solver!")
	mut ws := new_wordle(show_letters: show_letters)
	ws.check_guess('purse')
	ws.check_guess('steak')
	ws.check_guess('class')
	ws.check_guess('floss')
	ws.check_guess('fetch')
	ws.check_guess('churn')
}
