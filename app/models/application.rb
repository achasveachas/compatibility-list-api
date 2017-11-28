class Application < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  validates_presence_of :comments, :software

  def compatible?
    self.omaha || self.nashville || self.buypass || self.north || self.elavon || self.tsys || self.other
  end

end
