require "./regex.rb"


describe 'RegexBuilder' do
	before(:all) do 
		the_hash = {
			comment: /(\([^\(\)]*\))?/,
			post_chars: /[a-zA-Z0-9-]/,
			pre_chars: /[\w!#\$%&'*+\-\/=?^_`{|}~]/,
			string: /"(?:[^\"\\]|\\")*"/,
		}
		@builder =  RegexBuilder.new(the_hash)
	end
	describe 'expressions' do
		describe 'optional comment expression' do
			it 'matches a string with a comment in it' do
				test_strings =[
					'the following (is a comment)',
					'(pretty much @^y\#{\#i^g} is allowed in a comment)',
					'hiug&^*$#{\&GIU89yiug9\*\\}(jhgkjshd&#{@)})dgfskj./,?><',
				] 
				test_strings.each do |test_string|
					test_string.should match(@builder.expressions[:comment])
				end
			end

			it 'doesnt match strings without comments in them' do
				# comment is optional so no negatest is possible
			end
		end

		describe 'post_chars expression' do
			it 'matches sub-strings that contain only letters numbers and underscores' do
				test_strings_results = [
					'&*@^%$___hello',9,
					'THIS-I5-A150-ACC3PTAB13',0,
					')(!*&^[]":;<>AND-one-more-FOR-good-measure',13
				]
				test_strings_results.each_slice(2) do |test_string,expected|
					result = test_string =~ @builder.expressions[:post_chars] 
					result.should eq(expected)
				end
			end
		end

		describe 'pre_chars expression' do
			it 'matches strings with anything but "(),:;<>@[\] in them' do
				test_strings_results = [
					'(),:;<>@[\] &^should_be-found_at-&',12,
					'(),:;<>@[\] (),:;<>@[\]here%%Iam',23
				]
				test_strings_results.each_slice(2) do |test_string,expected|
					result = test_string =~ @builder.expressions[:pre_chars] 
					result.should eq(expected)
				end
			end
		end

		describe 'double quoted string expression' do 
			it 'matches double quoted strings with escaped double quotes in them' do
				test_strings_results =[
					'adjkhkjh7489327"hjkfsd^&*TYUG\"\"\"dfkjhsd"',[15,28],
					'01234"hello"additional stuff',[5,7],
				]
				test_strings_results.each_slice(2) do |test_string,expected|
					result = [
						test_string =~ @builder.expressions[:string],
						test_string.scan(@builder.expressions[:string])[0].length
					]
					result.should eq(expected)
				end
			end
		end
	end
	describe 'construct_expression' do
		it 'should create a single regex from two which matches the patterns serially' do
			@builder.new_expression(:hello,/hello/)
			@builder.new_expression(:world,/ world/)
			@builder.construct_expression(:hello_world,[:hello,:world])
			'hello world'.should match(@builder.expressions[:hello_world]) 
		end
	end
end

