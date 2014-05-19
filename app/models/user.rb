class User < ActiveRecord::Base
	has_one :gamelist, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :steamv2, :twitch],
				 :authentication_keys => [:login]
  after_save :create_game_list

  attr_accessor :login

		validates_uniqueness_of :username
		validates_presence_of :username
#   validates_presence_of :email

	validates :username, :uniqueness => { :case_sensitive => false }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		if signed_in_resource
			signed_in_resource.update_attributes(:provider => auth.provider, :uid => auth.uid)
		else
		  User.where(auth.slice(:provider, :uid)).first_or_create do |user|
		    user.provider = auth.provider
		    user.uid = auth.uid
		    user.email = auth.info.email
				user.username = auth.info.nickname
		    user.password = Devise.friendly_token[0,20]
				user.first_name = auth.info.first_name
				user.last_name = auth.info.last_name
		    #user.image = auth.info.image # assuming the user model has an image
		  end
		end
	end

	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
			signed_in_resource.update_attributes(:provider => auth.provider, :uid => auth.uid)
		else
			User.where(:provider => auth.provider, :uid => auth.uid).first_or_create do |user|
				user.username = auth.info.nickname
				user.first_name = auth.info.name.split(" ").first
				user.last_name = auth.info.name.split(" ").last
				user.twitter_handle = auth.info.nickname
				user.email = auth.uid+"@twitter.com"
				user.password = Devise.friendly_token[0,20]
				#user.image = auth.info.image
			end
		end
  end
  
  def self.find_for_steam_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      signed_in_resource.update_attributes(:provider => auth.provider, :uid => auth.uid)
    else
      User.where(:provider => auth.provider, :uid => auth.uid).first_or_create do |user|
        user.username = auth.info.nickname
        user.email = auth.uid+"@steampowered.com"
        user.first_name = auth.info.name
        user.steam_id = auth.uid
        user.password = Devise.friendly_token[0,20]
        #user.image = auth.info.image
      end
    end
  end
  
  def self.find_for_twitch_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      signed_in_resource.update_attributes(:provider => auth.provider, :uid => auth._id)
    else
      User.where(:provider => auth.provider, :uid => auth.uid).first_or_create do |user|
        user.username = auth.info.display_name
        user.email = auth.info.email
        user.first_name = auth.info.name
        user.bio = auth.info.bio
        user.twitch_handle = auth.info.display_name
        user.password = Devise.friendly_token[0,20]
      end
    end
  end

	def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end


  def create_game_list
		if gamelist.nil?
  		gamelist = self.build_gamelist()
  		gamelist.save
		end
  end

	def has_game?(game)
		self.gamelist.games.include?(game)
	end
end
