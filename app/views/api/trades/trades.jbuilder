json.trades @trades do |trade|
  json.id trade.to_param
  json.province trade.shipping_province
  json.city trade.shipping_city
  json.district trade.shipping_district
  json.created_at trade.created_at
  json.partial! "trades/comment", comment: trade.comments.first unless trade.comments.size.zero?
end
json.total_number @total_number
