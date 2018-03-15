require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    if cookie
      @hsh = JSON.parse(cookie)
    else
      @hsh = {}
    end
  end

  def [](key)
    @hsh[key]
  end

  def []=(key, val)
    @hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
  end
end
