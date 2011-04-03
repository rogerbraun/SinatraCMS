class Page
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String
  property :localized_title, String
  property :language, String
  property :body, Text
  property :position, Integer, :default => 0
  property :footer, Boolean
  property :root, Boolean

  has n, :pages
  belongs_to :page, :required => false

  before :create, :setposition

  def setposition
    unless Page.all.count == 1 
      self.position = Page.all.max_by(&:position).position + 1
      puts self.position
    end
    self.save
  end
end
