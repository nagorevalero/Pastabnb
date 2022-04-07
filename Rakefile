namespace :db do
  desc "It'll run migration"
  task :migration do
    system("psql -h 127.0.0.1 -d pastabnb -f ./lib/migrations/00_create_tables.sql")
  end
end