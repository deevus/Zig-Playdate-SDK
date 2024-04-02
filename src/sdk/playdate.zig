const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

pub const sound = @import("sound.zig");
pub const mem = @import("mem.zig");

pub const Playdate = struct {
    api: *const pdapi.PlaydateAPI,
    sound: sound.PlaydateSound,

    pub fn init(api: *const pdapi.PlaydateAPI) Playdate {
        return .{
            .api = api,
            .sound = sound.PlaydateSound.init(api.sound),
        };
    }
};
