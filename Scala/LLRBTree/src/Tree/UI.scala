package Tree

import scala.io.StdIn
import scala.math.BigInt

/**
  * Copyright 2016, Elberth Adrián Garro Sánchez.
  */
object UI extends App {
	var option = ""
	val treeNum: Tree[BigInt, BigInt] = new Tree[BigInt, BigInt]
	val treeStr: Tree[String, String] = new Tree[String, String]

	def readOption(): Unit = {
		println("""|
		          |--------(Red Black Tree)---------
		          |     1) Clear tree numbers.
		          |     2) Clear tree strings.
				  |     3) Insert number.
				  |     4) Insert string.
				  |     5) Delete number.
				  |     6) Delete string.
				  |     7) Search number.
				  |     8) Search string.
				  |     9) Print inorder tree numbers.
				  |     10) Print inorder tree strings.
				  |     11) Pretty print tree numbers.
				  |     12) Pretty print tree strings.
		          |     0) End.
		          |""".stripMargin
		)
		print("Select an option to continue: ")
		option = StdIn.readLine()
	}

	// Option 1
	def clearTreeNum(): Unit = {
		treeNum.clear()
		println("The tree has been successfully cleaned!")
	}

	// Option 2
	def clearTreeStr(): Unit = {
		treeStr.clear()
		println("The tree has been successfully cleaned!")
	}

	// Option 3
	def insertNum(): Unit = {
		print("Please enter the number you want insert: ")
		try {
			val numStr = StdIn.readLine()
			val num = BigInt(numStr)
			treeNum.insert(num, num)
			println("The number has been successfully inserted!")
		} catch {
			case e: Exception => println(e)
		}
	}

	// Option 4
	def insertStr(): Unit = {
		print("Please enter the string you want insert: ")
		val str = StdIn.readLine()
		treeStr.insert(str, str)
		println("The string has been successfully inserted!")
	}

	// Option 5
	def deleteNum(): Unit = {
		print("Please enter the number you want delete: ")
		try {
			// try read number.
			val numStrKey = StdIn.readLine()
			val numKey = BigInt(numStrKey)
			try {
				// try delete number.
				treeNum.delete(numKey)
				println("The number has been successfully deleted!")
			} catch {
				// case where number doesn't exist.
				case e: Exception => println(e)
			}
		} catch {
			// case where user doesn't type a number.
			case e: Exception => println(e)
		}
	}

	// Option 6
	def deleteStr(): Unit = {
		print("Please enter the string you want delete: ")
		val strKey = StdIn.readLine()
		try {
			// try delete string.
			treeStr.delete(strKey)
			println("The string has been successfully deleted!")
		} catch {
			// case where string doesn't exist.
			case e: Exception => println(e)
		}
	}

	// Option 7
	def searchNum(): Unit = {
		print("Please enter the number you want search: ")
		try {
			// try read number.
			val numStrKey = StdIn.readLine()
			val numKey = BigInt(numStrKey)
			try {
				// try search number.
				val numVal = treeNum.search(numKey)
				print("The number " + numVal + " was found!")
			} catch {
				// case where number doesn't exist.
				case e: Exception => println(e)
			}
		} catch {
			// case where user doesn't type a number.
			case e: Exception => println(e)
		}
	}

	// Option 8
	def searchStr(): Unit = {
		print("Please enter the string you want search: ")
		val strKey = StdIn.readLine()
		try {
			// try search string.
			val strVal = treeStr.search(strKey)
			print("The string " + strVal + " was found!")
		} catch {
			// case where string doesn't exist.
			case e: Exception => println(e)
		}
	}

	// Option 9
	def printInorderNum(): Unit = {
		val it = treeNum.inorderWalk
		it.foreach(println)
	}

	// Option 10
	def printInorderStr(): Unit = {
		val it = treeStr.inorderWalk
		it.foreach(println)
	}

	// Option 11
	def prettyPrintNum(): Unit = {
		treeNum.prettyPrint()
	}

	// Option 12
	def prettyPrintStr(): Unit = {
		treeStr.prettyPrint()
	}

	def menu(): Boolean = option match {
		case "1" =>
			clearTreeNum()
			true
		case "2" =>
			clearTreeStr()
			true
		case "3" =>
			insertNum()
			true
		case "4" =>
			insertStr()
			true
		case "5" =>
			deleteNum()
			true
		case "6" =>
			deleteStr()
			true
		case "7" =>
			searchNum()
			true
		case "8" =>
			searchStr()
			true
		case "9" =>
			printInorderNum()
			true
		case "10" =>
			printInorderStr()
			true
		case "11" =>
			prettyPrintNum()
			true
		case "12" =>
			prettyPrintStr()
			true
		case "0" =>
			println("Thank you for your time. ;)")
			false
		case _ =>
			println("Pick a valid option from menu!")
			true
	}

	do {
		readOption()
	} while (menu())
}
