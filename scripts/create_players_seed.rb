require 'rubygems'
require 'nokogiri'
require 'open-uri'

page_number = 1

player_links = []

player_number = 0

while page_number < 2
	puts "Processing page #{page_number}"
	current_page = Nokogiri::HTML(open("http://www.futhead.com/15/career-mode/players/?page=#{page_number}"))

	current_page.css('td.player a').each do |link|
		player_links.push(link.attribute("href").value)
	end

	creation_strings = []

	player_links.each do |link|
		player_number += 1
		player_page = Nokogiri::HTML(open("http://www.futhead.com#{link}"))
		first_name = player_page.css('div div h1 a small > text()').text.strip
		last_name = player_page.css('div div h1 a > text()').text.strip
		#overall = player_page.css('div div h3 > text()')[0].text.strip
		overall1 = player_page.css('title > text()').text.strip.split('-')
		overall2 = overall1[0].split(' ')
		overall = Integer(overall2[overall2.count-1])
		positions = player_page.css('table tbody tr td > text()')[8].text.strip.split(',')
		attributes = player_page.css('div div div div p > text()')
		club = player_page.css('table tbody tr td a > text()')[1].text.strip
		league = player_page.css('table tbody tr td > text()')[4].text.strip
		nation = player_page.css('table tbody tr td > text()')[6].text.strip
		age = player_page.css('table tbody tr td  > text()')[10].text.strip
		heightBase = player_page.css('table tbody tr td  > text()')[12].text.strip.split('|')
		height = heightBase[0]
		#foot = player_page.css('table tbody tr td a > text()')[7].text.strip
		foot = "?"
		attack_WR = player_page.css('table tbody tr td  > text()')[20].text.strip
		defend_WR = player_page.css('table tbody tr td  > text()')[22].text.strip
		#weak_foot = player_page.css('table tbody tr td  > text()')[24].text.strip
		weak_foot=0
		skill_moves = player_page.css('table tbody tr td  > text()')[26].text.strip

		primary_position = positions[0]
		secondary_position = positions[1]
		
		#puts "Player ##{player_number}: #{last_name}. overall: #{overall}   crossing: #{Integer(attributes[2].text.strip)}  agility: #{Integer(attributes[18].text.strip)}  interceptions: #{Integer(attributes[27].text.strip)}"

		if primary_position == "GK"
			# Stats don't exist
			diving = Integer(attributes[1].text.strip)
			handling = Integer(attributes[2].text.strip)
			kicking = Integer(attributes[3].text.strip)
			positioning = Integer(attributes[4].text.strip)
			reflexes = Integer(attributes[5].text.strip)

			if(first_name == "")
				# Retard uses only one name
				creation_strings.push("Player.create(last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, diving:#{diving}, handling: #{handling}, kicking: #{kicking}, positioning: #{positioning}, reflexes: #{reflexes}, club: \"#{club}\", nation: \"#{nation}\", age: #{age}, height: \"#{height}\", attack_WR: #{attack_WR}, defend_WR: #{defend_WR}, weak_foot: #{weak_foot}, skill_moves: #{skill_moves})")
				puts "Player ##{player_number}: #{last_name}. Done."
			else
				creation_strings.push("Player.create(first_name: \"#{first_name}\", last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, diving:#{diving}, handling: #{handling}, kicking: #{kicking}, positioning: #{positioning}, reflexes: #{reflexes}, club: \"#{club}\", nation: \"#{nation}\", age: #{age}, height: \"#{height}\", attack_WR: #{attack_WR}, defend_WR: #{defend_WR}, weak_foot: #{weak_foot}, skill_moves: #{skill_moves})")
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

			# Other Components
			reactions = Integer(attributes[21].text.strip)
			stamina = Integer(attributes[23].text.strip)
			positioning = Integer(attributes[26].text.strip)

			

			if(first_name == "")
				# Retard uses only one name
				creation_strings.push("Player.create(last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, acceleration: #{acceleration}, sprint_speed: #{sprint_speed}, ball_control: #{ball_control}, dribbling_skill: #{dribbling_skill}, agility: #{agility}, balance: #{balance}, curve: #{curve}, finishing: #{finishing}, free_kick_accuracy: #{free_kick_accuracy}, long_shots: #{long_shots}, penalties: #{penalties}, shot_power: #{shot_power}, volleys: #{volleys}, vision: #{vision}, crossing: #{crossing}, long_passing: #{long_passing}, short_passing: #{short_passing}, heading_accuracy: #{heading_accuracy}, jumping: #{jumping}, strength: #{strength}, sliding_tackle: #{sliding_tackle}, marking: #{marking}, standing_tackle: #{standing_tackle}, aggression: #{aggression}, interceptions: #{interceptions}, positioning: #{positioning}, stamina: #{stamina}, reactions: #{reactions}, club: \"#{club}\", nation: \"#{nation}\", age: #{age}, height: \"#{height}\", attack_WR: #{attack_WR}, defend_WR: #{defend_WR}, weak_foot: #{weak_foot}, skill_moves: #{skill_moves} )")
				puts "Player ##{player_number}: #{last_name}. Done."
			else
				creation_strings.push("Player.create(first_name: \"#{first_name}\",last_name: \"#{last_name}\", overall: #{overall}, league: \"#{league}\", primary_position: \"#{primary_position}\", secondary_position: \"#{secondary_position}\", games_played: 0, goals: 0, assists: 0, own_goals: 0, yellow_cards: 0, red_cards: 0, acceleration: #{acceleration}, sprint_speed: #{sprint_speed}, ball_control: #{ball_control}, dribbling_skill: #{dribbling_skill}, agility: #{agility}, balance: #{balance}, curve: #{curve}, finishing: #{finishing}, free_kick_accuracy: #{free_kick_accuracy}, long_shots: #{long_shots}, penalties: #{penalties}, shot_power: #{shot_power}, volleys: #{volleys}, vision: #{vision}, crossing: #{crossing}, long_passing: #{long_passing}, short_passing: #{short_passing}, heading_accuracy: #{heading_accuracy}, jumping: #{jumping}, strength: #{strength}, sliding_tackle: #{sliding_tackle}, marking: #{marking}, standing_tackle: #{standing_tackle}, aggression: #{aggression}, interceptions: #{interceptions}, positioning: #{positioning}, stamina: #{stamina}, reactions: #{reactions}, club: \"#{club}\", nation: \"#{nation}\", age: #{age}, height: \"#{height}\", attack_WR: #{attack_WR}, defend_WR: #{defend_WR}, weak_foot: #{weak_foot}, skill_moves: #{skill_moves} )")
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

