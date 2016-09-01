class InvitationsMailer < ApplicationMailer
  def change_password(user)
    @user = user
    @url = edit_user_password_url(user, reset_password_token: user.reset_password_token)

    mail(to: user.email, subject: "You've been invited to the Unaccompanied Children Dashboard")
  end
end
