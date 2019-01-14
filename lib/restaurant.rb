class Restaurant
    @@filepath = nil
    attr_accessor :name, :cuisine, :price, :best_known_for

    def initialize(args={})
        @name           = args[:name]           || ""
        @cuisine        = args[:cuisine]        || ""
        @price          = args[:price]          || ""
        @best_known_for = args[:best_known_for] || ""
    end
    def self.filepath=(path=nil)
        @@filepath = File.join(APP_ROOT, path)
    end

    def self.file_exists?
        # the class should know if the restaurant file exists
        if @@filepath && File.exists?(@@filepath) 
            return true
        else 
            return false
        end
    end

    def self.file_usable?
        # all the reasons it might fail
        # boolean tests
        return false unless @@filepath
        return false unless File.exists?(@@filepath)
        return false unless File.readable?(@@filepath)
        return false unless File.writable?(@@filepath)
    #    if it passes all these conditions then it is true
        return true
    end 

    def self.create_file
        # create the restaurant file
        File.open(@@filepath, 'w') unless file_exists?
        # return a boolean - is the file usable?
        return file_usable?
    end

    def self.saved_restaurants
        # open a restaurant file
        #  if the file is readable append the restaurant list 
        # create a blank restaurant line and then populate it from import_line
        # return instances of restaurant :name, cuise, price   
        @restaurants = []
        if file_usable?
            file = File.new(@@filepath, 'r')
            file.each_line do |line|
                @restaurants << Restaurant.new.import_line(line.chomp)
                end
            file.close
        end
        return @restaurants
    end

    # create an empty instance and then populate it
    def import_line(line)
        line_array =line.split("\t")
        @name, @cuisine, @price, @best_known_for = line_array
        return self
    end

    def self.build_from_questions

        args = {}
        print "Restaurant name:"
        args[:name] = gets.chomp.strip.capitalize

        print "Restaurant type:"
        args[:cuisine] = gets.chomp.strip.capitalize

        print "Restaurant price:"
        args[:price] = gets.chomp.strip.to_i

        print "This restaurant is best known for:"
        args[:best_known_for] = gets.chomp.strip

        return self.new(args)
    end

    

    def save
        return false unless Restaurant.file_usable?
        File.open(@@filepath, 'a') do |file|
            file.puts "#{[@name, @cuisine, @price, @best_known_for].join("\t")}\n"
        end
        return true
    end 
end 