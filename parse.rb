require 'csv'
require 'json'
require 'byebug'
require 'algoliasearch'
require 'pp'

Algolia.init :application_id => "OF1GIDPUZO",
             :api_key        => "305095306f0dd66c36f00ad0e46e4d87"
def parse

  Algolia::Index.new('restaurants').set_settings({"attributesForFaceting"=>["food_type", "stars_count", 'stars_rouned',"payment_options"]})

  file = File.read('restaurants_list.json')
  data_hash = JSON.parse(file)


  restaurants = {}
  data_hash.each do |restaurant|
    # restaurant.delete("image_url")
    # restaurant.delete("mobile_reserve_url")
    # restaurant.delete("reserve_url")
    restaurants[restaurant["objectID"]] = restaurant
  end
  unfound = {}
  CSV.foreach('restaurants_info.csv', headers: false) do |row|
    rest = row[0].split(';')
    index = rest[0].to_i
    if restaurants[index]
      restaurants[index][:food_type] = rest[1]
      restaurants[index][:stars_count] = rest[2]
      restaurants[index][:stars_rouned] = rest[2].to_f.round
      restaurants[index][:reviews_count] = rest[3]
      restaurants[index][:neighborhood] = rest[4]
      restaurants[index][:price_range] = rest[6]
      restaurants[index][:dining_style] = rest[7]
      # pp restaurants[index]
    else
      restaurant = {  objectID: rest[0],
                      food_type: rest[1],
                      stars_count: rest[2],
                      stars_rouned: rest[2].to_f.round,
                      reviews_count: rest[3],
                      neighborhood: rest[4],
                      phone_number: rest[5],
                      price_range: rest[6],
                      dining_style: rest[7],
                    }
      unfound[rest[0]] = restaurant
    end

  end

  restArray= []
  restaurants.each do |restaurant|
    restArray << restaurant[1]
  end
  File.open("/Users/dev/dev/combine-files/temp.json","w") do |f|
    f.write(restArray.to_json)
  end

end


parse
