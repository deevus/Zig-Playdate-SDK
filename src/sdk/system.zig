const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");
const Vector2i = @import("math.zig").Vector2i;

pub const System = struct {
    api: *const pdapi.PlaydateSys,

    pub fn init(api: *const pdapi.PlaydateSys) System {
        return .{ .api = api };
    }

    pub fn drawFps(self: @This(), position: Vector2i) void {
        self.api.drawFPS(position.x, position.y);
    }
};
