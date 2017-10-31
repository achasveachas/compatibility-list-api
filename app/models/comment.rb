class Comment < ApplicationRecord
  belongs_to :application
  belongs_to :user
  validates_presence_of :body
end
