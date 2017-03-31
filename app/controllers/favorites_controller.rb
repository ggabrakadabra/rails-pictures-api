# frozen_string_literal: true
class FavoritesController < OpenReadController
  before_action :set_favorite, only: [:update, :destroy]

  # GET /favorites
  def index
    @favorites = current_user.favorites.order(created_at: :asc)

    render json: @favorites
  end

  # GET /favorites/1
  def show
    @favorite = Favorite.find(params[:id])
    render json: @favorite
  end

  # POST /favorites
  def create
    @favorite = current_user.favorites.build(favorite_params)

    if Favorite.exists?(user_id: current_user.id,
                        picture_id: favorite_params[:picture_id])
      head :conflict
    elsif @favorite.save
      render json: @favorite, status: :created
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  def update
    if @favorite.update(favorite_params)
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  def destroy
    @favorite.destroy
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_favorite
    @favorite = current_user.favorites.find(params[:id])
  end
  private :set_favorite

  # Only allow a trusted parameter "white list" through.
  def favorite_params
    params.require(:favorite).permit(:picture_id)
  end
  private :favorite_params
end
