const std = @import("std");

const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;

output: ?[]const u8 = null,
_alloc: Allocator,

pub fn init(alloc: Allocator) !@This() {
    var arena = try alloc.create(ArenaAllocator);
    arena.* = .init(alloc);
    return .{
        ._alloc = arena.allocator(),
    };
}

pub fn deinit(self: *@This()) void {
    const arena: *ArenaAllocator = @ptrCast(@alignCast(self._alloc.ptr));
    const alloc = arena.child_allocator;

    arena.deinit();
    alloc.destroy(arena);
}

pub fn read(
    self: @This(),
    input_path: []const u8,
    comptime delimiter: []const u8,
) !std.mem.SplitIterator(
    u8,
    .sequence,
) {
    const input = try std.fs.cwd().readFileAlloc(
        self._alloc,
        input_path,
        1024 * 1024,
    );
    return std.mem.splitSequence(u8, input, delimiter);
}
