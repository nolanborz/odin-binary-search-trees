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
  
  def depth(node)
    return nil if find(node).nil?
    current_node = @root
    count = 0
    until current_node.value == node
      if node < current_node.value
        current_node = current_node.left
        count += 1
      elsif node > current_node.value
        current_node = current_node.right
        count += 1
      else
        return nil
      end
    end
    count
  end

  def reorder
    values = []
    inorder { |value| values << value if !value.nil? }
    @root = build_tree(values)
  end

  def inorder(node = @root, &block)
    return if node.nil?
    inorder(node.left, &block)
    yield node.value if block_given?
    inorder(node.right, &block)
  end

  def preorder(node = @root, &block)
    return if node.nil?
    yield node.value if block_given?
    preorder(node.left, &block)
    preorder(node.right, &block)
  end

  def postorder(node = @root, &block)
    return if node.nil?
    postorder(node.right, &block)
    postorder(node.left, &block)
    yield node.value if block_given?
  end

  def height(node_or_value = @root)
    node = node_or_value.is_a?(Integer) ? find(node_or_value) : node_or_value
    return -1 if node.nil?
    
    left_height = height(node.left)
    right_height = height(node.right)
    
    1 + [left_height, right_height].max
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
    node
  end

  def find(value)
    current_node = @root
    while current_node
      if value < current_node.value
        current_node = current_node.left
      elsif value > current_node.value
        current_node = current_node.right
      else
        return current_node
      end
    end
    nil
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
  def balanced?
    is_balanced?(@root)[0]
  end

  private

  def is_balanced?(node)
    return [true, -1] if node.nil?
    
    left_result = is_balanced?(node.left)
    return [false, 0] unless left_result[0]
    
    right_result = is_balanced?(node.right)
    return [false, 0] unless right_result[0]
    
    is_balanced = (left_result[1] - right_result[1]).abs <= 1
    height = 1 + [left_result[1], right_result[1]].max
    
    [is_balanced, height]
  end


  def delete_node(root, value)
    return root.value if root.nil?
    
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

great_eternal_tree = Tree.new((Array.new(15) { rand(1..100) }))
great_eternal_tree = Tree.new(array)
#puts great_eternal_tree.balanced?
new_arr = []
#puts great_eternal_tree.level_order { |node| puts node.value }
#great_eternal_tree.preorder { |value| new_arr << value }
#great_eternal_tree.postorder { |value| new_arr << value }
#great_eternal_tree.inorder { |value| new_arr << value }


#puts great_eternal_tree.find(3)
#greater_forever_tree = Tree.new(array)
great_eternal_tree.insert(103)

#great_eternal_tree.reorder
#puts great_eternal_tree.balanced?
#great_eternal_tree.postorder { |value| puts "#{value} " }
#puts great_eternal_tree.depth(67)
great_eternal_tree.pretty_print

