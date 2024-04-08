const std = @import("std");
const pdapi = @import("./sdk/playdate_api_definitions.zig");
const pd = @import("./sdk/playdate.zig");
const Playdate = pd.Playdate;

const State = struct {
    playdate: Playdate,
    playdate_image: pd.graphics.Bitmap,
    message: []const u8,
};

var buffer: [1024 * 1024 * 16]u8 = undefined;

var state: *State = undefined;

pub export fn eventHandler(handle: *pdapi.PlaydateAPI, event: pdapi.PDSystemEvent, arg: u32) callconv(.C) c_int {
    _ = arg;
    switch (event) {
        .EventInit => {
            const playdate = Playdate.init(handle);
            const playdate_image = playdate.graphics.loadBitmap("images/playdate_image");

            const font = handle.graphics.loadFont("/System/Fonts/Asheville-Sans-14-Bold.pft", null).?;
            handle.graphics.setFont(font);

            var fba = std.heap.FixedBufferAllocator.init(&buffer);
            var arena = std.heap.ArenaAllocator.init(fba.allocator());
            var allocator = arena.allocator();

            var array_list = std.ArrayList(u8).init(allocator);
            array_list.append(1) catch unreachable;
            array_list.append(2) catch unreachable;
            array_list.append(3) catch unreachable;
            _ = array_list.swapRemove(0);
            defer array_list.deinit();

            const message = allocator.alloc(u8, 16) catch undefined;
            _ = std.fmt.bufPrintZ(message, "Count: {}", .{array_list.items.len}) catch {};

            state = allocator.create(State) catch unreachable;

            state.* = .{
                .playdate = playdate,
                .playdate_image = playdate_image,
                .message = message,
            };

            handle.system.setUpdateCallback(updateAndRender, state);
        },
        else => {},
    }
    return 0;
}

fn updateAndRender(_: ?*anyopaque) callconv(.C) c_int {
    const playdate = state.playdate;
    const playdate_image = state.playdate_image;
    const message = state.message;

    playdate.graphics.clear(.{ .color = .ColorWhite });
    playdate.graphics.drawText(message, .{ .x = 0, .y = 0 });
    playdate.graphics.drawBitmap(playdate_image, .{ .x = pdapi.LCD_COLUMNS / 2 - 16, .y = pdapi.LCD_ROWS / 2 - 16 });

    //returning 1 signals to the OS to draw the frame.
    //we always want this frame drawn
    return 1;
}
