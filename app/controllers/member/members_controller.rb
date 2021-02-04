class Member::MembersController < ApplicationController
  def show
    @member = Member.find(params[:id])
    @tweets = @member.tweets.page(params[:page]).per(9)

  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to member_path(@member), notice: "更新に成功しました"
    else
      render :edit
      flash[:notice] = "更新に失敗しました"
    end
  end

  def withdrawal
    @member = Member.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @member.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

  # ブックマークの一覧表示用
  def bookmarks
    @bookmarks = current_member.bookmarks
  end

  # いいねをしたつぶやきの一覧表示用
  def tweet_likes
    @tweet_likes = current_member.tweet_likes
  end

  # フォロー画面表示用
  def follows
    member = Member.find(params[:id])
    @members = member.followings.page(params[:page]).per(10)
  end

  # フォロワー画面表示用
  def followers
    member = Member.find(params[:id])
    @members = member.followers.page(params[:page]).per(10)
  end

  private

  def member_params
    params.require(:member).permit(:name, :introduction, :profile_image)
  end
end
