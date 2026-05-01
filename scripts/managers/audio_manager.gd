extends Node
class_name AudioManager

const AUDIO_POOL_SIZE := 10

var audio_players: Array[AudioStreamPlayer] = []
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	for i in range(AUDIO_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		audio_players.append(player)


func play_sfx(sfx_name: String) -> void:
	var stream := _build_sfx_stream(sfx_name)
	for player in audio_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return

	audio_players[0].stream = stream
	audio_players[0].play()


func _build_sfx_stream(sfx_name: String) -> AudioStreamWAV:
	var frequency := 520.0
	var duration := 0.08
	var volume := 0.22
	var waveform := "sine"
	var end_frequency := frequency

	match sfx_name:
		"player_shot":
			frequency = 980.0
			end_frequency = 760.0
			duration = 0.045
			volume = 0.13
			waveform = "pulse"
		"charge_release":
			frequency = 1400.0
			end_frequency = 360.0
			duration = 0.24
			volume = 0.26
			waveform = "saw"
		"bomb":
			frequency = 95.0
			end_frequency = 45.0
			duration = 0.5
			volume = 0.34
			waveform = "noise"
		"enemy_destroy":
			frequency = 260.0
			end_frequency = 90.0
			duration = 0.16
			volume = 0.22
			waveform = "noise"
		"player_hit":
			frequency = 190.0
			end_frequency = 70.0
			duration = 0.22
			volume = 0.28
			waveform = "saw"
		"boss_warning":
			frequency = 330.0
			end_frequency = 330.0
			duration = 0.55
			volume = 0.2
			waveform = "alarm"
		"pickup":
			frequency = 660.0
			end_frequency = 1320.0
			duration = 0.28
			volume = 0.24
			waveform = "sine"

	return _make_wav(frequency, end_frequency, duration, volume, waveform)


func _make_wav(frequency: float, end_frequency: float, duration: float, volume: float, waveform: String) -> AudioStreamWAV:
	var mix_rate := 22050
	var sample_count := int(duration * float(mix_rate))
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)

	for i in range(sample_count):
		var t := float(i) / float(mix_rate)
		var progress := float(i) / float(maxi(sample_count - 1, 1))
		var current_frequency := lerpf(frequency, end_frequency, progress)
		var envelope := sin(progress * PI)
		var sample := _sample_wave(waveform, current_frequency, t, progress) * envelope * volume
		var int_sample := int(clampf(sample, -1.0, 1.0) * 32767.0)
		if int_sample < 0:
			int_sample = 65536 + int_sample
		bytes[i * 2] = int_sample & 0xff
		bytes[i * 2 + 1] = (int_sample >> 8) & 0xff

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = mix_rate
	stream.stereo = false
	stream.data = bytes
	return stream


func _sample_wave(waveform: String, frequency: float, t: float, progress: float) -> float:
	match waveform:
		"pulse":
			return 1.0 if sin(TAU * frequency * t) >= 0.0 else -1.0
		"saw":
			return 2.0 * fmod(frequency * t, 1.0) - 1.0
		"noise":
			return rng.randf_range(-1.0, 1.0) * (1.0 - progress * 0.35)
		"alarm":
			var gate := 1.0 if int(progress * 12.0) % 2 == 0 else 0.35
			return sin(TAU * frequency * t) * gate
		_:
			return sin(TAU * frequency * t)
