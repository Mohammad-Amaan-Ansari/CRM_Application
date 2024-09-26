# frozen_string_literal: true

# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      admin_permissions
    elsif user.salesperson?
      salesperson_permissions
    elsif user.customer?
      customer_permissions(user)
    else
      guest_permissions
    end
  end

  private

  def admin_permissions
    can :manage, :all # Admins can manage everything
  end

  def salesperson_permissions
    can :read, Product
    can :manage, Order
    can :read, Category
    can :all_products, Product
  end

  def customer_permissions(user)
    can :read, Product
    can :read, Category
    can :all_products, Product
    can :create, Order
    can :read, Order, user_id: user.id # Customers can only see their own orders
    cannot %i[create update], [Product, Category]
  end

  def guest_permissions
    can :read, Product
    can :read, Category
  end
end
