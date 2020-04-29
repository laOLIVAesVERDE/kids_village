class KidMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.kid_mailer.back_from_school.subject
  #
  def back_from_school(kid)
    @kid = kid
    @facility = @kid.facility
    mail to: kid.email, subject: '学校から戻りました!'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.kid_mailer.finish_homework.subject
  #
  def finish_homework(kid)
    @kid = kid
    @facility = @kid.facility
    mail to: kid.email, subject: '宿題が終わりました!'
  end
end
