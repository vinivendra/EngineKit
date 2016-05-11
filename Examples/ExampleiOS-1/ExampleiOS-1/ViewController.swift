//
//  ViewController.swift
//  ExampleiOS-1
//
//  Created by Vinicius Vendramini on 4/16/16.
//  Copyright © 2016 Vinicius Vendramini. All rights reserved.
//

import UIKit
import EngineKitiOS

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		printOSInfo()
		printCoreInfo()

		let factory = OSFactory
		let fileHandler = factory.createFileManager()
		let fileContents = fileHandler.getContentsFromFile("main.js")
		print(fileContents)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
