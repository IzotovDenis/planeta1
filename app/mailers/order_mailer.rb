class OrderMailer < ActionMailer::Base
  default from: "order@planeta-avtodv.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_from.subject
  #
  def order_from(order)
    @order = Order.find(order)
    @order_items = @order.show_list['items']
    @email = Rails.env.development? ? "izotov87@gmail.com" : "info@planeta-avtodv.ru"
    mail to: @email, :reply_to => @order.user.email, subject: "#{t(:order_mail_title)} #{@order.id} #{@order.user.name}"
  end
end
