class CorporateUser < User

  def can_invite?
    false
  end

end