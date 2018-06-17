import CoreGraphics

/// renders a whole bunch of circles
class CircleScene: Scene {
	unowned var container: SceneContainer
	var size: CGSize!
	
	init(in container: SceneContainer) {
		self.container = container
	}
	
	func render(in context: CGContext, dirtyRect: CGRect) {
		let circleCount = Int(size.width * size.height / 100)
		let maxRadius: CGFloat = 50
		for _ in 1...circleCount {
			let color = Color(hue: .random(in: 0...1), saturation: 1, brightness: .random(in: 0.5...1), alpha: 1)
			context.setFillColor(color.cgColor)
			
			let center = CGPoint(x: .random(in: -maxRadius...size.width + maxRadius),
								 y: .random(in: -maxRadius...size.height + maxRadius))
			let radius = CGFloat.random(in: 0...maxRadius)
			let radiusVector = CGSize(x: radius, y: radius)
			context.fillEllipse(in: CGRect(origin: center - radiusVector, size: radiusVector * 2))
		}
	}
}
