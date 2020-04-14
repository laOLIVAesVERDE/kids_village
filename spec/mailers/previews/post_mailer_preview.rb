# Preview all emails at http://localhost:3000/rails/mailers/post_mailer
class PostMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/post_mailer/create_post
  def create_post
    post = Post.first
    kid = Kid.first
    PostMailer.create_post(kid, post.content)
  end

end
