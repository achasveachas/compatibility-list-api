class Application < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  validates_presence_of :comments, :software
end
