class Application < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  validates_presence_of :comments, :software

  before_save :determine_compatibility

  private

  def is_compatible?
    self.omaha || self.nashville || self.buypass || self.north || self.elavon || self.tsys
  end


  def determine_compatibility
    self.compatible = is_compatible?
  end

end
