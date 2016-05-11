
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
