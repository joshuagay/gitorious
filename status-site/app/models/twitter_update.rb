class TwitterUpdate
  attr_reader :status
  def initialize(status)
    @status = status
  end

  def message
    result = ""
    result << case status.status
              when Status::OK
                "[UP] "
              when Status::SORTA
                "[SOME ISSUES] "
              when Status::DOWN
                "[DOWN] "
              else
                ""
              end
    result << "#{status.title}"
    body =  status.body.blank? ? "" : ": #{status.body}" 
    remaining = (140 - result.size)
    if status.sorta?
      result << " Read more on http://status.gitorious.org/"
    else
      result << body unless body.size > remaining
    end
    result
  end

  def self.update
    required_keys = ["TWITTER_OAUTH_KEY","TWITTER_OAUTH_SECRET","TWITTER_CONSUMER_KEY","TWITTER_CONSUMER_SECRET"]
    if required_keys.all?{|key| ENV.has_key?(key)}
      yield
    end
  end
end
