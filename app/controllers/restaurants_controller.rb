class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @restaurants = Restaurant.all
    @review = Review.new
  end

  def new
  	@restaurant = Restaurant.new
  end

  def create
  	@restaurant = Restaurant.create restaurant_params
    @restaurant.user = current_user

    if @restaurant.save
  	 redirect_to '/restaurants'
    else
      render :new
    end
  end

  def edit
  	@restaurant = current_user.restaurants.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Not your restaurant!'
      redirect_to '/restaurants'
  end

  def update
  	@restaurant = Restaurant.find params[:id]
  	@restaurant.update restaurant_params
    flash[:notice] = "Successfully updated #{@restaurant.name}"
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = current_user.restaurants.find params[:id]
    @restaurant.destroy
    flash[:notice] = "Successfully deleted #{@restaurant.name}"
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Not your restaurant!'
    ensure
      redirect_to '/restaurants'
  end

  private

  def restaurant_params
  	params.require(:restaurant).permit(:name, :cuisine)
  end
end
