const std = @import("std");
const WebView = @import("webview.zig").WebView;

// Back/forward/reload via JS history API instead of native key handling:
// the same script works identically on macOS, Windows and Linux backends.
// Back:    Alt+Left / Cmd+[
// Forward: Alt+Right / Cmd+]
// Reload:  F5 / Ctrl+R / Cmd+R
const keyboard_nav_js =
    \\(function () {
    \\  document.addEventListener('keydown', function (e) {
    \\    var back = (e.altKey && e.key === 'ArrowLeft') || (e.metaKey && e.key === '[');
    \\    var forward = (e.altKey && e.key === 'ArrowRight') || (e.metaKey && e.key === ']');
    \\    var reload = e.key === 'F5' || ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'r');
    \\    if (back) { e.preventDefault(); history.back(); }
    \\    else if (forward) { e.preventDefault(); history.forward(); }
    \\    else if (reload) { e.preventDefault(); location.reload(); }
    \\  }, true);
    \\})();
;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);

    if (args.len < 2) {
        std.debug.print("usage: peka <url>\nexample: peka https://example.com\n", .{});
        std.process.exit(1);
    }

    // args[1] is [:0]const u8 — already null-terminated, no copy needed
    const url = args[1];

    const wv = WebView.create(false) orelse {
        std.debug.print("error: failed to create webview window\n", .{});
        std.process.exit(1);
    };
    defer wv.destroy();

    try wv.setTitle("peka");
    try wv.setSize(1280, 800, .none);
    try wv.injectOnLoad(keyboard_nav_js);
    wv.navigate(url) catch {
        std.debug.print("error: failed to navigate to {s}\n", .{url});
        std.process.exit(1);
    };
    try wv.run();
}
