class TranslationsController < ApplicationController
  around_filter :shopify_session

  def new
    @product_count = ShopifyAPI::Product.count
    @cost_in_cents = (@product_count * Translation::UNIT_PRICE) * 100
    @translation = Translation.new
  end

  def create 
    @shop = Shop.find_by_subdomain(session[:shopify].subdomain)
    @translation = @shop.translations.find_or_initialize_by_shop_id_and_to_lang(params[:translation].merge(:shop_id => @shop.id))
    check_on_processing

    if @translation.save
      charge_user
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
    flash[:error] = 'You have a translation in progress. You must wait for that to finish before beginning a new one.' if @shop.processing?
    redirect_to :action => 'new' and return
  end
  
  def charge_user
    return true if @translation.paid?

    session[:return_to] = request.url
    charge = ShopifyAPI::ApplicationCharge.create(:name => "Translation charge from NoHablo for translation of product descriptions to #{params[:to_lang]}", 
                                         :price => ShopifyAPI::Product.count * Translation::UNIT_PRICE,
                                         :test => !Rails.env.production?,
                                         :return_url => url_for(:controller => 'payment_notification', :action => 'create'))

    redirect_to charge.confirmation_url
  end
end
