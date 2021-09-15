class CartController < ApplicationController
    before_action :authorize_request

    def addCart
        begin
           # check existing cart
            cart = Cart.where(:user_id => $current_user.id)
            if cart.nil?
                render json: cart, status: :ok
            else
                cart = Cart.new(:user_id => $current_user.id, :status => :draft)
                if cart.save
                    render json: {message: "Success add to cart", data: cart}, status: :ok
                end
            end 
        rescue => exception
            render json: {message: "Failed add cart", error: exception.errors}, status: :unprocessable_entity
        end

    end
end
