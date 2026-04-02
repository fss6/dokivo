module DocumentsHelper
  def document_status_options
    [
      ["Pendente", "pending"],
      ["Em processamento", "processing"],
      ["Processado", "processed"],
      ["Falhou", "failed"]
    ]
  end

  def document_status_label(status)
    {
      "pending" => "Pendente",
      "processing" => "Em processamento",
      "processed" => "Processado",
      "failed" => "Falhou"
    }[status.to_s] || status.to_s
  end

  def document_status_badge_classes(status)
    case status.to_s
    when "processed"
      "bg-teal-50 text-teal-800 ring-1 ring-inset ring-teal-600/20"
    when "processing", "pending"
      "bg-amber-50 text-amber-900 ring-1 ring-inset ring-amber-600/20"
    when "failed"
      "bg-red-50 text-red-800 ring-1 ring-inset ring-red-600/20"
    else
      "bg-zinc-100 text-zinc-700"
    end
  end

  def document_file_label(document)
    return "—" unless document.file.attached?

    document.file.filename.to_s
  end
end
