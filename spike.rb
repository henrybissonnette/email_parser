class parser

	def break_at(raw_string)
		out = raw_string.rpartition('@')
		if !out[0].empty? 
			out[0..1]
		else
			false
		end
	end

	def process(raw_string)
		parts = break_at(raw_string)
		if parts
			parse_front(parts[0]) + '@' + parse_domain(parts[1])
		end
	end

	def parse_domain(domain_string)

	end

	def parse_front(head_string)
	end
end