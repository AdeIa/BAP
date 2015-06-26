# From https://github.com/plataformatec/devise/wiki/How-To%3a-Require-admin-to-activate-account-before-sign_in
class User < ActiveRecord::Base
  has_many :loans
  has_many :reservations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  after_create :send_admin_mail

  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super
    end 
  end

  def name_with_surname
      "#{name} #{surname}"
  end

  # send email to admin about the new reader registration
  def send_admin_mail
    admins = Admin.all

    admins.each do |admin|
      if admin.reminder
        AdminMailer.new_user_waiting_for_approval(admin.email).deliver_now
      end
    end
  end
 
 # return if user has activated reminder or not
  def self.reminder(user_id)
    find_by(id: user_id).reminder
  end


  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  # approve the registration readers
  def self.approved(id)
    find_by(id: id).update_attribute(:approved, true)
  end
  
  # return approved users
  def self.approved_users
    User.where(approved: true)
  end
 
  # return unapproved users
  def self.unapproved_users
    User.where(approved: false)
  end

  # find user by id
  def self.get_user(id)
    User.find(id)
  end

  # find user by email
  def self.get_email(id)
    User.find(id).email    
  end

  # find user by first name
  def self.get_name(id)
    User.find(id).name     
  end

  # find user by last name
  def self.get_surname(id)
    User.find(id).surname    
  end

  # delete user from database
  def self.destroy_user(id)
    user = User.find(id)
    return user.destroy
  end

  # return if user is approved or not
  def self.get_approved(id)
    User.find(id).approved
  end
  
end
