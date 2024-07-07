class ConfigurationsController < ApplicationController


  def change_theme
    @user = current_user
    
    respond_to do |format|
      if @user.update(theme: params[:theme])
          format.html { redirect_to configurations_url, notice: "Tema atualizado com sucesso." }
          format.json { render json: { message: "Tema alterado com sucesso." }, status: :ok }
      else
        format.html { redirect_to configurations_url, alert: "Erro ao atualizar o tema." }
        format.json { render json: { message: "Erro ao atualizar o tema." }, status: :unprocessable_entity }
      end
    end
  end

end
