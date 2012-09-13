
match_optional_comment = /(\([^\(\)]*\))?/
post_chars = /[a-zA-Z0-9-]/ #chars allowed after @
pre_chars = /[\d!#\$%&'*+-\/\=\?\^_`\{\|\}~]/#chars allowed before @
match_domain = /#{match_optional_comment}#{post_chars}*(\.#{post_chars}+)+#{match_optional_comment}/ #post @ with comments
match_string = /"(?:[^\"\\]|\\")*"/
match_local = /(#{match_string}|#{pre_chars}+(\.(#{pre_chars}|(#{match_string}\.)+#{pre_chars})*)?)/
match_email = /#{match_optional_comment}#{match_local}@#{match_domain}/

the_hash = {
	comment: /(\([^\(\)]*\))?/,
	post_chars: /[a-zA-Z0-9-]/,
	pre_chars: /[\d!#\$%&'*+-\/\=\?\^_`\{\|\}~]/,
	match_string: /"(?:[^\"\\]|\\")*"/
}

constructions = {

}

class RegexBuilder
	attr_accessor :expressions

	def initialize(regex_hash={})
		@expressions = regex_hash
	end

	def new_expression(name_symbol,regex)
		@expressions[name_symbol] = regex
	end

	def delete_expression(name_symbol)
		@expressions.delete(name_symbol)
	end

	def construct_expression(name_symbol, symbol_list, inserts = nil)
		# symbol_list and inserts should be equal length
		# the nth insert will be added to the regex immediately after 
		# the expression referred to by the nth symbol

		inserts  = [//]*symbol_list.length if !inserts 
		if not inserts.length == symbol_list.length
			raise ArgumentError, "symbol_list and inserts must be of equal length"
		end

		exp = //
		symbol_list.zip(inserts).each do |symbol,insert|
			exp =/#{exp}#{@expressions[symbol]}#{insert}/
		end
		puts exp
		new_expression(name_symbol,exp)
	end

end

