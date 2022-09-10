# To deliver this notification:
#
# ItemNotification.with(post: @post).deliver_later(current_user)
# ItemNotification.with(post: @post).deliver(current_user)

class ItemNotification < Noticed::Base
  # Add your delivery methods
  #
  # deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"
  deliver_by :twilio, format: :format_for_twilio

  def format_for_twilio
    {
      Body: params[:message],
      From: Rails.application.credentials.twilio[:phone_number],
      To: recipient.number
    }
  end

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
