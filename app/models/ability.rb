class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # Guest user
    can :create, Account
    can :signup, User   
    if user.role == 'site_admin'
      can :manage, :all
    elsif user.role == 'administrator'
      can [:show, :change_settings], Account
      can :manage, User
      can :manage, Confidence
      can :manage, Status
      can :manage, Customer
      # can :manage, Opportunity
      # can :manage, AccountTarget
    elsif user.role == 'salesman'
      can :show, Account
      can [:index, :show, :change_profile], User
      can :read, Confidence
      can :read, Status
      can :manage, Customer
      # can :manage, Opportunity
    elsif user.role == 'associate'
      can :read, :all
    end
  end
end