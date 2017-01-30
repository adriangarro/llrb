# Tree.jl: Based on Sedgewick's "Left-leaning Red-Black Tree".

# Red-black trees are binary search trees obeying two key invariants:
# 1) All paths from root to leaf have same number of black nodes.
# 2) Red nodes always have black children.

# (c) 2016 E. Adrián Garro S. Costa Rica Institute of Technology.

import Base.isempty

RED = true
BLACK = false

"""
Tree helper node data type.
"""
type Node{Key, Value}
	# key
	key::Key
	# associated data
	value::Value
	# color of parent link
	color::Bool
	# link to left subtree
	left::Nullable{Node{Key, Value}}
	# link to right subtree
	right::Nullable{Node{Key, Value}}
	# constructor
	function Node(key::Key, value::Value, color::Bool) 
		new(
			key, value, color, 
			Nullable{Node{Key, Value}}(),
			Nullable{Node{Key, Value}}()
		)
	end
end

"""
Tree structure.
"""
type Tree{Key, Value}
	# root of the Tree
	root::Nullable{Node{Key, Value}}
	function Tree()
	  new(Nullable{Node{Key, Value}}())
	end
end

"""
Check if color of node x is red.
"""
function isred{Key, Value}(x::Nullable{Node{Key, Value}})
	if isnull(x)
		false
	else
		get(x).color == RED
	end
end

"""
Is tree t empty?
"""
function isempty{Key, Value}(t::Tree{Key, Value})
	isnull(t.root)
end

"""
Returns the value associated with the given key.
return error if the search returns a null node.
"""
function search{Key, Value}(t::Tree{Key, Value}, key::Key)
	result = search(t.root, key)
	if isnull(result)
		error("Key not found.")
	end
	get(result)
end


"""
Value associated with the given key in subtree rooted at x;
null value if no such key.
"""
function search{Key, Value}(x::Nullable{Node{Key, Value}}, key::Key)
	while !isnull(x) && key != get(x).key
		if key < get(x).key
			x = get(x).left
		else
			x = get(x).right
		end
	end		
	if isnull(x)
		return Nullable{Value}()
	else
		return Nullable(get(x).value)
	end
end


"""
Does this tree contain the given key?
"""
function contains{Key, Value}(t::Tree{Key, Value}, key::Key)
	!isnull(search(t.root, key))
end


"""
Inserts the specified key-value pair into the tree,
overwriting the old value with the new value if the
tree already contains the specified key.
"""
function insert!{Key, Value}(t::Tree{Key, Value}, key::Key, value::Value)
	t.root = insert!(t.root, key, value)
	get(t.root).color = BLACK
end


"""
Insert the key-value pair in the subtree rooted at h.
"""
function insert!{Key, Value}(h::Nullable{Node{Key, Value}}, key::Key, value::Value)
	if isnull(h)
		Nullable(Node{Key, Value}(key, value, RED))
	else
		if key < get(h).key
			get(h).left = insert!(get(h).left, key, value)
		elseif key > get(h).key
			get(h).right = insert!(get(h).right, key, value)
		else
			get(h).value = value
		end
		# fix-up any right-leaning links
		if isred(get(h).right) && !isred(get(h).left)
			h = rotate_left(h)
		end	
		if isred(get(h).left) && isred(get(get(h).left).left)
			h = rotate_right(h)
		end	
		if isred(get(h).left) && isred(get(h).right)
			flip_colors!(h)
		end	
		h	
	end	
end

"""
Removes the smallest key and associated value from the tree.
error if the tree is empty.
"""
function delete_min!{Key, Value}(t::Tree{Key, Value})
	if isempty(t)
		error("BST underflow.")
	end	
	# if both children of root are black, set root to red
	if !isred(get(t.root).left) && !isred(get(t.root).right)
		get(t.root).color = RED
	end	
	t.root = delete_min!(t.root)
	if !isempty(t)
		get(t.root).color = BLACK
	end	
end		
		
		
"""
delete! the key-value pair with the minimum key rooted at h.
"""
function delete_min!{Key, Value}(h::Nullable{Node{Key, Value}})
	if !isnull(get(h).left)
		if !isred(get(h).left) && !isred(get(get(h).left).left)
			h = move_red_left(h)
		end	
		get(h).left = delete_min!(get(h).left)
		balance(h)
	end	
