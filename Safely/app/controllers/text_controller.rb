class TextController < UIViewController
	extend IB

	outlet :phone_field, UITextField
	outlet :send_button, UIButton
	ib_action :send_text

	def viewDidLoad
		phone_field = UITextField
	end

	def send_text (sender)
		BW::HTTP.get('http://safelyapp.herokuapp.com/text?pnumber='+ "#{phone_field.text}")
		p "Safely"

   	 	ab = AddressBook::AddrBook.new
    	people = ab.people

    	if AddressBook.authorized?
  			puts "This app is authorized!"
		else
  			puts "This app is not authorized!"
		end

		p people
	end
end 