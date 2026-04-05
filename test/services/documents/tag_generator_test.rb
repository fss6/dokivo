# frozen_string_literal: true

require "test_helper"

class Documents::TagGeneratorTest < ActiveSupport::TestCase
  test "normalize_tags trims, dedupes, and caps length" do
    out = Documents::TagGenerator.normalize_tags([" a ", "b", " b ", "", "a", ("x" * 100)])
    assert_equal %w[a b], out[0..1]
    assert_equal 80, out[2].length
  end

  test "parse_tags_json strips markdown fence" do
    raw = <<~JSON.strip
      ```json
      {"tags":["contrato","imóvel"]}
      ```
    JSON
    assert_equal %w[contrato imóvel], Documents::TagGenerator.parse_tags_json(raw)
  end

  test "parse_tags_json reads plain object" do
    assert_equal ["x"], Documents::TagGenerator.parse_tags_json('{"tags":["x"]}')
  end

  test "call returns empty array on invalid json from model" do
    document = documents(:one)
    document.update!(content: "Conteúdo mínimo para amostra.")

    Openai::Completion.stub :call, "not json" do
      tags = Documents::TagGenerator.call(document)
      assert_equal [], tags
    end
  end

  test "call returns nil when there is no text sample" do
    document = documents(:one)
    document.update!(content: nil, summary: nil)
    document.embedding_records.delete_all

    assert_nil Documents::TagGenerator.call(document)
  end
end
