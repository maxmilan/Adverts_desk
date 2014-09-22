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
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  def admin_ability user
    user_ability user
    can :create, Category
    can :destroy, Category do |t|
      t.adverts.empty?
    end
    can :manage, User

    cannot [:edit, :create], Advert
  end

  def user_ability user
    can :read, :all
    can :create, Advert
    can :publicate, Advert
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
  end

  def guest_ability
    can :index, Advert
  end
end
