# frozen_string_literal: true

# app/controllers/concerns/rack_sessions_fix.rb
module RackSessionsFix
  # app/controllers/concerns/rack_sessions_fix.rb
  extend ActiveSupport::Concern
  # app/controllers/concerns/rack_sessions_fix.rb
  class FakeRackSession < Hash
    def enabled?
      false
    end

    def destroy; end
  end
  included do
    before_action :set_fake_session

    private

    def set_fake_session
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end