require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'net/smtp'
@password = ""
@christyRank = -1

url = "http://games.crossfit.com/scores/leaderboard.php?numberperpage=60&full=1&showathleteac=1"

page = Nokogiri::HTML(open(url))

length = page.css('a').length
@names = []

for i in 1..length-6
  @names << page.css('a')[i].text
end

def sendEmail
  rank = 1
  @subject = "Ranking Update - Your new rank is #{@christyRank+1}!"
  @printout = "Your new rank is #{@christyRank+1}!\n"
  @names.each do |name|
    @printout += "\n#{rank}: #{name}\n"
    rank += 1
  end
  @printout += "\n Built by Stuart Wagner and Will McAuliff"

  msg = "Subject: #{@subject} \n\n #{@printout}"
  smtp = Net::SMTP.new 'smtp.gmail.com', 587
  smtp.enable_starttls
  smtp.start("GMAIL", "stuwags@gmail.com", @password, :login) do
    smtp.send_message(msg, "stuwags@gmail.com", "stuwags@gmail.com")
  end
end

if @christyRank != @names.index("Christy Phillips")
  @christyRank = @names.index("Christy Phillips")
  sendEmail
end

