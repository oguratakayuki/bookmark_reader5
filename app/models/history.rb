class History < ActiveRecord::Base
  attr_accessor :file
  has_many :bookmarks, inverse_of: :history
  has_many :folders, inverse_of: :history
  attachment :file
  def max_nest
    folders.map{|t| t.folders.count}.uniq.max
  end

  def count_by_layer
    f_arr = []
    f_arr = folders.select('layer, count(*) as count').group(:layer).inject([]){|arr, k| arr[k.layer] = k.count; arr    }
    f_arr = bookmarks.select('layer, count(*) as count').group(:layer).map do |bookmark|
      f_arr[bookmark.layer] ? f_arr[bookmark.layer] = f_arr[bookmark.layer] + bookmark.count : f_arr[bookmark.layer] = bookmark.count
    end
  end

end
