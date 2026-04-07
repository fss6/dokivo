# README

## Account
```
- id
- name
- plan_id
- active
- description
- belongs_to Plan
- has_many Users, Documents, Conversations
```

## User
```
- id
- account_id
- email
- name
- role
- active
- has_many Conversations, Documents, GroupMemberships
- has_many Groups, through: GroupMemberships
```

## Plan
```
- id
- name
- price
- status
- has_many Accounts (FK plan_id)
```

## Subscription
```
- id
- account_id
- plan_id
- status
- current_period_end
- trial_ends_at
- canceled_at
- belongs_to Account, Plan
```

> [!IMPORTANT]
> Subscription status
> - trialing (Ex: 7 dias grátis)
>   - cliente ainda não paga
>   - acesso liberado (às vezes com limite)
> - active
>    - pagamento ok
>    - acesso total conforme plano
> - past_due (pagamento falhou)
>    - cartão recusado
>    - tentativa de cobrança falhou
> - unpaid (dívida confirmada)
>    - várias tentativas falharam
>    - cliente não pagou
> - canceled (cancelado pelo usuário)
>    - não renova mais
>    - ainda pode usar até current_period_end
> - expired (acabou o período)
>    - trial terminou OU assinatura venceu
>    - sem pagamento ativo

## Folder
```
- id
- account_id
- name
- belongs_to Account
- has_many Documents
```

## Group
```
- id
- account_id
- name
- belongs_to Account
- has_many GroupMemberships
```

## GroupMembership
```
- id
- group_id
- user_id
- belongs_to Group, User
```

## Conversation
```
- id
- title
- user_id
- account_id
- belongs_to User, Account
- has_many Messages
```

## Message
```
- id
- conversation_id
- role [user | assistant]
- content
- sources (jsonb; citações RAG / referências)
- metadata (jsonb; ex.: focus_document_id para RAG num único documento)
- streaming
- belongs_to Conversation
```

## Document

```
- id
- account_id
- user_id (owner)
- folder_id
- content [Texto bruto extraído do arquivo (PDF, DOCX, etc.)]
- summary [resumo com IA]
- status [pending, processing, processed, failed]
- metadata [Campo flexível (jsonb) para guardar informações extras (Ex: {"pages": 12, "language": "pt-BR", "file_type": "pdf"})]
- file (Active Storage)
- belongs_to Account, User, Folder
- has_many EmbeddingRecords, as: :recordable
```

## EmbeddingRecord
```
- id
- account_id
- document_id (opcional; deve coincidir com recordable quando recordable é Document)
- content (trecho indexado)
- embedding (pgvector, 1536 dim.; similaridade via neighbor / ivfflat)
- recordable_type, recordable_id (polymorphic; tipicamente Document)
- metadata (jsonb; ex.: page, chunk_index)
- belongs_to Account, optional Document, polymorphic: recordable
```

## Dashboard
```
- rota: /dashboard
- root: dashboard#index
- policy: DashboardPolicy
- KPIs:
  - total de tags unicas (documents.tags)
  - total de arquivos
  - total de usuarios
  - total de pastas
- widgets:
  - Arquivos por tipo (doughnut chart)
  - Arquivos criados por dia (line chart, ultimos 30 dias)
  - Ultimas tags adicionadas
  - Arquivos recentes
```

> This Readme using [GitHub syntax](https://docs.github.com/pt/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
