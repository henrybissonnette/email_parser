require './regex.rb'


def find_emails_in_text(text) 

  the_hash = {
    comment: '(?:\([^\(\)]*\))?',
    post_chars: '[a-zA-Z0-9-]',
    pre_chars: '[\w!#\$%&\'*+\-\/\=\?\^_`\{\|\}~]',
    string: "\"(?:[^\\\"]|\\\")*\"",
  }
  constructions = [
    [:domain,:comment,:post_chars,'+(?:\.',:post_chars,'+)*',:comment],
    [:local,:comment,:pre_chars,'+',:comment]
  ]
  @builder =  RegexBuilder.new(the_hash)
  @builder.construct_many(constructions)

  @builder.construct_expression(:email,'(',:local,'@',:domain,')')
  regex = @builder.get_expression(:email)
  text.scan(regex).map {|capture| capture[0]}
end