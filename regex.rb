
match_optional_comment = /(\([^\(\)]*\))?/

post_chars = /[a-zA-Z0-9-]/ #chars allowed after @
pre_chars = /[\d!#\$%&'*+-\/\=\?\^_`\{\|\}~]/#chars allowed before @
match_domain = /#{match_optional_comment}#{post_chars}*(\.#{post_chars}+)+#{match_optional_comment}/ #post @ with comments
match_string = /"(?:[^\"\\]|\\")*"/
match_local = /(#{match_string}|#{pre_chars}+(\.(#{pre_chars}|(#{match_string}\.)+#{pre_chars})*)?)/
match_email = /#{match_optional_comment}#{match_local}@#{match_domain}/


# this solution is still about constructing one gigantic regex
# it just uses regex builder to handle collecting many small
# testable pieces into the complete solution 

the_hash = {
		comment: '(\([^\(\)]*\))?',
		post_chars: '[a-zA-Z0-9-]',
		pre_chars: '[\d!#\$%&\'*+-\/\=\?\^_`\{\|\}~]',
		string: '"(?:[^\"\]|\")*"'
	}

constructions = [
	[:domain,[:comment,:post_chars,:post_chars,:comment],[nil,nil,'*(\.','+)+',nil]],
]

class RegexBuilder

	def initialize(regex_hash={})
		@expressions = regex_hash
	end

	def new_expression(name_symbol,regex)
		@expressions[name_symbol] = regex
	end

	def new_expressions(constructor_list)
		# takes list of length 2 lists
		constructor_list.each do |name_symbol,regex|
			new_expression(name_symbol,regex)
		end
	end

	def prepend_to_expression(name_symbol,regex_string)
		@expressions[name_symbol].prepend(regex_string) 
	end

	def get_expression(name_symbol)
		Regexp.new(@expressions[name_symbol])
	end

	def delete_expression(name_symbol)
		@expressions.delete(name_symbol)
	end

	def construct_expression(name_symbol, symbol_list, inserts = nil, prepend = nil)
		# symbol_list and inserts should be equal length
		# the nth insert will be added to the regex immediately after 
		# the expression referred to by the nth symbol
		#
		# a flaw in this implementation is that the final regex must
		# start with something that's already in expressions (not an insertion) 

		inserts  = ['']*symbol_list.length if !inserts 
		if not inserts.length == symbol_list.length
			raise ArgumentError, "symbol_list and inserts must be of equal length"
		end

		exp = prepend ? prepend : '' 
		symbol_list.zip(inserts).each do |symbol,insert|
			exp ="#{exp}#{@expressions[symbol]}#{insert}"
		end
		new_expression(name_symbol,exp)
	end

	def construct_many(constructor_list)
		constructor_list.each do |constructor|
			construct_expression(*constructor)
		end
	end

end

