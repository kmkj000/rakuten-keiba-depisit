require "selenium"
require "webdrivers"
require "./custom_exception"



# TODO: Write documentation for `Rakuten::Keiba`
module Rakuten::Keiba::Deposit
  class RakutenKeibaClient
    Errors = Hash{
      "COMW0014" => "ただいまのお時間は入金のサービス時間外です。\n詳細 -> https://keiba.faq.rakuten.net/detail/000017016?scid=su_66",
    }

    @session : Selenium::Session
    @driver : Selenium::Driver

    def initialize(@id : String, @password : String, @pin_code : String, @deposit_amount : Int32)
      webdriver_path = Webdrivers::Chromedriver.install
      @driver = Selenium::Driver.for(:chrome, service: Selenium::Service.chrome(driver_path: webdriver_path) )

      capabilities = Selenium::Chrome::Capabilities.new
      capabilities.chrome_options.args = ["no-sandbox", "headless", "disable-gpu"]
      @session = @driver.create_session(capabilities)
    end

    def finalize
      @driver.stop
    end

    def run
      begin
        @session.navigate_to("https://keiba.rakuten.co.jp/")

        if @session.find_elements(:id, "PRmodal").size > 0
          @session.find_element(:xpath, "//div[@data-ratid='rat_pr_close']").click
        end

        @session.find_element(:id, "noBalanceStatus").click

        window_manager = @session.window_manager()
        window_manager.switch_to_window(window_manager.window_handles.last())

        user_id_input = @session.find_element(:id, "loginInner_u")
        user_id_input.send_keys(@id)
        password_input = @session.find_element(:id, "loginInner_p")
        password_input.send_keys(@password)
        password_input.send_keys(Selenium::SendKeyConverter.encode([:enter]))

        if @session.find_elements(:class, "errorCode").size > 0
          raise SiteErrorException.new
        end

        payment

      rescue ex : SiteErrorException
        @session.screenshot("./site_error.png")
        puts ex.message
        puts parse_site_error
      rescue ex
        @session.screenshot("./error.png")
        puts ex.message
      end
    end

    def payment
      @session.find_element(:id, "depositingInputPrice").send_keys(@deposit_amount.to_s)
      @session.find_element(:id, "depositingInputButton").click

      @session.find_element(:class, "definedNumber").send_keys(@pin_code)
      @session.find_element(:id, "depositingConfirmButton").click

      @session.screenshot("./deposit_result.png")
    end

    def parse_site_error()
      error_code = @session.find_element(:class, "errorCode").text().gsub("エラーコード：","")
      Errors[error_code]
    end
  end

end
