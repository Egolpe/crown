 # == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  last_name       :string           not null
#  email           :string           not null
#  username        :string           not null
#  password_digest :string           not null
#  admin           :boolean          default(FALSE)
#  status          :integer          default("active")
#  validator       :boolean          default(FALSE)
#  organization    :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_secure_password
  enum status: %i(active pending blocked)

  validates :name, :last_name, :email, :username, :password, :status, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  before_create :set_status_to_pending

  def set_status_to_pending
    self.status = :pending
    # Pending: Send user confirmation email
  end
end