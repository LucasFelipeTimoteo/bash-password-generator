#!/bin/bash

# ============== PASSWORD GENERATOR ================
# Author: Lucas Felipe Timoteo
# GitHub: https://github.com/LucasFelipeTimoteo
# Description: Allows you to generate strong and customizable passwords. You can define whether it will include numbers, uppercase letters, symbols, whether it will be composed of random characters or existing English words, transform the password with leetspeak, etc.
# ==================================================

echo -e "\e[1;36m=========== PASSWORD GENERATOR ==============\e[0m"
read -rp 'Do you want to generate a human-friendly password (composed of dictionary words for easier memorization)? It may be less secure. (n/y) ' IS_WORD_COMPOSED
read -rp 'What is the length of your password? (must be greater than 5). ' PASSWORD_LENGTH
if [ "$PASSWORD_LENGTH" -lt 6 ]; then
  echo "Error: Password length must be greater than 5" >&2
  exit 1
fi

function dictionaryPassword() {
  read -rp "Type the character you would like to use as a word separator: " WORD_SEPARATOR
  if [ "${#WORD_SEPARATOR}" -gt "1" ]; then
    echo "Error: You must use 0 or 1 character as a separator" >&2
    exit 1
  fi

  read -rp "Would you like to use 'leetspeak' in your password (using symbols that resemble some letters in place of those letters)? (n/y) " HAS_LEET_SPEAK

  DICTIONARY_PASSWORD=""
  DICTIONARY=$(cat "./dictionary.txt")
  DICTIONARY_LENGTH=$(echo "$DICTIONARY" | wc --words)
  
  for (( i=1; i <= "$PASSWORD_LENGTH"; i++ )); do
    RANDOM_WORD_PASSWORD=$(shuf -i 0-"$DICTIONARY_LENGTH" -n1)
    CURRENT_RANDOM_WORD=$(echo "$DICTIONARY" | awk "{print \$$RANDOM_WORD_PASSWORD}")
    if [ "$DICTIONARY_PASSWORD" = "" ]; then
      DICTIONARY_PASSWORD="$CURRENT_RANDOM_WORD"
    else
      DICTIONARY_PASSWORD="$DICTIONARY_PASSWORD$WORD_SEPARATOR$CURRENT_RANDOM_WORD"
    fi
  done

  if [ "$HAS_LEET_SPEAK" = "y" ]; then
    DICTIONARY_PASSWORD=$(tr 'aeos' '4305' <<< "$DICTIONARY_PASSWORD")
  fi

  echo -e "\nYour password is: \e[1;33m$DICTIONARY_PASSWORD\e[0m"
  echo -e "\e[1;36m==============\e[0m"
  exit 0
}

function randomCharsPassword() {
  read -rp 'Should I include numbers in your password? (n/y) ' HAS_NUMBERS
  read -rp 'Should I include uppercase letters in your password? (n/y) ' HAS_UPPERCASE
  read -rp 'Should I include special symbols in your password? (n/y) ' HAS_SYMBOLS

  ALPHABET_LOWER="abcdefghijklmnopqrstuvwxyz"
  ALPHABET_UPPER="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  NUMBERS="0123456789"
  SYMBOLS="!@#$%^&*()_-+="
  ALLOWED_CHARS="$ALPHABET_LOWER"

  if [ "$HAS_NUMBERS" = "y" ]; then
    ALLOWED_CHARS="$ALLOWED_CHARS$NUMBERS"
  fi

  if [ "$HAS_UPPERCASE" = "y" ]; then
    ALLOWED_CHARS="$ALLOWED_CHARS$ALPHABET_UPPER"
  fi

  if [ "$HAS_SYMBOLS" = "y" ]; then
    ALLOWED_CHARS="$ALLOWED_CHARS$SYMBOLS"
  fi

  ALLOWED_CHARS_LENGTH="${#ALLOWED_CHARS}"
  PASSWORD=''

  for (( i=1; i <= "$PASSWORD_LENGTH"; i++ )); do
    randomIndex=$(shuf -i 1-"$ALLOWED_CHARS_LENGTH" -n1)
    randomChar=${ALLOWED_CHARS:randomIndex:1}
    PASSWORD="$PASSWORD$randomChar"
  done

  echo -e "\nYour password is: \e[1;33m$PASSWORD\e[0m"
  echo -e "\e[1;36m==============\e[0m"
}

if [ "$IS_WORD_COMPOSED" = "y" ]; then
  dictionaryPassword
else 
  randomCharsPassword
fi