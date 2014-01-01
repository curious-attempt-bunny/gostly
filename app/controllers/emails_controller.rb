require 'images/upload'

class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def post
    sender      = params['sender']
    subject     = params['Subject']
    body        = params["stripped-text"]
    attachments = JSON.parse(params["attachments"])

    Rails.logger.error "Email received From #{sender}, Subject #{subject}, Body: #{body}, Attachments: #{attachments.size}"

    attachments.each_with_index do |attachment, index|
      Rails.logger.error "  Attachment #{index} Filename: #{attachment["name"]} URL: #{attachment["url"]}"
      
      url = Images::Upload.new.upload(attachment["url"])
      Image.create!(url: url, email_from: sender, email_subject: subject) if url
    end
    render :text => "OK"
  end
end