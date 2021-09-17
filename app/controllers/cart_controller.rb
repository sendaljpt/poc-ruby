class CartController < ApplicationController
    before_action :authorize_request
    before_action :buildCartItem, only: [:addCart]
    # before_action :getProductBySku

    def addCart
        begin
            # check existing cart
            cart = Cart.find_by(:user_id => $current_user.id)

            # validate sku
            if !@isSku
                render json: {message: "Invalid SKU"}, status: :unprocessable_entity
                return
            end

            # if exist
            if cart
                # check existing sku
                cartItem = cart.item 
                if cartItem.any? {|ci| ci['sku'] == params[:sku]}
                    # delete first 
                    cartItem.delete_if{|u| u["sku"] == params[:sku]}
                    cart.save
                    # then push for update
                    cart.push(item: @item)
                else
                    cart.push(item: @item)
                end

                render json: {message: "Success add to cart", data: cart}, status: :ok

            # create new cart and insert sku
            else
                cart = Cart.new(:user_id => $current_user.id, :status => :draft, :item => [@item])
                if cart.save
                    render json: {message: "Success add to cart", data: cart}, status: :ok
                end
            end 
        rescue => exception
            render json: {message: "Failed add cart", error: exception.message}, status: :unprocessable_entity
        end

    end

    def getCart
        cart = Cart.find_by(:user_id => $current_user.id)
        data  = []
        cart.item.each do |item|
            itemData = buildProduct(item['sku'], item['quantity'])
            if data.length == 0
                data << itemData

            else
                data.each do |dt|
                    if dt[:store_id] == itemData[:store_id]
                        puts dt[:product][0][:product_id]
                        dt[:product].each do |pr|
                            if pr[:product_id] == itemData[:product][0][:product_id]
                                pr[:variant].each do |vr|
                                    if vr[:sku] != itemData[:product][0][:variant][0][:sku]
                                        pr[:variant] << itemData[:product][0][:variant][0]
                                    end
                                end
                            else
                                dt[:product] << itemData[:product][0]
                            end
                        end
                    else
                        data << itemData
                    end

                end
                
            end
        end

        res = {
            "cart_id": cart.id,
            "status": cart.status,
            "item": data
        }

        render json: {message: "Success get cart", data: res}, status: :ok

    end

    private
        # def getProductBySku
        #     @product = Product.first
        #     @product.variant.any? { |v| v.sku == params[:sku] }
        #     puts "&&&&"
        #     puts @product.exist?
        #     puts "&&&&"
        #     if !@product
        #         return nil
        #     end
        # end

        def buildCartItem
            @isSku = Variant.find_by(:sku => params[:sku])
            if !@isSku
                return nil
            end

            @item = {
                "sku": params[:sku],
                "quantity": params[:quantity],
                "price": @isSku.price
            }

        end

        def buildProduct(sku, quantity)

            # get variant
            variant = Variant.find_by(:sku => sku)
            if !variant
                return nil
            end

            product = Product.find(variant.product_id)
            
            if !product
                return nil
            end

            store = Store.find(product.store_id)
            if !store
                return nil
            end

            @cartData = {
                "store_id": store.id,
                "store_name": store.name,
                "product": [
                    {
                        "product_id": product.id,
                        "name": product.name,
                        "variant": [{
                            "sku": variant.sku,
                            "color": variant.color,
                            "quantity": quantity,
                            "price": variant.price,
                        }]
                    }
                ]
            }

        end

end
