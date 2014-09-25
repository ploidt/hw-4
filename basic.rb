require 'sinatra'
require 'timezone'

get '/'  do
	erb :form
end

post '/city' do
	city = params[:input]
	worldtime = Timezone::Zone.names
	
	begin
	if (city.include?" ")
		multi_word = city.split(' ')
		first_word = multi_word[0]
		second_word = multi_word[1]
		city = worldtime.find{ |e| /#{first_word}_#{second_word}/ =~ e}
	else  
		city = worldtime.find{ |e| /#{city}/ =~ e}
	end
	
	timezone = Timezone::Zone.new :zone => city
	times = timezone.time Time.now
	time = times.to_s.split(' ')
	actualtime = time[1]
	hours = actualtime[0,2].to_i
	morning_hours = actualtime[0,2]
	mins = actualtime[2..4]

	if hours>12&&hours<=23
		afternoon = (hours-12).to_s + mins
		"The current time in #{city} is 

		 #{afternoon} PM"
	else 
		 morning = morning_hours + mins
	 	"The current time in #{city} is  #{morning} AM"
	end
	rescue
		"Sorry! We cannot find #{city} time."
	end


end