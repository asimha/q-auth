class User < ActiveRecord::Base

  # including Password Methods
  has_secure_password

  # Constants
  INACTIVE = "inactive"
  ACTIVE = "active"
  SUSPEND = "suspended"
  STATUS_LIST = [INACTIVE, ACTIVE, SUSPEND]
  EXCLUDED_JSON_ATTRIBUTES = [:designation_id, :department_id, :confirmation_token, :password_digest, :reset_password_token, :unlock_token, :status, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :locked_at, :created_at, :updated_at]
  DEFAULT_PASSWORD = "Password@1"
  SESSION_TIME_OUT = 30.minutes

  # Validations
  extend PoodleValidators
  validate_string :name, mandatory: true
  validate_username :username
  validate_email :email
  validate_password :password, condition_method: :should_validate_password?

  validates :status, :presence=> true, :inclusion => {:in => STATUS_LIST, :presence_of => :status, :message => "%{value} is not a valid status" }

  # Callbacks
  before_validation :generate_auth_token

  # Associations
  belongs_to :designation
  belongs_to :department
  has_one :profile_picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::ProfilePicture"

  state_machine :status, :initial => :inactive do

    event :active do
      transition :inactive => :active
    end

    event :suspended do
      transition :active => :suspended
    end

    event :active do
      transition :suspended => :active
    end

  end

  # ------------------
  # Class Methods
  # ------------------

  def self.find_by_email_or_username(query)
    self.where("LOWER(email) = LOWER('#{query}') OR LOWER(username) = LOWER('#{query}')").first
  end

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(username) LIKE LOWER('%#{query}%') OR\
                                        LOWER(email) LIKE LOWER('%#{query}%') OR\
                                        LOWER(city) LIKE LOWER('%#{query}%') OR\
                                        LOWER(state) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where ("LOWER(status)='#{status}'") }

  # ------------------
  # Instance variables
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    inclusion_list = []
    inclusion_list << {:department => {:except => ConfigCenter::Defaults::EXCLUDED_JSON_ATTRIBUTES}} if department.present?
    inclusion_list << {:designation => {:except => ConfigCenter::Defaults::EXCLUDED_JSON_ATTRIBUTES}} if designation.present?
    options[:include] ||= inclusion_list

    exclusion_list = []
    exclusion_list += EXCLUDED_JSON_ATTRIBUTES
    exclusion_list += EXCLUDED_JSON_ATTRIBUTES
    options[:except] ||= exclusion_list

    options[:methods] = []
    options[:methods] << :profile_image

    super(options)
  end

  # * Return full name
  # == Examples
  #   >>> user.display_name
  #   => "Joe Black"
  def display_name
    "#{name}"
  end

  def department_name
    department.blank? ? "" : department.name
  end

  def designation_title
    designation.blank? ? "" : designation.title
  end

  def profile_image
    if (profile_picture && profile_picture.image)
      {
        thumb: profile_picture.image.thumb.url,
        medium: profile_picture.image.medium.url,
        large: profile_picture.image.large.url,
        original: profile_picture.image.url
      }
    else
      {}
    end
  end

  # * Return the designation text
  # If the user has overridden the designation it will return that, else it will populate the display from the associated designation and department
  # == Examples
  #   >>> user.display_designation
  #   => "Joe Black"
  def display_designation
    return "#{designation_overridden}" if designation_overridden
    designation_list = []
    designation_list << designation.title unless designation.blank?
    designation_list << department.name unless department.blank?
    designation_list.join(", ")
  end

  # * Return address which includes city, state & country
  # == Examples
  #   >>> user.display_address
  #   => "Mysore, Karnataka, India"
  def display_address
    address_list = []
    address_list << city unless city.blank?
    address_list << state unless state.blank?
    address_list << country unless country.blank?
    address_list.join(", ")
  end

  # * Return true if the user is either a Q-Auth Super Admin or Q-Auth Admin
  # == Examples
  #   >>> user.is_admin?
  #   => true
  def is_admin?
    user_type == 'admin' || user_type == 'super_admin'
  end

  # * Return true if the user is either a Q-Auth Admin
  # == Examples
  #   >>> user.is_super_admin?
  #   => true
  def is_super_admin?
    user_type == 'super_admin'
  end

  # * Return true if the user is not approved, else false.
  # * pending status will be there only for users who are not approved by user
  # == Examples
  #   >>> user.pending?
  #   => true
  def inactive?
    (status == INACTIVE)
  end

  # * Return true if the user is approved, else false.
  # == Examples
  #   >>> user.pending?
  #   => true
  def active?
    (status == ACTIVE)
  end

  # * Return true if the user is blocked, else false.
  # == Examples
  #   >>> user.blocked?
  #   => true
  def suspended?
    (status == SUSPEND)
  end

  # change the status to :pending
  # Return the status
  # == Examples
  #   >>> user.pending!
  #   => "pending"
  def inactive!
    self.update_attribute(:status, INACTIVE)
  end

  # change the status to :approve
  # Return the status
  # == Examples
  #   >>> user.approve!
  #   => "approved"
  def active!
    self.update_attribute(:status, ACTIVE)
  end

  # change the status to :approve
  # Return the status
  # == Examples
  #   >>> user.block!
  #   => "blocked"
  def suspended!
    self.update_attribute(:status, SUSPEND)
  end

  def start_session
    # FIX ME - specs are not written to ensure that all these data are saved
    self.token_created_at = Time.now
    self.sign_in_count = self.sign_in_count ? self.sign_in_count + 1 : 1
    self.last_sign_in_at = self.current_sign_in_at
    self.last_sign_in_ip = self.current_sign_in_ip
    self.current_sign_in_at = self.token_created_at

    # FIX ME - pass remote_ip to this method.
    # Make necessary changes to authentication service to make it work
    # self.current_sign_in_ip = remote_ip if remote_ip
    self.save
  end

  def end_session
    # Reseting the auth token for user when he logs out.
    # (Time.now - 1.second)
    self.update_attributes auth_token: SecureRandom.hex, token_created_at: nil
  end

  def assign_default_password_if_nil
    self.password = DEFAULT_PASSWORD
    self.password_confirmation = DEFAULT_PASSWORD
  end

  def token_expired?
    return self.token_created_at.nil? || (Time.now > self.token_created_at + SESSION_TIME_OUT)
  end

  def generate_reset_password_token
     self.reset_password_token = SecureRandom.hex unless self.reset_password_token
     self.reset_password_sent_at = Time.now unless self.reset_password_sent_at
  end

  private

  def should_validate_password?
    self.new_record? || (self.new_record? == false and self.password.present?)
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex unless self.auth_token
  end

  include StateMachinesScopes

end
