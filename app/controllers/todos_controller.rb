class TodosController < ApplicationController

	def index
		validateUIDCookie
		uid = cookies[:uid]
		@todo = Todo.new
		@todos = Todo.where(:uid => uid, :status => 0).order(created_at: :desc)
		@todosDone = Todo.where(:uid => uid, :status => 1).order(created_at: :desc)
	end

	def create
		uid = cookies[:uid]
		if(!uid)
			redirect_to root_path
		end
		text = params[:todo][:text]
		if(text.empty? == false)
			if (Todo.exists?(:uid => uid, :text => text))
				redirect_to root_path
			else
				status = 0
  				Todo.create(:uid => uid, :text => text, :status => status)
  				redirect_to root_path
  			end
  		else
  			redirect_to root_path
  		end
	end

	def destroy
    	@todo = Todo.find(params[:id])
    	uid = cookies[:uid]
    	if(!uid)
			redirect_to root_path
		end
    	if(@todo.uid == uid)
    		@todo.destroy
    	end
    	redirect_to root_path
  	end

  	def complete
  		@todo = Todo.find(params[:id])
    	uid = cookies[:uid]
    	if(!uid)
			redirect_to root_path
		end
    	if(@todo.uid == uid)
    		if(@todo.status == 0)
    			@todo.update_attribute('status', 1)
    		else
    			@todo.update_attribute('status', 0)
    		end
    	end
    	redirect_to root_path
  	end

	private 
  		def validateUIDCookie
  			uid_cookie = cookies[:uid]
			if(!uid_cookie)
				uid_gen = SecureRandom.hex(12)
				while (User.exists?(:uid => uid_gen)) do
					uid_gen = SecureRandom.hex(12)
				end
				User.create(:uid => uid_gen)
				cookies[:uid] = { :value => uid_gen, :expires => 10.year.from_now }
			end
		end
end
