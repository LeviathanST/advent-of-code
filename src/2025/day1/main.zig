//! | 98 | 99 | 0  | 1  | 2  |
//! | .. |              | .. |
//! | .. |              | .. |
//! | 52 | 51 | 50 | 49 | 48 |
const std = @import("std");

fn sovle(input: [][]const u8) !usize {
    var point: isize = 50;
    var count_zero: usize = 0;

    for (input) |it| {
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
                point = ~point + 1;
            }
        } else {
            point += normalized_times;
            if (point > 100) {
                point -= 100;
            }
        }

        if (point == 0) {
            count_zero += 1;
        }
    }

    std.log.debug("count 0: {d}", .{count_zero});
}

test "(2025) solved" {
    const test_result = try sovle();
    try std.testing.expect(true);
}
