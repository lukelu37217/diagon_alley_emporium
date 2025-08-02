module ApplicationHelper
  def flash_class(flash_type)
    case flash_type.to_s
    when 'notice'
      'alert-success'
    when 'alert'
      'alert-danger'
    when 'warning'
      'alert-warning'
    else
      'alert-info'
    end
  end

  def page_title(title = nil)
    if title
      "#{title} | Diagon Alley Emporium"
    else
      "Diagon Alley Emporium - Magical Items & Wizarding Supplies"
    end
  end

  def current_cart_count
    return 0 unless user_signed_in?
    @current_cart_count ||= current_user.shopping_carts.sum(:quantity)
  end

  def currency_format(amount)
    number_to_currency(amount, unit: '$', precision: 2)
  end

  def truncate_text(text, length = 100)
    truncate(text, length: length, separator: ' ')
  end
end
