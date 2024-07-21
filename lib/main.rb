class Node
  attr_accessor :value, :left, :right
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :arr
  
  def initialize(array)
    @arr = array
    @root = build_tree(array)
  end

  def build_tree(arr, start = 0, last = @arr.length - 1)
    sorted_arr = arr.sort.uniq
    if start > last
      return nil
    end
    mid = (start + last) / 2
    node = Node.new(sorted_arr[mid])
    node.left = build_tree(sorted_arr, start, mid - 1)
    node.right = build_tree(sorted_arr, mid + 1, last)
    return node
  end
end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
great_eternal_tree = Tree.new(array)
puts great_eternal_tree.root
  