end		

"""
Removes the specified key and its associated value
from this tree (if the key is in this tree).
error if key is not in tree.
"""
function delete!{Key, Value}(t::Tree{Key, Value}, key::Key)
	if !contains(t, key)
		error("Key not found.")
	end	
	# if both children of root are black, set root to red
	if !isred(get(t.root).left) && !isred(get(t.root).right)
		get(t.root).color = RED
	end	
	t.root = delete!(t.root, key)
	if !isempty(t)
		get(t.root).color = BLACK
	end	
end		


"""
delete! the key-value pair with the given key rooted at h.
"""
function delete!{Key, Value}(h::Nullable{Node{Key, Value}}, key::Key)
	if key < get(h).key
		if !isred(get(h).left) && !isred(get(get(h).left).left)
			h = move_red_left(h)
		end	
		get(h).left = delete!(get(h).left, key)
	else
		if isred(get(h).left)
			h = rotate_right(h)
		end	
		if key == get(h).key && isnull(get(h).right)
			return Nullable{Node{Key, Value}}()
		end	
		if !isred(get(h).right) && !isred(get(get(h).right).left)
			h = move_red_right(h)
		end	
		if key == get(h).key
			x = min(get(h).right)
			get(h).key = get(x).key
			get(h).value = get(x).value
			get(h).right = delete_min!(get(h).right)
		else
			get(h).right = delete!(get(h).right, key)
		end
	end		
	balance(h)
end	

"""
Delete all nodes from tree.
"""
function clear!{Key, Value}(t::Tree{Key, Value})
	clear!(t.root)
	t.root = Nullable{Node{Key, Value}}()
end	

function clear!{Key, Value}(x::Nullable{Node{Key, Value}})
	if !isnull(x)
		# recurse: visit all nodes in the two subtrees.
		clear!(get(x).left)
		clear!(get(x).right)
		# after both subtrees have been visited,
		# set links of this node to None
		get(x).left = Nullable{Node{Key, Value}}()
		get(x).right = Nullable{Node{Key, Value}}()
	end
end		

"""
Make a left-leaning link lean to the right.
"""
function rotate_right{Key, Value}(h::Nullable{Node{Key, Value}})
	x = get(h).left
	get(h).left = get(x).right
	get(x).right = h
	get(x).color = get(get(x).right).color
	get(get(x).right).color = RED
	x
end

"""
Make a right-leaning link lean to the left.
"""
function rotate_left{Key, Value}(h::Nullable{Node{Key, Value}})
	x = get(h).right
	get(h).right = get(x).left
	get(x).left = h
	get(x).color = get(get(x).left).color
	get(get(x).left).color = RED
	x
end

"""
Flip the colors of a node and its two children,
h must have opposite color of its two children.
"""
function flip_colors!{Key, Value}(h::Nullable{Node{Key, Value}})
	get(h).color = !get(h).color
	get(get(h).left).color = !get(get(h).left).color
	get(get(h).right).color = !get(get(h).right).color
end

"""
Assuming that h is red and both h.left and h.left.left
are black, make h.left or one of its children red.
"""
function move_red_left{Key, Value}(h::Nullable{Node{Key, Value}})
	flip_colors!(h)
	if isred(get(get(h).right).left)
		get(h).right = rotate_right(get(h).right)
		h = rotate_left(h)
		flip_colors!(h)
	end	
	h
end	
	
	
"""
Assuming that h is red and both h.right and h.right.left
are black, make h.right or one of its children red.
"""
function move_red_right{Key, Value}(h::Nullable{Node{Key, Value}})
	flip_colors!(h)
	if isred(get(get(h).left).left)
		h = rotate_right(h)
		flip_colors!(h)
	end	
	h
end	

"""
Restore red-black tree invariant.
"""
function balance{Key, Value}(h::Nullable{Node{Key, Value}})
	if isred(get(h).right)
		h = rotate_left(h)
	end	
	if isred(get(h).left) && isred(get(get(h).left).left)
		h = rotate_right(h)
	end	
	if isred(get(h).left) && isred(get(h).right)
		flip_colors!(h)
	end	
	h
