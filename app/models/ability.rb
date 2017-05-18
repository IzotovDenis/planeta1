class Ability
  include CanCan::Ability
  

    def initialize(user)
    @user = user || User.new # for guest
    puts (@user.inspect)
    if @user.id == nil
      can :read, Item #for guest without roles
      can :view_price, Item
    else
      send(@user.role)
    end

  end

  def buyer
    user
    can :view, :qty
    can :create, Order
    can :add_items, Order do |order|
      order.user_id == @user.id
    end
    can :manage, Order do |order|
      order.user_id == @user.id
    end
  end

  def user
    can :read, Item
    can :read, Order do |order|
      order.user_id == @user.id
    end
    cannot :manage, User
    can [:show, :update], User do |current_user|
      current_user.id == @user.id
    end
  end
  
  def retail
    buyer
    cannot :set, :discount
  end 

  def manager
    superbuyer
  end

  def admin
    can :manage, :all
  end

  def dev
    admin
  end
end
