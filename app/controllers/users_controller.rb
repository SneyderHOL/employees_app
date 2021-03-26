class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_import, only: %i[ index new ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.csv { send_data User.export_to_csv, filename: "users-#{Date.today}.csv"}
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users/import
  def import
    if params[:user_import].blank?
      flash[:alert] = "Missing CSV file"
      redirect_to new_user_path
      return
    end
    @user = User.new
    @import = User::Import.new(user_import_params)
    if @import.save
      flash[:notice] = "Total employees imported: #{@import.imported_count}"
      redirect_to users_path
    else
      @user = User.new
      flash.now[:notice] = "Employees imported: #{@import.imported_count}"
      flash.now[:alert] = "There were errors with your CSV file"
      render 'new'
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_import
    @import = User::Import.new
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :position, :salary, :department)
  end

  def valid_type?(file)
    valid_types = ["text/csv"]
    unless file.content_type.in?(valid_types)
      return false
    end
    true
  end

  def user_import_params
    params.require(:user_import).permit(:file)
  end
end
