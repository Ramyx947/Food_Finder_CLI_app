require 'spec_helper'

describe Restaurant do

    it "has a name, cuisine, best known for and price" do
        restaurant = Restaurant.new(" ")
        restaurant.name = " "
        restaurant.cuisine = " "
        restaurant.best_known_for = " "
        restaurant.price = " "
    end
        
end