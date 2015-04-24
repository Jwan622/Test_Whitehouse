class Pdf < ActiveRecord::Base
  has_attached_file :pdf_file,
    :path => ":rails.root/public/assets/pdfs/:id.:extension"

  validates_attachment_content_type :pdf_file,
                                    :content_type => [ 'application/pdf' ],
                                    :message => "only pdf files are allowed",
                                    :if => :pdf_attached?

  def self.learn_more
    where("page = 'tools and resources' and slot = 1").first
  end

  def pdf_attached?
    self.pdf_file.present?
  end
end
