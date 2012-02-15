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
        raise "We should never reach this."
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

  def extract_features(idea_list, keys = [])
    if keys.empty?
      keys = idea_list.reduce([]) { |acc, idea|
        acc << idea.attributes.keys
      }.flatten.uniq
    end
    features = idea_list.map { |idea|
      attributes = idea.attributes.map { |key, val|
        [keys.index(key), val]
      }.sort_by {|k| k[0]}.map { |e| e[1] }
      [attributes, idea.outcome_safe]
    }
    [keys, features]
  end

  def fitted_model(keys = [])
    dimensions, examples = complete_features(keys)
    # need regularization (elastic net?) before adding these terms
    #terms = Matrix.rows examples.map { |example|
    #  example[0] + example[0].permutation(2).to_a.map { |term| term.reduce(1) {|acc,k| acc*k } }
    #}
    terms = Matrix.rows examples.map { |example| example[0] }
    outcomes = Matrix.column_vector(examples.map { |example| example[1] })
    if (terms.t * terms).det == 0
      raise "The determinant is zero.  There's likely no useful information here."
    end
    betas = ((terms.t * terms).inv * terms.t * outcomes).t.to_a.flatten.map { |e|
      e.to_f.round(4)
    }
    [keys, betas]
  end

  def estimate_outcomes(model = nil)
    if model.nil?
      keys, betas = fitted_model
    else
      keys, betas = model
    end
    keys, features = incomplete_features(keys)
    features.map { |idea|
      val = 0
      idea[0].each_with_index { |attribute, i|
        val += betas[i] * attribute
      }
      val
    }
  end

  def complete_features(keys = [])
    extract_features(complete, keys)
  end

  def incomplete_features(keys = [])
    extract_features(incomplete, keys)
  end

  def choose(weather, time)
    keys, betas = fitted_model
    jitter = betas.inject{|sum,x| sum + x }
    outcomes = estimate_outcomes([keys, betas]).each_with_index.map {|k,i|
      [k,i]
    }.sort_by {|k| -k[0] + rand(jitter)}
    best = outcomes.first[1]
    incomplete[best]
  end

end