const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

pub const Debug = struct {
    api: *const pdapi.PlaydateSys,

    pub fn init(api: *const pdapi.PlaydateSys) Debug {
        return .{
            .api = api,
        };
    }
};
