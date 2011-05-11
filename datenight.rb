#!/usr/bin/env ruby

$dates = nil

class DateIdeas

  ATTRIBUTES = %w(adventure romantic athletic intellectual)

  def initialize()
    @date_ideas = []
  end
# adds a date to the date_ideas list
  def date(name, &block)
    date = DateIdea.new(name)
    date.instance_eval(&block)
    @date_ideas << date
  end
#prints out date ideas
  def to_s
    str = "Date ideas:\n"
    @date_ideas.each do |f|
      str << "  #{f.to_s}"
    end
    str
  end
#TODO: modify method to produce co-variance 
  def outcome_covariance
    cov = {}

    @date_ideas.each do |idea_a|
	    @date_ideas.each do |idea_b|
		    cov[[idea_a, idea_b]]=0
		    length_a=0
		    length_b=0
		    all_keys=idea_a.attributes.keys
		    all_keys.each do |attribute|
		   	cov[[idea_a, idea_b]]=cov[[idea_a, idea_b]]+idea_a.attributes[attribute]*idea_b.attributes[attribute]
			length_a=length_a+idea_a.attributes[attribute]**2
			length_b=length_b+idea_b.attributes[attribute]**2
		    end
		    
		
		    cov[[idea_a, idea_b]]=(cov[[idea_a, idea_b]]/(Math.sqrt(length_a)))/Math.sqrt(length_b)
		   # puts cov[[idea_a, idea_b]]

	    end
    end

    return cov
  end
#is complete?
  def complete
    @date_ideas.reject { |idea| idea.complete? }
  end
#is incomplete?
  def incomplete
    @date_ideas.reject { |idea| !idea.complete? }
  end
#randomly selects date (TODO: weight)
  def choose(weather, time)
	  #A lot of what i did here was completely arbitrary, feel free to modify
cov=outcome_covariance()
	  prior_weight=0.5
	  sum=0.0
	  
	  date_scores={}

	incomplete.each do |option|
		if option.requirements[:"weather"]<weather && option.requirements[:"hours"]<=time  #refactor
		complete.each do |point|
			value= 1.1**((point.score-5)*cov[[option, point]]*prior_weight) #GENERALIZE
			date_scores[option]=value
			sum+=value
		end
		end
	end

	rand_choice=rand()*sum
#	puts rand_choice
#	puts sum
	incomplete.each do |option|
		if option.requirements[:"weather"]<weather && option.requirements[:"hours"]<=time
		rand_choice-=date_scores[option]
		if(rand_choice<=0)
			return option
		end
		end
	end
end
#makes a new dateIdeas object and adds the plan?
  def self.plan(&block)
    $dates = DateIdeas.new
    $dates.instance_eval(&block)
  end

end

#a particular date idea
class DateIdea

  def initialize(name = "")
    @name = name.to_s
    @attributes = {}
    @requirements = {}
    @outcome = nil
  end

  def kind(args)
    args.each do |field, value|
      @attributes[field] = value
    end
  end

  def requires(args)
    args.each do |field, value|
      @requirements[field] = value
    end
  end

  def outcome(score)
    @outcome = score
  end
  
  def attributes
    @attributes
  end

  def attribute(name)
    @attributes[name]
  end
  
def requirements
	@requirements
end

def name
	@name
end

  def score
    @outcome
  end

  def complete?
    @outcome == nil
  end

  def to_s
    attr_str = @attributes.map { |k,v|
      "#{k}: #{v}"
    }.join(", ")
    date_str = "#{@name}: (#{attr_str})"
    date_str = date_str + ", outcome: #{@outcome}" unless @outcome == nil
    "#{date_str}\n"
  end

end

infile = ARGV[0]
require infile

weather=10
time=24
i=1
while i<ARGV.length do
        command =ARGV[i]
	if command == 'list'
		puts $dates
	elsif command == 'weather'
		i=i+1
		weather=ARGV[i].to_f
	elsif command == 'time'
		i=i+1
		time=ARGV[i].to_f
	else
                 puts "Usage: ./datenight.rb <ideas-file> [weather float] [time float] [list]"
        end
	i=i+1
end	

    date_map={}	
	for i in 0 ..10
		temp=$dates.choose(weather, time)
		if(!date_map.has_key?(temp))
			date_map[temp]=0
		end
     		date_map[temp]=date_map[temp]+1
	end
		date_map.keys.each do |key_val|
		     puts key_val.name
		    puts date_map[key_val] 
		end

#end
