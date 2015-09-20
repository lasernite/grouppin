	class PostersController < ApplicationController

		def create
			@poster = Poster.new(poster_params)
			@poster.save
			@poster.reload
	  		url = @poster.image_paperclip.url()
			@poster.update_attribute(:image_url, url)
	  		time, text = index(params['poster']['image_paperclip'])
	  		datetime = DateTime.new(year = time.year, month = time.month, day = time.day, hour = time.hour, minute = time.min)
			@poster.update_attribute(:tesseract_text, text)
			@poster.update_attribute(:parsed_datetime, datetime)
			# @results = Array.new
			# # Poster.find(:all, :order => "parsed_datetime").each do |item|
			# #       @results << item
			# #   end
			# # put @results
			redirect_to '/'
		end

		def countNumbers(arr)
		    count = 0
		    for item in arr
		        if item =~ /\A[-+]?[0-9:]*\.?[0-9:]+\Z/
		            count += 1
		        end
		    end
		    return count
		end

		def toTime(text)
		    if Chronic.parse(text, :now=>Time.now, :guess=>true) != nil
		        return Chronic.parse(text, :now=>Time.now, :guess=>true)
		    else
		        arr = text.split(" ")
		        scores = Hash.new
		        matches = 0
		        for i in 2..[arr.length-1, 4].min
		            for start in 0..arr.length-i-1
		                combs = arr[start, i+1].combination(i).to_a
		                for comb in combs
		                    hypothesis = Chronic.parse(comb.join(" "), :now=>Time.now, :guess=>true)
		                    if hypothesis != nil
		                        if scores[hypothesis] == nil
		                            scores[hypothesis] = 0
		                        else
		                            matches+=1
		                        end

		                        #Prior belief that Dates on posters are likely NEAR-FUTURE.
		                        exotic_time_penalty = 0
		                        if hypothesis - Time.now > 800000
		                            exotic_time_penalty = 0.2*Math.log10(hypothesis - Time.now - 800000)
		                        elsif Time.now - hypothesis > 500000
		                            exotic_time_penalty = 0.2*Math.log10(Time.now - hypothesis - 50000)
		                        end

		                        #Value numbers over words. Penalize hypothesis made from smaller combinations.
		                        scores[hypothesis] += i + countNumbers(comb)**2 - exotic_time_penalty
		                    end
		                end
		            end
		        end
		        scores.each { |k, v| return k if v == scores.values.max }
		    end
		end

		def guess(text)
		    print "Guess ", toTime(text), "\n\n"
		end


	  	def index(paperclip_file)
		  	e = Grouppin::Application::ENGINE

			StanfordCoreNLP.use :english

			open('app/assets/images/image.jpg', 'wb') do |file|
			  	file << paperclip_file.read
			end
			text = e.text_for('app/assets/images/image.jpg')
			@extracted = text


			pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
			text = StanfordCoreNLP::Annotation.new(text)
			pipeline.annotate(text)
			tmp = []
			# prev = false
			# current = []
			text.get(:sentences).each do |sentence|
				# Syntatical dependencies
				sentence.get(:tokens).each do |token|
			    	time = token.get(:named_entity_tag).to_s
			    	# # Named entity tag
				    if time == 'TIME' or time == 'DATE'
				    	time_info = token.get(:lemma).to_s
				    	tmp.push(time_info)
				    # 	current.push(time_info)
				    # 	prev = true
				    # elsif prev = true
				    # 	prev = false
				    # 	if not current.empty?
				    #  		tmp.push(current)
				    #  	end
				    # 	current = []
				    end
				end
			end

			# times = []
			time = toTime(tmp.join(" "))
			# for arr in tmp
			# 	time = toTime(arr.join(" "))
			# 	times.push(time)
			# end
			@date_time_info = time
			return time, @extracted
	  	end

		private
		    def poster_params
		  	  params.require(:poster).permit(:image_url, :image_paperclip, :love, :comments, :tesseract_text, :parsed_minute, :parsed_hour, :parsed_day_of_week, :parsed_day_of_month, :parsed_month, :parsed_datetime)
		    end
	end