require 'spec_helper'

describe MemberUser do

  before do
    @first_user = MemberUser.new name: 'First User'
    @first_user.generate_invite_code
    @first_user.save(validate: false)
  end

  it "allows to register user using an invite code" do
    new_user = MemberUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
    new_user.persisted?.should be_true
    new_user.owner.should be_eql @first_user
  end

  it 'does not allow to register user using non-existing invite code' do
    new_user = MemberUser.register_by_invite_code 'nonexistent_invite_code', name: 'Invited User'
    new_user.persisted?.should_not be_true
  end

  it 'generates an invite code for new user' do
    new_user = MemberUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
    new_user.invite_code.is_a?(String).should be_true
    (new_user.invite_code.length > 0).should be_true
  end

  it 'creates friendship between owner and invited user' do
    new_user = MemberUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
    @first_user.friends.include?(new_user).should be_true
  end

  it 'does not create reverse friendship between owner and invited user' do
    new_user = MemberUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
    new_user.friends.include?(@first_user).should be_false
  end

  it 'can invite corporate users' do
    corporate_user = CorporateUser.register_by_invite_code @first_user.invite_code, name: 'Invited User'
    corporate_user.persisted?.should be_true
    corporate_user.is_a?(CorporateUser).should be_true
  end

end