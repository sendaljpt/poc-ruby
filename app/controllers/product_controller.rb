class ProductController < ApplicationController
    def allProduct
        product = Product.all 
        # @query = "kamar"
        # product = Product.joins(:stores).where('store.name like :query OR product.name like :query', query: "%#{@query}%")

        if product
            render json: product, :include => [:store, :variant], status: :ok
        else
            render json: {message: "Product not found"}, status: :unprocessable_entity
        end
    
    end

    def detailProduct
        product = Product.find(params[:id])

        if product
            render json: product, :include => [:store, :variant], status: :ok
        else
            render json: {message: "product not found", error: product.errors}, status: :unprocessable_entity
        end
    end

end
