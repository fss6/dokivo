# frozen_string_literal: true

require "test_helper"

class MistralOcrChunkPageMarkdownTest < ActiveSupport::TestCase
  test "texto curto retorna um único chunk" do
    text = "  Olá, mundo OCR  "
    chunks = MistralOcr::ChunkPageMarkdown.call(text, max_chars: 4000, overlap: 0)

    assert_equal 1, chunks.size
    assert_equal "Olá, mundo OCR", chunks.first
  end

  test "string vazia retorna lista vazia" do
    assert_equal [], MistralOcr::ChunkPageMarkdown.call("", max_chars: 100)
    assert_equal [], MistralOcr::ChunkPageMarkdown.call("   ", max_chars: 100)
  end

  test "texto longo sem quebras naturais é dividido respeitando max_chars" do
    text = "a" * 250
    chunks = MistralOcr::ChunkPageMarkdown.call(text, max_chars: 100, overlap: 0)

    assert_equal 3, chunks.size
    chunks.each do |chunk|
      assert_operator chunk.length, :<=, 100
    end
    assert_equal text, chunks.join
  end

  test "overlap repete trecho entre chunks consecutivos" do
    # 70 caracteres, janela 50 e overlap 15 => avanço 35 por passo após o 1º chunk:
    # [0..50) e [35..70) — exatamente 2 trechos; o final do 1º e o início do 2º coincidem em 15 chars.
    text = "a" * 70
    chunks = MistralOcr::ChunkPageMarkdown.call(text, max_chars: 50, overlap: 15)

    assert_equal 2, chunks.size
    assert_equal text.length, chunks.sum(&:length) - 15

    suffix = chunks.first.last(15)
    prefix = chunks.second[0, 15]
    assert_equal suffix, prefix
  end

  test "prefere cortar em parágrafo quando cabe na janela" do
    head = "x" * 40
    tail = "y" * 200
    text = "#{head}\n\n#{tail}"

    chunks = MistralOcr::ChunkPageMarkdown.call(text, max_chars: 100, overlap: 0)

    assert_operator chunks.size, :>=, 2
    assert_includes chunks.first, head
    assert_not_includes chunks.first, "y" * 10
  end
end
