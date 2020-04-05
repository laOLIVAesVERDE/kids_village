# Preview all emails at http://localhost:3000/rails/mailers/kid_mailer
class KidMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/kid_mailer/back_from_school
  def back_from_school
    kid = Kid.first
    KidMailer.back_from_school(kid)
  end

  # Preview this email at http://localhost:3000/rails/mailers/kid_mailer/finish_homework
  def finish_homework
    kid = Kid.first
    KidMailer.finish_homework(kid)
  end

end
