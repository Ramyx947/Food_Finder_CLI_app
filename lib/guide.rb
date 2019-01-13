require 'restaurant'

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
            puts "Listing ..."
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
        puts "\n\n\nAdd a restaurant\n\n".upcase
    
        restaurant = Restaurant.build_from_questions

        if restaurant.save
            puts "\nRestaurant Added\n\n"
        else
            puts "\nSave Error: Restaurant Not Added\n\n"
        end
    end

    def introduction
        puts "<<<<<<<  Welcome to the Food Finder!  >>>>>>>"
        puts "This is an interactive guide to help you find the food you crave."
    end
    def conclusion
        puts "<<<<<<<< Goodbye and Bon Appetit! >>>>>>>"
    end
end
