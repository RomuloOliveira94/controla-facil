class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_frame_response, only: %i[ create ]
  before_action :set_category, only: %i[ destroy ]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.user = current_user

    respond_to do |format|
      if @category.save
          format.turbo_stream do
          render turbo_stream: turbo_stream.append(list_to_update, partial: 'configurations/categories_list',
                                                                 locals: { category: @category })
        end
        format.html { redirect_to configurations_path, notice: 'Categoria criada com sucesso.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @category.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(@category)
      end
      format.html { redirect_to configurations_path, notice: 'Categoria deletada com sucesso.' }
    end
  end

  private

  def ensure_frame_response
    redirect_to configurations_path unless turbo_frame_request?
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :cat_sub, :icon)
  end

  def list_to_update
    @category.cat_sub === "expenses" ? "expenses" : "incomes"
  end
end
