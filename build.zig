const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "peka",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libcpp = true,
        }),
    });

    // webview headers: core/include/ contains webview/webview.h, webview/api.h, etc.
    exe.root_module.addIncludePath(b.path("vendor/webview/core/include"));

    switch (target.result.os.tag) {
        .macos => {
            // Compiled as Objective-C++ for Cocoa + WKWebView backend
            exe.root_module.addCSourceFile(.{
                .file = b.path("vendor/webview_impl.mm"),
                .flags = &.{ "-std=c++17", "-DWEBVIEW_STATIC" },
            });
            exe.root_module.linkFramework("WebKit", .{});
            exe.root_module.linkFramework("Cocoa", .{});
        },
        .windows => {
            // Vendored Microsoft WebView2 SDK headers (WebView2.h, WebView2EnvironmentOptions.h).
            // webview's built-in loader resolves WebView2Loader.dll at runtime via
            // LoadLibrary/GetProcAddress, so no import library needs to be linked here.
            exe.root_module.addIncludePath(b.path("vendor/mswebview2/include"));
            exe.root_module.addCSourceFile(.{
                .file = b.path("vendor/webview_impl.cpp"),
                .flags = &.{ "-std=c++17", "-DWEBVIEW_STATIC" },
            });
            exe.root_module.linkSystemLibrary("ole32", .{});
            exe.root_module.linkSystemLibrary("shlwapi", .{});
            exe.root_module.linkSystemLibrary("version", .{});
        },
        .linux => {
            exe.root_module.addCSourceFile(.{
                .file = b.path("vendor/webview_impl.cpp"),
                .flags = &.{ "-std=c++17", "-DWEBVIEW_STATIC" },
            });
            exe.root_module.linkSystemLibrary("gtk-3", .{});
            exe.root_module.linkSystemLibrary("webkit2gtk-4.0", .{});
        },
        else => {},
    }

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    b.step("run", "Run peka").dependOn(&run_cmd.step);
}
