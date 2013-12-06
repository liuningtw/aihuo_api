require 'carrierwave'
class Tag < ActiveRecord::Base
  # extends ...................................................................
  acts_as_nested_set
  # includes ..................................................................
  include CarrierWave
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :for_popularize, lambda { where(:category => "Popularize").order(:id) }
  # additional config .........................................................
  CATEGORIES = [1, 8, 3, 5, 6, 7, 4, 114]
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
