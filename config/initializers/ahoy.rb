class Ahoy::Store < Ahoy::DatabaseStore
  def authenticate(data)
    # disables automatic linking of visits and users
  end
end

# API Only
Ahoy.api_only = true

# Allow bot tracking because otherwise API calls are excluded
Ahoy.track_bots = true

# Privacy
Ahoy.cookies = false
Ahoy.mask_ips = true
Ahoy.geocode = false

# Debug
Ahoy.quiet = false
