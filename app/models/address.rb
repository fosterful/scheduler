class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  validates :street, :city, :state, :postal_code, presence: true
  validates_address geocode: true, fields: %i[street street2 city state postal_code]

  def to_s
    [street, street2, city, state, postal_code].compact.join(' ')
  end

  def skip_api_validation!
    @skip_api_validation = true
  end

  def skip_api_validation?
    !!instance_variable_get(:@skip_api_validation)
  end

  private
  # Allow us to skip API validation hook as they have not implemented an option
  # for us to use `if` or `unless` in the method `validates_address`
  begin
    original_method = instance_method(:verify_address)
    define_method :verify_address do |*args, &block|
      original_method.bind(self).call(*args, &block) unless skip_api_validation?
    end
  end
end
