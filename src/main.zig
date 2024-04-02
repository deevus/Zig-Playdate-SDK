const std = @import("std");
const pdapi = @import("./sdk/playdate_api_definitions.zig");
const pd = @import("./sdk/playdate.zig");

const ExampleGlobalState = struct {
    playdate: *pdapi.PlaydateAPI,
    playdate_image: *pdapi.LCDBitmap,
    message: [*c]u8,
};

var global_state: *ExampleGlobalState = undefined;

pub export fn eventHandler(playdate: *pdapi.PlaydateAPI, event: pdapi.PDSystemEvent, arg: u32) callconv(.C) c_int {
    _ = arg;
    switch (event) {
        .EventInit => {
            const playdate_image = playdate.graphics.loadBitmap("images/playdate_image", null).?;
            const font = playdate.graphics.loadFont("/System/Fonts/Asheville-Sans-14-Bold.pft", null).?;
            playdate.graphics.setFont(font);

            var playdate_allocator = pd.mem.PlaydateAllocator.init(playdate);
            var arena = std.heap.ArenaAllocator.init(playdate_allocator.allocator());
            var allocator = arena.allocator();

            var array_list = std.ArrayList(u8).init(allocator);
            array_list.append(1) catch unreachable;
            array_list.append(2) catch unreachable;
            array_list.append(3) catch unreachable;
            _ = array_list.swapRemove(0);
            defer array_list.deinit();

            // const message = allocator.alloc(u8, 16) catch undefined;
            // _ = std.fmt.bufPrintZ(message, "Count: {}", .{array_list.items.len}) catch {};
            var message: [*c]u8 = undefined;

            _ = playdate.system.formatString(&message, "Count: %d", array_list.items.len);

            global_state = allocator.create(ExampleGlobalState) catch unreachable;

            global_state.* = .{
                .playdate = playdate,
                .playdate_image = playdate_image,
                .message = message,
            };

            playdate.system.setUpdateCallback(updateAndRender, global_state);
        },
        else => {},
    }
    return 0;
}

fn updateAndRender(_: ?*anyopaque) callconv(.C) c_int {
    //TODO: replace with your own code!

    const playdate = global_state.playdate;
    const playdate_image = global_state.playdate_image;
    const message = global_state.message;

    playdate.graphics.clear(@intFromEnum(pdapi.LCDSolidColor.ColorWhite));
    const pixel_width = playdate.graphics.drawText(message, 16, .UTF8Encoding, 0, 0);
    _ = pixel_width;
    playdate.graphics.drawBitmap(playdate_image, pdapi.LCD_COLUMNS / 2 - 16, pdapi.LCD_ROWS / 2 - 16, .BitmapUnflipped);

    //returning 1 signals to the OS to draw the frame.
    //we always want this frame drawn
    return 1;
}
