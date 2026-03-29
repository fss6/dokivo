module SubscriptionsHelper
  def subscription_status_options
    [
      ["Em trial", "trialing"],
      ["Ativa", "active"],
      ["Em atraso", "past_due"],
      ["Não pago", "unpaid"],
      ["Cancelada", "canceled"],
      ["Expirada", "expired"]
    ]
  end

  def subscription_status_label(status)
    {
      "trialing" => "Em trial",
      "active" => "Ativa",
      "past_due" => "Em atraso",
      "unpaid" => "Não pago",
      "canceled" => "Cancelada",
      "expired" => "Expirada"
    }[status.to_s] || status.to_s
  end

  def subscription_status_badge_classes(status)
    case status.to_s
    when "active", "trialing"
      "bg-teal-50 text-teal-800 ring-1 ring-inset ring-teal-600/20"
    when "past_due"
      "bg-amber-50 text-amber-900 ring-1 ring-inset ring-amber-600/20"
    when "unpaid"
      "bg-red-50 text-red-800 ring-1 ring-inset ring-red-600/20"
    when "canceled", "expired"
      "bg-zinc-100 text-zinc-600"
    else
      "bg-zinc-100 text-zinc-700"
    end
  end

  def format_subscription_datetime(value)
    return "—" if value.blank?

    value.strftime("%d/%m/%Y %H:%M")
  end
end
