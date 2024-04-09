const pdapi = @import("playdate_api_definitions.zig");

pub const PlaydateSound = struct {
    sound_api: *const pdapi.PlaydateSound,

    pub fn init(sound_api: *const pdapi.PlaydateSound) PlaydateSound {
        return .{ .sound_api = sound_api };
    }

    pub fn loadSample(self: @This(), file_path: [:0]const u8) PlaydateSamplePlayer {
        var sample_player = PlaydateSamplePlayer.init(self.sound_api);
        sample_player.loadPath(file_path);
        return sample_player;
    }
};

pub const PlaydateSamplePlayer = struct {
    sound_api: *const pdapi.PlaydateSound,
    sample_player: *pdapi.SamplePlayer,
    sample: ?PlaydateSoundSample = undefined,
    repeat: c_int = 1,
    rate: f32 = 1.0,

    pub fn init(sound_api: *const pdapi.PlaydateSound) PlaydateSamplePlayer {
        return .{
            .sound_api = sound_api,
            .sample_player = sound_api.sampleplayer.newPlayer().?,
        };
    }

    pub fn deinit(self: *@This()) void {
        if (self.sample) |sample| {
            sample.deinit();
        }

        self.sound_api.sampleplayer.freePlayer(self.sample_player);
    }

    pub fn load(self: *@This(), sample: PlaydateSoundSample) void {
        self.sample = sample;
        self.sound_api.sampleplayer.setSample(self.sample_player, sample.sample);
    }

    pub fn loadPath(self: *@This(), file_path: [:0]const u8) void {
        const sample = PlaydateSoundSample.init(self.sound_api, file_path);

        self.load(sample);
    }

    pub fn play(self: @This()) void {
        _ = self.sound_api.sampleplayer.play(self.sample_player, self.repeat, self.rate);
    }
};

pub const PlaydateSoundSample = struct {
    sound_api: *const pdapi.PlaydateSound,
    sample: *pdapi.AudioSample,

    pub fn init(sound_api: *const pdapi.PlaydateSound, file_path: [:0]const u8) PlaydateSoundSample {
        return .{
            .sound_api = sound_api,
            .sample = sound_api.sample.load(file_path).?,
        };
    }

    pub fn deinit(self: @This()) void {
        self.sound_api.sample.freeSample(self.sample);
    }
};
