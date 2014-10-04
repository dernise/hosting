class SupportController < ApplicationController
  before_action :authorize
  def show
    @ticket = Ticket.new
  end

  def delete_ticket
    ticket = Ticket.find(params[:id].to_i)
    if (ticket && ticket.user_id == current_user.id)
      ticket.resolved = true
      ticket.save!
    end
    redirect_to support_path
  end
end
