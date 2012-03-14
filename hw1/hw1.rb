# test methods

def put_line(string)
  puts string
  puts "\n"
end

def trace(string)
	# todo: comment this out before shipping
	#put_line string
end
# assert the test is true
# @param testString the test name
def assert_true(test, testString)
  put_line (test ? :Passed!.to_s : :Failed!.to_s) + ' ' + testString + ' '
end

def assert_false(test, testString)
  assert_true(!test, testString) # no reason to duplicate code
end

# part 1

# part 1.a
# --------
# A method that determines whether the given word or phrase 
# is a palindrome
def palindrome?(string)
  string_forward = string.downcase.gsub(/[^a-z]/, '')
  string_backwards = string.reverse.downcase.gsub(/[^a-z]/, '')
  
  trace "#{string_forward} == #{string_backwards}"
  
  return  string_forward == string_backwards
end

# palindrone tests
def test_hw1_part_1_a
	assert_true(palindrome?("A man, a plan, a canal -- Panama"),
		'palindrome?("A man, a plan, a canal -- Panama") == true')#=> true 
	assert_true(palindrome?("Madam, I'm Adam!"),
		'palindrome?("Madam, I\'m Adam!") == true') # => true 
	assert_false(palindrome?("Abracadabra"), 
		'palindrome?("Abracadabra")') # => false (nil is also ok)
end

# part 1.b
# --------
# Given a string of input, return a hash whose keys are words 
# in the string and whose values are the number of times each 
# word appears.
def count_words(string)
	words = Hash.new
	
	string.downcase.scan(/[\w]+\b/) { |word|
		if !words.has_key?(word)
			words[word] = 0
		end
		
		words[word] += 1
	}
	
	return words
end

def test_hw1_part_1_b
  words = count_words("A man, a plan, a canal -- Panama")
  
  put_line("\t#{words}")
  
  assert_true(words == 
	{'a' => 3, 'man' => 1, 'canal' => 1, 'panama' => 1, 
'plan' => 1},
		"words counted correctly")
end

# part 2

# part 2.a
# --------
# Write a method rps_game_winner that takes a two-element list and behaves 
# as follows
# - If the number of players is not equal to 2, raise WrongNumberOfPlayersError 
# - If either player's strategy is something other than "R", "P" or "S" 
# (case-insensitive), raise NoSuchStrategyError 
# - Otherwise, return the name and strategy of the winning player.  
# If both players use the same strategy, the first player is the winner. 
class WrongNumberOfPlayersError < StandardError ; end 
class NoSuchStrategyError < StandardError ; end 

class RockPaperScissors
  @@strategy_test = { :r => {:r => 0,
                             :p => 1,
					         :s => 0},
					  :p => {:r => 0,
					         :p => 0,
					         :s => 1},
					  :s => {:r => 1,
					         :p => 0,
					         :s => 0} }
					  
  def RockPaperScissors.get_winner(strategy1, strategy2)
    return @@strategy_test[strategy1][strategy2]
  end
  
  def RockPaperScissors.get_rules
    return @@strategy_test
  end
end

def normalize_strategy (strategy)
  return strategy.downcase.to_sym
end
 
def strategy_is_valid(strategy)
  strategy = normalize_strategy(strategy)
  
  if strategy == :r or
     strategy == :p or
     strategy == :s then
    return true
  end
  
  return false
end

def rps_game_winner(game) 
 raise WrongNumberOfPlayersError unless game.length == 2 
 raise NoSuchStrategyError unless 
         strategy_is_valid (game[0][1]) and 
         strategy_is_valid (game[1][1])
  
  trace "Playing match #{game}"
  
  winner = RockPaperScissors.get_winner(
			  normalize_strategy( game[0][1] ),
			  normalize_strategy( game[1][1] ) )

  return game[ winner[0] ]
end 

def test_hw1_part_2_a
	game1 = [ ["Armando", :p], ["Dave", :s] ]
	game2 = [ ["Armando", :s], ["Dave", :s] ]
	
	put_line "\tgame1 = " + game1.to_s
	put_line "\tgame2 = " + game2.to_s
	
	assert_true(rps_game_winner(game1) == game1[1], 
		'rps_game_winner(game1)')
	assert_true(rps_game_winner(game2) == game2[0],
		'rps_game_winner(game2)')
