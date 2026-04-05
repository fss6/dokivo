# frozen_string_literal: true

# O tipo PostgreSQL `vector` (extensão pgvector) usa um OID que o adaptador `pg`
# não conhece por padrão — sem registro, o schema dumper emite:
#   unknown OID ... failed to recognize type of 'embedding'. It will be treated as String.
# A gem `neighbor` registra :vector (e afins) em ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.
# Ver: https://github.com/ankane/neighbor
require "neighbor"
