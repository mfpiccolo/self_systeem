DummyApp::Application.routes.draw do

  devise_for :users
  devise_scope :user do
    get "login",  to: "devise/sessions#new",      as: "login"
    get "logout", to: "devise/sessions#destroy",  as: "logout"
    get "ba586033c88c2216a/signup", to: "devise/registrations#new", as: "signup"
  end

  scope module: "user" do
    resources :projects do
      resources :members, controller: :project_users
      resources :areas, except: :index
      resources :attachments, controller: :project_attachments,
          only: [:index, :create, :destroy]
      resources :budget_items
      resources :categories, except: :index
      resources :finishes do
        resources :comments, only: [:new, :create, :edit, :update]
        patch :select, on: :member
        patch :deselect, on: :member
      end
      resources :deadlines
    end
  end

  scope module: "organization" do
    resources :organizations, only: [:new, :create, :show, :edit, :update] do
      resources :members, controller: :organization_users
      resources :default_areas, except: :index
      resources :default_categories, except: :index
      resources :projects do
        resources :areas, except: :index
        resources :budget_items
        resources :attachments, controller: :project_attachments,
          only: [:index, :create, :destroy]
        resources :categories, except: :index
        resources :finishes do
          resources :comments, only: [:new, :create, :edit, :update]
          patch :select, on: :member
          patch :deselect, on: :member
        end
        resources :members, controller: :project_users
        resources :deadlines
      end
    end
  end

  get "invitations/:token", to: "invitations#edit", as: "accept_invitation"
  patch "invitations/:token", to: "invitations#update"

  root "site#index"
  get "/:id" => "site#show"
end
