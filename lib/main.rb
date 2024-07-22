class Node
  attr_accessor :value, :left, :right
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @waiting_list = []
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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    @root = insert_recursive(@root, value)
  end
  def delete(value)
    @root = delete_node(@root, value)
  end
  def level_order
    return if @root.nil?
    queue = [@root]
    until queue.empty?
      current_node = queue.shift
      yield current_node if block_given?
      queue << current_node.left if current_node.left
      queue << current_node.right if current_node.right
    end
  end
  private
  def delete_node(root, value)
    return root if root.nil?
    
    if value < root.value
      root.left = delete_node(root.left, value)
    elsif value > root.value
      root.right = delete_node(root.right, value)
    else
      #if root is same as value to be deleted, we've found what we need to delete
      return root.right if root.left.nil?
      return root.left if root.right.nil?
      #node with 2 children
      root.value = min_value(root.right)
      root.right = delete_node(root.right, root.value)
    end
    root
  end
  def min_value(node)
    min_v = node.value
    while node.left
      min_v = node.left.value
      node = node.left
    end
    min_v
  end
  def insert_recursive(node, value)
    return Node.new(value) if node.nil?
  
    if value < node.value
      node.left = insert_recursive(node.left, value)
    elsif value > node.value
      node.right = insert_recursive(node.right, value)
    else
      # Value already exists in the tree, do nothing
      return node
    end
    node
  end

end

array = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
great_eternal_tree = Tree.new(array)

great_eternal_tree.level_order { |node| puts node.value }
  
