//! | 98 | 99 | 0  | 1  | 2  |
//! | .. |              | .. |
//! | .. |              | .. |
//! | 52 | 51 | 50 | 49 | 48 |
const std = @import("std");
const InputReader = @import("../../InputReader.zig");

fn sovle(input: *std.mem.SplitIterator(u8, .sequence)) !usize {
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
    var input_reader: InputReader = try .init(alloc);
    defer input_reader.deinit();

    var iter1 = try input_reader.read("src/2025/day1/test_input.txt", "\n");
    const result1 = try sovle(&iter1);
    try std.testing.expectEqual(3, result1);

    var iter2 = try input_reader.read("src/2025/day1/input.txt", "\n");
    const result2 = try sovle(&iter2);
    try std.testing.expectEqual(1120, result2);
}
