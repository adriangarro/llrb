package Tree

import scala.annotation.tailrec

/**
  * Based on Sedgewick's "Left-leaning Red-Black Tree".
  * Copyright 2016, Elberth Adrián Garro Sánchez.
  *
  * Red-black trees are binary search trees obeying two key invariants:
  * 1) All paths from root to leaf have same number of black nodes.
  * 2) Red nodes always have black children.
  **/
class Tree[Key, Value] (implicit cmp : Key => Ordered[Key]) {
	private val RED: Boolean = true
	private val BLACK: Boolean = false

	// root of the Tree
	private var root: Option[Node] = None

	// tree helper node data type
	class Node(var key: Key, var value: Value, var color: Boolean) {
		// links to left and right subtrees
		var left: Option[Node] = None
		var right: Option[Node] = None
	}

	/*
	 * Check if color of node x is red.
	 **/
	private def isRed(x: Option[Node]): Boolean = x match {
		case None => false
		case _ => x.get.color == RED
	}

	/**
	  * Is this tree empty?
	  * @return true if this tree is empty and false otherwise.
	  **/
	private def isEmpty: Boolean = this.root.isEmpty

	/**
	  * Returns the value associated with the given key.
	  * @param key the key
	  * @return the Node associated with the given key if the key is in the tree
	  *         and None if the key is not in the tree.
	  * @throws Exception if the search returns None.
	  **/
	def search(key: Key): Value = {
		val result = search(this.root, key)
		result match {
			case None => throw new Exception("Key not found.")
			case _ => result.get
		}
	}

	/**
	  * Value associated with the given key in subtree rooted at x;
	  * None if no such key.
	  **/
	@tailrec
	private def search(x: Option[Node], key: Key): Option[Value] = x match {
		case None => None
		case _ =>
			if (key == x.get.key)
				Some(x.get.value)
			else if (key < x.get.key)
				search(x.get.left, key)
			else
				search(x.get.right, key)
	}

	/**
	  * Does this tree contain the given key?
	  * @param key the key
	  * @return true if this tree contains key and false otherwise.
	  **/
	private def contains(key: Key): Boolean = search(this.root, key).isDefined
	
	/**
	  * Inserts the specified key-value pair into the tree, overwriting the old
	  * value with the new value if the tree already contains the specified key.
	  * @param key the key
	  * @param value the value
	  **/
	def insert(key: Key, value: Value) {
		this.root = insert(this.root, key, value)
		this.root.get.color = BLACK
	}

	/**
	  * Insert the key-value pair in the subtree rooted at h.
	  **/
	private def insert(x: Option[Node], key: Key, value: Value): Option[Node] = x match {
		case None => Some(new Node(key, value, RED))
		case _ =>
			var h = x
			if (key < h.get.key)
				h.get.left = insert(h.get.left, key, value)
			else if (key > h.get.key)
				h.get.right = insert(h.get.right, key, value)
			else
				h.get.value = value
			// fix-up any right-leaning links
			if (isRed(h.get.right) && !isRed(h.get.left))
				h = rotateLeft(h)
			if (isRed(h.get.left) && isRed(h.get.left.get.left))
				h = rotateRight(h)
			if (isRed(h.get.left) && isRed(h.get.right))
				flipColors(h)
			h
	}

	/**
	  * Removes the smallest key and associated value from the tree.
	  * @throws Exception if the tree is empty.
	  **/
	def deleteMin(): Unit = isEmpty match {
		case true => throw new Exception("BST underflow.")
		case false =>
			// if both children of root are black, set root to red
			if (!isRed(this.root.get.left) && !isRed(this.root.get.right))
				this.root.get.color = RED
			this.root = deleteMin(this.root)
			if (!isEmpty) this.root.get.color = BLACK
	}

