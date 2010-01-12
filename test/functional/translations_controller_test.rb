require 'test_helper'
require 'ostruct'

class TranslationsControllerTest < ActionController::TestCase
  def setup
    login_to_shopify
    ShopifyAPI::Product.stubs(:count).returns(12)
    ShopifyAPI::ApplicationCharge.stubs(:create).returns(OpenStruct.new(:confirmation_url => 'http://google.com'))
  end

  test "on GET to :new should render a form" do
    get :new

    assert_response :ok
    assert_template 'new'
    assert_select 'form'
  end

  test "on POST to :create should redirect to shopify" do
    post :create, :translation => {:to_lang => 'fr'}

    assert_response :redirect
  end

  test "on GET to :create after accepting charge should create a DJ" do
    @controller.stubs(:requires_payment?).returns(false)
    
    assert_difference "Delayed::Job.count" do
      get :create, :translation => {:to_lang => 'fr'}
    end

    assert assigns(:translation).shop.processing?
  end

  test "on POST to :create while currently processing should refuse" do

  end
end
