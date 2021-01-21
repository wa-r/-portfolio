class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  attachment :profile_image

  has_many :tweets, dependent: :destroy
  # 自分がフォローしているユーザーとの関係
  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower
  # 自分がフォローされているユーザーとの関係
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following

  validates :name, presence: true, length: { in: 2..20 }

  # 退会済み(is_deleted == true)のユーザーを弾くためのメソッド
  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (self.is_deleted == false)
  end

  # フォローする際に、すでにフォロー済みかどうかを判定する
  def followed_by?(member)
    passive_relationships.find_by(following_id: member.id).present?
  end
end
