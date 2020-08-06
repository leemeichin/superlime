# Superlime

A replacement for [Rectify::Command](https://github.com/andypike/rectify#commands) that uses Ruby 2.7 pattern matching in place of events.
Uses a mostly-compatible API.

## Usage

When creating a command, have it inherit from `Superlime::Command` (instead of `Rectify::Command` if refactoring).

```ruby
class Payment::Send < Superlime::Command
  attr_reader :params
  
  def initialize(params)
    @params = params
  end

  def call
    broadcast(:no_payee) if params[:payee].nil?
    transaction = make_payment!
    broadcast(:success, tx_id: transaction.id)
  rescue PaymentError, SomeSillyError => err
    broadcast(:error, err)    
  end
  
  private 

  def make_payment!
    # do the payment...
    # raise if payment_failed 
  end 
end
```

The behaviour is mostly the same, except you don't require a `return` invocation when calling `broadcast`.

In order to use this command, you can use Ruby's brand new pattern matching niceness. It's a little bit different but
offers a lot of flexibility depending on the complexity of your command.

```ruby
class PaymentController < ApplicationController
  def create
    case Payment::Send.call(payment_params)
    in success: result then render json: result
    in :no_payee then head :bad_request
    in error: PaymentError => err then render json: err.message, status: :internal_server_error
    in error: SomeSillyError then redirect_to 'http://www.zombo.com'
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:payee, :card_details_and_stuff)
  end
end
```

Ruby's pattern matching allows you to match against types, hashes, arrays, while also being able to destructure them,
so these destructurings can be as simple or complex as you like (including destructuring of custom classes).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mrleedev/superlime.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
