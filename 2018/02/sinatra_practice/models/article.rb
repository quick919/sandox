require 'sequel'

DB = Sequel.connect('sqlite://db/journal.db')
class Article < Sequel::Model(:article)
  many_to_many :tag, left_key: :article_id, right_key: :tag_id,
    join_table: :article_tags

  dataset_module do
    def fetch_articles(per_page, page, searchText = nil)
      offset = per_page * (page - 1)
      if searchText.nil?
        select().
        order(Sequel.desc(:update_date)).
        limit(per_page, offset).
        all
      else
        select().
        where(Sequel.lit('text LIKE ?', '%'+ searchText +'%')).
        order(Sequel.desc(:update_date)).
        limit(per_page, offset).
        all
      end
    end

    def fetch_number_of_pages(per_page)
      select().count / per_page
    end

    def fetch_search_articles_count(per_page, page, searchText)
      offset = per_page * (page - 1)
      select()
      where(Sequel.lit('text LIKE ?', '%'+ searchText +'%')).
      order(Sequel.desc(:update_date)).
      limit(per_page, offset).
      count / per_page
    end
  end
end