	/**
	  * Delete the key-value pair with the minimum key rooted at h.
	  **/
	private def deleteMin(x: Option[Node]): Option[Node] = x.get.left match {
		case None => None
		case _ =>
			var h = x
			if (!isRed(h.get.left) && !isRed(h.get.left.get.left))
				h = moveRedLeft(h)
			h.get.left = deleteMin(h.get.left)
			balance(h)
	}

	/**
	  * Removes the specified key and its associated value from this tree
	  * (if the key is in this tree).
	  * @param  key the key
	  * @throws Exception if key is not in tree.
	  **/
	def delete(key: Key):Unit = contains(key) match {
		case false => throw new Exception("Key not found.")
		case true =>
			// if both children of root are black, set root to red
			if (!isRed(this.root.get.left) && !isRed(this.root.get.right))
				this.root.get.color = RED
			this.root = delete(this.root, key)
			if (!isEmpty)
				this.root.get.color = BLACK
	}

	/**
	  * Delete the key-value pair with the given key rooted at h.
	  **/
	private def delete(x: Option[Node], key: Key): Option[Node] = {
		var h = x
		if (key < h.get.key) {
			if (!isRed(h.get.left) && !isRed(h.get.left.get.left))
				h = moveRedLeft(h)
			h.get.left = delete(h.get.left, key)
		}
		else {
			if (isRed(h.get.left))
				h = rotateRight(h)
			if (key == h.get.key && h.get.right.isEmpty)
				return None
			if (!isRed(h.get.right) && !isRed(h.get.right.get.left))
				h = moveRedRight(h)
			if (key == h.get.key) {
				val x: Option[Node] = min(h.get.right)
				h.get.key = x.get.key
				h.get.value = x.get.value
				h.get.right = deleteMin(h.get.right)
			}
			else
				h.get.right = delete(h.get.right, key)
		}
		balance(h)
	}

	/**
	  * Delete all nodes from tree.
	  **/
	def clear(): Unit = {
		clear(this.root)
		this.root = None
	}

	private def clear(x: Option[Node]): Unit =  x match {
		case None => None
		case _ =>
			// recurse: visit all nodes in the two subtrees
			clear(x.get.left)
			clear(x.get.right)
			// after both subtrees have been visited,
			// set links of this node to None
			x.get.left = None
			x.get.right = None
	}

	/**
	  * Make a left-leaning link lean to the right.
	  **/
	private def rotateRight(h: Option[Node]): Option[Node] = {
		val x: Option[Node] = h.get.left
		h.get.left = x.get.right
		x.get.right = h
		x.get.color = x.get.right.get.color
		x.get.right.get.color = RED
		x
	}

	/**
	  * Make a right-leaning link lean to the left.
	  **/
	private def rotateLeft(h: Option[Node]): Option[Node] = {
		val x: Option[Node] = h.get.right
		h.get.right = x.get.left
		x.get.left = h
		x.get.color = x.get.left.get.color
		x.get.left.get.color = RED
		x
	}

	/**
	  * Flip the colors of a node and its two children,
	  * h must have opposite color of its two children.
	  **/
	private def flipColors(h: Option[Node]): Unit = {
		h.get.color = !h.get.color
		h.get.left.get.color = !h.get.left.get.color
		h.get.right.get.color = !h.get.right.get.color
	}

	/**
	  * Assuming that h is red and both h.left and h.left.left
	  * are black, make h.left or one of its children red.
	  **/
	private def moveRedLeft(x: Option[Node]): Option[Node] = {
		var h = x
		flipColors(h)
		if (isRed(h.get.right.get.left)) {
			h.get.right = rotateRight(h.get.right)
			h = rotateLeft(h)
			flipColors(h)
		}
		h
	}

	/**
	  * Assuming that h is red and both h.right and h.right.left
	  * are black, make h.right or one of its children red.
	  **/
	private def moveRedRight(x: Option[Node]): Option[Node] = {
		var h = x
		flipColors(h)
		if (isRed(h.get.left.get.left)) {
			h = rotateRight(h)
			flipColors(h)
		}
		h
	}

