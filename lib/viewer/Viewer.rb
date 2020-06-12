class Viewer
    @@message = ""

    def self.message=(message)
        @@message = message
    end

    def self.message
        @@message
    end

    @@a = Artii::Base.new :font => 'slant'
    
    def self.header
        system ('clear')
        puts @@a.asciify("COVID-19 App")
        puts "By Ziming Mao and Chad Palmer"
        puts "\n"
        if message != ""
            puts message
            puts "\n"
            Viewer.message = ""
        end
    end
end    