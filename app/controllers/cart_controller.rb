class CartController < ApplicationController
    before_action :authorize_request
    before_action :buildProduct, only: [:addCart]

    def addCart
        begin
            # check existing cart
            cart = Cart.find_by(:user_id => $current_user.id)

            # get product by sku
            puts "************"
            puts @variant.inspect
            puts @product.inspect
            puts @store.inspect
            puts "************"



            # if exist
            if cart
                # puts "---"
                # puts cart.inspect
                # puts "---"

                # check sku in cart
                cartItem = cart.item 
                # puts cartItem.inspect
                # if cartItem.any? {|i| i.sku == params[:sku]}
                if cartItem.any? {|ci| ci['sku'] == params[:sku]}
                    puts "ada"
                else
                    skuData = Variant.find_by(:sku => params[:sku]).
                    puts "---"
                    puts skuData.inspect
                    puts "---"
                    newItem = {
                        "sku": params[:sku],
                        "quantity": params[:quantity],
                        "price": params[:price]
                    }
                    cart.push(item: newItem)
                    puts "gak ada"
                end
                # if sku exist in cart
                # TODO : update quantity

                # else : insert sku in cart
                
                render json: cart, status: :ok
            # create new cart and insert sku
            else
                cart = Cart.new(:user_id => $current_user.id, :status => :draft, :item => [@cartData])
                if cart.save
                    render json: {message: "Success add to cart", data: cart}, status: :ok
                end
            end 
        rescue => exception
            render json: {message: "Failed add cart", error: exception.message}, status: :unprocessable_entity
        end

    end

    private
        def buildProduct
            @sku = params[:sku]
            @quantity = params[:quantity]

            # get variant
            @variant = Variant.find_by(:sku => @sku)
            if !@variant
                return nil
            end

            @product = Product.find(@variant.product_id)
            
            if !@product
                return nil
            end

            @store = Store.find(@product.store_id)
            if !@store
                return nil
            end

            @cartData = {
                "store_id": @store.id,
                "store_name": @store.name,
                "product": [
                    {
                        "product_id": @product.id,
                        "name": @product.name,
                        "variant": {
                            "sku": @variant.sku,
                            "color": @variant.color,
                            "quantity": @quantity,
                            "price": @variant.price,
                        }
                    }
                ]
            }

        end

end
