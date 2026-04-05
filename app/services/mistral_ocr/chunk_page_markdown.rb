# frozen_string_literal: true

module MistralOcr
  # Divide o markdown de uma página do OCR em trechos menores para embedding / leitura.
  # Limite por caracteres (aproximação barata a limites de token); overlap evita cortar
  # contexto na junção entre chunks.
  class ChunkPageMarkdown
    DEFAULT_MAX_CHARS = 4000
    DEFAULT_OVERLAP = 200
    MIN_MAX_CHARS = 256

    def self.call(text, max_chars: nil, overlap: nil)
      new(text, max_chars: max_chars, overlap: overlap).call
    end

    def initialize(text, max_chars: nil, overlap: nil)
      @text = text.to_s
      @max_chars = normalize_max_chars(max_chars)
      @overlap = normalize_overlap(overlap, @max_chars)
    end

    def call
      return [] if @text.blank?
      return [ @text.strip ] if @text.length <= @max_chars

      chunks = []
      i = 0
      while i < @text.length
        chunk_end = [ i + @max_chars, @text.length ].min

        if chunk_end < @text.length
          window = @text[i...chunk_end]
          rel = preferred_break_offset(window)
          chunk_end = i + rel if rel
        end

        piece = @text[i...chunk_end].strip
        chunks << piece if piece.present?

        break if chunk_end >= @text.length

        next_i = chunk_end - @overlap
        next_i = [ next_i, i + 1 ].max
        i = next_i
      end

      chunks.presence || [ @text.strip ]
    end

    private

    def normalize_max_chars(value)
      if value.nil?
        n = ENV.fetch("OCR_CHUNK_MAX_CHARS", DEFAULT_MAX_CHARS).to_i
        n = DEFAULT_MAX_CHARS unless n.positive?
        [ n, MIN_MAX_CHARS ].max
      else
        n = value.to_i
        n = DEFAULT_MAX_CHARS unless n.positive?
        [ n, 1 ].max
      end
    end

    def normalize_overlap(value, max_chars)
      o =
        if value.nil?
          ENV.fetch("OCR_CHUNK_OVERLAP_CHARS", DEFAULT_OVERLAP).to_i
        else
          value.to_i
        end
      o = 0 if o.negative?
      [ o, [ max_chars - 1, 0 ].max ].min
    end

    # Último bom ponto de corte no trecho (tamanho relativo ao window).
    def preferred_break_offset(window)
      return nil if window.length < 48

      min_break = window.length / 4
      idx = window.rindex("\n\n")
      return idx + 2 if idx && idx >= min_break

      idx = window.rindex("\n")
      return idx + 1 if idx && idx >= min_break

      idx = window.rindex(" ")
      return idx + 1 if idx && idx >= min_break

      nil
    end
  end
end
