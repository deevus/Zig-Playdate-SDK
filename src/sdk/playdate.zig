const std = @import("std");

pub const pdapi = @import("playdate_api_definitions.zig");
pub const sound = @import("sound.zig");
pub const mem = @import("mem.zig");
pub const graphics = @import("graphics.zig");
pub const math = @import("math.zig");
pub const system = @import("system.zig");
pub const debug = @import("debug.zig");

pub const Playdate = struct {
    api: *const pdapi.PlaydateAPI,
    sound: sound.PlaydateSound,
    graphics: graphics.PlaydateGraphics,
    system: system.System,
    mem: mem.Memory,
    debug: debug.Debug,

    pub fn init(api: *const pdapi.PlaydateAPI) Playdate {
        return .{
            .api = api,
            .sound = sound.PlaydateSound.init(api.sound),
            .graphics = graphics.PlaydateGraphics.init(api.graphics),
            .system = system.System.init(api.system),
            .mem = mem.Memory.init(api.system),
            .debug = debug.Debug.init(api.system),
        };
    }
};
