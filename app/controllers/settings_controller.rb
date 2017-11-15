class SettingsController < ApplicationController
  def edit
    @setting = User.friendly.find(current_user.id).setting
  end

  def update
    @setting = User.friendly.find(current_user.id).setting
    if @setting.update(setting_params)
      flash[:notice] = "Your setting has been saved..."
    else
      flash[:alert] = "Cannot save the setting..."
    end
    render 'edit'
  end

  private
    def setting_params
      params.require(:setting).permit(:enable_sms, :enable_email)
    end
end
