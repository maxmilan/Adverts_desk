module AdminPanelHelper
  def user_info user
    "#{full_name user} (#{user.email})"
  end
end