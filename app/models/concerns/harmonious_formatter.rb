module HarmoniousFormatter
  extend ActiveSupport::Concern

  def body
    if self.attributes.include?("body")
      content = self[:body].strip.downcase
      ban_words = (Setting.find_by_name("ban_words").value || "").split("\n")
      # Notice: incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string)
      # force_encoding("UTF-8") can be fixd this error.
      ban_words.each { |word| content.force_encoding("UTF-8").gsub!(word.strip.downcase, "**") }
      content
    else
      raise NoMethodError.new("undefined method `body' for #{self}")
    end
  end

  def nickname
    if self.attributes.include?("nickname")
      content = self[:nickname]
      #从数据库中去除和谐关键字， 2小时更新一次
      reg = Rails.cache.fetch("nickname_key_word_harmonious", expires_in: 2.hours) do
        keyword = Setting.find_by_name("nickname_key_word_harmonious").try(:value)
        Regexp.new(keyword) if keyword
      end

      content.force_encoding("UTF-8").gsub!(reg, '*') if content && reg
      content
    else
      raise NoMethodError.new("undefined method `nickname' for #{self}")
    end
  end
end
