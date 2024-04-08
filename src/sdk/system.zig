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

    pub fn isButtonDown(self: @This(), button: pdapi.PDButtons) bool {
        var down: pdapi.PDButtons = 0;

        self.api.getButtonState(&down, null, null);

        return down & button != 0;
    }

    pub fn isButtonPressed(self: @This(), button: pdapi.PDButtons) bool {
        var pressed: pdapi.PDButtons = 0;

        self.api.getButtonState(null, &pressed, null);

        return pressed & button != 0;
    }
};
