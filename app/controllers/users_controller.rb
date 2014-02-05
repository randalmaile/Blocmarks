class UsersController < ApplicationController

  def my_library
    @user = User.find(params[:id])
    @my_bookmarks = @user.bookmarks
    authorize! :show, @user, message: "You need to be an account holder."
  end

  def favorites
    @user = User.find(params[:id])
    @favorited_bookmarks = Bookmark.favorited(current_user)
    authorize! :show, @user, message: "You need to be an account holder."
  end

  def show 
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to log_in_path, :notice => "Signed up! Start adding Blocmarks!"
    else
      flash[:error] = "There was a problem creating your account, please try again."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user, message: "You have to own the this account to edit user information."
  end

  def update
    @user = User.find(params[:id])
    # authorize! :update, @post, message: "You need to own the post to edit it."
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account info was updated."
      redirect_to @user
    else
      flash[:error] = "There was an error saving account info.  Please try again."
      render :edit
    end
  end

  def destroy
    @user = Bookmark.find(params[:id])
    if @user.destroy
      redirect_to root_url, notice: "User was deleted successfully."
    else
      flash[:error] = "There was a problem deleting the user"
      render :show
    end
  end
end
