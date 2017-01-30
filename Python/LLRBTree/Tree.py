#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
Tree.py: Based on Sedgewick's "Left-leaning Red-Black Tree".

Red-black trees are binary search trees obeying two key invariants:
1) All paths from root to leaf have same number of black nodes.
2) Red nodes always have black children.
"""

__copyright__ = "(c) 2016 E. Adrián Garro S. Costa Rica Institute of Technology."


class Tree:
    def __init__(self):
        self.red = True
        self.black = False
        # root of the Tree
        self.root = None

    # tree helper node data type
    class Node:
        def __init__(self, key, value, color):
            # key
            self.key = key
            # associated data
            self.value = value
            # color of parent link
            self.color = color
            # link to left subtree
            self.left = None
            # link to right subtree
            self.right = None

    def is_red(self, x):
        """
        Check if color of node x is red.
        """
        if not x:
            return False
        return x.color == self.red

    def is_empty(self):
        """
        Is this tree empty?
        """
        return self.root is None

    def search(self, key):
        """
        Returns the value associated with the given key.
        raise IndexError if the search returns None.
        """
        result = self.search_aux(self.root, key)
        if not result:
            raise IndexError("Key not found.")
        return result

    @staticmethod
    def search_aux(x, key):
        """
        Value associated with the given key in subtree rooted at x;
        None if no such key.
        """
        while x and key != x.key:
            if key < x.key:
                x = x.left
            else:
                x = x.right
        if x:
            return x.value

    def contains(self, key):
        """
        Does this tree contain the given key?
        """
        return self.search_aux(self.root, key) is not None

    def insert(self, key, value):
        """
        Inserts the specified key-value pair into the tree,
        overwriting the old value with the new value if the
        tree already contains the specified key.
        """
        self.root = self.insert_aux(self.root, key, value)
        self.root.color = self.black

    def insert_aux(self, h, key, value):
        """
        Insert the key-value pair in the subtree rooted at h.
        """
        if not h:
            return self.Node(key, value, self.red)
        if key < h.key:
            h.left = self.insert_aux(h.left, key, value)
        elif key > h.key:
            h.right = self.insert_aux(h.right, key, value)
        else:
            h.value = value
        # fix-up any right-leaning links
        if self.is_red(h.right) and not self.is_red(h.left):
            h = self.rotate_left(h)
        if self.is_red(h.left) and self.is_red(h.left.left):
            h = self.rotate_right(h)
        if self.is_red(h.left) and self.is_red(h.right):
            self.flip_colors(h)
        return h

    def delete_min(self):
        """
        Removes the smallest key and associated value from the tree.
        raise RuntimeWarning if the tree is empty.
        """
        if self.is_empty():
            raise RuntimeWarning("BST underflow.")
        # if both children of root are black, set root to red
        if not self.is_red(self.root.left) and not self.is_red(self.root.right):
            self.root.color = self.red
        self.root = self.delete_min_aux(self.root)
        if not self.is_empty():
            self.root.color = self.black

    def delete_min_aux(self, h):
        """
        Delete the key-value pair with the minimum key rooted at h.
        """
        if h.left:
            if not self.is_red(h.left) and not self.is_red(h.left.left):
                h = self.move_red_left(h)
            h.left = self.delete_min_aux(h.left)
            return self.balance(h)

    def delete(self, key):
        """
        Removes the specified key and its associated value
        from this tree (if the key is in this tree).
        raise indexError if key is not in tree.
        """
        if not self.contains(key):
            raise IndexError("Key not found.")
        # if both children of root are black, set root to red
        if not self.is_red(self.root.left) and not self.is_red(self.root.right):
            self.root.color = self.red
        self.root = self.delete_aux(self.root, key)
        if not self.is_empty():
            self.root.color = self.black

    def delete_aux(self, h, key):
        """
        Delete the key-value pair with the given key rooted at h.
        """
        if key < h.key:
            if not self.is_red(h.left) and not self.is_red(h.left.left):
                h = self.move_red_left(h)
            h.left = self.delete_aux(h.left, key)
        else:
            if self.is_red(h.left):
                h = self.rotate_right(h)
            if key == h.key and not h.right:
                return None
            if not self.is_red(h.right) and not self.is_red(h.right.left):
                h = self.move_red_right(h)
            if key == h.key:
                x = self.min_aux(h.right)
                h.key = x.key
                h.value = x.value
                h.right = self.delete_min_aux(h.right)
            else:
                h.right = self.delete_aux(h.right, key)
        return self.balance(h)

    def clear(self):
        """
        Delete all nodes from tree.
        """
        self.clear_aux(self.root)
        self.root = None

    def clear_aux(self, x):
        if x:
            # recurse: visit all nodes in the two subtrees.
            self.clear_aux(x.left)
            self.clear_aux(x.right)
            # after both subtrees have been visited,
            # set links of this node to None
            x.left = None
            x.right = None

    def rotate_right(self, h):
        """
        Make a left-leaning link lean to the right.
        """
        x = h.left
        h.left = x.right
        x.right = h
        x.color = x.right.color
        x.right.color = self.red
        return x

    def rotate_left(self, h):
        """
        Make a right-leaning link lean to the left
        """
        x = h.right
        h.right = x.left
        x.left = h
        x.color = x.left.color
        x.left.color = self.red
        return x

    @staticmethod
    def flip_colors(h):
        """
        Flip the colors of a node and its two children;
        h must have opposite color of its two children.
        """
        h.color = not h.color
        h.left.color = not h.left.color
        h.right.color = not h.right.color

    def move_red_left(self, h):
        """
        Assuming that h is red and both h.left and h.left.left
        are black, make h.left or one of its children red.
        """
        self.flip_colors(h)
        if self.is_red(h.right.left):
            h.right = self.rotate_right(h.right)
            h = self.rotate_left(h)
            self.flip_colors(h)
        return h

    def move_red_right(self, h):
        """
        Assuming that h is red and both h.right and h.right.left
        are black, make h.right or one of its children red.
        """
        self.flip_colors(h)
        if self.is_red(h.left.left):
            h = self.rotate_right(h)
            self.flip_colors(h)
        return h

    def balance(self, h):
        """
        Restore red-black tree invariant.
        """
        if self.is_red(h.right):
            h = self.rotate_left(h)
        if self.is_red(h.left) and self.is_red(h.left.left):
            h = self.rotate_right(h)
        if self.is_red(h.left) and self.is_red(h.right):
            self.flip_colors(h)
        return h

    def min(self):
        """
        Returns the smallest key in the tree,
        raise RuntimeWarning if the tree is empty.
        """
        if self.is_empty():
            raise RuntimeWarning("Called min with empty tree.")
        return self.min_aux(self.root).key

    @staticmethod
    def min_aux(x):
        """
        Node with smallest key in subtree rooted at x.
        """
        while x.left:
            x = x.left
        return x

    def max(self):
        """
        Returns the biggest key in the tree,
        raise RuntimeWarning if the tree is empty.
        """
        if self.is_empty():
            raise RuntimeWarning("Called max with empty tree.")
        return self.max_aux(self.root).key

    @staticmethod
    def max_aux(x):
        """
        Node with biggest key in subtree rooted at x;
        """
        while x.right:
            x = x.right
        return x

    def inorder_walk(self):
        return self.inorder_walk_aux(self.root)

    @staticmethod
    def inorder_walk_aux(x):
        s = list()
        while s or x:
            if x:
                s.append(x)
                x = x.left
            else:
                x = s.pop()
                yield x.value
                x = x.right

    def preorder_walk(self):
        return self.preorder_walk_aux(self.root)

    @staticmethod
    def preorder_walk_aux(x):
        if x:
            depth = 0
            s = list()
            s.append((x, depth))
            while s:
                node_and_depth = s.pop()
                x = node_and_depth[0]
                depth = node_and_depth[1]
                yield node_and_depth
                if x.right:
                    s.append((x.right, depth+1))
                if x.left:
                    s.append((x.left, depth+1))

    def pretty_print(self):
        for node, depth in self.preorder_walk():
            print(depth * "  ", end="")
            print("+-", end="")
            if node.color == self.red:
                print("\033[91m" + str(node.value) + "\033[0m")
            else:
                print("\033[90m" + str(node.value) + "\033[0m")

    def is_bst(self):
        """
        Returns true if a binary tree is a binary search tree.
        """
        if not self.is_empty():
            min_key = self.min()
            max_key = self.max()
            return self.is_bst_aux(self.root, min_key, max_key)
        return True

    def is_bst_aux(self, x, min_key, max_key):
        """
        Returns true if a binary tree is a binary search tree.
        """
        if not x:
            return True
        if x.key < min_key:
            return False
        if x.key > max_key:
            return False
        return (
            self.is_bst_aux(x.left, min_key, x.key)
            and self.is_bst_aux(x.right, x.key, max_key)
        )

    def is_balanced(self):
        """
        Do all paths from x to leaf have same number of black nodes?
        """
        # number of black links on path from root to min.
        black_links = 0
        x = self.root
        while x:
            if not self.is_red(x):
                black_links += 1
            x = x.left
        return self.is_balanced_aux(self.root, black_links)

    def is_balanced_aux(self, x, black_links):
        """
        Do all paths from x to leaf have same number of black nodes?
        """
        if not x:
            return black_links == 0
        if not self.is_red(x):
            black_links -= 1
        return (
            self.is_balanced_aux(x.left, black_links)
            and self.is_balanced_aux(x.right, black_links)
        )