end	

"""
Returns the smallest key in the tree,
error if the tree is empty.
"""
function min{Key, Value}(t::Tree{Key, Value})
	if isempty(t)
		error("Called min with empty tree.")
	end	
	get(min(t.root)).key
end	
	
	
"""
Node with smallest key in subtree rooted at x;
"""
function min{Key, Value}(x::Nullable{Node{Key, Value}})
	while !isnull(get(x).left)
		x = get(x).left
	end	
	x
end

"""
Returns the biggest key in the tree,
error if the tree is empty.
"""
function max{Key, Value}(t::Tree{Key, Value})
	if isempty(t)
		error("Called max with empty tree.")
	end	
	get(max(t.root)).key
end	
	
	
"""
Node with biggest key in subtree rooted at x;
"""
function max{Key, Value}(x::Nullable{Node{Key, Value}})
	while !isnull(get(x).right)
		x = get(x).right
	end	
	x
end
			
function inorderwalk{Key, Value}(t::Tree{Key, Value})
	inorderwalk(t.root)
end

function inorderwalk{Key, Value}(x::Nullable{Node{Key, Value}})
	s = []
	while !isempty(s) || !isnull(x)
		if !isnull(x)
			push!(s, x)
			x = get(x).left
		else
			x = pop!(s)
			produce(get(x).value)
			x = get(x).right
		end
	end	
end

function preorderwalk{Key, Value}(t::Tree{Key, Value})
	preorderwalk(t.root)
end

function preorderwalk{Key, Value}(x::Nullable{Node{Key, Value}})
	if !isnull(x)
		depth = 0
		s = []
		push!(s, (x, depth))
		while !isempty(s)
			node_and_depth = pop!(s)
			x = node_and_depth[1]
			depth = node_and_depth[2]
			produce(node_and_depth)
			if !isnull(get(x).right)
				push!(s, (get(x).right, depth + 1))
			end	
			if !isnull(get(x).left)
				push!(s, (get(x).left, depth + 1))
			end
		end
	end
end	

function prettyprint{Key, Value}(t::Tree{Key, Value})
	prettyprint(t.root, 0)
end

function prettyprint{Key, Value}(h::Nullable{Node{Key, Value}}, depth::Int64)
	for (node, depth) in @task preorderwalk(h)
		print("  " ^ depth)
		print("+-")
		if get(node).color == RED
			println(
				string("\033[91m", string(
						string(get(node).value), "\033[0m"
					)
				)
			)
		else
			println(
				string("\033[90m", string(
						string(get(node).value), "\033[0m"
					)
				)
			)
		end	
	end
end

"""
Returns true if a binary tree is a binary search tree.
"""
function isbst{Key, Value}(t::Tree{Key, Value})
	if !isempty(t)
		minkey = min(t)
		maxkey = max(t)
		isbst(t.root, minkey, maxkey)
	else
		true
	end
end

"""
Returns true if a binary tree is a binary search tree.
"""
function isbst{Key, Value}(x::Nullable{Node{Key, Value}}, minkey::Key, maxkey::Key)
	if isnull(x)
		return true
	end	
	if get(x).key < minkey
		return false
	end	
	if get(x).key > maxkey
		return false
	end	
	isbst(get(x).left, minkey, get(x).key) && isbst(get(x).right, get(x).key, maxkey)
end	

"""
Do all paths from x to leaf have same number of black nodes?
"""
function isbalanced{Key, Value}(t::Tree{Key, Value})
	# number of black links on path from root to min.
	blacklinks = 0
	x = t.root
	while !isnull(x)
		if !isred(x)
			blacklinks += 1
		end
		x = get(x).left
	end	
	isbalanced(t.root, blacklinks)
end

"""
Do all paths from x to leaf have same number of black nodes?
"""
function isbalanced{Key, Value}(x::Nullable{Node{Key, Value}}, blacklinks::Int64)
	if isnull(x)
		return blacklinks == 0
	end	
	if !isred(x)
		blacklinks -= 1
	end	
	isbalanced(get(x).left, blacklinks) && isbalanced(get(x).right, blacklinks)
end
