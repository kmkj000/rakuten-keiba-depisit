require "base64"

module Rakuten::Keiba::Deposit
  def self.salt_path
    process_path = Process.executable_path
    if process_path.is_a?(String)
      if match_data = process_path.match(/(.+)\/(.*)/)
        match_data[1] + "/salt"
      end
    end
  end
end
