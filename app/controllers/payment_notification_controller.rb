class PaymentNotificationController < ApplicationController
  around_filter :shopify_session
  
  def create
    ShopifyAPI::ApplicationCharge.find(params[:charge_id]).activate
    @translation = Translation.find(params[:translation_id])
    @translation.update_attributes!(:paid => true)

    redirect_to session[:return_to] || root_path
  end
end
