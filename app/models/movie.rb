class Movie < ActiveRecord::Base
  # Returns an array containing allowed  values for ratings
  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end



before_validation :capitalize_title 

# Validate model fields
  validates :title, :uniqueness => {:case_sensitive => false}
  validates :title, length: {minimum: 3}, allow_blank: true 
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?


def capitalize_title 
self.title = self.title.split(/\s+/).map(&:downcase).
map(&:capitalize).join(' ')
  end


# Check that release date is greater than Jan 1, 1930.
# Set error if otherwise.
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      release_date && release_date < Date.parse('1 Jan 1930')
  end

  # The rating system did not go into effect until Nov 1, 1968.
  # Therefore, ignore ratings validation for movies released
  # prior to this.
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered?
    release_date && release_date >= @@grandfathered_date
  end
end
