require 'md5'

class Domain < ActiveRecord::Base
  
  has_many :urls
  validates_presence_of :domain, :domain_hash
  before_validation_on_create :hash_domain
  
  def hash_domain
    self.domain_hash = MD5.md5(domain).to_s
  end
  
  def to_param
    domain_hash
  end
  
end