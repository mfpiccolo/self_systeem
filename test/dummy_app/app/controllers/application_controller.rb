class ApplicationController < ActionController::Base

  def index
    @current_user = User.new
    render :text => 'Rendered MiniTest::Spec', :layout => false
  end

end
