# rakuten-keiba-deposit

Automation Rakuten keiba deposit.
Also for my crystal-lang study.

## Installation

TODO: Write installation instructions here

## Usage

```
  Usage:
    rakuten-keiba-deposit [command] [flags] [arguments]

  Commands:
    decrypt <encrypted-password>  [For Debug] Decrypt input encrypted password
    encrypt <password>  Encrypt input password (Not perfect secure)
    help [command]      Help about any command.

  Flags:
    -d, --deposit-amount  Rakuten keiba money of deposit amount. default: 100
    -h, --help            Help for this command.
    -i, --id              Rakuten ID(mail address).
        --no-payment      [For Debug] No payment flag.
    -p, --password        Rakuten Password.
    -c, --code            Rakuten keiba pincode.
    -s, --salt-path       Exist salt file path or New salt file path default: '/home/puti/.cache/crystal/salt'
    -v, --version         Show version.
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/rakuten-keiba-deposit/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [kmkj000](https://github.com/your-github-user) - creator and maintainer
