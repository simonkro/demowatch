require 'test_helper'

class OrganisationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organisations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organisation
    assert_difference('Organisation.count') do
      post :create, :organisation => { }
    end

    assert_redirected_to organisation_path(assigns(:organisation))
  end

  def test_should_show_organisation
    get :show, :id => organisations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organisations(:one).id
    assert_response :success
  end

  def test_should_update_organisation
    put :update, :id => organisations(:one).id, :organisation => { }
    assert_redirected_to organisation_path(assigns(:organisation))
  end

  def test_should_destroy_organisation
    assert_difference('Organisation.count', -1) do
      delete :destroy, :id => organisations(:one).id
    end

    assert_redirected_to organisations_path
  end
end
