module V1
  class AppointmentSerializer < BaseSerializer
    attributes :id, :email, :confirmed, :canceled

    # Relationships
    belongs_to_link :offer
    belongs_to_link :offer_time
    belongs_to_link :location

    # Method
    def email
      ''
    end

    def confirmed
      object.confirmed_at.present?
    end

    def canceled
      object.canceled_at.present?
    end
  end
end
