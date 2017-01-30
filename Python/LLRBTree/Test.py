# !/usr/bin/python
# -*- coding: utf-8 -*-

from Tree import Tree

__copyright__ = "(c) 2016 E. Adrián Garro S. Costa Rica Institute of Technology."

if __name__ == "__main__":
    tree = Tree()

    seq = [16, 17, 11, 9, 5, 10, 12, 3, 19, 14, 13, 1, 4, 8, 15, 18, 7, 0, 6, 2]
    for i in seq:
        tree.insert(i, i)

    tree.delete(16)
    tree.delete(14)
    tree.delete(2)
    tree.insert(23, 23)

    for i in tree.inorder_walk():
        print(i)

    tree.pretty_print()

    print(tree.is_bst())

    print(tree.is_balanced())

