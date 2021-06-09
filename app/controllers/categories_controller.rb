class CategoriesController < ApplicationController
	before_action :require_admin
	before_action :set_cat, only: [:edit, :update, :show, :destroy]

	def index
		@categories = Category.all
	end


	def new
		@category = Category.new
	end


	def create
		@category = Category.new(category_params)
		if @category.save
			flash[:success] = "Category was successfully created"
			redirect_to categories_path
		else
			render 'new'
		end
	end

	def edit
		
	end	

	def update
		if @category.update(category_params)
			flash[:success] = "Category name was successfully updated"
			redirect_to categories_path
		else
			render 'edit'
		end
	end


	# def show
	# 	@category = Category.find(params[:id])
		
	# end

	def destroy
		@category.destroy
	    flash[:danger] = "The selectd Category has been deleted"
	    redirect_back(fallback_location:"/")
	end









	private

	def category_params
		params.require(:category).permit(:name)
	end

	def require_admin
		if !logged_in? || (logged_in? && !current_user.admin?)
			flash[:danger] = "Only Admins can perform that action"
			redirect_to root_path
		end
	end

	def set_cat
	    @category = Category.find(params[:id])
	end


end