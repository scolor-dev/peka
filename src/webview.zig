const c = @cImport({
    @cInclude("webview/api.h");
});

pub const Error = error{
    InvalidArgument,
    InvalidState,
    Canceled,
    MissingDependency,
    Unspecified,
};

pub const SizeHint = enum(c_uint) {
    none = c.WEBVIEW_HINT_NONE,
    min = c.WEBVIEW_HINT_MIN,
    max = c.WEBVIEW_HINT_MAX,
    fixed = c.WEBVIEW_HINT_FIXED,
};

fn checkError(code: c.webview_error_t) Error!void {
    switch (code) {
        c.WEBVIEW_ERROR_OK => {},
        c.WEBVIEW_ERROR_INVALID_ARGUMENT => return Error.InvalidArgument,
        c.WEBVIEW_ERROR_INVALID_STATE => return Error.InvalidState,
        c.WEBVIEW_ERROR_CANCELED => return Error.Canceled,
        c.WEBVIEW_ERROR_MISSING_DEPENDENCY => return Error.MissingDependency,
        else => return Error.Unspecified,
    }
}

pub const WebView = struct {
    handle: c.webview_t,

    pub fn create(debug: bool) ?WebView {
        const h = c.webview_create(@intFromBool(debug), null);
        if (h == null) return null;
        return .{ .handle = h };
    }

    /// Cleanup path: nothing meaningful to do with a failure here, so the
    /// result is intentionally discarded.
    pub fn destroy(self: WebView) void {
        _ = c.webview_destroy(self.handle);
    }

    pub fn run(self: WebView) Error!void {
        return checkError(c.webview_run(self.handle));
    }

    /// Typically called from a callback running on the webview's own thread,
    /// where there is no meaningful way to handle a failure either.
    pub fn terminate(self: WebView) void {
        _ = c.webview_terminate(self.handle);
    }

    pub fn setTitle(self: WebView, title: [:0]const u8) Error!void {
        return checkError(c.webview_set_title(self.handle, title.ptr));
    }

    pub fn setSize(self: WebView, width: c_int, height: c_int, hint: SizeHint) Error!void {
        return checkError(c.webview_set_size(self.handle, width, height, @as(c.webview_hint_t, @intFromEnum(hint))));
    }

    pub fn navigate(self: WebView, url: [:0]const u8) Error!void {
        return checkError(c.webview_navigate(self.handle, url.ptr));
    }

    /// Injects JS that runs before window.onload on every page load,
    /// including subsequent in-page navigations.
    pub fn injectOnLoad(self: WebView, js: [:0]const u8) Error!void {
        return checkError(c.webview_init(self.handle, js.ptr));
    }
};
