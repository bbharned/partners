class CurrenciesController < ApplicationController
	before_action :require_admin
    before_action :set_currency, only: [:edit, :update, :show]


def index
	@currencies = Currency.all

	
end


def new
    @currency = Currency.new 

end

def show

end



def edit

end



def update
    if @currency.update(currency_params)
        flash[:success] = "Currency was successfully updated"
        #redirect_to currency_path(@currency)
        redirect_to currencies_path
    else
        render 'edit'
    end
end




def create
    @currency = Currency.new(currency_params)

    if @currency.save
        flash[:success] = "Currency has been created and saved"
        redirect_to currencies_path
    else
        render 'new'
    end
end


def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy
    flash[:danger] = "Currency has been deleted"
    redirect_to currencies_path
end



private

    def currency_params
        params.require(:currency).permit(:name, :symbol, :rate)
    end

	def require_admin
        if (logged_in? and !current_user.admin?) || !logged_in? 
            flash[:danger] = "Only admin users can perform that action"
            redirect_to root_path
        end
    end

    def set_currency
        @currency = Currency.find(params[:id])
    end

end