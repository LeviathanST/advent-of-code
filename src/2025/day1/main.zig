//! | 98 | 99 | 0  | 1  | 2  |
//! | .. |              | .. |
//! | .. |              | .. |
//! | 52 | 51 | 50 | 49 | 48 |
const std = @import("std");

fn sovle(input: *std.mem.SplitIterator(u8, .scalar)) !usize {
    var point: isize = 50;
    var count_zero: usize = 0;

    while (input.next()) |it| {
        if (it.len <= 0) continue;
        const dir = it[0];
        const turn_times = try std.fmt.parseInt(u32, it[1..], 10);

        // all times larger than 100 doesn't mean anything :/
        const normalized_times = normalized: {
            if (turn_times < 100) {
                break :normalized turn_times;
            } else {
                break :normalized turn_times % 100;
            }
        };

        if (dir == 'L') {
            point -= normalized_times;
            if (point < 0) {
                point = 100 - (~point + 1);
            }
        } else {
            point += normalized_times;
            if (point >= 100) {
                point -= 100;
            }
        }

        if (point == 0) count_zero += 1;
    }
    return count_zero;
}

test "(2025) solved" {
    const alloc = std.testing.allocator;
    const test_input = try std.fs.cwd().readFileAlloc(
        alloc,
        "src/2025/day1/test_input.txt",
        1024,
    );
    defer alloc.free(test_input);
    var iter1 = std.mem.splitScalar(u8, test_input, '\n');

    const result1 = try sovle(&iter1);
    try std.testing.expectEqual(3, result1);

    const input = try std.fs.cwd().readFileAlloc(
        alloc,
        "src/2025/day1/input.txt",
        1024 * 1024, // 1mb
    );
    defer alloc.free(input);
    var iter2 = std.mem.splitScalar(u8, input, '\n');
    const result2 = try sovle(&iter2);
    try std.testing.expectEqual(1120, result2);
}
