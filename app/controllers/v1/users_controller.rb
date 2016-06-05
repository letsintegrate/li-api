module V1
  class UsersController < BaseController
    before_action :doorkeeper_authorize!
    before_action :set_user, only: %i(show update destroy)

    def index
      @users = get_index(User)
      render json: @users, each_serializer: UserSerializer
    end

    def create
      @user = User.create!(user_params)
      render json: @user, serializer: UserSerializer
    end

    def show
      render json: @user, serializer: UserSerializer
    end

    def me
      render json: current_user, serializer: UserSerializer
    end

    def update
      @user.update!(user_params)
      render json: @user, serializer: UserSerializer
    end

    def destroy
      @user.destroy!
      head :no_content
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      deserialized_params.permit(:email, :password).reject do |key, value|
        key === 'password' && value.empty?
      end
    end
  end
end
