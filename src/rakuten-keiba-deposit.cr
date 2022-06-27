require "commander"
require "./*"

module Rakuten::Keiba::Deposit
  VERSION = "0.1.0"

  cli = Commander::Command.new do |cmd|
    cmd.use = "rakuten-keiba-deposit"
    cmd.long = "Automation for rakuten keiba deposit."

    cmd.flags.add do |flag|
      flag.name = "version"
      flag.long = "--version"
      flag.short = "-v"
      flag.default = false
      flag.description = "Show version."
    end

    cmd.flags.add do |flag|
      flag.name        = "id"
      flag.short       = "-i"
      flag.long        = "--id"
      flag.default     = ""
      flag.description = "Rakuten ID(mail address)."
    end

    cmd.flags.add do |flag|
      flag.name        = "password"
      flag.short       = "-p"
      flag.long        = "--password"
      flag.default     = ""
      flag.description = "Rakuten Password."
    end

    cmd.flags.add do |flag|
      flag.name        = "pin_code"
      flag.short       = "-c"
      flag.long        = "--code"
      flag.default     = ""
      flag.description = "Rakuten keiba pincode."
    end

    cmd.flags.add do |flag|
      flag.name        = "deposit_amount"
      flag.short       = "-d"
      flag.long        = "--deposit-amount"
      flag.default     = 100
      flag.description = "Rakuten keiba money of deposit amount."
    end

    cmd.flags.add do |flag|
      flag.name        = "no_payment"
      flag.long        = "--no-payment"
      flag.default     = false
      flag.description = "[For Debug] No payment flag."
    end

    cmd.commands.add do |cmd|
      cmd.use   = "encrypt <password>"
      cmd.short = "Encrypt input password (Not perfect secure)"
      cmd.long  = cmd.short

      cmd.flags.add do |flag|
        flag.name        = "salt_path"
        flag.short       = "-s"
        flag.long        = "--salt-path"
        flag.default     = salt_path()
        flag.description = "Exist salt file path or New salt file path"
      end

      cmd.run do |options, arguments|
        if arguments.size == 0
          puts cmd.help
          exit 1
        end

        password_client = PasswordClient.new arguments[0], options.string["salt_path"]
        p "Encrypted password: " + password_client.encrypt
      end
    end

    cmd.run do |options, arguments|
      if options.bool["version"]
        puts Rakuten::Keiba::Deposit::VERSION
        next
      end

      begin
        id = options.string["id"]
        if id == ""
          raise Exception.new("Error: Rakuten ID is not set")
        end
        password = options.string["password"]
        if password == ""
          raise Exception.new("Error: Rakuten Password is not set")
        end
        pin_code = options.string["pin_code"]
        if pin_code == ""
          raise Exception.new("Error: pin code is not set")
        end
        deposit_amount = options.int["deposit_amount"]
        no_payment = options.bool["no_payment"]

      rescue ex
        puts "#{ex.message}\n#{cmd.help}"
        exit 1
      end

      client = RakutenKeibaClient.new id, password, pin_code, Int32.new(deposit_amount), no_payment
      client.run()
    end
  end

  Commander.run(cli, ARGV)
end
