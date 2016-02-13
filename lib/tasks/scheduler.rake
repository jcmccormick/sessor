# desc "This task is called by the Heroku scheduler add-on and will destroy tokens based on Devise Token Auth's token lifespan, default: 2 weeks"
# task :destroy_old_sessions => :environment do
#     ActiveRecord::SessionStore::Session.delete_all(["updated_at < ?", DeviseTokenAuth.token_lifespan.ago])
# end