json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beers do
    json.n_beers brewery.beers.count
  end
  json.status do
    json.active brewery.active
  end
end
