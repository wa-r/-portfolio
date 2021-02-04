class Member::TweetsController < ApplicationController

  def index
    @tweets = Tweet.all.page(params[:page]).per(6)
    @member = current_member
  end

  def show
    @tweet = Tweet.find(params[:id])
    @tweet_comment = TweetComment.new
    @member = current_member
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.member_id = current_member.id
    if @tweet.save
      redirect_to tweets_path
    else
      render :new
    end
  end

  # def edit
  #   @tweet = Tweet.find(params[:id])
  # end

  # def update
  #   @tweet = Tweet.find(params[:id])
  #   @tweet.update(tweet_params)
  #   redirect_to tweets_path
  # end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:title, :content, :image)
  end

end
