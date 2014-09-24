class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
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
    can [:accept, :reject], Advert
    can :create, Category
    can :destroy, Category do |category|
      category.adverts.empty?
    end
    can :manage, User

    cannot [:edit, :create], Advert
  end

  def user_ability user
    can :read, :all
    can [:create], Advert
    can :update, User do |u|
      u == user
    end
    can :read, User do |u|
      u == user
    end
    can :update, Advert do |advert|
      advert.try(:user) == user
    end
    can :destroy, Advert do |advert|
      advert.try(:user) == user
    end
    can :publicate, Advert do |advert|
      advert.try(:user) == user
    end
    can :archivate, Advert do |advert|
      advert.try(:user) == user
    end

    cannot :read, :admin_panel
  end

  def guest_ability
    can :index, Advert
  end
end
