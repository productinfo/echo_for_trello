module CardsHelper
  def edit_card_link(card)
    link_to "<span class='glyphicon glyphicon-pencil'></span> Edit".html_safe, card_path(card), class: "edit-card-link"
  end

  def delete_card_link(card)
    link_to "<span class='glyphicon glyphicon-remove'></span> Delete".html_safe, card_path(card), method: :delete, class: "delete-card-link"
  end

  def update_card_status_link(card)
    link_text = card.disabled? ? "Enable" : "Disable"
    link_to "<span class='glyphicon glyphicon-ban-circle'></span> #{link_text}".html_safe, update_status_card_path(card), method: :put, class: "update-card-status-link"
  end
end