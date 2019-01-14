# a helper that adds a new method to al strings

class String
    # capitalize the first letter of each string

    def titleize
        self.split(' ').collect {|word| word.capitalize}.join(" ")
    end
end