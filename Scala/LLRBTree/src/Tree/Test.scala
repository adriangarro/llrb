package Tree

/**
  * Copyright 2016, Elberth Adrián Garro Sánchez.
  */
object Test extends App {
	val tree: Tree[Int, Int] = new Tree[Int, Int]

	val seq = List(16, 17, 11, 9, 5, 10, 12, 3, 19, 14, 13, 1, 4, 8, 15, 18, 7, 0, 6, 2)
	for (key <- seq) tree.insert(key, key)

	tree.delete(16)

	val it = tree.inorderWalk
	it.foreach(println)

	tree.prettyPrint()

	println(tree.isBalanced)

	println(tree.isBST)

}
