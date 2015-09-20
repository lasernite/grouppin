class TesseractInformationController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  def index
  	e = Grouppin::Application::ENGINE

	StanfordCoreNLP.use :english

	open('app/assets/images/image.png', 'wb') do |file|
	  file << open('http://www.openoffice.org/marketing/art/galleries/marketing/posters/poster_A3_OOoFreeYourself.png').read
	end
	text = e.text_for('app/assets/images/image.png')
	@extracted = text


	pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
	text = StanfordCoreNLP::Annotation.new(text)
	pipeline.annotate(text)
	tmp = []
	prev = false
	current = []
	text.get(:sentences).each do |sentence|
	  # Syntatical dependencies
	  sentence.get(:tokens).each do |token|
	     time = token.get(:named_entity_tag).to_s
	    # # Named entity tag
	     if time == 'TIME' or time == 'DATE'
	     	time_info = token.get(:lemma).to_s
	     	current.push(time_info)
	     	prev = true
	     elsif prev = true
	     	prev = false
	     	if not current.empty?
	     		tmp.push(current)
	     	end
	     	current = []
	     end
		end
		@date_time_info = tmp
	end
	end
  end