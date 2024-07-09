class CategoriesController < ApplicationController


  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to new_category_path, notice: 'Categoria criada com sucesso'
    else
      render :new
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
  end

  private

  def category_params
    params.require(:category).permit(:name, :description, :cat_sub)
  end

end
