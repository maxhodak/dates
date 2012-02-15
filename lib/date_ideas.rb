class DateIdeas

  ATTRIBUTES = %w(adventure romantic athletic intellectual)

  def initialize(&block)
    @date_ideas = []
    instance_eval &block
  end

  def ideas
    @date_ideas
  end

  def date(name, &block)
    date = DateIdea.new(name)
    if block
      date.instance_eval(&block)
    end
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

  def to_s
    render
  end

  def complete
    @date_ideas.reject { |idea| idea.stub? or not idea.complete? }
  end

  def incomplete
    @date_ideas.reject { |idea| idea.stub? or idea.complete? }
  end

  def extract_features(idea_list)
    keys = idea_list.reduce([]) { |acc, idea|
      acc << idea.attributes.keys
    }.flatten.uniq
    features = idea_list.map { |idea|
      attributes = idea.attributes.map { |key, val|
        [keys.index(key), val]
      }.sort_by {|k| k[0]}.map { |e| e[1] }
      [attributes, idea.outcome_safe]
    }
    [keys, features]
  end

  def fitted_model
    dimensions, examples = complete_features
    terms = examples.map { |examples|
      examples[0] + examples[0].permutation(2).to_a.map { |term| term.reduce(1) {|acc,k| acc*k } }
    }
    
    puts terms.inspect
  end

  def complete_features
    extract_features(complete)
  end

  def incomplete_features
    extract_features(incomplete)
  end

  def choose(weather, time)
    fitted_model
    incomplete.first
  end

end