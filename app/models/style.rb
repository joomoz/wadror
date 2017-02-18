class Style < ActiveRecord::Base
  has_many :beers

  def to_s
    "#{name}"
  end

  def formatted_content
    if description.split.size > 10
      description.split.take(10).join(" ") + "..."
    else
      description
    end
  end

end
