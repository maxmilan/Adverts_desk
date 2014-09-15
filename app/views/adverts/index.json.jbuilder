json.array!(@adverts) do |advert|
  json.extract! advert, :id, :title, :body, :price
  json.url advert_url(advert, format: :json)
end
