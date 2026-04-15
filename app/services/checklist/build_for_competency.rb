module Checklist
  class BuildForCompetency
    def initialize(account:, client:, period:)
      @account = account
      @client = client
      @period = period.beginning_of_month.to_date
    end

    def call
      CompetencyChecklist.find_or_create_by!(
        account: @account,
        client: @client,
        period: @period
      )
    end
  end
end
