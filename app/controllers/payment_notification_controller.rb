class PaymentNotificationController < ApplicationController
  around_filter :shopify_session
  
  def create
    ShopifyAPI::ApplicationCharge.find(params[:charge_id]).activate

    redirect_to session[:return_to] || root_path
  end
end
