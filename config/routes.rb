Rails.application.routes.draw do
  # Add your extension routes here
  def advanced_reporting_routes
    namespace :admin do
      resources :reports do
        collection do
          get :sales_total
          get :revenue
          get :units
          get :profit
          get :count
          get :top_products
          get :top_customers
          get :geo_revenue
          get :geo_units
          get :geo_profit
          get :zip_units
        end
      end

      match "/"=> 'admin/advanced_report_overview#index', :as=>:admin
    end

  end
  advanced_reporting_routes

end
