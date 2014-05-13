module ApplicationHelper
  # include FontAwesome::Rails::IconHelper

  def display_user(user)
    "#{user.name} (#{user.email})"
  end

  def subnav_link_to(icon, name, path, options = {})
    subnav_class = current_page?(path) ? "active" : nil
    # content_tag "dd", link_to(fa_icon(icon, text: name, class: "fa-fw"), path, options), class: subnav_class
  end

  def attachment_preview(attachment)
    image = attachment.image? ? attachment.file.thumb.url : "document_plain.png"

    content_tag :ul, class: "clearing-thumbs", data: { clearing: "" } do
      content_tag :li do
        link_to image_tag(image), attachment.file.url, class: "th radius"
      end
    end
  end

  def filter_options_for_select(klass, collection, selected)
    options = [
      ["All #{klass.to_s.downcase.pluralize}", ""]
    ] + collection.map { |c| [c.name, c.id] }

    options_for_select options, selected.to_i
  end

  def status_icon(status)
    content_tag :span, "", class: "status-icon #{status}"
  end

end
