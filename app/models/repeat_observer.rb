class RepeatObserver < ActiveRecord::Observer
  def after_create(repeat)
    return true unless repeat.successful?

    organisation = repeat.payment.organisation
    billing_address = organisation.payment_method.billing_address

    Invoice.create!(:payment => repeat.payment,
                    :amount => repeat.amount / 100.0,
                    :customer_name => billing_address.name,
                    :customer_address_line_1 => billing_address.address_line_1,
                    :customer_address_line_2 => billing_address.address_line_2,
                    :customer_county => billing_address.county,
                    :customer_town => billing_address.town,
                    :customer_postcode => billing_address.postcode,
                    :customer_country => billing_address.country)
  end
end
