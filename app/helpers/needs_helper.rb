# frozen_string_literal: true

module NeedsHelper
  def race_options_for_select
    Race.pluck(:name, :id)
  end
  def language_options_for_select
    language_options = Language.all.map { |l| [l.name, l.id] }
    english = language_options.find { |l| l[0]=='English'}
    #raise english.inspect
    options_for_select(language_options, selected: english[1])
  end
end
