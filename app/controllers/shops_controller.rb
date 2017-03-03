class ShopsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show ]
  before_action :find_shop, only: [:show]

  def index
    if params[:category].nil? || params[:category].empty?
      params[:where].blank? ? @shops = Shop.all : @shops = Shop.near(params['where'], 1000)
    else
      @shops = Shop.near(params['where'], 1000).where("category_id = #{params['category']}")
    end

    @hash = Gmaps4rails.build_markers(@shops) do |shop, marker|
      marker.lat shop.latitude
      marker.lng shop.longitude
      marker.infowindow render_to_string(partial: "/shared/map_box", locals: { shop: shop })
    end
  end

  def show
    @shops = Shop.near(@shop,5).limit(5).last(4)
    @today = Date.today
    @cart = session[:cart] || {} #set to empty hash if empty (new cart)
  end

  private

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
