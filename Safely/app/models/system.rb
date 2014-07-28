class User
	PROPERTIES = [:first_name, :last_name, :email, :password, :created_at, :updated_at]
	PROPERTIES.each { |prop|
		attr_accessor prop
	}

	def initialize(hash = {})
		hash.each { |key, value|
			if PROPERIES.member? key.to_sym
				self.send((key.to_s + '=').to_s, value)
			end 
		}
	end

	def self.pull_system_date(friend_id, &block)
		BW::HTTP.get()
			result_data = BW::JSON.parse(response.first_name.to_str)
			friend_data = result_data[:user]
			block.call(friend_data) 
	end 
end  

# def signup
# 	http create new user
# end

# def get_friends
# 	http get friend lists
# end
