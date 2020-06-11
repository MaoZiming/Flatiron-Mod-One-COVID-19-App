# Graph data

class Grapher
    def graph
        graph1 = Scruffy::Graph.new
        graph1.add(:line, 'US', [100, -20, 30, 60])
        graph1.render
    end
end