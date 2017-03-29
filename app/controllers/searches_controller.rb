# frozen_string_literal: true
require 'open-uri'
require 'json'

class SearchesController < OpenReadController
  before_action :set_example, only: [:update, :destroy]

  def index

  end

  def show
    render json: Example.find(params[:id])
  end

  # using create route for api w/o generating new resource
  def sounds_search
    query = params[:search][:query]
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/planetary/sounds?q=#{query}&limit=100&api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def mars_search
    query = params[:search][:query]
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=#{query}&api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def patents_search
    query = params[:search][:query]
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/patents/content?query=#{query}&api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def apod_search
    query = params[:search][:query]
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/planetary/apod?date=#{query}&api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def apod_today
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/planetary/apod?api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def neo_today
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/neo/rest/v1/feed/today?detailed=true&api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def neo_stats
    api_key = Rails.application.secrets.nasa_api_key
    url = "https://api.nasa.gov/neo/rest/v1/stats?api_key=#{api_key}"
    response = open(url)
    data_string = response.read
    json_string = JSON.parse(data_string)
    render json: json_string
  end

  def update
    if @example.update(example_params)
      head :no_content
    else
      render json: @example.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @example.destroy

    head :no_content
  end

  def set_example
    @example = current_user.examples.find(params[:id])
  end

  def example_params
    params.require(:query).permit(:query)
  end

  private :set_example, :example_params
end
