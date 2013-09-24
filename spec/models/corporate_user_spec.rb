require 'spec_helper'

describe CorporateUser do

  before do
    @first_user = MemberUser.new name: 'First User'
    @first_user.generate_invite_code
    @first_user.save(validate: false)

    @corporate_user = CorporateUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
  end

  it "cannot invite other users" do
    new_user = MemberUser.register_by_invite_code @corporate_user.invite_code, name: 'Invited User'

    new_user.persisted?.should be_false
  end

  it 'does not have an invite code' do
    @corporate_user.invite_code.should be_eql nil
  end

end