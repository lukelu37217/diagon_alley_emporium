require "test_helper"

class ShoppingCartControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shopping_cart_index_url
    assert_response :success
  end

  test "should get create" do
    get shopping_cart_create_url
    assert_response :success
  end

  test "should get update" do
    get shopping_cart_update_url
    assert_response :success
  end

  test "should get destroy" do
    get shopping_cart_destroy_url
    assert_response :success
  end
end
