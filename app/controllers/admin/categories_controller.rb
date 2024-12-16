class Admin::CategoriesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin_user!
  before_action :set_category, only: [:edit, :update, :destroy]
  before_action :category_sort_values, only: [:new, :edit]

  def index
    @categories = Category.order(status: :desc).order(sort: :asc).page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = 'Category created successfully'
      redirect_to admin_categories_path
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit;end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category updated successfully'
      redirect_to admin_categories_path
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = "Category was successfully deleted."
      redirect_to admin_categories_path
    else
      flash[:alert] = @banner.errors.full_messages.to_sentence
      redirect_to admin_categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :sort)
  end

  def category_sort_values
    category_sort_values = Category.where.not(sort: nil).pluck(:sort)
    category_max_sort = Category.count
    @category_sort_values = (1..category_max_sort).to_a - category_sort_values
    @category_sort_values.unshift(["Default", 0])
  end
end
