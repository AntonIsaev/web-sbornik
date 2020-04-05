class GlobalParamsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_rights
  
  def index
    @global_params = GlobalParam.all
  end
  
  def show
    @global_param = GlobalParam.find(params[:id])
  end
  
  def new
    @global_param = GlobalParam.new
  end

  def edit
    @global_param = GlobalParam.find(params[:id])
  end

  def create
    @global_param = GlobalParam.create(global_params_params)
    if @global_param.save
      redirect_to global_params_path
    else
      render 'new'
    end
  end
  
  def update
    @global_param = GlobalParam.find(params[:id])

    if @global_param.update(global_params_params)
      redirect_to global_params_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @global_param = GlobalParam.find(params[:id])
    @global_param.destroy
    redirect_to global_params_path
  end

  
private
  def global_params_params
    params.require(:global_param).permit(:param_name, :val, :description)
  end  
  
  def check_rights
    if not (user_signed_in? && current_user.id == 0)
	  redirect_to root_path
	end
  end  

end
