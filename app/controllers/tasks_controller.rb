class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  before_action :set_task, only: [:show,  :edit, :update, :destroy]
  def index
         @tasks = Task.all
         @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
  end

  def show
      @task = Task.find(params[:id])
  end

  def new
      @task = Task.new
  end

  def create
    
       @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'task が正常に投稿されました'
      redirect_to root_url
    else
      @pagy, @tasks = pagy(current_user.tasks.order(id: :desc))
      flash.now[:danger] = 'task が投稿されませんでした'
      render :new
    end
  end

  def edit
      
  end

  def update
     binding.pry

   if @task.update(task_params)
      flash[:sucess] ='task は正常に更新されました'
      redirect_to root_url
   else 
      flash.now[:danger] = 'task は更新されませんでした'
      render :edit
   end
  end
  def destroy
       @task.destroy
    flash[:success] = 'task は正常に削除されました'
    redirect_to root_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
    
    
  end
  
  def task_params
    params.require(:task).permit(:status,:content)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
