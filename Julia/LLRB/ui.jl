# User interaction with RBTree.

# (c) E. Adrian Garro S. Costa Rica Institute of Technology.

include("tree.jl")

type UI
	option::String
	tree_num::Tree{Int64, Int64} 
	tree_str::Tree{String, String}
end

"""
`input(prompt::AbstractString="")`

Read a string from STDIN. The trailing newline is stripped.

The prompt string, if given, is printed to standard output without a
trailing newline before reading input.
"""
function input(prompt::AbstractString="")
	print(prompt)
	return chomp(readline())
end

"""
`int_input(prompt::AbstractString="")`

Use input function to get integers from user.
"""
function int_input(string_num::AbstractString)
	possible_int = input(string_num)
	parse(Int, possible_int)
end

function read_option(app::UI)
	println("")
	println("--------(Red Black Tree)---------")
	println("     1) Clear tree numbers.")
	println("     2) Clear tree strings.")
	println("     3) Insert number.")
	println("     4) Insert string.")
	println("     5) Delete number.")
	println("     6) Delete string.")
	println("     7) Search number.")
	println("     8) Search string.")
	println("     9) Print inorder tree numbers.")
	println("     10) Print inorder tree strings.")
	println("     11) Pretty print tree numbers.")
	println("     12) Pretty print tree strings.")
	println("     0) End.")
	println("----------------------------------")
	println("")
	app.option = input("Select an option to continue: ")
end

# Option 1
function clear_tree_num(app::UI)
	clear!(app.tree_num)
	println("The tree has been successfully cleaned!")
end	

# Option 2
function clear_tree_str(app::UI)
	clear!(app.tree_str)
	println("The tree has been successfully cleaned!")
end

# Option 3
function insert_num(app::UI)
	try
		num = int_input("Please enter the number you want insert: ")
		insert!(app.tree_num, num, num)
		println("The number has been successfully inserted!")
	catch e
		println(e)
	end	
end

# Option 4
function insert_str(app::UI)
	string = input("Please enter the string you want insert: ")
	insert!(app.tree_str, string, string)
	println("The string has been successfully inserted!")	
end

# Option 5
function delete_num(app::UI)
	try
		# try read number.
		num_key = int_input("Please enter the number you want delete: ")
		try
			# try delete number.
			delete!(app.tree_num, num_key)
			println("The number has been successfully deleted!")
		catch e
			# case where number key doesn't exist.
			println(e)
		end
	catch e
		# case where user doesn't type a number.
		println(e)
	end	
end

# Option 6
function delete_str(app::UI)
	str_key = input("Please enter the string you want delete: ")
	try
		# try delete string.
		delete!(app.tree_str, str_key)
		println("The string has been successfully deleted!")
	catch e
		# case where string key doesn't exist.
		println(e)
	end	
end

# Option 7
function search_num(app::UI)
	try
		# try read number.
		num_key = int_input("Please enter the number you want search: ")
		try
			# try search number.
			num_val = search(app.tree_num, num_key)
			println(string("The number ", string(string(num_val), " was found!")))
		catch e
			# case where number doesn't exist.
			println(e)
		end	
	catch e
		# case where user doesn't type a number.
		println(e)
	end	
end

# Option 8
function search_str(app::UI)
	str_key = input("Please enter the string you want search: ")
	try
		# try search string.
		str_val = search(app.tree_str, str_key)
		println(string("The string ", string(string(str_val), " was found!")))
	catch e
		# case where string doesn't exist.
		println(e)
	end	
end

# Option 9
function print_inorder_num(app::UI)
	for num in @task inorderwalk(app.tree_num)
		println(num)
	end	
end

# Option 10
function print_inorder_str(app::UI)
	for string in @task inorderwalk(app.tree_str)
		println(string)
	end	
end		

# Option 11
function pretty_print_num(app::UI)
	prettyprint(app.tree_num)
end	

# Option 12
function pretty_print_str(app::UI)
	prettyprint(app.tree_str)
end			

function menu(app::UI)
	if app.option == ""
		true
	elseif app.option == "1"
		clear_tree_num(app::UI)
		true
	elseif app.option == "2"
		clear_tree_str(app::UI)
		true
	elseif app.option == "3"
		insert_num(app::UI)
		true
	elseif app.option == "4"
		insert_str(app::UI)
		true
	elseif app.option == "5"
		delete_num(app::UI)
		true
	elseif app.option == "6"
		delete_str(app::UI)
		true
	elseif app.option == "7"
		search_num(app::UI)
		true
	elseif app.option == "8"
		search_str(app::UI)
		true
	elseif app.option == "9"
		print_inorder_num(app::UI)
		true
	elseif app.option == "10"
		print_inorder_str(app::UI)
		true
	elseif app.option == "11"
		pretty_print_num(app::UI)
		true
	elseif app.option == "12"
		pretty_print_str(app::UI)
		true
	elseif app.option == "0"
		println("Thank you for your time. ;)")
		false
	else
		println("Pick a valid option from menu!")
		true
	end
end
	
function main()
	app = UI("", Tree{Int64, Int64}(), Tree{String, String}())
	while menu(app::UI)
		read_option(app::UI)
	end
end

main()
