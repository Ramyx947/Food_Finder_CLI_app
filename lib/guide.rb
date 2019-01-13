require 'restaurant'

class Guide

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
          # what do you want to do? (list, find, add, quit)
            print "> "
            user_response = gets.chomp
            #   do that action
            result = do_action(user_response)
        end 
        conclusion 
    end

    def do_action(action)
        case action
        when 'list'
            puts "Listing ..."
        when 'find'
            puts "Finding ..."
        when 'add'
            puts "Adding ..."
        when 'quit'
            return :quit
        else 
            puts "\nI don't understand that command.\n"
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
