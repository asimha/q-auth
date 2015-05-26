class Department < ActiveRecord::Base

  # Validations
  extend PoodleValidators
  validate_string :name, mandatory: true
  validate_string :description, max_length: 2056

  # Associations
  has_many :users

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> department.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(departments.name) LIKE LOWER('%#{query}%') OR LOWER(departments.description) LIKE LOWER('%#{query}%')")}

end
