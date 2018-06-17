import Cocoa

class ViewController: NSViewController {
	@IBOutlet weak var sceneView: SceneView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sceneView.scene = defaultScene(in: sceneView)
	}
	
	override func viewDidLayout() {
		super.viewDidLayout()
		
		sceneView.sizeChanged()
	}
	
	// MARK: Mouse Handling
	
	var touch: Touch?
	
	override func mouseDown(with event: NSEvent) {
		touch = Touch(at: position(of: event))
		sceneView.scene.handle(touch!)
	}
	
	override func mouseDragged(with event: NSEvent) {
		touch!.touchMoved(to: position(of: event))
	}
	
	override func mouseUp(with event: NSEvent) {
		touch!.touchEnded()
		touch = nil
	}
	
	private func position(of event: NSEvent) -> CGPoint {
		let position = sceneView.convert(event.locationInWindow, from: nil)
		return CGPoint(x: position.x, y: sceneView.bounds.height - position.y)
	}
}

class SceneView: NSView, SceneContainer {
	var scene: Scene!
	
	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
		let context = NSGraphicsContext.current!.cgContext
		// flip y-axis so origin is in upper left corner
		context.translateBy(x: 0, y: bounds.height)
		context.scaleBy(x: 1, y: -1)
		
		scene.render(in: context, dirtyRect: dirtyRect)
	}
	
	func sizeChanged() {
		scene.size = bounds.size
	}
	
	func setNeedsDisplay() {
		setNeedsDisplay(bounds)
	}
}
