# -*- coding: utf-8 -*-
class PaymentsController < ApplicationController
  skip_before_filter :authenticate_filter, only: %w[ipn]
  include ActiveMerchant::Billing::Integrations

  # paypalのipn通知を処理する
  def ipn
    notify = Paypal::Notification.new(request.raw_post)
    acknowledge_result = false

    acknowledge_result = notify.acknowledge
    if acknowledge_result
      logger.info "Success to verify"
      logger.info notify.params
      #Payment.dispatch_ipn(notify.params)
    else
      logger.error "Failed to verify Paypal's notification, please investigate"
    end
    render :nothing => true
  end
end
