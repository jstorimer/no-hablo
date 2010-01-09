class TranslationsController < ApplicationController
  around_filter :shopify_session
  before_filter :load_shop
  before_filter :check_on_processing, :only => :create
  
  def new
    @product_count = ShopifyAPI::Product.count
    @cost_in_cents = (@product_count * Translation::UNIT_PRICE) * 100
    @translation = Translation.new
  end

  def create 
    @translation = @shop.translations.find_or_initialize_by_shop_id_and_to_lang(params[:translation].merge(:shop_id => @shop.id))

    if @translation.save
      if redirect = requires_payment?
        redirect_to redirect and return
      end
      
      @shop.update_attributes(:processing => true)
      @translation.send_later(:translate)
      flash[:notice] = 'We have queued up your translation job in a background task and will send you an email once the job is finished!'
    else
      flash[:error] = @translation.errors.full_messages.to_sentence
    end

    redirect_to :action => 'new'
  end

  private
  def check_on_processing
    if @shop.processing?
      flash[:error] = 'You have a translation in progress. You must wait for that to finish before beginning a new one.' 
      redirect_to :action => 'new'
    end
  end
  
  def load_shop
    @shop = Shop.find_by_subdomain(session[:shopify].subdomain)
  end
  
  def requires_payment?
    return false if @translation.paid?

    session[:return_to] = url_for("http://#{request.host}:#{request.port}/translations/create?translation[to_lang]=#{params[:translation][:to_lang]}")
    charge = ShopifyAPI::ApplicationCharge.create(:name => "Translation charge from NoHablo for translation of product descriptions to #{params[:translation][:to_lang]}", 
                                         :price => ShopifyAPI::Product.count * Translation::UNIT_PRICE,
                                         :test => !Rails.env.production?,
                                         :return_url => url_for(:controller => 'payment_notification', :action => 'create', :translation_id => @translation.id))

    charge.confirmation_url
  end
end
