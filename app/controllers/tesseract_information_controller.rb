class TesseractInformationController < ApplicationController
 	skip_before_filter :verify_authenticity_token 
	
	#Uses gem 'chronic'
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


  	def index
	  	e = Grouppin::Application::ENGINE

		StanfordCoreNLP.use :english

		open('app/assets/images/image.png', 'wb') do |file|
		  	file << open('http://www.openoffice.org/marketing/art/galleries/marketing/posters/poster_A3_OOoFreeYourself.png').read
		end
		text = e.text_for('app/assets/images/test_photo.jpg')
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
  	end
end