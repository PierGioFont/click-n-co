class ShopsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :find_shop, only: [:show]

  def index
    respond_to do |format|
      format.html {
        @shops = Shop.search_by_address(params)
        session[:address] = params['where']
        @hash = build_markers(@shops)
      }
      format.json {
        @shops = Shop.search_by_latlng(params)
      }
    end
  end

  def show
    @shops = Shop.near(@shop,5).limit(4).offset(1)
    @today = Date.today
    @open_hours = OpeningHour.where(shop_id: params[:id])
    @collection = OpenHourSort.new(@open_hours).call  ## unless @open_hours.empty?
    @cart = session[:cart] || {} #set to empty hash if empty (new cart)
    @product_hash = @shop.to_hash
  end

  private

  def build_markers(shops)
    markers = Gmaps4rails.build_markers(shops) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
      marker.infowindow render_to_string(partial: "/shared/map_box", locals: { shop: shop })
    end
    markers
  end

  def find_shop
    @shop = Shop.find(params[:id])
  end

  def find_relative_distances(centre)
    location = Geocoder.coordinates(centre)
    if location
      @shops.each do |shop|
        shop.distance = Geocoder::Calculations.distance_between(location, [shop.latitude, shop.longitude]).truncate
      end
    end
  end

end
