import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var sceneView: SceneView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sceneView.scene = defaultScene(in: sceneView)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		sceneView.sizeChanged()
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	// MARK: Touch Handling
	
	// maps UITouchs' identifiers to their Touch object, for multitouch interaction
	private var activeTouches: [ObjectIdentifier: Touch] = [:]
	
	func activeTouches<S>(representing sequence: S) -> [(UITouch, Touch)] where S: Sequence, S.Element == UITouch {
		return sequence.map { raw in (raw, activeTouches[ObjectIdentifier(raw)]!) }
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for rawTouch in touches {
			let touch = Touch(at: rawTouch.location(in: sceneView))
			activeTouches[ObjectIdentifier(rawTouch)] = touch
			sceneView.scene.handle(touch)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: sceneView))
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: sceneView))
			touch.touchEnded()
			activeTouches.removeValue(forKey: ObjectIdentifier(rawTouch))
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: sceneView))
			touch.touchCancelled()
			activeTouches.removeValue(forKey: ObjectIdentifier(rawTouch))
		}
	}
}

class SceneView: UIView, SceneContainer {
	var scene: Scene!
	
	override func draw(_ dirtyRect: CGRect) {
		super.draw(dirtyRect)
		
		let context = UIGraphicsGetCurrentContext()!
		
		scene.render(in: context, dirtyRect: dirtyRect)
	}
	
	func sizeChanged() {
		scene.size = bounds.size
	}
}
