
# match_optional_comment = /(\([^\(\)]*\))?/

# post_chars = /[a-zA-Z0-9-]/ #chars allowed after @
# pre_chars = /[\d!#\$%&'*+-\/\=\?\^_`\{\|\}~]/#chars allowed before @
# match_domain = /#{match_optional_comment}#{post_chars}*(\.#{post_chars}+)+#{match_optional_comment}/ #post @ with comments
# match_string = /"(?:[^\"\\]|\\")*"/
# match_local = /(#{match_string}|#{pre_chars}+(\.(#{pre_chars}|(#{match_string}\.)+#{pre_chars})*)?)/
# match_email = /#{match_optional_comment}#{match_local}@#{match_domain}/


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
	[:domain,:comment,:post_chars,'+(\.',:post_chars,'+)+',:comment],
]

class RegexBuilder

	def initialize(regex_hash={})
		@expressions = regex_hash
	end

	def get_expression(name_symbol)
		Regexp.new(@expressions[name_symbol],'g')
	end

	def delete_expression(name_symbol)
		@expressions.delete(name_symbol)
	end

	def construct_expression(name_symbol, *args)
		exp = ''
		args.each do |item|
			if item.is_a? String 
				exp += item
			elsif item.is_a? Symbol
				exp += @expressions[item]
			else
				raise TypeError, "parts must be strings symbol keys not #{item.class}"
			end
		end
		@expressions[name_symbol] = exp
	end

	def construct_many(constructor_list)
		constructor_list.each do |constructor|
			construct_expression(*constructor)
		end
	end

end

