# test.jl
# (c) 2016 E. Adrián Garro S. Costa Rica Institute of Technology.

include("tree.jl")

tree = Tree{Int64, Int64}()

seq = [16, 17, 11, 9, 5, 10, 12, 3, 19, 14, 13, 1, 4, 8, 15, 18, 7, 0, 6, 2]
for i in seq
	insert!(tree, i, i)
end

delete!(tree, 16)
delete!(tree, 14)
delete!(tree, 2)
insert!(tree, 23, 23)

for value in @task inorderwalk(tree)
	println(value)
end
	
prettyprint(tree)

println(isbst(tree))

println(isbalanced(tree))
