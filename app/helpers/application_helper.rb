module ApplicationHelper

    def format_price
      sprintf('%.2f', (self.price))
    end

end
