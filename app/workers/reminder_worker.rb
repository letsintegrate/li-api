class ReminderWorker
  include Sidekiq::Worker

  def perform
    reminder_records.each do |appointments|
      send_reminder(appointment)
    end
  end

  def reminder_records
    Appointment.where.not(confirmed_at: nil)
      .joins(:offer_time)
      .where(offer_times: { time: interval })
      .where(reminder_sent: nil)
  end

  def send_reminder(appointment)
    AppointmentMailer.remind_local(appointment).deliver_now
    AppointmentMailer.remind_refugee(appointment).deliver_now
  end

  def interval
    (8.hours.from_now..9.hours.from_now)
  end
end
