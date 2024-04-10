const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");
const Vector2i = @import("math.zig").Vector2i;

const Buttons = enum(c_int) {
    ButtonUp = pdapi.BUTTON_UP,
    ButtonDown = pdapi.BUTTON_DOWN,
    ButtonLeft = pdapi.BUTTON_LEFT,
    ButtonRight = pdapi.BUTTON_RIGHT,
    ButtonA = pdapi.BUTTON_A,
    ButtonB = pdapi.BUTTON_B,
};

pub const System = struct {
    api: *const pdapi.PlaydateSys,

    pub fn init(api: *const pdapi.PlaydateSys) System {
        return .{ .api = api };
    }

    pub fn drawFps(self: @This(), position: Vector2i) void {
        self.api.drawFPS(position.x, position.y);
    }

    pub fn isButtonDown(self: @This(), button: Buttons) bool {
        var down: pdapi.PDButtons = 0;

        self.api.getButtonState(&down, null, null);

        return down & @intFromEnum(button) != 0;
    }

    pub fn isButtonPressed(self: @This(), button: Buttons) bool {
        var pressed: pdapi.PDButtons = 0;

        self.api.getButtonState(null, &pressed, null);

        return pressed & @intFromEnum(button) != 0;
    }
};
