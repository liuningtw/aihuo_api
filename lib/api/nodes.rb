class Nodes < Grape::API
  resources 'nodes' do
    desc "Return public nodes list."
    params do
      optional :page, type: Integer, default: 1, desc: "Page number."
      optional :per_page, type: Integer, default: 10, desc: "Per page value."
    end
    get "/", jbuilder: 'nodes/nodes' do
      @nodes = paginate(Node.by_state(:public))
      cache(key: [:v2, :nodes, @nodes], expires_in: 2.days) do
        @nodes
      end
    end

    params do
      requires :id, type: String, desc: "Node ID."
    end
    route_param :id do
      desc "Return roles, also to check a device is node manager or not."
      params do
        requires :device_id, type: String, desc: "Device ID."
      end
      get :check_role do
        node = Node.find(params[:id])
        role = node.manager_list.include?(params[:device_id]) ? "node_manager" : "user"
        { role: role }
      end

      desc "Block a user in node."
      params do
        requires :device_id, type: String, desc: "Device ID."
        requires :object_id, type: String, desc: "Object ID."
        requires :object_type, type: Symbol, values: [:topic, :reply], default: :topic, desc: "Object Type."
      end
      post :block_user do
        node = Node.find(params[:id])
        obj = eval(params[:object_type].to_s.capitalize).find(params[:object_id])
        response = node.block_user(params[:device_id], obj.device_id)
        if response
          status 201
        else
          status 200
        end
        { success: response }
      end

      resources 'topics' do
        params do
          optional :filter, type: Symbol, values: [:hot, :new, :mine, :all], default: :all, desc: "Filtering topics."
          requires :device_id, type: String, desc: "Device ID."
          optional :page, type: Integer, default: 1, desc: "Page number."
          optional :per_page, type: Integer, default: 10, desc: "Per page value."
        end
        get "/", jbuilder: 'topics/topics' do
          node = Node.find(params[:id])
          topics = case params[:filter]
          when :hot
            node.topics.popular
          when :new
            node.topics.lasted
          when :mine
            node.topics.by_device(params[:device_id])
          else :all
            node.topics
          end
          @topics = paginate(topics.order("top DESC, updated_at DESC"))
        end

        desc "Create a topic to the node."
        params do
          requires :body, type: String, desc: "Topic content."
          requires :nickname, type: String, desc: "User nickname."
          requires :device_id, type: String, desc: "Deivce ID."
          requires :sign, type: String, desc: "sign value."
        end
        post "/", jbuilder: 'topics/topic' do
          if sign_approval?
            node = Node.find(params[:id])
            @topic = node.topics.new({
                       body: params[:body],
                       nickname: params[:nickname],
                       device_id: params[:device_id]
                     })
            status 422 unless @topic.save
          else
            error! "Access Denied", 401
          end
        end
      end

    end
  end
end
