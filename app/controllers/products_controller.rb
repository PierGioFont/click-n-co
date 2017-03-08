class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :search ]

  def index
    # @shops = Shop.near(@shop,5).limit(4).offset(1)
    @shops = Shop.first(5)
    @today = Date.today
    # @open_hours = OpeningHour.where(shop_id: params[:id])
    # @collection = OpenHourSort.new(@open_hours).call  ## unless @open_hours.empty?
    @cart = session[:cart] || {} #set to empty hash if empty (new cart)
    @product_hash = Product.search(params[:search], session[:address])
  end

  def search
    # respond_to do |format|
      @products = Product.search_autocomplete(params[:term])

      # @products.each { |e| e.name = e.pg_search_highlight }

      # @products
      # format.json
    # end
  end
end
