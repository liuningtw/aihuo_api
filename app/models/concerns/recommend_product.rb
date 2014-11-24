module RecommendProduct
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def recommend_products(length = 6)
    return unless recommends
    product_lists = products_by_recommends
    recommends = product_lists.inject(product_lists.first) do |result, list|
      result = result.zip(list)
    end
    recommends.flatten.uniq[0, length]
  end

  private

  def products_by_recommends
    tags = recommend_tag_with_children

    tags.inject([]) do |product_lists, tag_array|
      products = Product.serach_by_keyword(tag_array, "match_all").order_by_sales_volumes.pluck(:id)
      product_lists << products unless products.empty?
      product_lists
    end
  end

  def recommend_tag_with_children
    tags = recommend_list.inject([]) do |tags, tag_name|
      tag = Tag.find_by(name: tag_name)
      tags << tag.self_and_descendants.collect(&:name) if tag
      tags
    end
  end


end
