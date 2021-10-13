# GENERAL PROBLEMS -----------------------------------

def no_dupes?(arr)
    counts = Hash.new(0)
    arr.each { |ele| counts[ele] += 1}
    arr.select { |ele| counts[ele] < 2 }
end

# p no_dupes?([1, 1, 2, 1, 3, 2, 4])         # => [3, 4]
# p no_dupes?(['x', 'x', 'y', 'z', 'z'])     # => ['y']
# p no_dupes?([true, true, true])            # => []

def no_consecutive_repeats?(arr)
    (0 ... arr.length - 1).each { |i| return false if arr[i] == arr[i + 1] }
    return true
end

# p no_consecutive_repeats?(['cat', 'dog', 'mouse', 'dog'])     # => true
# p no_consecutive_repeats?(['cat', 'dog', 'dog', 'mouse'])     # => false
# p no_consecutive_repeats?([10, 42, 3, 7, 10, 3])              # => true
# p no_consecutive_repeats?([10, 42, 3, 3, 10, 3])              # => false
# p no_consecutive_repeats?(['x'])                              # => true

def char_indices(str)
    chars = Hash.new {|k, v| k[v] = [] }
    str.each_char.with_index do |char, i|
        chars[char] << i 
    end
    chars
end

# p char_indices('mississippi')   # => {"m"=>[0], "i"=>[1, 4, 7, 10], "s"=>[2, 3, 5, 6], "p"=>[8, 9]}
# p char_indices('classroom')     # => {"c"=>[0], "l"=>[1], "a"=>[2], "s"=>[3, 4], "r"=>[5], "o"=>[6, 7], "m"=>[8]}

def longest_streak(str)

    streaks = [] # streak substrings only

    return str if str.length <= 1

    (0 .. str.length - 1).each do |i|
        substring = ""
        while str[i] == str[i + 1]
            substring += str[i]
            i += 1
        end
        substring += str[i]
        streaks << substring
    end
    sorted = streaks.sort_by {|substring| substring.length }
    sorted.last
end

# p longest_streak('a')           # => 'a'
# p longest_streak('accccbbb')    # => 'cccc'
# p longest_streak('aaaxyyyyyzz') # => 'yyyyy
# p longest_streak('aaabbb')      # => 'bbb'
# p longest_streak('abc')         # => 'c'

def bi_prime?(num)
    (2...num).each do |i|
        (2...num).each do |j|
            if is_prime?(i) && is_prime?(j)
                return true if i * j == num
            end
        end
    end
    return false
end

def is_prime?(num)
    return false if num < 2
    (2...num).each { |i| return false if num % i == 0 }
    return true
end

# p bi_prime?(14)   # => true
# p bi_prime?(22)   # => true
# p bi_prime?(25)   # => true
# p bi_prime?(94)   # => true
# p bi_prime?(24)   # => false
# p bi_prime?(64)   # => false

def vigenere_cipher(message, keys)
    # while entire message is not yet encrypted, run inner loop on keys elements to encrypt
    new_message = ""
    i = 0
    while i < message.length
        # encrypt the current character by calling caesar cipher with key
        this_char = message[i]
        this_key = keys[i % keys.length]

        new_char = caesar_cipher_char(this_char, this_key)
        new_message += new_char
        i += 1
    end
    new_message
end

def caesar_cipher_char(char, n)
    alphabet = ("a".."z").to_a

    this_index = alphabet.index(char.downcase)
    new_index = (this_index + n) % 26

    new_char = alphabet[new_index]

    new_char
end

# Message:  b a n a n a s i n p a j a m a s
# Keys:     1 2 3 1 2 3 1 2 3 1 2 3 1 2 3 1
# Result:   c c q b p d t k q q c m b o d t

# p vigenere_cipher("toerrishuman", [1])        # => "upfssjtivnbo"
# p vigenere_cipher("toerrishuman", [1, 2])     # => "uqftsktjvobp"
# p vigenere_cipher("toerrishuman", [1, 2, 3])  # => "uqhstltjxncq"
# p vigenere_cipher("zebra", [3, 0])            # => "ceerd"
# p vigenere_cipher("yawn", [5, 1])             # => "dbbo"

