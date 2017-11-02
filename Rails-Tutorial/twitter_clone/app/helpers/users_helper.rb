module UsersHelper

  # returns the gravatar for a given user
  def gravatar_for(user, size = '60')
    # gravatar's are based on the MD5 hash of a users email
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", width: size)
  end
end
