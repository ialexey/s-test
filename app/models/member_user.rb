class MemberUser < User
  before_validation :generate_invite_code, on: :create

  validates :invite_code, uniqueness: true, length: {is: 7}, numericality: { only_integer: true }

  def generate_invite_code
    record = true
    while record
      random = Array.new(7){rand(9)}.join
      record = self.class.where(invite_code: random).take
    end
    self.invite_code = random if self.invite_code.blank?
    self.invite_code
  end

end