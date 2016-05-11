//
//  ViewController.swift
//  ExampleOSX-1
//
//  Created by Vinicius Vendramini on 4/16/16.
//  Copyright © 2016 Vinicius Vendramini. All rights reserved.
//

import Cocoa
import EngineKitOSX

class ViewController: NSViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		printOSInfo()
		printCoreInfo()

		let factory = OSFactory
		let fileHandler = factory.createFileManager()
		let fileContents = fileHandler.getContentsFromFile("main.js")
		print(fileContents)
	}
}
