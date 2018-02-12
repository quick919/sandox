require 'sequel'

DB = Sequel.connect('sqlite://db/journal.db')
class Tag < Sequel::Model(:tag)
  many_to_many :article, left_key: :tag_id, right_key: :article_id,
  join_table: :article_tags
end