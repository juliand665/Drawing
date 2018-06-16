import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var renderView: RenderView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		renderView.renderer = DraggableRectRenderer(in: renderView!)
		//renderView.renderer = CircleRenderer(in: renderView!)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		renderView.sizeChanged()
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
			let touch = Touch(at: rawTouch.location(in: renderView))
			activeTouches[ObjectIdentifier(rawTouch)] = touch
			renderView.renderer.handle(touch)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: renderView))
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: renderView))
			touch.touchEnded()
			activeTouches.removeValue(forKey: ObjectIdentifier(rawTouch))
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for (rawTouch, touch) in activeTouches(representing: touches) {
			touch.touchMoved(to: rawTouch.location(in: renderView))
			touch.touchCancelled()
			activeTouches.removeValue(forKey: ObjectIdentifier(rawTouch))
		}
	}
}

class RenderView: UIView, RendererContainer {
	var renderer: Renderer!
	
	override func draw(_ dirtyRect: CGRect) {
		super.draw(dirtyRect)
		
		let context = UIGraphicsGetCurrentContext()!
		
		renderer.render(in: context, dirtyRect: dirtyRect)
	}
	
	func sizeChanged() {
		renderer.size = bounds.size
	}
}
