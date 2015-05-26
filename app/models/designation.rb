class Designation < ActiveRecord::Base

  # Validations
  extend PoodleValidators
  validate_string :title, mandatory: true
  validate_string :responsibilities, max_length: 2056

  # Associations
  has_many :users

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> designation.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(designations.title) LIKE LOWER('%#{query}%') OR LOWER(designations.responsibilities) LIKE LOWER('%#{query}%')")}

end
