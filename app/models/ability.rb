# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    # can :read, :all
    #**dont delete
      # User.first.user_role_permissions.includes(:role,:permission).pluck(:role_name,:permission_name) ** dont delete it is a query for getiing the associated name from rails console(not so important just i found it like a raw query)
    #**dont delete
    user_roles = user.roles.pluck(:slug).uniq
    user_permissions = user.permissions.pluck(:permission_slug).uniq
    user_roles.each do |test|
      case test
      when 'admin'
        can :manage, :all
      when 'manager'
        can :read, Post if user_permissions.include?('read-post')
        can :update, Post if user_permissions.include?('approve-post')
      when 'content-manager'
        can :read, Post if user_permissions.include?('read-post')
        can :destroy, Post if user_permissions.include?('delete-post')
      when 'employee'
        can :read, Post if user_permissions.include?('read-post')
        can :create, Post if user_permissions.include?('add-post')
        can :update, Post if user_permissions.include?('edit-post')
        can :destroy, Post if user_permissions.include?('delete-post')
      when 'hr-manager'
        can :read, User if user_permissions.include?('read-employee-profile')
        can :update, User if user_permissions.include?('approve-employee')
      when 'executive'
        can :read, User if user_permissions.include?('read-employee-profile')
        can :create, User if user_permissions.include?('add-new-employee')
      when 'junior-executive'
        can :read, User if user_permissions.include?('read-employee-profile')
        can :update, User if user_permissions.include?('edit-employee-profile')
        can :destroy, User if user_permissions.include?('delete-employee-profile')
      end
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
end
