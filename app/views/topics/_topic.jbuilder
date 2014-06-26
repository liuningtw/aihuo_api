json.id topic.to_param
json.body topic.body
json.nickname topic.nickname
json.liked_count topic.likes_count
json.disliked_count topic.unlikes_count
json.replies_count topic.replies_count
json.top topic.top
json.lock topic.lock
json.best topic.best
json.approved topic.approved
json.deleted topic.deleted_at.present?
json.created_at topic.created_at
if topic.member
  json.member do
    json.partial! "members/member", member: topic.member
  end
end