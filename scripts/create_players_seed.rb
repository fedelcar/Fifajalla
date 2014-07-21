require 'rubygems'
require 'nokogiri'
require 'open-uri'

page_number = 191

player_links = []

player_number = 0

while page_number < 340
	puts "Processing page #{page_number}"
	current_page = Nokogiri::HTML(open("http://www.futhead.com/14/career-mode/players/?page=#{page_number}"))

	current_page.css('td.player a').each do |link|
		player_links.push(link.attribute("href").value)
	end

	creation_strings = []

	player_links.each do |link|
		player_number += 1
		player_page = Nokogiri::HTML(open("http://www.futhead.com#{link}"))
		first_name = player_page.css('div div h1 a small > text()').text.strip
		last_name = player_page.css('div div h1 a > text()').text.strip
		overall = player_page.css('div div h3 > text()')[0].text.strip
		positions = player_page.css('table tbody tr td > text()')[11].text.strip.split(',')
		attributes = player_page.css('div div div div p > text()')
		league = player_page.css('table tbody tr td a > text()')[1].text.strip
		primary_position = positions[0]
		secondary_position = positions[1]
		if primary_position == "GK"
			# Stats don't exist
			if(first_name == "")
				# Retard uses only one name
				creation_strings.push("Player.create(last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0)")
				puts "Player ##{player_number}: #{last_name}. Done."
			else
				creation_strings.push("Player.create(first_name: \"#{first_name}\", last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0)")
				puts "Player ##{player_number}: #{first_name} #{last_name}. Done."
			end
		else
			# Pace Components
			acceleration = Integer(attributes[17].text.strip)
			sprint_speed = Integer(attributes[22].text.strip)

			pace = (acceleration + sprint_speed)/2

			# Dribbling Components
			ball_control = Integer(attributes[1].text.strip)
			dribbling_skill = Integer(attributes[4].text.strip)
			agility = Integer(attributes[18].text.strip)
			balance = Integer(attributes[19].text.strip)

			dribbling = (ball_control + dribbling_skill + agility + balance)/4

			# Shooting Components
			curve = Integer(attributes[3].text.strip)
			finishing = Integer(attributes[5].text.strip)
			free_kick_accuracy = Integer(attributes[6].text.strip)
			long_shots = Integer(attributes[9].text.strip)
			penalties = Integer(attributes[11].text.strip)
			shot_power = Integer(attributes[13].text.strip)
			volleys = Integer(attributes[16].text.strip)

			shooting = (curve + finishing + free_kick_accuracy + long_shots + penalties + shot_power + volleys)/7

			# Passing Components
			vision = Integer(attributes[28].text.strip)
			crossing = Integer(attributes[2].text.strip)
			long_passing = Integer(attributes[8].text.strip)
			short_passing = Integer(attributes[12].text.strip)

			passing = (vision + crossing + long_passing + short_passing)/4

			# Heading Components
			heading_accuracy = Integer(attributes[7].text.strip)
			jumping = Integer(attributes[20].text.strip)
			strength = Integer(attributes[24].text.strip)

			heading = (heading_accuracy + jumping + strength)/3

			# Defence Components
			sliding_tackle = Integer(attributes[14].text.strip)
			marking = Integer(attributes[10].text.strip)
			standing_tackle = Integer(attributes[15].text.strip)
			aggression = Integer(attributes[25].text.strip)
			interceptions = Integer(attributes[27].text.strip)

			defence = (sliding_tackle + marking + standing_tackle + aggression + interceptions)/5

			if(first_name == "")
				# Retard uses only one name
				creation_strings.push("Player.create(last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, pace: #{pace}, shooting: #{shooting}, passing: #{passing}, dribbling: #{dribbling}, defence: #{defence}, heading: #{heading})")
				puts "Player ##{player_number}: #{last_name}. Done."
			else
				creation_strings.push("Player.create(first_name: \"#{first_name}\", last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, pace: #{pace}, shooting: #{shooting}, passing: #{passing}, dribbling: #{dribbling}, defence: #{defence}, heading: #{heading})")
				puts "Player ##{player_number}: #{first_name} #{last_name}. Done."
			end
		end
	end

	File.open('players_seed', 'a') do |file|
		creation_strings.each do |string|
			file.write(string + "\n")
		end
	end

	player_links = []
	page_number += 1
end

