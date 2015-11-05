require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:microblog.sqlite3"

enable :sessions


#home#homepage
get '/' do
	erb :index
end



#User#Index
get '/users' do
	@users = User.all
	erb :users_index
end


#Users#create
post '/users' do
			@user = User.new(userparams)
		if @user.save
			flash[:notice] = "User created successfully!"
			redirect_to users_path
		else
			flash[:alert] = "User was not created successfully."
			render :new

		end

end


#users#new
get '/users/new' do
	@user = User.new
end

#users#edit
get '/users/:id/edit' do
	@user = User.find(params[:id])
end

#users#show
get '/users/:id' do
	@users = User.all
end

#users#update
patch '/users/:id' do

	@user.update(userparams)
		redirect_to users_path
	
end

#users#update
put '/users/:id' do

	@user.update(userparams)
		redirect_to users_path

end

#users#destroy
delete '/users/:id' do

			if session[:id] == @user.id
		   	session[:id] = nil
			@user = User.find(params[:id]).destroy
			redirect_to users_path, notice: "User was deleted!"
		else
			redirect_to users_path, notice: "User cannot be deleted."
		end

end




#posts#index
get '/posts' do
		@posts = Post.all
		@recent = Post.order("created_at DESC").limit(10)
	erb :posts
end

#posts#create
post '/posts' do

		@post = Post.new(postparams.merge(user_id: current_user.id))
		if @post.save
			flash[:notice] = "Post created successfully!"
		else
			flash[:alert] = "Post was not created successfully."

		end
			# The same as typing in post_path(@post.id)
			redirect_to @post 

end

#posts#new
get '/posts/new' do

	@post = Post.new	

end

#posts#edit
get '/posts/:id/edit' do

	@post = Post.find(params[:id])

end


#posts#show
get '/posts/:id' do

	@post = Post.find(params[:id])

end

#posts#update
patch '/posts/:id' do

		@post.update(postparams)
		redirect_to posts_path

end

#posts#update
put '/posts/:id' do

		@post.update(postparams)
		redirect_to posts_path
end

#posts#destroy
delete '/posts/:id' do

		@post.destroy
		redirect_to posts_path, notice: "Post was deleted!"

end


#users#follow
post '/users/:id/follow' do

		Follow.create(followee_id: params[:id], follower_id: current_user.id)
		redirect_to @user, notice: "Followed!"

end

#users#unfollow
delete '/users/:id/unfollow' do

			Follow.where(followee_id: params[:id], follower_id: current_user.id).first.destroy
		redirect_to @user, notice: "Unfollowed!"

end

#sessions#login
post '/signin' do

		@user = User.find_by(username: params[:username])
		if @user and @user.password == params[:password]
			session[:id] = @user.id
			redirect_to user_path(current_user), notice: "Successfully signed in!"
		else
			redirect_to root_path, alert: "Failed to log in."
		end

end

#sessions#logout
delete '/signout' do

		session[:id] = nil
		flash[:notice] = "You have been signed out."
		redirect_to root_path
	end

end

helpers do

	def current_user
		session[:id] ? User.find(session[:id]) : nil
	end

	def userparams
		params.require(:user).permit(:username, :fname, :lname, :password)
	end

	def postparams
		params.require(:post).permit(:body, :user_id)
	end

end