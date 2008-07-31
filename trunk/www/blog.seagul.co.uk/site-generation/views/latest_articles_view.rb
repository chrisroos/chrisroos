class LatestArticlesView
  def initialize(latest_articles)
    @latest_articles = latest_articles
  end
  def path
    "/"
  end
  def url
    File.join(path, 'index')
  end
  def articles
    @latest_articles
  end
  def page_title
    "Most recent posts"
  end
  def robots_meta_tag
  end
  public :binding
end
