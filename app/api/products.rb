module API
  class Products < Grape::API
    # define helpers with a block
    helpers do
      def keyword
        if params[:tag]
          tag = Tag.find_by_name(params[:tag])
          tag = tag.self_and_descendants.collect(&:name) if tag
          tag || params[:tag]
        end
      end
    end

    resources :products do
      desc "Listing products."
      params do
        optional :tag, type: String, desc: "Tag name."
        optional :page, type: Integer, desc: "Page number."
        optional :per, type: Integer, default: 10, desc: "Per page value."
      end
      get "/", jbuilder: 'products/products' do
        @products = Product.search(keyword).page(params[:page]).per(params[:per])
      end

      params do
        requires :id, type: String, desc: "Product ID."
      end
      route_param :id do
        desc "Return a product."
        get "/", jbuilder: 'products/product' do
          @product = Product.find(params[:id])
        end

        desc "Listing trades of the product."
        params do
          optional :filter, type: Symbol, values: [:rated, :all], default: :all, desc: "Filtering trades with commented or not."
          optional :page, type: Integer, desc: "Page number."
          optional :per, type: Integer, default: 10, desc: "Per page value."
        end
        get :trades, jbuilder: 'trades/trades' do
          product = Product.find(params[:id])
          @trades = product.orders.by_filter(params[:filter]).order("created_at DESC").page(params[:page]).per(params[:per])
        end
      end

    end
  end
end