def vowel_rotate(str)
    vowels = "aeiou"
    new_string = ""

    # get vowel indices array, rotate vowel indices array 1 to the right
    vowel_indices = (0 .. str.length - 1).select {|i| vowels.include?(str[i]) }

    vowel_array = str.split("").select {|char| vowels.include?(char.downcase) }
    rotated_vowel_array = vowel_array.rotate(-1)

    str.each_char.with_index do |char, i|
        if vowels.include?(char.downcase)
            # use original vowel idx (i) to find new vowel index, adding corresponding new vowel
            old_vowel_idx = vowel_indices.index(i)
            new_vowel = rotated_vowel_array[old_vowel_idx]
            new_string += new_vowel
        else
            new_string += char
        end
    end
    new_string
end

# p vowel_rotate('computer')      # => "cempotur"
# p vowel_rotate('oranges')       # => "erongas"
# p vowel_rotate('headphones')    # => "heedphanos"
# p vowel_rotate('bootcamp')      # => "baotcomp"
# p vowel_rotate('awesome')       # => "ewasemo"


# PROC PROBLEMS  --------------------------------------

class String

    def select(&prc)
        return "" if prc.nil?
        selected = ""
        
        self.each_char do |char|
            selected += char if prc.call(char)
        end

        selected
    end
    
    def map!(&prc)
        self.each_char.with_index do |char, i|
            self[i] = prc.call(char, i)
        end
    end
end

# String#select tests

# p "app academy".select { |ch| !"aeiou".include?(ch) }   # => "pp cdmy"
# p "HELLOworld".select { |ch| ch == ch.upcase }          # => "HELLO"
# p "HELLOworld".select          # => ""

# String#map! tests

# word_1 = "Lovelace"
# word_1.map! do |ch| 
#     if ch == 'e'
#         '3'
#     elsif ch == 'a'
#         '4'
#     else
#         ch
#     end
# end
# p word_1        # => "Lov3l4c3"

# word_2 = "Dijkstra"
# word_2.map! do |ch, i|
#     if i.even?
#         ch.upcase
#     else
#         ch.downcase
#     end
# end
# p word_2        # => "DiJkStRa"


# RECURSION PROBLEMS ----------------------------------

def multiply(a, b)
    return 0 if a == 0 # base case: multiply(3, 5) --> multiply(1, 5) == 5

    if a > 0 # positive counter
        multiply(a - 1, b) + b
    else # negative counter
        -(multiply(-a - 1, b) + b)
    end
end

# p multiply(3, 5)        # => 15
# p multiply(5, 3)        # => 15
# p multiply(2, 4)        # => 8
# p multiply(0, 10)       # => 0
# p multiply(-3, -6)      # => 18
# p multiply(3, -6)       # => -18
# p multiply(-3, 6)       # => -18

def lucas_sequence(n)
    return [] if n <= 0
    return [2] if n == 1
    return [2, 1] if n == 2

    right_end = lucas_sequence(n - 1)
    right_end << right_end[-2] + right_end[-1] # 2nd to last + last

    right_end
end

# p lucas_sequence(0)   # => []
# p lucas_sequence(1)   # => [2]    
# p lucas_sequence(2)   # => [2, 1]
# p lucas_sequence(3)   # => [2, 1, 3]
# p lucas_sequence(6)   # => [2, 1, 3, 4, 7, 11]
# p lucas_sequence(8)   # => [2, 1, 3, 4, 7, 11, 18, 29]

def prime_factorization(num)
    (2 ... num).each do |i|
        if num % i == 0 # if not prime yet
            # divide num by i and check division's factors
            return [*prime_factorization(i), *prime_factorization(num/i)]
            # final result should be [p_f of i , p_f of num/i] in array form
        end
    end
    [num]
end

# p_f(12) -> p_f(2) , p_f(6) -> 2, 2, 3

p prime_factorization(12)     # => [2, 2, 3]
p prime_factorization(24)     # => [2, 2, 2, 3]
p prime_factorization(25)     # => [5, 5]
p prime_factorization(60)     # => [2, 2, 3, 5]
p prime_factorization(7)      # => [7]
p prime_factorization(11)     # => [11]
p prime_factorization(2017)   # => [2017]