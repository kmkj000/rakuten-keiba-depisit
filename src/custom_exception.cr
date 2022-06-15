class SiteErrorException < Exception
  def initialize()
    @message = "Occured error by rakuten keiba site."
  end
end
