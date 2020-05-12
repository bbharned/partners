class Flexforward < ApplicationRecord
	belongs_to :user
	belongs_to :currency
	before_save :calcs
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

# Flex Forward Calculations
def calcs

    @vfRedPrices = [3400, 1870, 1700, 1360, 1190, 1020]
    @smrPrices = [400, 220, 200, 160, 140, 120]
    @vfNonRedPrices = [2400, 1320, 1200, 960, 840, 720]

    self.sm_exp = self.sm_exp.strftime("%m/%d/%Y")

    self.tr_simp = self.ex_simp_sup + self.ex_simp_nosup #15
    self.tr_red = self.ex_red_sup + self.ex_red_nosup #16

    self.total_terms = self.tr_serv + self.tr_site + self.tr_simp + self.tr_red + self.new_simp + self.new_red #19

    #Ranges
    @currentRange = self.findRange(self.total_terms)
    @tradePackRange = self.findRange(self.tr_simp)
    @tradeRPackRange = self.findRange(self.tr_red)

    #Prices
    @simplexPricePer = @vfNonRedPrices[@currentRange] * self.currency.rate
    @redundPricePer = @vfRedPrices[@currentRange] * self.currency.rate
    @tradeSimplexPricePer = @vfNonRedPrices[@tradePackRange] * self.currency.rate
    @tradeRedPricePer = @vfRedPrices[@tradeRPackRange] * self.currency.rate

    #Trade up pricing
    self.tr_pr_serv = (600 * self.currency.rate) * self.tr_serv #20
    self.tr_pr_site = (600 * self.currency.rate) * self.tr_site #21
    self.new_pr_simp = @simplexPricePer * self.new_simp #24
    self.new_pr_red = @redundPricePer * self.new_red #25
    self.tr_pr_simp = @tradeSimplexPricePer * self.tr_simp #22
    self.tr_pr_red = @tradeRedPricePer * self.tr_red #23
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
    if self.tr_cred_simp < 0
        self.tr_cred_simp = 0
    end

    if self.tr_cred_simp > self.tr_pr_simp
        self.tr_cred_simp = self.tr_pr_simp
    end

    ## Redundant
    @creditForRPackLicensesWithSupport = self.ex_red_sup * @tradeRedPricePer
    @creditForRPackLicensesNoSupport = (1-(0.2*self.ex_red_nosup_years))*(self.ex_red_nosup*@tradeRedPricePer)
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

    @termsForSM = self.tr_serv + self.tr_site + self.tr_simp + self.tr_red
    @smrange = findRange(@termsForSM)
    @smPricePer = @smrPrices[@currentRange] * self.currency.rate #This is the total term range
    self.total_maint = @smPricePer * @termsForSM

    self.total_quote = self.total_tr_cost + self.total_maint


end


end