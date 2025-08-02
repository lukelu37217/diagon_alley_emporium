module ProductsHelper
  def product_image_tag(product, size: :medium)
    if product.image.present?
      case size
      when :small
        image_tag product.image, class: "img-fluid", style: "height: 150px; object-fit: cover;"
      when :large
        image_tag product.image, class: "img-fluid", style: "height: 400px; object-fit: cover;"
      else
        image_tag product.image, class: "img-fluid", style: "height: 200px; object-fit: cover;"
      end
    else
      content_tag :div, class: "bg-light d-flex align-items-center justify-content-center", 
                       style: image_placeholder_style(size) do
        content_tag :span, "No Image", class: "text-muted"
      end
    end
  end

  def product_status_badge(product)
    if product.in_stock?
      content_tag :span, "In Stock", class: "badge bg-success"
    else
      content_tag :span, "Out of Stock", class: "badge bg-danger"
    end
  end

  def price_display(price)
    number_to_currency(price)
  end

  private

  def image_placeholder_style(size)
    case size
    when :small
      "height: 150px;"
    when :large
      "height: 400px;"
    else
      "height: 200px;"
    end
  end
end
