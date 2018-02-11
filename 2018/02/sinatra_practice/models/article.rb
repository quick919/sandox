require 'sequel'

DB = Sequel.connect('sqlite://db/journal.db')
class Article < Sequel::Model(:article)
  dataset_module do
    def fetch_articles(per_page, page)
      offset = per_page * (page - 1)
      select().
      order(Sequel.desc(:update_date)).
      limit(per_page, offset).
      all
    end

    def fetch_number_of_pages(per_page)
      select().count / per_page
    end
  end
end