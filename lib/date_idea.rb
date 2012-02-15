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

  def outcome(score = nil)
    if score.nil?
      @outcome
    else
      @outcome = score
    end
  end

  def outcome_safe
    return @outcome unless @outcome.nil?
    -1
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

  def stub?
    @attributes.empty?
  end

  def complete?
    not @outcome.nil?
  end

  def to_s
    attr_str = @attributes.map { |k,v| "#{k}: #{v}" }.join(", ")
    date_str = "#{@name}: (#{attr_str})"
    date_str = date_str + ", outcome: #{@outcome}" unless @outcome.nil?
    "#{date_str}\n"
  end

end