# == Schema Information
#
# Table name: failed_messages
#
#  id           :integer          not null, primary key
#  message      :string
#  phone_number :string
#

class FailedMessage < ApplicationRecord
end
