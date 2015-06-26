class SettingsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @settings = Setting.all
  end


  def update_multiple
    admin = Admin.find_by(id: params[:admin_id])
    reminder = params[:reminder] 
    admin = Admin.find_by(id: params[:admin_id])
    admin.update_attribute :reminder, reminder

    if Setting.update(params[:settings].keys, params[:settings].values)
       redirect_to settings_path, notice: 'Nastavení proběhlo úspěšně.'
    else
      redirect_to settings_path,  :flash => { :error => 'Nastavení se nezdařilo.'}
    end
  end

end
