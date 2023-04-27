require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 2
  end
  test 'render a detailed product page' do
    get product_path(products(:vestido))

    assert_response :success
    assert_select '.title', 'Vestido de noche'
    assert_select '.description', 'Muy elegante, no incluye accesorios'
    assert_select '.price', '$1500'
  end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allow to create a new product' do
    post products_path, params: {
      product: {
        title: 'calcetas',
        description: 'estan rotas',
        price: 45
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params: {
      product: {
        title: '',
        description: 'estan rotas',
        price: 45
      }
    }
    assert_response :unprocessable_entity
  end

  test 'render a edit product form' do
    get edit_product_path(products(:falda))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:falda)), params: {
      product: {
        price: 65
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end

  test 'does not allow to update a product with an invalid field' do
    patch product_path(products(:falda)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count',-1) do
      delete product_path(products(:falda))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end

end

