const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

pub const sound = @import("sound.zig");
pub const mem = @import("mem.zig");
pub const graphics = @import("graphics.zig");
pub const math = @import("math.zig");
pub const system = @import("system.zig");

pub const Playdate = struct {
    api: *const pdapi.PlaydateAPI,
    sound: sound.PlaydateSound,
    graphics: graphics.PlaydateGraphics,
    allocator: mem.PlaydateAllocator,
    system: system.System,

    pub fn init(api: *const pdapi.PlaydateAPI) Playdate {
        return .{
            .api = api,
            .sound = sound.PlaydateSound.init(api.sound),
            .graphics = graphics.PlaydateGraphics.init(api.graphics),
            .allocator = mem.PlaydateAllocator.init(api),
            .system = system.System.init(api.system),
        };
    }
};
