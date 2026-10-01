import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var splashChannel: FlutterMethodChannel?
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    backgroundColor = .white
    flutterViewController.backgroundColor = .white
    let splash = NSView(frame: flutterViewController.view.bounds)
    splash.autoresizingMask = [.width, .height]
    splash.wantsLayer = true
    splash.layer?.backgroundColor = NSColor.white.cgColor
    let logo = NSImageView()
    logo.image = NSImage(named: "LaunchImage")
    logo.imageScaling = .scaleProportionallyUpOrDown
    logo.translatesAutoresizingMaskIntoConstraints = false
    splash.addSubview(logo)
    NSLayoutConstraint.activate([
      logo.centerXAnchor.constraint(equalTo: splash.centerXAnchor),
      logo.centerYAnchor.constraint(equalTo: splash.centerYAnchor),
      logo.widthAnchor.constraint(equalToConstant: 280),
      logo.heightAnchor.constraint(equalToConstant: 280),
    ])
    flutterViewController.view.addSubview(splash)
    splashChannel = FlutterMethodChannel(
      name: "havena/startup", binaryMessenger: flutterViewController.engine.binaryMessenger)
    splashChannel?.setMethodCallHandler { [weak splash] call, result in
      if call.method == "ready" {
        splash?.removeFromSuperview()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
