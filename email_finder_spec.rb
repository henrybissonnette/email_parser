
require './email_finder.rb'

describe 'find_emails_in_text' do
  context 'with basic email addresses' do
    before do
      @single_email_text = 'my email address is henryb@groupon.com!'
      @multiple_email_text = "here are some emails Hank henryb@groupon.com and Chris cpowers@groupon.com done"
    end

  	it 'should find a basic email in text and return it in an array' do
      emails = find_emails_in_text @single_email_text
      emails.should eq(['henryb@groupon.com'])  
    end

    it 'should find many basic emails addresses in a text' do
      emails = find_emails_in_text @multiple_email_text
      emails.should eq(['henryb@groupon.com', 'cpowers@groupon.com'])  
    end
  end

  context 'with email addresses with comments' do
    before do
      @multiple_with_comments = <<-EOF
      here is some text containing (comment)fake@(comm*&^@$!$%#^ent)com 
      a wide henryb@groupon.com variety of emails@(many of which)contain.comments.
      comments( can appear)@the.beginning( or end) of either part of the email.
      EOF
    end

    it 'should find emails with comments in a text' do
      emails = find_emails_in_text(@multiple_with_comments)
      emails.should eq([
        '(comment)fake@(comm*&^@$!$%#^ent)com', 
        'henryb@groupon.com',
        'emails@(many of which)contain.comments',
        'comments( can appear)@the.beginning( or end)',
        ])
    end
  end

  context 'addresses with comments and/or with local as strings' do
    before do
      @multiple_with_comments = <<-EOF
      here is some text containing (comment)fake@(comm*&^@$!$%#^ent)com 
      a wide henryb@groupon.com variety of emails@(many of which)contain.comments.
      comments( can appear)@the.beginning( or end) of either part of the email.

      Here is some further code that contains strings for local parts. Pretty much 
      anything can go inside of them "local (*(*&&%#@#%[][}{;::<<./><? part"@theinternet.yes
      
      EOF
    end

    it 'should find emails with comments in a text' do
      emails = find_emails_in_text(@multiple_with_comments)
      emails.should eq([
        '(comment)fake@(comm*&^@$!$%#^ent)com', 
        'henryb@groupon.com',
        'emails@(many of which)contain.comments',
        'comments( can appear)@the.beginning( or end)',
        ])
    end    
  end
end