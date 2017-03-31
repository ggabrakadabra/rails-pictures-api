# frozen_string_literal: true
class CommentsController < OpenReadController
  before_action :set_comment, only: [:update, :destroy]

  # GET /comments
  def index
    @comments = Comment.all.order(created_at: :desc)

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = current_user.favorites.find(params[:id])
  end
  private :set_comment

  # Only allow a trusted parameter "white list" through.
  def comment_params
    params.require(:comment).permit(:picture_id, :note)
  end
  private :comment_params
end
