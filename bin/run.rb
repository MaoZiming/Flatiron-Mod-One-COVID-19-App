require_relative '../config/environment'

def run
    Seeder.clear
    Viewer.header
    load_data
    user_console
end

def load_data
    puts "Welcome to the COVID-19 App!"
    puts "To start, let's load a country's data."

    country_prompt
    add_additional_countries_prompt

    puts "Data loaded! Launching user console...".green
end

def user_console
    puts "Now, you will form a query on your data."

    new_query_prompt

    while true
        Viewer.header
        pp Query.load.return
        puts "\n"

        selection = $prompt.select('What would you like to do next?', {"Form a new query": 0, "Load existing query": 1, "Export data": 2, "Quit": 3})
        
        case selection
        when 0
            Viewer.header
            new_query_prompt
        when 1
            Viewer.header
            load_query_prompt
        when 2
            Viewer.header
            export_prompt
        when 3
            puts "Goodbye!"
            break
        end
    end
end

def country_options
    country_list_data = GetRequester.get_data(Request.countries_list)

    country_list_data.each_with_object({}) do |name_info, hash|
        hash[name_info["Country"]] = name_info["Slug"]
    end
end

def country_prompt
    country_slug = $prompt.select('Choose your country! Type to filter', country_options, filter: true)

    puts "Loading data...".yellow
    seed_database(country_slug)
end

def seed_database(country_slug)
    country_url = Request.country_url(country_slug)
    country_data = GetRequester.get_data(country_url)
    if country_data == []
        puts "API does not support the current country.".red
        country_prompt
    elsif Country.all.map {|country| country.name}.include?(country_data.first["Country"])
        puts "Country already loaded!".red
    else
        Seeder.seed(country_data)
        puts "Done!".green
    end
end

def add_additional_countries_prompt
    while selection = $prompt.select("Would you load another country's data?", ['Add another country', 'Next', 'Quit'])
        case selection
        when 'Add another country'
            country_prompt
        when 'Next'
            break
        when 'Quit'
            puts "Goodbye!"
            exit
        end
    end
end

def new_query_prompt
    query = Query.new

    date_prompt
    case_prompt

    Query.load = query
end

def load_query_prompt
    options = Query.all.each_with_object({}) {|query, hash| hash["#{query.id}: #{query.case_type}, #{query.date_type}, #{query.single_date}, #{query.starting_date}, #{query.ending_date}"] = query}

    Query.load = $prompt.select("Which query would you like to load?", options)
end

def date_prompt
    query = Query.all.last
    selection = $prompt.select('Would you like to search by a date or a range of dates?', {'Date' => 0, 'Range of dates' => 1, 'Quit' => 2})

    case selection
    when 0
        date = $prompt.ask("Provide a date (DD/MM):") {|q| q.validate(/[0-9][0-9]\/[0-9][0-9]/, 'Please format as DD/MM')}

        if !Date.valid_date? 2020,date[3..4].to_i, date[0..1].to_i #check whether it is a valid date
            puts "Date input incorrect".red
            date_prompt
            return 0
        end

        if check_date(date) == false
            puts "Selected date cannot be later than the current date!".red
            date_prompt
            return 0
        end

        query.date_type = "single"
        date_array = Query.create_date_array(date)
        query.single_date = date_array
    when 1
        starting_date = $prompt.ask("Provide a starting date (DD/MM):") {|q| q.validate(/[0-9][0-9]\/[0-9][0-9]/, 'Please format as DD/MM')}
        ending_date = $prompt.ask("Provide a ending date (DD/MM):") {|q| q.validate(/[0-9][0-9]\/[0-9][0-9]/, 'Please format as DD/MM')}

        if (!Date.valid_date? 2020,starting_date[3..4].to_i, starting_date[0..1].to_i or !Date.valid_date? 2020,ending_date[3..4].to_i, ending_date[0..1].to_i)
            puts "Date input incorrect (DD/MM)".red
            date_prompt
            return 0
        end

        if check_date(starting_date) == false || check_date(ending_date) == false
            puts "Selected date cannot be later than the current date!".red
            date_prompt
            return 0
        end
        if check_date(starting_date, ending_date) == false
            puts "Starting date must be earlier than ending date!".red
            date_prompt
            return 0
        end
        if check_date_available(starting_date) == false || check_date_available(ending_date) == false
            puts "Data are only available for dates later than 22/01".red
            date_prompt
            return 0
        end
        query.date_type = "range"
        starting_date_array = Query.create_date_array(starting_date)
        ending_date_array = Query.create_date_array(ending_date)

        query.starting_date = starting_date_array
        query.ending_date = ending_date_array
    when 2
        puts "Goodbye!"
        exit
    end
end

def case_prompt
    query = Query.all.last
    query.case_type = $prompt.select('Select a case type.', {'Confirmed' => 'confirmed_cases', 'Active' => 'active_cases', 'Deaths' => 'death_cases', 'Recovered' => 'recovered_cases'}) 
end

def export_prompt
    data = Query.load.return
    selection = $prompt.select('How would you like to export your data?', {"Data: Cumulative cases": 1, "Data: Daily cases": 2, "Graph: Cumulative cases": 3, "Graph: Daily cases": 4, "Go back": 5})
    
    case selection
    when 1
        Exporter.export_txt(data, "cumulative")
    when 2
        data_incremented = Query.increment(data)
        Exporter.export_txt(data_incremented, "daily")
    when 3
        Exporter.graph(data, "cumulative")
    when 4
        data_incremented = Query.increment(data)
        Exporter.graph(data_incremented, "daily")
    when 5
    end
end

def check_date(date1, date2 = Time.now.strftime("%d/%m/%Y %H:%M"))    
    
    # time_now = Time.now.strftime("%d/%m/%Y %H:%M")
    #=> "14/09/2011 14:09"
    # date => DD/MM

    if date2[3..4].to_i > date1[3..4].to_i
        true
    elsif date2[3..4].to_i == date1[3..4].to_i
        date2[0..1].to_i > date1[0..1].to_i + 2
    else 
        false
    end
end

def check_date_available(date)
    # DD/MM

    if date[3..4].to_i == 1
        if date[1..2].to_i >= 22
            true
        else
            false
        end
    else 
        true
    end
end

run