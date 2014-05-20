module Voting
  extend ActiveSupport::Concern

  # public instance methods ...................................................
  def add_liked
    likes_count + 1
  end

  def add_disliked
    unlikes_count + 1
  end

  def liked
    update_column(:likes_count, add_liked)
  end

  def disliked
    update_column(:unlikes_count, add_disliked)
  end
end