	/**
	  * Restore red-black tree invariant.
	  **/
	private def balance(x: Option[Node]): Option[Node] = {
		var h = x
		if (isRed(h.get.right))
			h = rotateLeft(h)
		if (isRed(h.get.left) && isRed(h.get.left.get.left))
			h = rotateRight(h)
		if (isRed(h.get.left) && isRed(h.get.right))
			flipColors(h)
		h
	}

	/**
	  * Returns the smallest key in the tree.
	  *
	  * @return the smallest key in the tree.
	  * @throws Exception if the tree is empty.
	  **/
	def min: Key = {
		if (isEmpty)
			throw new Exception("Called min with empty tree.")
		min(this.root).get.key
	}

	/**
	  * Node with smallest key in subtree rooted at x;
	  * None if no such key.
	  **/
	@tailrec
	private def min(x: Option[Node]): Option[Node] = {
		if (x.get.left.isEmpty) x
		else min(x.get.left)
	}

	/**
	  * Returns the biggest key in the tree.
	  *
	  * @return the smallest key in the tree.
	  * @throws Exception if the tree is empty.
	  **/
	def max: Key = {
		if (isEmpty)
			throw new Exception("Called max with empty tree.")
		max(this.root).get.key
	}

	/**
	  * Node with biggest key in subtree rooted at x;
	  * None if no such key.
	  **/
	@tailrec
	private def max(x: Option[Node]): Option[Node] = {
		if (x.get.right.isEmpty) x
		else max(x.get.right)
	}

	def inorderWalk: Iterator[Value] = inorderWalk(this.root)

	private def inorderWalk(h: Option[Node]): Iterator[Value] = h match {
		case None => Iterator()
		case _ => inorderWalk(h.get.left) ++ Iterator(h.get.value) ++ inorderWalk(h.get.right)
	}

	def prettyPrint(): Unit = {
		prettyPrint(this.root, 0)
	}

	private def prettyPrint(h: Option[Node], depth: Integer): Unit = h match {
		case None => None
		case _ =>
			print("  " * depth)
			print("+-")
			h.get.color match {
				case RED => println(Console.RED + h.get.value + Console.RESET)
				case _ => println(Console.BLACK + h.get.value + Console.RESET)
			}
			prettyPrint(h.get.left, depth + 1)
			prettyPrint(h.get.right, depth + 1)
	}

	/**
	  * Returns true if a binary tree is a binary search tree.
	  * */
	def isBST: Boolean = isEmpty match {
		case true => true
		case false =>
			val minKey = min
			val maxKey = max
			isBST(this.root, minKey, maxKey)
	}

	/**
	  * Returns true if a binary tree is a binary search tree.
	  * */
	private def isBST(x: Option[Node], min: Key, max: Key): Boolean = x match {
		case None => true
		case _ =>
			if (x.get.key < min) return false
			if (x.get.key > max) return false
			isBST(x.get.left, min, x.get.key) && isBST(x.get.right, x.get.key, max)
	}

	/**
	  * Do all paths from root to leaf have same number of black edges?
	  **/
	def isBalanced: Boolean = {
		// number of black links on path from root to min.
		var blackLinks: Int = 0
		var x = this.root
		while (x.isDefined) {
			if (!isRed(x)) {
				blackLinks += 1
			}
			x = x.get.left
		}
		isBalanced(this.root, blackLinks)
	}

	/**
	  * Do all paths from x to leaf have same number of black nodes?
	  **/
	private def isBalanced(x: Option[Node], blackLinks: Int): Boolean = {
		var blackLinksAux = blackLinks
		if (x.isEmpty) return blackLinksAux == 0
		if (!isRed(x)) {
			blackLinksAux -= 1
		}
		isBalanced(x.get.left, blackLinksAux) && isBalanced(x.get.right, blackLinksAux)
	}
}
