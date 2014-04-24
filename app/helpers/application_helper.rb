module ApplicationHelper

  def group_for_graph(count_hash, top_count = 5, show_other = true)
    @data = Hash[count_hash.sort_by {|_, v| v}.reverse]
    @others = @data
    @data.first(top_count).each do |genre|
      @others = @others.except(genre.first)
    end
    if @others.count > 1 && show_other
      @data = @data.first(top_count).push(["Others", 0])
      @others.to_a.each do |other|
        @other = @data.pop
        @other[1] += other.last
        @data.push(@other)
      end
    end
    @data.to_a
  end
end
