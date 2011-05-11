DateIdeas.plan do
  
  date "watch primer in north" do
    kind :adventure => 2, :romantic => 4, :intellectual => 6, :athletic => 0
    requires :weather => 0, :hours => 2
    outcome -100
  end
 
date "very close to primer" do
    kind :adventure => 2, :romantic => 4, :intellectual => 6, :athletic => 1
    requires :weather => 0, :hours => 2
  end

date "very far from primer" do
    kind :adventure => 10, :romantic => 10, :intellectual => 0, :athletic => 10
    requires :weather => 0, :hours => 2
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
    kind :adventure => 100, :romantic => 7, :intellectual => 5, :athletic => 1
    requires :weather => 8, :hours => 4
  end
  
end
