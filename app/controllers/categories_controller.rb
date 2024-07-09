class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('categories', partial: 'configurations/categories_list',
                                                                 locals: { category: @category })
        end
        format.html { redirect_to configurations_path, notice: 'Categoria criada com sucesso.' }
      else
        format.html { render :new }
      end
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
