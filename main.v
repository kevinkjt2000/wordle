import os
import rand

[params]
struct WordleConfig {
	word_length     int    = 5
	max_guesses     int    = 6
	answers_file    string = './word-lists/wordle-nyt-answers-alphabetical.txt'
	dictionary_file string = './word-lists/wordle-nyt-dictionary.txt'
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

pub fn (color LetterColor) str() string {
	red, green, blue := match color {
		.gray { 0x2c, 0x30, 0x32 }
		.green { 0x42, 0x71, 0x3e }
		.yellow { 0x91, 0x7f, 0x2f }
	}
	return '\033[48:2::$red:$green:${blue}m \033[49m'
}

pub fn (colors []LetterColor) str() string {
	mut ret := ''
	for c in colors {
		ret += c.str()
	}
	return ret
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
	return letter_colors
}

fn main() {
	println("Hi, I'm gonna be a wordle solver!")
	mut ws := new_wordle()
	println(ws.check_guess('purse'))
	println(ws.check_guess('steak'))
	println(ws.check_guess('class'))
	println(ws.check_guess('floss'))
	println(ws.check_guess('fetch'))
	println(ws.check_guess('churn'))
}
