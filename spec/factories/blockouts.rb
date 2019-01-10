FactoryBot.define do
  factory :blockout do
    association :user, strategy: :build
    start_at { 1.day.from_now }
    end_at { 1.day.from_now + 1.hour }

    factory :blockout_with_occurrences do
      transient do
        max_occurrence_count { 3 }
      end

      rrule { "FREQ=WEEKLY;COUNT=#{max_occurrence_count};INTERVAL=1;WKST=MO" }

      after(:build) do |blockout, _evaluator|
        Services::ExpandRecurringBlockout.call(blockout)
      end
    end
  end
end
