class User < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'

  has_many :friendships
  has_many :friends, through: :friendships

  after_create :create_owner_friendship

  validates_presence_of :name
  validates_presence_of :owner
  validate :owner_should_be_able_to_invite

  def owner_should_be_able_to_invite
    errors.add(:owner, 'cannot invite') if !owner || !owner.can_invite?
  end

  def create_owner_friendship
    Friendship.create(user: owner, friend: self)
  end

  def self.register_by_invite_code (invite_code, params={})
    owner = User.where(invite_code: invite_code).take
    self.create params.merge(owner: owner)
  end

  def can_invite?
    true
  end
end