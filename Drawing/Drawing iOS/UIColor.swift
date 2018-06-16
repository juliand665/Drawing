import UIKit

typealias Color = UIColor

// oh god the API
extension UIColor: _Color {
	var alpha: CGFloat {
		var alpha = CGFloat.nan
		getRed(nil, green: nil, blue: nil, alpha: &alpha)
		return alpha
	}
	
	var red: CGFloat {
		var red = CGFloat.nan
		getRed(&red, green: nil, blue: nil, alpha: nil)
		return red
	}
	
	var green: CGFloat {
		var green = CGFloat.nan
		getRed(nil, green: &green, blue: nil, alpha: nil)
		return green
	}
	
	var blue: CGFloat {
		var blue = CGFloat.nan
		getRed(nil, green: nil, blue: &blue, alpha: nil)
		return blue
	}
	
	var hue: CGFloat {
		var hue = CGFloat.nan
		getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
		return hue
	}
	
	var saturation: CGFloat {
		var saturation = CGFloat.nan
		getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
		return saturation
	}
	
	var brightness: CGFloat {
		var brightness = CGFloat.nan
		getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
		return brightness
	}
}
