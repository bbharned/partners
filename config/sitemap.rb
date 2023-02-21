# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://partners.thinmanager.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end


  add '/', :changefreq => 'weekly', :priority => 1
  add '/dashboard', :changefreq => 'weekly', :priority => 0.9
  add '/pricing', :changefreq => 'monthly'
  add '/learning'
  add '/reports'
  add '/users'
  add '/flexforwards'
  add '/labs'
  add '/documents', :changefreq => 'weekly', :priority => 0.9
  add '/vflex'
  add '/pinpoint'
  add '/downloads'
  add '/calculators'
  add '/flex'
  add '/mycert'
  add '/si'
  add '/rau'
  add '/learn'
  add '/qrcodes', :changefreq => 'monthly', :priority => 0.8
  add '/hardwares', :changefreq => 'weekly', :priority => 0.9
  add '/terminals', :changefreq => 'weekly', :priority => 0.9
  add '/events', :changefreq => 'weekly', :priority => 0.9
  add '/companies'
  add '/listings', :changefreq => 'weekly', :priority => 0.9
  add '/features', :changefreq => 'weekly', :priority => 0.9
  add '/demokits'
  add '/tmc'
  add '/quizzes'


end
