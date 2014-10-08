module ApplicationHelper
  def full_name user
    user.name.capitalize + ' ' + user.surname.capitalize
  end

  def short_text text
    if text.length <= 1000
      text
    else
      text[0...997] + '...'
    end
  end
end