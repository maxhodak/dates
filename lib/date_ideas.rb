class DateIdeas

  ATTRIBUTES = %w(adventure romantic athletic intellectual)

  def initialize()
    @date_ideas = []
  end

  def ideas
    @date_ideas
  end

  # adds a date to the date_ideas list
  def date(name, &block)
    date = DateIdea.new(name)
    date.instance_eval(&block)
    @date_ideas << date
  end

  def list(opts)
    if opts[:complete]
      render complete
    elsif opts[:incomplete]
      render incomplete
    else
      render
    end
  end

  def render(ideas = nil)
    if nil == ideas
      ideas = @date_ideas
    end
    str = "Date ideas:\n"
    ideas.each do |f|
      if not f.complete?
        str << "  #{f.to_s}".blue
      elsif f.complete? and f.score >= 6.0
        str << "  #{f.to_s}".green
      elsif f.complete? and f.score < 6.0
        str << "  #{f.to_s}".red
      else
        raise Exception("We should never reach this.")
      end
    end
    str
  end

  #prints out date ideas
  def to_s
    render
  end

  #TODO: modify method to produce co-variance 
  def outcome_covariance
    cov = {}

    @date_ideas.each do |idea_a|
      @date_ideas.each do |idea_b|
        cov[[idea_a, idea_b]] = 0
        length_a = 0
        length_b = 0
        all_keys = idea_a.attributes.keys
        all_keys.each do |attribute|
          cov[[idea_a, idea_b]] = cov[[idea_a, idea_b]] + idea_a.attributes[attribute] * idea_b.attributes[attribute]
          length_a = length_a + idea_a.attributes[attribute] ** 2
          length_b = length_b + idea_b.attributes[attribute] ** 2
        end

        cov[[idea_a, idea_b]] = (cov[[idea_a, idea_b]]/(Math.sqrt(length_a)))/Math.sqrt(length_b)
        # puts cov[[idea_a, idea_b]]

      end
    end

    cov
  end

  def complete
    @date_ideas.reject { |idea| !idea.complete? }
  end

  def incomplete
    @date_ideas.reject { |idea| idea.complete? }
  end

  #randomly selects date (TODO: weight)
  def choose(weather, time)

    cov = outcome_covariance()
    prior_weight = 0.5
    sum = 0.0

    date_scores = {}

    incomplete.each do |option|
      if option.requirements[:weather] < weather && option.requirements[:hours] <= time  #refactor
        complete.each do |point|
          value = 1.1**((point.score-5)*cov[[option, point]]*prior_weight) #GENERALIZE
          date_scores[option] = value
          sum += value
        end
      end
    end

    rand_choice=rand()*sum
    #  puts rand_choice
    #  puts sum
    incomplete.each do |option|
      if option.requirements[:weather] < weather && option.requirements[:hours] <= time
        rand_choice -= date_scores[option]
        if(rand_choice <= 0)
          return option # this probably doesn't do what you think it does.
        end
      end
    end
  end

  def self.plan(&block)
    $dates = DateIdeas.new
    $dates.instance_eval(&block)
  end

end