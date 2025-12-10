const std = @import("std");

pub fn build(b: *std.Build) void {
    const t = b.standardTargetOptions(.{});
    const o = b.standardOptimizeOption(.{});

    // const exe = b.addExecutable(.{
    //     .name = "advent_of_code",
    //     .root_module = b.createModule(.{
    //         .root_source_file = b.path("src/main.zig"),
    //         .target = t,
    //         .optimize = o,
    //     }),
    // });
    //
    // const run_step = b.step("run", "Run the application");
    // const run_exe = b.addRunArtifact(exe);
    // run_step.dependOn(&run_exe.step);

    const test_exe = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/test.zig"),
            .target = t,
            .optimize = o,
        }),
        .test_runner = .{
            .path = b.path("test_runner.zig"),
            .mode = .simple,
        },
    });

    const run_test_step = b.step("test", "Run unit tests");
    const run_test_exe = b.addRunArtifact(test_exe);
    run_test_step.dependOn(&run_test_exe.step);
}
