require 'snail/constants'

class Snail
  include Configurable
  
  # this will be raised whenever formatting or validation is run on an unsupported or unknown country
  class UnknownCountryError < ArgumentError; end
  
  # My made-up standard fields.
  attr_accessor :name
  attr_accessor :line_1
  attr_accessor :line_2
  attr_accessor :city
  attr_accessor :region
  attr_accessor :postal_code
  attr_accessor :country
  
  # Aliases for easier assignment compatibility
  {
    :full_name  => :name,
    :street     => :line_1,
    :town       => :city,
    :state      => :region,
    :province   => :region,
    :zip        => :postal_code,
    :zip_code   => :postal_code,
    :postcode   => :postal_code
  }.each do |new, existing|
    alias_method "#{new}=", "#{existing}="
  end
  
  def to_s
    [name, line_1, line_2, city_line, country_line].select{|line| !(line.nil? or line.empty?)}.join("\n")
  end
  
  def to_html 
    "<address>#{to_s.gsub("\n", '<br />')}</address>"
  end
  
  # this method will get much larger. completeness is out of my scope at this time.
  # currently it's based on the sampling of city line formats from frank's compulsive guide.
  def city_line
    case country
    when 'China', 'India'
      "#{city}, #{region}  #{postal_code}"
    when 'Brazil'
      "#{postal_code} #{city}-#{region}"
    when 'Mexico'
      "#{postal_code} #{city}, #{region}"
    when 'Italy'
      "#{postal_code} #{city} (#{region})"
    when 'USA', 'Canada', 'Australia', nil, ""
      "#{city} #{region}  #{postal_code}"
    when 'Israel', 'Denmark', 'Finland', 'France', 'Germany', 'Greece', 'Italy', 'Norway', 'Spain', 'Sweden'
      "#{postal_code} #{city}"
    when 'Ireland'
      "#{city}, #{region}"
    when 'England', 'Scotland', 'Wales', 'United Kingdom', 'Russia', 'Ukraine'
      "#{city}  #{postal_code}" # Locally these may be on separate lines. The USPS prefers the city line above the country line, though.
    when 'Ecuador'
      "#{postal_code} #{city}"
    when 'Hong Kong', 'Syria', 'Iraq'
      "#{city}"
    else
      raise UnknownCountryError, "unknown country: #{country}"
    end
  end
  
  def country_line
    country == 'USA' ? nil : country.upcase
  end
end