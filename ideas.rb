DateIdeas.plan do

  date "watch primer in north" do
    kind :adventure => 2, :romantic => 4, :intellectual => 6, :athletic => 0
    requires :weather => 0, :hours => 2
    outcome 6
  end

  date "escher in the DiVE" do
    kind :adventure => 4, :romantic => 3, :intellectual => 4, :athletic => 0
    requires :weather => 0, :hours => 2
  end

  date "mushroom hunting" do
    kind :adventure => 6, :romantic => 3, :intellectual => 5, :athletic => 3
    requires :weather => 5, :hours => 2
  end

  date "duke observatory" do
    kind :adventure => 5, :romantic => 7, :intellectual => 5, :athletic => 1
    requires :weather => 8, :hours => 3
  end

  date "learn to ride a bicycle" do
    kind :adventure => 7, :romantic => 3, :intellectual => 2, :athletic => 6
    requires :weather => 8, :hours => 1
  end

  date "watch _serenity_" do
    kind :adventure => 2, :romantic => 4, :intellectual => 5, :athletic => 0
    requires :weather => 0, :hours => 2
  end

  date "watch _thank you for smoking_" do
    kind :adventure => 2, :romantic => 4, :intellectual => 5, :athletic => 0
    requires :weather => 0, :hours => 2
  end

  date "learn to ice skate" do
    kind :adventure => 7, :romantic => 4, :intellectual => 2, :athletic => 6
    requires :weather => 4, :hours => 3
  end

end
