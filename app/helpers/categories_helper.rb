module CategoriesHelper
  def all_available_categories
    Category.select(:cat_sub).distinct.pluck(:cat_sub).map do |cat_sub|
      case cat_sub
      when 'expenses'
        %w[Despesas expenses]
      when 'incomes'
        %w[Receitas incomes]
      end
    end
  end

  def all_available_icons
    %w[
      fa-ambulance
      fa-baby-carriage
      fa-balance-scale
      fa-birthday-cake
      fa-book
      fa-briefcase
      fa-bus
      fa-car
      fa-child
      fa-coffee
      fa-credit-card
      fa-cutlery
      fa-diamond
      fa-graduation-cap
      fa-home
      fa-hospital
      fa-money
      fa-plane
      fa-shopping-cart
      fa-subway
      fa-taxi
      fa-train
      fa-university
      fa-user-md
      fa-users
      fa-wrench
      fa-gamepad
    ]
  end

end
