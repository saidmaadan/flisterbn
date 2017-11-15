class ReservationMailer < ApplicationMailer
  def send_email_to_guest(guest, listing)
    @recipient = guest
    @listing = listing
    mail(to: @recipient.email, subject: "Enjoy You Trip! 😘 💋")
  end
end
