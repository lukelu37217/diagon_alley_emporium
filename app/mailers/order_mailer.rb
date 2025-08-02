class OrderMailer < ApplicationMailer
  default from: 'orders@diagonalley.com'

  def order_confirmation(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'Order Confirmation - Diagon Alley Emporium')
  end

  def order_shipped(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'Your Order Has Shipped!')
  end

  def order_delivered(order)
    @order = order
    @user = order.user
    mail(to: @user.email, subject: 'Order Delivered Successfully')
  end
end
