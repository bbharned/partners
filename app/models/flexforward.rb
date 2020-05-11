class Flexforward < ApplicationRecord
	belongs_to :user
	belongs_to :currency
	before_save :calcs





def findRange(terminalCount)

    if terminalCount == 0..5 
        terminalRange = 0
    elsif terminalCount >= 5 && terminalCount < 50 
        terminalRange = 1
    elsif terminalCount >= 50 && terminalCount < 100
        terminalRange = 2
    elsif terminalCount >= 100 && terminalCount < 250
        terminalCount = 3
    elsif terminalCount >= 250 && terminalCount < 500
        terminalRange = 4
    elsif terminalCount >= 500
        terminalRange = 5  
    end

    return terminalRange

end








private

# Flex Forward Calculations
def calcs
    
    vfRedPrices = [3400, 1870, 1700, 1360, 1190, 1020]
    smrPrices = [400, 220, 200, 160, 140, 120]
    vfNonRedPrices = [2400, 1320, 1200, 960, 840, 720]

    self.tr_simp = self.ex_simp_sup + self.ex_simp_nosup
    self.tr_red = self.ex_red_sup + self.ex_red_nosup

    self.tr_pr_serv = (600 * self.currency.rate) * self.tr_serv
    self.tr_pr_site = (600 * self.currency.rate) * self.tr_site

    self.total_terms = self.tr_serv + self.tr_site + self.tr_simp + self.tr_red + self.new_simp + self.new_red

    #Ranges
    currentRange = findRange(self.total_terms)
    tradePackRange = findRange(self.tr_simp)
    tradeRPackRange = findRange(self.tr_red);



end


end