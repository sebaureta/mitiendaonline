class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  ActionController::Parameters.permit_all_parameters = true
  # GET /products
  # GET /products.json
  def index
  #  @productsi = Product.all.page(params[:page])
  #  @categories = Category.
    if params[:category]
      @products = Category.find_by(name: params[:category]).products
    elsif params[:searchbox]
      @products = Product.search(params[:searchbox])
    else
      @products = Product.all.page(params[:page])
    end

    @categories = Category.pluck(:name,:id)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.categories = params[:categories]
    respond_to do |format|
        if @product.save
          format.html { redirect_to @product, notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    authorize! :destroy, Product
    @product.destroy
    respond_to do |format|
      format.html { redirect_to admins_path, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :categories, :searchbox)
  end
end
