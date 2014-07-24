class Player < ActiveRecord::Base

	belongs_to :team

	has_many :sanctions
	

# starts a Comma description block, generating 2 methods #to_comma and
 # #to_comma_headers for this class.
 comma do

   # name, description are attributes of Book with the header being reflected as
   # 'Name', 'Description'
   first_name
   last_name
   overall

   # pages is an association returning an array, :size is called on the
   # association results, with the header name specified as 'Pages'
   

   # publisher is an association returning an object, :name is called on the
   # associated object, with the reflected header 'Name'
   

   # isbn is an association returning an object, :number_10 and :number_13 are
   # called on the object with the specified headers 'ISBN-10' and 'ISBN-13'
   

   # blurb is an attribute of Book, with the header being specified directly
   # as 'Summary'
   

 end

end
