import AppKit
import Foundation

guard CommandLine.arguments.count == 3 else {
    fputs("Usage: swift generate_event_card.swift <icon.png> <output.png>\n", stderr)
    exit(2)
}

let iconPath = CommandLine.arguments[1]
let outputPath = CommandLine.arguments[2]
guard let icon = NSImage(contentsOfFile: iconPath) else {
    fputs("Could not load icon at \(iconPath)\n", stderr)
    exit(1)
}

let width = 1_200
let height = 630
guard let bitmap = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: width,
    pixelsHigh: height,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
) else {
    fputs("Could not create output bitmap\n", stderr)
    exit(1)
}

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)

let canvas = NSRect(x: 0, y: 0, width: width, height: height)
let gradient = NSGradient(colors: [
    NSColor(red: 0.95, green: 1.00, blue: 0.97, alpha: 1),
    NSColor(red: 0.86, green: 0.96, blue: 0.89, alpha: 1),
    NSColor(red: 0.79, green: 0.91, blue: 0.83, alpha: 1)
])!
gradient.draw(in: canvas, angle: -12)

let glow = NSBezierPath(ovalIn: NSRect(x: 305, y: 15, width: 590, height: 590))
NSColor.white.withAlphaComponent(0.30).setFill()
glow.fill()

NSGraphicsContext.current?.saveGraphicsState()
let shadow = NSShadow()
shadow.shadowColor = NSColor(red: 0.05, green: 0.25, blue: 0.14, alpha: 0.24)
shadow.shadowBlurRadius = 38
shadow.shadowOffset = NSSize(width: 0, height: -18)
shadow.set()
icon.draw(
    in: NSRect(x: 410, y: 105, width: 380, height: 380),
    from: .zero,
    operation: .sourceOver,
    fraction: 1
)
NSGraphicsContext.current?.restoreGraphicsState()
NSGraphicsContext.restoreGraphicsState()

guard let png = bitmap.representation(using: .png, properties: [:]) else {
    fputs("Could not encode PNG\n", stderr)
    exit(1)
}
try png.write(to: URL(fileURLWithPath: outputPath), options: .atomic)
