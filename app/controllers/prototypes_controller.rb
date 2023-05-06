class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_author, only: [:edit, :update]

  def index
    @prototypes = Prototype.all
  end


  def new
    @prototype = Prototype.new
  end
  
  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to (root_path)
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new #(prototype_id: params[:id])
    @comments = @prototype.comments
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end 

  def update
       @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end 

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def ensure_author
    @prototype = Prototype.find(params[:id])
    unless @prototype.user == current_user
      flash[:alert] = "編集・更新は投稿者のみが行えます"
      redirect_to root_path
    end
  end

end