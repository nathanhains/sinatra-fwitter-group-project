class TweetsController < ApplicationController
    configure do
        enable :sessions
        set :session_secret, "secret"
      end
    
    get '/tweets' do
        if logged_in?
          @users = current_user
          @tweets = Tweet.all
          erb :'/tweets/tweets'
        else
          redirect to "/login"
        end
      end

    get '/tweets/new' do
        if logged_in?
            @user = current_user
            erb :'tweets/new'
        else
            redirect "/login"
        end
    end

    post '/tweets' do
        if params[:content] != ""
            @tweet = Tweet.create(content: params[:content], user: current_user)
            @tweet.user_id = session[:user_id]
            redirect to "/tweets/#{@tweet.id}"
        else
            redirect "/tweets/new"
        end
    end

    get "/tweets/:id" do
        if logged_in?
          @tweet = Tweet.find_by_id(params[:id])
          erb :'/tweets/show_tweet'
        else
          redirect to "/login"
        end
    
      end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find_by_id(params[:id])
        if logged_in? && @tweet.user == current_user
            erb :'tweets/edit_tweet'
        else
            redirect to "/login"
        end
    end

    patch "/tweets/:id" do
        @tweet = Tweet.find_by_id(params[:id])
    
        if logged_in? && !params[:content].blank?
            @tweet.update(content: params[:content])
            @tweet.save
            redirect to "/tweets/#{@tweet.id}"
        else
            redirect to "/tweets/#{@tweet.id}/edit"
      end
    end    

    post "/tweets/:id/delete" do
        @tweet = Tweet.find_by_id(params[:id])
        if current_user == @tweet.user
            @tweet.delete
            redirect to '/tweets'
          else
            redirect to "/tweets/#{params[:id]}"
          end
        end

end
