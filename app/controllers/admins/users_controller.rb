class Admins::UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def index
    authenticate_admin!
  	@approved_users = User.approved_users.order(sort_column + " " + sort_direction)
  	@unapproved_users = User.unapproved_users.order(sort_column + " " + sort_direction)
  end

  def edit
    authenticate_admin!
    @user = User.find(params[:id])
  end
  
  def user_params
    authenticate_admin!
    params.require(:user).permit!
  end

  def update
    authenticate_admin!
    @user = User.get_user(params[:id])
    if @user.update_attributes(user_params)
        @user.save
        ApplicationMailer.update_user(@user.email, user_params).deliver_now
        flash[:notice] = "Editace proběhla úspěšně."
    else
        flash[:error] = "Editace se nepodařila."
    end

    redirect_to admins_users_path
  end

  def approved()
    authenticate_admin!
  	if User.approved(params[:id])
          email = User.get_email(params[:id])
         ApplicationMailer.user_was_approved(email).deliver_now
    end
  	@approved_users = User.approved_users
  	@unapproved_users = User.unapproved_users
  	render "/admins/users/index"
  end

  def destroy
    authenticate_admin!
    user_id = params[:id]
    email = User.get_email(user_id)
    approved = User.get_approved(user_id)
    if User.destroy_user(user_id)
      Loan.destroy_all(:user_id => user_id)
      Reservation.destroy_all(:user_id => user_id)
      flash[:notice] = "Uživatel byl úspěšně odstraněn."
      if approved
         ApplicationMailer.destroy_user(email).deliver_now
      else
        ApplicationMailer.unapproved_user(email).deliver_now
      end
    else
      flash[:error] = "Uživatele se nepodařilo odstranit."
    end
    redirect_to admins_users_path
  end

  def self_destroy
    user_id = params[:id]
    if User.destroy_user(user_id)
      Loan.destroy_all(:user_id => user_id)
      Reservation.destroy_all(:user_id => user_id)
      flash[:notice] = "Účet byl úspěšně odstraněn."
    else
      flash[:error] = "Účet se nepodařilo odstranit."
    end
    redirect_to home_index_path
  end

  private
    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "email"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end