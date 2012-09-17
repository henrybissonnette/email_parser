require "./regex.rb"

describe "parsing emails out of a string" do
  before(:all) do 
    the_hash = {
      comment: '(?:\([^\(\)]*\))?',
      post_chars: '[a-zA-Z0-9-]',
      pre_chars: '[\w!#\$%&\'*+\-\/\=\?\^_`\{\|\}~]',
      string: "\"(?:[^\\\"]|\\\")*\"",
    }
    constructions = [
      [:domain,:comment,:post_chars,'+(?:\.',:post_chars,'+)*',:comment],
    ]
    @builder =  RegexBuilder.new(the_hash)
    @builder.construct_many(constructions)
  end

  context "with normal email addresses" do
    it "extracts email from 'henryb@groupon.com'" do
      @builder.construct_expression(:email,:pre_chars,'+@',:domain)
      regex = @builder.get_expression(:email)
      puts regex.to_s
      'henryb@groupon.com'.match(regex)[0].should eq('henryb@groupon.com')
    end
  end
end

describe 'RegexBuilder' do
	before(:all) do 
		the_hash = {
			comment: '(?:\([^\(\)]*\))?',
			post_chars: '[a-zA-Z0-9-]',
			pre_chars: '[\d!#\$%&\'*+\-\/\=\?\^_`\{\|\}~]',
			string: "\"(?:[^\\\"]|\\\")*\"",
		}
		constructions = [
			[:domain,:comment,:post_chars,'+(?:\.',:post_chars,'+)*',:comment],
		]
		@builder =  RegexBuilder.new(the_hash)
		@builder.construct_many(constructions)
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
					test_string.should match(@builder.get_expression(:comment))
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
					result = test_string =~ @builder.get_expression(:post_chars) 
					result.should eq(expected)
				end
			end
		end

		describe 'pre_chars expression' do
			it 'matches strings with anything but "(),:;<>@[\] in them' do
				test_strings_results = [
					'(),:;<>@[\] &^should_be-found_at-&',12,
					'(),:;<>@[\] (),:;<>@[\]here%%Iam',27
				]
				test_strings_results.each_slice(2) do |test_string,expected|
					result = test_string =~ @builder.get_expression(:pre_chars) 
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
						test_string =~ @builder.get_expression(:string),
						test_string.scan(@builder.get_expression(:string))[0].length
					]
					result.should eq(expected)
				end
			end
		end

		describe 'domain expression' do
			it 'should match all possible domain strings' do
				# with the exception of literal IPs
				test_domains = [
					'!@@@!!!..(the domain begins here @)internets.com &&&',[9,39],
					'com',[0,3],
					'[][][][][mydomain.net(comments also allowed here)',[9,40],
					'0-----.-----0',[0,13],
					'!!!this.that.the-other.asia',[3,24],
				]
				test_domains.each_slice(2) do |domain,expected|
					results = [
						domain =~ @builder.get_expression(:domain),
						domain.scan(@builder.get_expression(:domain))[0].length
					]
					results.should eq(expected)
				end
			end
		end
	end
	describe 'construct_expression' do
		before(:all) do 
			@builder.construct_expression(:hello,'hello')
			@builder.construct_expression(:world,' world')
		end

		it 'should create a single regex from two which matches the patterns serially' do			
			@builder.construct_expression(:hello_world,*[:hello,:world])
			'hello world'.should match(@builder.get_expression(:hello_world)) 
		end

		it 'should fail to match expressions which its concatenated constituents would not' do
			@builder.construct_expression(:hello_world,*[:hello,:world])
			'hello  world'.should_not match(@builder.get_expression(:hello_world))
		end

		it 'should be able to insert additional regex in between existing expressions' do
			@builder.construct_expression(:hello_world,*[:hello,' there',:world,'!'])
			'hello there world!'.should match(@builder.get_expression(:hello_world)) 
		end

		after(:all) do
			@builder.delete_expression(:hello)
			@builder.delete_expression(:world)
			@builder.delete_expression(:hello_world)
		end
	end

	describe 'construct_many' do
		it 'should build multiple working compound expressions in one call' do
			@builder.construct_expression(:hello,'hello')
			@builder.construct_expression(:otherstuff,'.*')
			@builder.construct_expression(:world,' world')
			test_constructors = [
				[:hello_world1,:hello,:world],
				[:hello_world2,'why ',:hello,'a',:world,'b',:otherstuff,'c'],
			]
			@builder.construct_many(test_constructors)
			'hello world'.should match(@builder.get_expression(:hello_world1))
			'why helloa worldb sajkdfhfjdkshc'.should match(@builder.get_expression(:hello_world2))
		end
	end

end

