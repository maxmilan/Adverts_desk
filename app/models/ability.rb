class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      admin_ability user
    elsif user.user?
      user_ability user
    else
      guest_ability
    end
  end

  def admin_ability user
    user_ability user
    can :read, :admin_panel
    can [:accept, :reject, :reject_reason], Advert
    can :create, Category
    can :destroy, Category do |category|
      category.adverts.empty?
    end
    can :manage, User

    cannot :read, :profile
    cannot [:edit, :create, :update, :new], Advert
  end

  def user_ability user
    can :read, :all
    can [:create], Advert
    can :update, User do |u|
      u == user
    end
    can [:update, :destroy, :edit, :publicate, :archivate], Advert do |advert|
      advert.try(:user) == user
    end
    can :search, Advert

    cannot :read, :admin_panel
  end

  def guest_ability
    can :index, Advert
  end
end
