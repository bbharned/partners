class Flexforward < ApplicationRecord
	belongs_to :user
	belongs_to :currency
	before_save :calcs
    before_create :dating
    validates :name, presence: true, length: { minimum: 1, maximum: 50 }



def findRange(terminalCount)

    if (0..4).include? terminalCount 
        @terminalRange = 0
    elsif (5..49).include? terminalCount 
        @terminalRange = 1
    elsif (50..99).include? terminalCount
        @terminalRange = 2
    elsif (100..249).include? terminalCount
        @terminalRange = 3
    elsif (250..499).include? terminalCount
        @terminalRange = 4
    elsif (terminalCount >= 500)
        @terminalRange = 5 
    end 
    return @terminalRange
    
end











private


def dating
    if self.sm_exp == nil
        self.sm_exp = Date.today() + 1.year
    end
end

# Flex Forward Calculations
def calcs

    if self.ex_serv_sup.nil?
        self.ex_serv_sup = 0
    end

    if self.ex_serv_nosup.nil?
        self.ex_serv_nosup = 0
    end

    if self.ex_serv_nosup_years.nil?
        self.ex_serv_nosup_years = 0
    end

    if self.ex_site_sup.nil?
        self.ex_site_sup = 0
    end

    if self.ex_site_nosup.nil?
        self.ex_site_nosup = 0
    end

    if self.ex_site_nosup_years.nil?
        self.ex_site_nosup_years = 0
    end

    if self.ex_simp_sup.nil?
        self.ex_simp_sup = 0
    end

    if self.ex_simp_nosup.nil?
        self.ex_simp_nosup = 0
    end

    if self.ex_simp_nosup_years.nil?
        self.ex_simp_nosup_years = 0
    end

    if self.ex_red_sup.nil?
        self.ex_red_sup = 0
    end

    if self.ex_red_nosup.nil?
        self.ex_red_nosup = 0
    end

    if self.ex_red_nosup_years.nil?
        self.ex_red_nosup_years = 0
    end

    if self.tr_serv.nil?
        self.tr_serv = 0
    end

    if self.tr_site.nil?
        self.tr_site = 0
    end

    if self.new_simp.nil?
        self.new_simp = 0
    end

    if self.new_red.nil?
        self.new_red = 0
    end
    
    # updated 8/23/2021
    @vfRedPrices = [3588, 1973.40, 1794, 1435.20, 1255.80, 1076.40]
    @smrPrices = [422, 232.10, 211, 168.80, 147.70, 126.60]
    @vfNonRedPrices = [2532, 1392.60, 1266, 1012.80, 886.20, 759.60] #ThinManager V-FLEX Perpetual Licensing - 8x5 Software Maintenance


    # subscription pricing arrays
    if self.sub_exchange
        @vfRedPrices = [412, 226.60, 206, 164.80, 144.20, 123.60]
        @vfNonRedPrices = [410, 225.50, 205, 164, 143.50, 123]
        # for new on sub exchange
        @vfNewSimpSubPrices = [844, 464.20, 422, 337.60, 295.40, 253.20]
        @vfNewRedSubPrices = [1077, 592.35, 538.50, 430.80, 376.95, 323.10]
    end



    if self.sm_exp == nil
        self.sm_exp = Date.today() + 1.year
    end

    self.tr_simp = self.ex_simp_sup + self.ex_simp_nosup #15 Add Redundant trade from Simple?
    self.tr_red = self.ex_red_sup + self.ex_red_nosup #16 Add Redundant trade from Simple?
    @existingSimp = self.tr_simp
    @existingRed = self.tr_red
    @simpToRed = self.tr_red + self.tr_simp

    

    if self.red_exchange
        self.tr_red = @simpToRed
        self.tr_simp = 0
    end

    self.total_terms = self.tr_serv + self.tr_site + self.tr_simp + self.tr_red + self.new_simp + self.new_red #19

    #Ranges
    @currentRange = self.findRange(self.total_terms)
    @tradePackRange = self.findRange(@existingSimp)
    @tradeRPackRange = self.findRange(@existingRed)
    @originalRPackRange = self.findRange(@existingRed)

    if self.red_exchange
        @tradeRPackRange = self.findRange(@existingSimp + @existingRed)
    end

    #Prices
    @simplexPricePer = @vfNonRedPrices[@currentRange] * self.currency.rate
    @redundPricePer = @vfRedPrices[@currentRange] * self.currency.rate
    @tradeSimplexPricePer = @vfNonRedPrices[@tradePackRange] * self.currency.rate
    @tradeRedPricePer = @vfRedPrices[@tradeRPackRange] * self.currency.rate
    @tradeCredRedPricePer = @vfRedPrices[@originalRPackRange] * self.currency.rate
    if self.sub_exchange
        @newSubSimpPricePer = @vfNewSimpSubPrices[@currentRange] * self.currency.rate
        @newRedSubPricePer =  @vfNewRedSubPrices[@currentRange] * self.currency.rate
    end


    #subscription exchange prices with new pricing table
    if self.sub_exchange

        # @tradeSimplexPricePer = 0 * self.currency.rate
        # @tradeRedPricePer = 0 * self.currency.rate
        # @tradeCredRedPricePer = 0 * self.currency.rate 
    end
    

    #Trade up pricing
    self.tr_pr_serv = (633 * self.currency.rate) * self.tr_serv #20
    self.tr_pr_site = (633 * self.currency.rate) * self.tr_site #21
    

    if self.sub_exchange
        self.tr_pr_serv = @redundPricePer * self.tr_serv
        self.tr_pr_site = @redundPricePer * self.tr_site
    end
    

    self.new_pr_simp = @simplexPricePer * self.new_simp #24
    self.new_pr_red = @redundPricePer * self.new_red #25
    self.tr_pr_simp = @tradeSimplexPricePer * self.tr_simp #22
    if self.red_exchange
        self.tr_pr_red = (@tradeCredRedPricePer * @existingRed) + (@tradeSimplexPricePer * @existingSimp)
    else 
        self.tr_pr_red = @tradeRedPricePer * self.tr_red
    end

    

    #############################################
    if self.sub_exchange
        if !self.red_exchange
            self.tr_pr_simp = @simplexPricePer * self.tr_simp
            self.tr_pr_red = @redundPricePer * self.tr_red
            self.new_pr_simp = @newSubSimpPricePer * self.new_simp #24
            self.new_pr_red = @newRedSubPricePer * self.new_red #25
        else
            #prices for redundant exchange with Subscription Exchange
            self.tr_pr_simp = @redundPricePer * self.tr_simp
            self.tr_pr_red = @redundPricePer * self.tr_red
            self.new_pr_simp = @newRedSubPricePer * self.new_simp #24
            self.new_pr_red = @newRedSubPricePer * self.new_red #25
        end
    end
    ##############################################


    if self.sub_exchange
        if self.red_exchange
            self.new_pr_red = self.new_pr_simp + self.new_pr_red
            self.new_pr_simp = 0
        end
    end


    self.tr_pr_total = self.tr_pr_serv + self.tr_pr_site + self.tr_pr_simp + self.tr_pr_red + self.new_pr_simp + self.new_pr_red #26

    #Credits
    ## Server
    @creditForServerLicensesWithSupport = 61150 * self.ex_serv_sup * self.currency.rate
    @creditForServerLicensesNoSupport = (1-(0.2*self.ex_serv_nosup_years))*(self.ex_serv_nosup*61150 * self.currency.rate)
    if @creditForServerLicensesNoSupport < 0 
        @creditForServerLicensesNoSupport = 0
    end
    self.tr_cred_serv = @creditForServerLicensesWithSupport + @creditForServerLicensesNoSupport
    if self.tr_cred_serv < 0
        self.tr_cred_serv = 0
    end
    if self.tr_cred_serv > self.tr_pr_serv 
        self.tr_cred_serv = self.tr_pr_serv 
    end

    ## Site
    @creditForSiteLicensesWithSupport = 134000 * self.ex_site_sup * self.currency.rate
    @creditForSiteLicensesNoSupport = (1-(0.2*self.ex_site_nosup_years))*(self.ex_site_nosup*134000 * self.currency.rate)
    if @creditForSiteLicensesNoSupport < 0 
        @creditForSiteLicensesNoSupport = 0
    end
    self.tr_cred_site = @creditForSiteLicensesWithSupport + @creditForSiteLicensesNoSupport
    if self.tr_cred_site < 0
        self.tr_cred_site = 0
    end
    if self.tr_cred_site > self.tr_pr_site 
        self.tr_cred_site = self.tr_pr_site 
    end

    ## Simplex
    @creditForPackLicensesWithSupport = self.ex_simp_sup * @tradeSimplexPricePer
    @creditForPackLicensesNoSupport = (1-(0.2*self.ex_simp_nosup_years))*(self.ex_simp_nosup*@tradeSimplexPricePer)
    if @creditForPackLicensesNoSupport < 0
        @creditForPackLicensesNoSupport = 0
    end
    self.tr_cred_simp = @creditForPackLicensesWithSupport + @creditForPackLicensesNoSupport #No negative
    @trCreditSimp = self.tr_cred_simp
    
    if self.tr_cred_simp < 0
        self.tr_cred_simp = 0
    end

    if self.tr_cred_simp > self.tr_pr_simp
        self.tr_cred_simp = self.tr_pr_simp
    end

    if self.red_exchange
        self.tr_cred_simp = @trCreditSimp
    end

    ## Redundant
    @creditForRPackLicensesWithSupport = self.ex_red_sup * @tradeCredRedPricePer
    @creditForRPackLicensesNoSupport = (1-(0.2*self.ex_red_nosup_years))*(self.ex_red_nosup*@tradeCredRedPricePer)
    if @creditForRPackLicensesNoSupport < 0
        @creditForRPackLicensesNoSupport = 0
    end
    self.tr_cred_red = @creditForRPackLicensesWithSupport + @creditForRPackLicensesNoSupport  #No negative
    

    if self.tr_cred_red < 0
        self.tr_cred_red = 0
    end

    if self.tr_cred_red > self.tr_pr_red
        self.tr_cred_red = self.tr_pr_red
    end



    self.tr_cred_total = self.tr_cred_serv + self.tr_cred_site + self.tr_cred_simp + self.tr_cred_red;
    if self.tr_cred_total < 0
       self.tr_cred_total = 0
    end

    self.total_tr_cost = self.tr_pr_total - self.tr_cred_total


    if self.red_exchange 
        if self.total_tr_cost < 0
            self.total_tr_cost = (@redundPricePer - @simplexPricePer) * @existingSimp
        else
           self.total_tr_cost = self.total_tr_cost + ((@redundPricePer - @simplexPricePer) * @existingSimp) 
        end
    end



    @termsForSM = self.tr_serv + self.tr_site + self.tr_simp + self.tr_red
    @smrange = findRange(@termsForSM)
    @smPricePer = @smrPrices[@currentRange] * self.currency.rate #This is the total term range
    self.total_maint = @smPricePer * @termsForSM

    


    if self.sub_exchange
        #zero credits
        self.tr_cred_serv = 0
        self.tr_cred_site = 0
        self.tr_cred_simp = 0
        self.tr_cred_red = 0
        # self.new_pr_simp = 0
        # self.new_pr_red = 0

        @smPricePer = @smrPrices[@currentRange] * self.currency.rate #This is the total term range
        #self.total_maint = @smPricePer * @termsForSM
        self.total_tr_cost = 0
        self.total_maint = self.new_pr_simp + self.new_pr_red + self.tr_pr_serv + self.tr_pr_site + self.tr_pr_simp + self.tr_pr_red
    end

    self.total_quote = self.total_tr_cost + self.total_maint

end


end