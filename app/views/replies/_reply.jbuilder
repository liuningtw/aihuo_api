json.id reply.to_param
json.body reply.body
json.nickname reply.nickname
json.created_at reply.created_at

if reply.replyable_type
  replyable_class = reply.replyable_type.constantize.new
  json.replyable_id Reply.encrypt(replyable_class.encrypted_id_key, reply.replyable_id)
  json.replyable_type reply.replyable_type
  json.replyable_body reply.replyable.body
end

if reply.topic_id
  json.topic_id Topic.encrypt(Topic.encrypted_id_key, reply.topic_id)
end

if reply.member
  json.member do
    json.partial! "members/member", member: reply.member
  end
end

unless reply.replies.size.zero?
  json.replies reply.replies.vision_of_reply(@current_device_id) do |reply|
    json.partial! "replies/reply", reply: reply
  end
end
