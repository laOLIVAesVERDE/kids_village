class PostMailer < ApplicationMailer

  def create_post(kid, content)
    @kid = kid
    @content = content

    mail to: @kid.email, subject: '日記を書きました!'
  end
  
end
