# Hooks
require_dependency 'centos/rating/hooks/issue'
require_dependency 'centos/rating/hooks/user'

# Patches
require 'centos/rating/patches/user'
require 'centos/rating/patches/issue'
require 'centos/rating/patches/project'

Redmine::Plugin.register :redmine_centosadmin_rating do
  name 'Redmine Centosadmin Rating plugin'
  author 'Kernel Wed Studio'
  description 'Redmine Centosadmin Rating plugin'
  version '0.0.1'
  url 'https://github.com/olemskoi/redmine_centosadmin_rating'
  author_url 'http://centos-admin.ru/'
 
  project_module :centosadmin_rating do
    permission :centos_rate, { ratings: [:new, :create, :show, :update, :edit, :destroy] }
    permission :centos_be_rated, {}
    permission :view_ratings, { ratings: [:index, :show] }
  end

  Redmine::Activity.map do |activity|
    activity.register :ratings
  end

  menu :project_menu, :ratings, { controller: 'ratings', action: 'index' }, caption: :rating, param: :project_id
end
