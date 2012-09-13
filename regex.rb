
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

class RegexBuilder
	attr_accessor :expressions

	def initialize(regex_hash)
		@expressions = regex_hash
	end

	def new_expression(name_symbol,regex)
		@expressions[name_symbol] = regex
	end

	def construct_expression(name_symbol, symbol_list)
		exp = //
		symbol_list.each do |symbol|
			exp =/#{exp}#{@expressions[symbol]}/
		end
		new_expression(name_symbol,exp)
	end

end

