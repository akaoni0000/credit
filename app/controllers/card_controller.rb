class CardController < ApplicationController
  skip_before_action :verify_authenticity_token  #『Can't verify CSRF token authenticity』エラー対策
  def new
    card = Card.where(user_id: current_user.id)
    unless card.blank?
      redirect_to action: "show" 
    end
    gon.key = ENV['KEY'] #payjp(クレジットカード)の公開鍵
  end

  def pay #payjpの顧客情報とカード情報を保存 appcationのCardモデルのデータベースを作成
    Payjp.api_key = ENV['SECRET_KEY'] #秘密鍵
    if params["payjp-token"].blank?  #params[:aaa-afa] -はできない -を使いたい時は["ff-fff"]
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(   #Payjp::Customerはモデル カラムはpayjpサイトの顧客詳細でみれる 顧客idは自動で作成
      description: '登録テスト',             #payjpのサイトの顧客詳細の備考に登録される なくてもいい 顧客情報を保存
      email: current_user.email,           #payjpのサイトの顧客詳細の備考に登録される なくてもいい 顧客情報を保存
      card: params['payjp-token'],         #絶対に必要 カード情報を保存
      metadata: {user_id: current_user.id} #payjpのサイトのmetadataに登録される なくてもいい 顧客情報を保存
      ) 
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)  #customer.idはpayjpサイトの顧客id customer.default_cardはpayjpサイトのカードID
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end 

  def delete #PayjpとCardデータベースを削除します
    card = Card.where(user_id: current_user.id).first
    if card.blank?
    else
      Payjp.api_key = ENV['SECRET_KEY']     #秘密鍵
      customer = Payjp::Customer.retrieve(card.customer_id)  #payjpサイトの顧客情報を取得
      customer.delete
      card.delete
    end
      redirect_to action: "new"
  end

  def show
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = ENV['SECRET_KEY'] #秘密鍵
      customer = Payjp::Customer.retrieve(card.customer_id)              #payjpサイトの顧客情報を取得
      @default_card_information = customer.cards.retrieve(card.card_id)  #payjpサイトのカード情報を取得
    end
  end

  def purchase
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = ENV['SECRET_KEY']
    Payjp::Charge.create(
      :amount => 13500, #支払金額を入力（itemテーブル等に紐づけても良い）
      :customer => card.customer_id, #顧客ID
      :currency => 'jpy', #日本円
    )
    redirect_to action: "show"
  end

  def purchase2
    Payjp.api_key = ENV['SECRET_KEY']
    Payjp::Charge.create(
      :amount => 13500, #支払金額を入力（itemテーブル等に紐づけても良い）
      :card => params['payjp-token'],
      :currency => 'jpy', #日本円
    )
    redirect_to action: "show"
  end

end