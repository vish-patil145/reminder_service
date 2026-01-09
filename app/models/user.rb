# class User < ApplicationRecord
#   has_secure_password
#   has_many :sessions, dependent: :destroy

#   normalizes :email_address, with: ->(e) { e.strip.downcase }
# end
# class User < ApplicationRecord
#   has_secure_password
#   has_many :created_tasks, class_name: "Task", foreign_key: "creator_id", dependent: :destroy
#   has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :destroy

#   validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

#   normalizes :email_address, with: ->(email) { email.strip.downcase }
# end

# class User < ApplicationRecord
#   has_secure_password
#   has_many :sessions, dependent: :destroy
#   has_many :created_tasks, class_name: "Task", foreign_key: "creator_id", dependent: :destroy
#   has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :destroy

#   validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

#   normalizes :email_address, with: ->(email) { email.strip.downcase }
# end
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id", dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :destroy

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  # For authentication
  def self.authenticate_by(email_address:, password:)
    user = find_by(email_address: email_address)
    user&.authenticate(password)
  end
end
