require 'sequel'

namespace :db_migrate_task do
  desc "create db task!!"

  task :create_db do
    unless FileTest.exist?('db')
      Dir::mkdir('db')
    end
    DB = Sequel.sqlite('db/article.db',{})
    unless DB.table_exists?(:items)  
      DB.create_table :items do
        unrestrict_primary_key :id
        String :text
        DateTime :create_date
        DateTime :update_date
      end
    end

    unless DB.table_exists?(:tag)  
      DB.create_table :tag do
        primary_key :id
        String :name
      end
    end

    puts 'create db!!'
  end
end