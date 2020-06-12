# Reads data from database

class Query
    attr_accessor :id, :date_type, :starting_date, :ending_date, :single_date, :case_type

    @@all = []

    def initialize
        if @@all.empty?
            @id = 1
        else
            @id = Query.all.last.id + 1
        end

        @@all << self
    end

    def self.all
        @@all
    end

    def self.destroy_all
        @@all = []
    end

    def self.load=(query)
        @@load = query
    end

    def self.load
        @@load
    end

    def self.create_date_array(date)
        date.split('/')
    end

    def return 
        case date_type
        when "single"
            search_date(single_date)
        when "range"
            search_date_range(starting_date, ending_date)
        end
    end

    def search_date(date_array)
        date = "2020-#{date_array[1]}-#{date_array[0]} 00:00:00 UTC"
        # "Date": "2020-02-26 00:00:00 UTC"

        data = Day.all.select{|day| day.date == date}
        format(data)
    end

    def search_date_range(starting_date_array, ending_date_array)
        starting_date = "2020-#{starting_date_array[1]}-#{starting_date_array[0]} 00:00:00 UTC"
        ending_date = "2020-#{ending_date_array[1]}-#{ending_date_array[0]} 00:00:00 UTC"

        data = []
        num_of_countries = Country.all.size

        starting_triggered = false
        Day.all.each do |element|
            if element["date"] == starting_date
                starting_triggered = true
            end
            if starting_triggered == true
                data << element
            end
            if element["date"] == ending_date
                num_of_countries -= 1
                starting_triggered = false
            end
            if num_of_countries < 1
                break
            end
        end
        format(data)
    end

    def format(data)
        data.map do |element| 
            [
            element.country.name,
            element["date"],
            element[case_type]
            ]
        end
    end

    def self.increment(input)
        prev = input[0][2]
        output = []
        country_name = ""
        input.each do |arr| 
            if country_name != arr[0]
                country_name = arr[0]
                prev = arr[2]
                next #omit the first date starting with each country
            else
                output << [arr[0], arr[1], arr[2] - prev]
                prev = arr[2]
            end
        end
        output
    end

    def formatted_case_type
        {'Confirmed' => 'confirmed_cases', 'Active' => 'active_cases', 'Deaths' => 'death_cases', 'Recovered' => 'recovered_cases'}.key(case_type)
    end
end