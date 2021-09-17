class OrderController < ApplicationController
    def createOrder
        puts params[:cart_id]
        puts params[:item]
    end
end
