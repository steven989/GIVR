Monologue.config do |config|
  config.site_name = "Givingly blog"
  config.site_subtitle = "The official Givingly blog"
  config.site_url = "http://givingly.me"

  config.meta_description = "This is the official blog for Givingly"
  config.meta_keyword = "volunteering, pro bono, volunteer toronto"

  config.admin_force_ssl = false
  config.posts_per_page = 5

  config.disqus_shortname = "givinglyblog"

  # LOCALE
  config.twitter_locale = "en" # "fr"
  config.facebook_like_locale = "en_CA" # "fr_CA"
  config.google_plusone_locale = "en"

  # config.layout               = "layouts/application"

  # ANALYTICS
  # config.gauge_analytics_site_id = "YOUR COGE FROM GAUG.ES"
  # config.google_analytics_id = "YOUR GA CODE"

  config.sidebar = ["latest_posts", "latest_tweets", "categories", "tag_cloud"]

  #SOCIAL
  # config.twitter_username = "jipiboily"
  # config.facebook_url = "https://www.facebook.com/jipiboily"
  # config.facebook_logo = 'logo.png'
  # config.google_plus_account_url = "https://plus.google.com/u/1/115273180419164295760/posts"
  # config.linkedin_url = "http://www.linkedin.com/in/jipiboily"
  # config.github_username = "jipiboily"
  # config.show_rss_icon = true

end