# Exports data

class Exporter
    def self.graph(input, text)
        puts ("")
        puts (Query.load.formatted_case_type + " Cases: " + text.capitalize)
        max = 0.00
        input.each do |arr|
            if arr[2] > max
                max = arr[2].to_f
            end
        end
        base = 60.00
        country_name = ""
        input.each do |arr|
            if country_name != arr[0]
                country_name = arr[0]
                puts("")
                puts("-----------------------")
                puts "#{country_name} (from #{input[0][1].to_s[0..9]} to #{input[-1][1].to_s[0..9]})".yellow
                puts ("----------------------")
                puts("")
            end
            if max == 0
                percentage = 0
            else
                percentage = (arr[2]/max).round(2)
            end
            print "#{arr[1].to_s[0..9]}: "
            number_of_stars = percentage*base.round
            for i in 1..number_of_stars do
                print "*"
            end
            print " #{arr[2]} cases"
            puts ""
        end

        # User can choose whether to export this graph to a txt file
        puts "\n"
        selection = $prompt.select("Would you like to export this graph to a file (stored in exports/graphs)?", ["yes", "no"])
        case selection
        when "yes"
            self.export_graph(input, text)
        when "no"
        end
    end
    
    def self.export_graph(input, text)
        FileUtils.mkdir_p 'exports/graphs' 
        # This Gem is used to create folder if not already existed
        out_file = File.new("exports/graphs/id_#{Query.load.id.to_s}_#{Query.load.case_type}_#{text}_graph.
        txt", "w")

        out_file.puts (Query.load.case_type + " cases: " + text)
        max = 0.00
        input.each do |arr|
            if arr[2] > max
                max = arr[2].to_f
            end
        end
        base = 60.00
        country_name = ""
        input.each do |arr|
            if country_name != arr[0]
                country_name = arr[0]
                out_file.puts("")
                out_file.puts("-----------------------")
                out_file.puts(country_name + " (from: " + input[0][1].to_s[0..9] + " to: " + input[-1][1].to_s[0..9] + ")")
                out_file.puts ("----------------------")
                out_file.puts("")
            end
            if max == 0
                percentage = 0
            else
                percentage = (arr[2]/max).round(2)
            end
            out_file.print "#{arr[1].to_s[0..9]}: "
            number_of_stars = percentage*base.round
            for i in 0..number_of_stars do
                out_file.print "*"
            end
            out_file.print " #{arr[2]} cases"
            out_file.puts ""
        end
        out_file.close
        Viewer.message = "File exported to exports/graphs folder in working directory"
    end

    def self.export_txt(input, text)
        FileUtils.mkdir_p 'exports/data'
        out_file = File.new("exports/data/id_#{Query.load.id.to_s}_#{Query.load.case_type}_#{text}.txt", "w")
        country_name = ""
        out_file.puts (Query.load.formatted_case_type + " Cases: " + text.capitalize)

        input.each do |arr|
            if country_name != arr[0]
                country_name = arr[0]
                out_file.puts("")
                out_file.puts("-----------------------")
                out_file.puts(country_name + " (from: " + input[0][1].to_s[0..9] + " to: " + input[-1][1].to_s[0..9] + ")")
                out_file.puts ("----------------------")
                out_file.puts("")
            end
            out_file.puts("Date: " + arr[1].to_s[0..9] + " Cases: " + arr[2].to_s)
        end
        out_file.close
        Viewer.message = "File exported to exports/data folder in working directory"
    end
end