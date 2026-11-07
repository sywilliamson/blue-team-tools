import random

DICTIONARY_PATH = r'data/words.txt'
NUM_PASSWORD_WORDS = 4

def get_random_word():
    word = random.choice(open(DICTIONARY_PATH).readlines()).lower().strip()

    return word

def generate_password():
    words = []
    for _ in range(NUM_PASSWORD_WORDS):
        word = get_random_word()
        words.append(word)

    return '-'.join(words)

def main():
    print(generate_password())

if __name__ == '__main__':
    main()