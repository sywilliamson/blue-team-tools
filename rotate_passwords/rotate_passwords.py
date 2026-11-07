import random

DICTIONARY_PATH = r'data/words.txt'
NUM_PASSWORD_WORDS = 4

def get_random_word():
    try:
        word = random.choice(open(DICTIONARY_PATH).readlines()).lower().strip()
    except FileNotFoundError:
        raise FileNotFoundError

    return word

def generate_password():
    words = []
    for _ in range(NUM_PASSWORD_WORDS):
        try:
            word = get_random_word()
        except FileNotFoundError:
            return "ERROR: Can't find the dictionary. Change into the directory with the 'data' directory."
        words.append(word)

    return '-'.join(words)

def main():
    print(generate_password())
    print()

if __name__ == '__main__':
    main()