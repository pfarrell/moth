class App < Sequel::Model
  many_to_many :users
  one_to_many :tokens
end
