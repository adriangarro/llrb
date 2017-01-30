# !/usr/bin/python
# -*- coding: utf-8 -*-

"""
UI.py: User interaction with RBTree.
"""

from Tree import Tree

__copyright__ = "(c) 2016 E. Adrián Garro S. Costa Rica Institute of Technology."


class UI:
    def __init__(self):
        self.option = ""
        self.tree_num = Tree()
        self.tree_str = Tree()

    def read_option(self):
        print("\n--------(Red Black Tree)---------")
        print("     1) Clear tree numbers.")
        print("     2) Clear tree strings.")
        print("     3) Insert number.")
        print("     4) Insert string.")
        print("     5) Delete number.")
        print("     6) Delete string.")
        print("     7) Search number.")
        print("     8) Search string.")
        print("     9) Print inorder tree numbers.")
        print("     10) Print inorder tree strings.")
        print("     11) Pretty print tree numbers.")
        print("     12) Pretty print tree strings.")
        print("     0) End.")
        print("----------------------------------\n")
        self.option = input("Select an option to continue: ")

    # Option 1
    def clear_tree_num(self):
        self.tree_num.clear()
        print("The tree has been successfully cleaned!")

    # Option 2
    def clear_tree_str(self):
        self.tree_str.clear()
        print("The tree has been successfully cleaned!")

    # Option 3
    def insert_num(self):
        try:
            num_str = input("Please enter the number you want insert: ")
            num = int(num_str)
            self.tree_num.insert(num, num)
            print("The number has been successfully inserted!")
        except ValueError as verr:
            print(verr)

    # Option 4
    def insert_str(self):
        string = input("Please enter the string you want insert: ")
        self.tree_str.insert(string, string)
        print("The string has been successfully inserted!")

    # Option 5
    def delete_num(self):
        try:
            # try read number.
            str_key = input("Please enter the number you want delete: ")
            num_key = int(str_key)
            try:
                # try delete number.
                self.tree_num.delete(num_key)
                print("The number has been successfully deleted!")
            except IndexError as ierr:
                # case where number doesn't exist.
                print(ierr)
        except ValueError as verr:
            # case where user doesn't type a number.
            print(verr)

    # Option 6
    def delete_str(self):
        str_key = input("Please enter the string you want delete: ")
        try:
            # try delete string.
            self.tree_str.delete(str_key)
            print("The string has been successfully deleted!")
        except IndexError as ierr:
            # case where string doesn't exist.
            print(ierr)

    # Option 7
    def search_num(self):
        try:
            # try read number.
            num_str = input("Please enter the number you want search: ")
            num_key = int(num_str)
            try:
                # try search number.
                num_val = self.tree_num.search(num_key)
                print("The number " + str(num_val) + " was found!")
            except IndexError as ierr:
                # case where number doesn't exist.
                print(ierr)
        except ValueError as verr:
            # case where user doesn't type a number.
            print(verr)

    # Option 8
    def search_str(self):
        str_key = input("Please enter the string you want search: ")
        try:
            # try search string.
            str_val = self.tree_str.search(str_key)
            print("The string " + str_val + " was found!")
        except IndexError as ierr:
            # case where string doesn't exist.
            print(ierr)

    # Option 9
    def print_inorder_num(self):
        for num in self.tree_num.inorder_walk():
            print(num)

    # Option 10
    def print_inorder_str(self):
        for string in self.tree_str.inorder_walk():
            print(string)

    # Option 11
    def pretty_print_num(self):
        self.tree_num.pretty_print()

    # Option 12
    def pretty_print_str(self):
        self.tree_str.pretty_print()

    def menu(self):
        if self.option == "":
            return True
        elif self.option == "1":
            self.clear_tree_num()
            return True
        elif self.option == "2":
            self.clear_tree_str()
            return True
        elif self.option == "3":
            self.insert_num()
            return True
        elif self.option == "4":
            self.insert_str()
            return True
        elif self.option == "5":
            self.delete_num()
            return True
        elif self.option == "6":
            self.delete_str()
            return True
        elif self.option == "7":
            self.search_num()
            return True
        elif self.option == "8":
            self.search_str()
            return True
        elif self.option == "9":
            self.print_inorder_num()
            return True
        elif self.option == "10":
            self.print_inorder_str()
            return True
        elif self.option == "11":
            self.pretty_print_num()
            return True
        elif self.option == "12":
            self.pretty_print_str()
            return True
        elif self.option == "0":
            print("Thank you for your time. ;)")
            return False
        else:
            print("Pick a valid option from menu!")
            return True

    def main(self):
        while self.menu():
            self.read_option()

if __name__ == "__main__":
    app = UI()
    app.main()