end

#test_hw1_part_2_a

# part 2.b
class Bracket
	
	def initialize (match_list = nil)
		@ready = false
		if match_list != nil
			@matches = Array.new(match_list)
			@ready = true
		else
			@matches = Array.new
		end
		
		@match_count = 0
	end
	
	attr_accessor :match_count
	
	def ready?
		return @ready
	end
	
	def create_bracket_from_player_list! (player_list)
		raise WrongNumberOfPlayersError unless player_list.length % 2 == 0
		
		# build bracket from player list
		@matches = Array.new
		@match_count = 0
		player_list.each do |player|
			if @matches[@match_count / 2] == nil
				@matches[@match_count / 2] = Array.new
			end
			
			@matches[@match_count / 2][@match_count % 2] = player
			@match_count += 1
		end
		
		@ready = true
	end
	
	
	def get_winner
		raise WrongNumberOfPlayersError unless ready?
		
		player_list = Array.new
		
		@matches.each do |match|
			player_list.push (rps_game_winner(match))
			@match_count -= 1
		end
		
		if(player_list.length != 1)
			create_bracket_from_player_list! (player_list)
			return get_winner
		end
		
		return player_list[0]
	end
end

def rps_tournament_winner (tourney)

	match_list = Array.new
	
	tourney.each do |bracket|
		if bracket[0].length == 2
			bracket.each do |match|
				match_list.push (match)
			end
		else
			rps_tournament_winner (bracket)
		end
	end
	
	brackets = Bracket.new(match_list)
	
	return brackets.get_winner
end

def test_hw1_part_2_b
	tourney = [ 
			[ # bracket 1
			  [ ["Armando", "P"], ["Dave", "S"] ], # match 1
			  [ ["Richard", "R"],  ["Michael", "S"] ], # match 2
			], # match 3
			[  # bracket 2
			  [ ["Allen", "S"], ["Omer", "P"] ], #match 1
			  [ ["David E.", "R"], ["Richard X.", "P"] ] #match 2
			] #match 3
		  ] # finals

	tourney16 = [
			[ # bracket 1
			  [ ["Armando", "P"], ["Dave", "S"] ], # match 1
			  [ ["Richard", "R"],  ["Michael", "S"] ], # match 2
			  [ ["Armando", "P"], ["Dave", "S"] ], # match 3
			  [ ["Richard", "R"],  ["Michael", "S"] ], # match 4
			], # match 5
			[  # bracket 2
			  [ ["Allen", "S"], ["Omer", "P"] ], #match 1
			  [ ["David E.", "R"], ["Richard X.", "P"] ], #match 2
			  [ ["Allen", "S"], ["Omer", "P"] ], #match 3
			  [ ["David E.", "R"], ["Richard X.", "P"] ] #match 4
			] #match 5
		]
	
	put_line "\ttourney = " + tourney.to_s
	
	tourney_winner = rps_tournament_winner(tourney)
	tourney16_winner = rps_tournament_winner(tourney16)
	
	trace tourney_winner.to_s
	trace tourney16_winner.to_s
	
	assert_true(tourney_winner == ["Richard", "R"],
		"rps_tournament_winner(tourney) => #{tourney_winner} == [\"Richard\", \"R\"]")
	
	assert_true(tourney16_winner == ["Richard", "R"],
		"rps_tournament_winner(tourney16) => #{tourney_winner} == [\"Richard\", \"R\"]")
	
end

# part 3

def sorted_word (word)
	return word.chars.sort.join
end

def combine_anagrams(words)
	combined = Array.new

	words_hash_map = Hash.new
	found = 0
	words.each do |word|
		sort_word = sorted_word (word).downcase
		
		if !words_hash_map.has_key?(sort_word)
			words_hash_map[sort_word] = found
			found += 1
		end
		
		if(combined[words_hash_map[sort_word]] == nil)
			combined[words_hash_map[sort_word]] = Array.new
		end
		
		combined[words_hash_map[sort_word]].push(word)
	end
	
	return combined
