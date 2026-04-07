class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  set_current_tenant_through_filter
  before_action :find_current_tenant

  def find_current_tenant
    current_account = current_user.account
    set_current_tenant(current_account)
  end
end
