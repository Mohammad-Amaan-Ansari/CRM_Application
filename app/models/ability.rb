# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all # Admins can manage everything
    elsif user.salesperson?
      can :read, Product
      can :manage, Order
      can :read, Category

      can :all_products, Product
    elsif user.customer?
      # Customers can read Products and Categories
      can :read, Product
      can :read, Category

      # Grant access to the all_products action
      can :all_products, Product

      # Customers can create and read their own orders only
      can :create, Order
      can :read, Order, user_id: user.id # Customers can only see their own orders

      # Customers cannot create or update Products and Categories
      cannot :create, Product
      cannot :create, Category
      cannot :update, Product
      cannot :update, Category
    else
      # Guests can only read Products and Categories
      can :read, Product
      can :read, Category
    end
  end
end
