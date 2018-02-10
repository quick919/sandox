require 'sequel'

namespace :db_migrate_task do
  desc "create db task!!"

  task :create_db do
    unless FileTest.exist?('db')
      Dir::mkdir('db')
    end
    DB = Sequel.sqlite('db/journal.db',{})
    unless DB.table_exists?(:article)  
      DB.create_table :article do
        primary_key :article_id
        String :text
        DateTime :create_date
        DateTime :update_date
      end
    end

    unless DB.table_exists?(:tag)  
      DB.create_table :tag do
        primary_key :tag_id
        String :name
      end
    end

    unless DB.table_exists?(:article_tags)  
      DB.create_table :article_tags do
        foreign_key :article_id, :article
        foreign_key :tag_id, :tag
      end

      DB.alter_table(:article_tags) do
        add_primary_key [:article_id, :tag_id]
      end
    end

    puts 'create db!!'
  end
end