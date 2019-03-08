# frozen_string_literal: true

require 'rails_helper'
require 'shared_model_stuff'

RSpec.describe ApplicationRecord, type: :model do
  it_behaves_like 'real_model'


end
