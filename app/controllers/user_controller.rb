class UserController < ApplicationController
    before_action :authorize_request, except: [:login, :register]
    before_action :getUser, only: [:updateUser, :deleteUser, :showUser]

    def register
        # user = User.new(fullname: params[:fullname], email: params[:email], gender: params[:gender], pswd: params[:pswd])
        user = User.new(userparams)

        if user.save()
            render json: {message: 'Success register!', data: user}, status: :ok
        else
            render json: {message: "Failed add user", error: user.errors}, status: :unprocessable_entity 
        end 
    end

    def login

        begin
            user = User.find_by(:email =>params[:email])

            if !user
                render json: {message: "Username and password not match"}, status: :unprocessable_entity
            end

            if user.authenticate(params[:password])
                token = JsonWebToken.encode(user_id: user.id)
                time = Time.now + 24.hours.to_i
                render json: { message: "Success Login", token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                                email: user.email }, status: :ok
                
            else
                render json: {message: "Username and password not match"}, status: :unprocessable_entity
            end
            
        rescue => exception
            render json: {message: "Username and password not match", error: exception.message}, status: :unprocessable_entity
        end
        

    end

    def allUser
        user = User.all
        if user
            render json: {message: 'Success get user', data: user}, status: :ok
        else 
            render json: {message: "Failed get user"}, status: :unprocessable_entity
        end
    end

    def showUser
        if @user
            render json: {message: "Success get user", data: @user}, status: :ok
        else
            render json: {message: "User not found", error: @user.errors}, status: :unprocessable_entity
        end

    end

    def updateUser
        if @user
            if @user.update(userparams)
                render json: {message: 'Success update user', data: @user}, status: :ok
            else
                render json: {message: "Failed update user"}, status: :unprocessable_entity
            end
        else
            render json: {message: "User not found"}, status: :unprocessable_entity
        end

    end

    def deleteUser
        if @user
            if @user.destroy(userparams)
                render json: {message: "User deleted"}, status: :ok
            else
                render json: {message: "Failed update user"}, status: :unprocessable_entity
            end
        else
            render json: {message: "User not found"}, status: :unprocessable_entity
        end

    end

    private
        def userparams
            params.permit(:fullname, :email, :gender, :password)
        end 

        def getUser
            @user = User.find(params[:id])
        end
end
