class EmailBlacklistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    domain = value.to_s.downcase.split('@').last.strip
    if EMAIL_DOMAIN_BLACKLIST.include?(domain)
      record.errors[attribute] << (options[:message] || "blacklisted")
    end

    EMAIL_WORD_BLACKLIST.each do |word|
      if value.include?(word)
        record.errors[attribute] << (options[:message] || "blacklisted")
      end
    end
  end
end
