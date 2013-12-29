require 'images/upload'

# Based on https://devcenter.heroku.com/articles/mailgun#receiving-messages-via-http

class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def post
    # process various message parameters:
    sender  = params['from']
    subject = params['subject']

    # get the "stripped" body of the message, i.e. without
    # the quoted part
    actual_body = params["stripped-text"]

    # process all attachments:
    count = params['attachment-count'].to_i
    Rails.logger.error "Email received From #{sender}, Subject #{subject}, Body: #{actual_body}, Attachments: #{count}"

    count.times do |i|
      stream = params["attachment-#{i+1}"]
      filename = stream.original_filename
      data = stream.read()
      Rails.logger.error "  Attachment #{i} Filename: #{filename}"
      url = Images::Upload.new.upload(data)
      Image.create!(url: url, email_from: sender, email_subject: subject) if url
    end
    render :text => "OK"
  end
end