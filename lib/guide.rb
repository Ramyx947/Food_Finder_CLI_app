require 'restaurant'
require './support/string_extend'

class Guide
    class Config 
        # valid actions
        @@actions = ['list', 'find', 'add', 'quit']
        def self.actions
            @@actions
        end
    end

    def initialize(path = nil)
        # locate the restaurant text file at path
        Restaurant.filepath = path
        if Restaurant.file_usable?
            puts "Found restaurant file"
        # or create a new file
        elsif Restaurant.create_file
            puts "created restaurant file"
        # exit if create fails
        else 
            puts "Exiting. \n\n"
            exit!
        end
    end

    def launch!
        introduction 
        result = nil
        until result == :quit 
            action = get_action
            result = do_action(action)
        end 
        conclusion 
    end
    def get_action
        action = nil
        # Loop through keep asking for user input until we get a valid action
        until Guide::Config.actions.include?(action)
            puts "Actions: " + Guide::Config.actions.join(", ") if action
            print "> "
            user_response = gets.chomp
            action = user_response.downcase.strip
        end
        return action   
    end


    def do_action(action)
        case action
        when 'list'
            list
        when 'find'
            puts "Finding ..."
        when 'add'
            add
        when 'quit'
            return :quit
        else 
            puts "\nI don't understand that command.\n"
        end
    end
    
    # adding a restaurant instance  
    def add
        output_header("Add a restaurant")
    
        restaurant = Restaurant.build_from_questions

        if restaurant.save
            # puts "\nRestaurant Added\n\n"
            output_header("Restaurant Added")
        else
            # puts "\nSave Error: Restaurant Not Added\n\n"
            output_header("Save Error: Restaurant Not Added")
        end
    end

    def list
        output_header("Listing restaurants")
        restaurants = Restaurant.saved_restaurants
        # restaurants.each do |r|
        #     puts  r.name + " | " +  r.cuisine + " | " +  r.formatted_price + " | " + r.best_known_for
        # end
        output_restaurant_table(restaurants)
    end

    def introduction
        puts "<<<<<<<  Welcome to the Food Finder!  >>>>>>>"
        puts "This is an interactive guide to help you find the food you crave."
    end
    def conclusion
        puts "<<<<<<<< Goodbye and Bon Appetit! >>>>>>>"
    end
    private
    def output_header(text)
        puts "\n#{text.upcase.center(80)}\n\n"
    end

    def output_restaurant_table(restaurants=[])
        print " " + "Name".ljust(15)
        print " " + "Cuisine".ljust(15)
        print " " + "Best known for".ljust(25)
        print " " + "Price".rjust(6) + "\n"
        puts "-" * 70
        restaurants.each do |r|
            line = " " << r.name.titleize.ljust(15)
            line << " " + r.cuisine.titleize.ljust(15)
            line << " " + r.best_known_for.titleize.ljust(25)
            line << " " + r.formatted_price.rjust(6)
            puts line
        end
        puts "No listings found" if restaurants.empty?
        puts "-" * 70
    end
end
