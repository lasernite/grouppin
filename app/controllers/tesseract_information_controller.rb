class TesseractInformationController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  def index
  	e = Grouppin::Application::ENGINE

	StanfordCoreNLP.use :english

	text = e.text_for('app/assets/images/test_image.jpg')
	@extracted = text

	pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
	text = StanfordCoreNLP::Annotation.new(text)
	pipeline.annotate(text)
	tmp ||= []
	text.get(:sentences).each do |sentence|
	  # Syntatical dependencies
	  sentence.get(:tokens).each do |token|
	     time = token.get(:named_entity_tag).to_s
	    # # Named entity tag
	     if time == 'TIME' or time == 'DATE'
	     	time_info = token.get(:lemma).to_s
	     	tmp.push(time_info)
	    @date_time_info = tmp.join(' ')
		end
	  end
	end
  end
end