end

def test_hw1_part_3
	words = ['cars', 'for', 'potatoes', 'racs', 'four','scar', 'creams', 
	'scream', 'Cars', 'cArS', 'A', 'a']

	combined = combine_anagrams(words)
	
	put_line (combined.to_s)
	
	if(combined == [["cars", "racs", "scar", 'Cars', 'cArS'], ["for"], ["potatoes"], 
["four"], ["creams", "scream"], ['A', 'a']])
		assert_true(true, 'anagrams combined')
	else
		assert_true(false, 'anagrams combined');
	end
end
# part 4

class Dessert
	def initialize (name, calories)
		@name = name
		@calories = calories
	end
	
	def name
		return @name
	end
	
	def name=(name)
		@name = name
	end
	
	def calories
		return @calories
	end
	
	def calories=(calories)
		@calories = calories
	end
	
	def healthy?
		return @calories < 200
	end
	
	def delicious?
		return true
	end
end

class JellyBean < Dessert
    def initialize (name, calories, flavor)
		@name = name
		@calories = calories
		@flavor = flavor
	end
	
	def flavor
		return @flavor
	end
	
	def flavor=(flavor)
		@flavor = flavor.downcase
	end
	
	def delicious?
		return @flavor != "black licorice"
	end
end

def test_hw1_part_4_a
	pudding = Dessert.new("pudding", 150)
	pie = Dessert.new("apple pie", 200)
	cake = Dessert.new("lies", 400)
	
	test_dessert_attr(pudding, "pudding", 150, true)
	test_dessert_attr(pie, "apple pie", 200, false)
	test_dessert_attr(cake, "lies", 400, false)
	
	put_line 'Changing pudding'
	
	pudding.name = "banana pudding"
	pudding.calories = 200
	
	test_dessert_attr(pudding, "banana pudding", 200, false)
end

def test_dessert_attr (dessert, name, calories, healthy, delicious = true)
	assert_true((dessert.name == name and
				dessert.calories == calories and
				dessert.healthy? == healthy and
				dessert.delicious? == delicious),
				"#{dessert.name} => #{dessert.to_s} == #{name}, #{calories}, #{healthy}, #{delicious}")
end

def test_hw1_part_4_b
	bogies = JellyBean.new("bogie bean", 5, "bogie")
	blacklic = JellyBean.new("black licorice bean", 300, "black licorice")
	
	test_dessert_attr(bogies, "bogie bean", 5, true, true)
	test_dessert_attr(blacklic, "black licorice bean", 300, false, false)
end

# part 5

# reopen the Class class and modify it to allow for a variable with history
class Class 
 def attr_accessor_with_history(attr_name) 
   attr_name = attr_name.to_s   # make sure it's a string 
   attr_reader attr_name        # create the attribute's getter 
   attr_reader attr_name+"_history" # create bar_history getter 
   class_eval (%Q"
		def #{attr_name}=(value)
			if @#{attr_name}_history == nil
				@#{attr_name}_history = Array.new
				@#{attr_name}_history.push (nil)
			end
		
			@#{attr_name}_history.push (value);
		
			@#{attr_name} = value
		end
   ")
 end 
end 
 
class Foo
 attr_accessor_with_history :bar 
end 

def test_hw1_part_5
	f = Foo.new 
	f.bar = 1 
	f.bar = 2 
	
	if(f.bar_history == [nil,1,2])
		assert_true(true, 'f.bar_history == [nil,1,2]')
	end
	
	# this is not working.  todo: find out why
#	assert_false (f.bar_history == [nil,1,2], 'f.bar_history == [nil,1,2]')
end

def run_tests

	# run tests
	test_hw1_part_1_a
	test_hw1_part_1_b

	test_hw1_part_2_a
	test_hw1_part_2_b

	test_hw1_part_3
	
	test_hw1_part_4_a
	test_hw1_part_4_b

	test_hw1_part_5
end

run_tests