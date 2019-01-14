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
            action, args = get_action
            result = do_action(action, args)
        end 
        conclusion 
    end
    def get_action
        action = nil
        # Loop through keep asking for user input until we get a valid action
        until Guide::Config.actions.include?(action)
            puts "Actions: " + Guide::Config.actions.join(", ") 
            print "> "
            user_response = gets.chomp
            args = user_response.downcase.strip.split(' ')
            action = args.shift
        end
        return action, args
    end


    def do_action(action, args=[])
        case action
        when 'list'
            list(args)
        when 'find'
            keyword = args.shift
            find(keyword)
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

    def list(args=[])
        sort_order = args.shift 
        sort_order = args.shift if sort_order == 'by'
        sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

        output_header("Listing restaurants")

        restaurants = Restaurant.saved_restaurants
        #sort the restaurants array
         restaurants.sort! do |r1,r2|
            case sort_order
            when 'name'
                r1.name.downcase <=> r2.name.downcase
            when 'cuisine'
                r1.cuisine.downcase <=> r2.cuisine.downcase
            when 'price'
                r1.price.to_i <=> r2.price.to_i
            end
        end
        output_restaurant_table(restaurants)
        puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
    end

    def find(keyword="")
       output_header("Find a restaurant") 
        if keyword
            #search method
            restaurants = Restaurant.saved_restaurants 
            found = restaurants.select do |r|
                r.name.downcase.include?(keyword.downcase) ||
                r.cuisine.downcase.include?(keyword.downcase) ||
                r.best_known_for.downcase.include?(keyword.downcase) ||
                r.price.to_i <= keyword.to_i 
            end
            output_restaurant_table(found)
        else
            puts "Find using a key phrase to search the restaurant list."
            puts "Examples: 'find Memei', 'find Chinese', 'find chin'\n\n"
        end
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
        puts "\n#{text.upcase.center(75)}\n\n"
    end

    def output_restaurant_table(restaurants=[])
        print " " + "Name".ljust(20)
        print " " + "Cuisine".ljust(15)
        print " " + "Best known for".ljust(25)
        print " " + "Price".rjust(6) + "\n"
        puts "-" * 75
        restaurants.each do |r|
            line = " " << r.name.titleize.ljust(20)
            line << " " + r.cuisine.titleize.ljust(15)
            line << " " + r.best_known_for.titleize.ljust(25)
            line << " " + r.formatted_price.rjust(6)
            puts line
        end
        puts "No listings found" if restaurants.empty?
        puts "-" * 75
    end
end
