package org.gchouse.sieve

import android.media.AudioAttributes
import android.media.SoundPool
import android.os.Handler
import android.os.Looper
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentHashMap

class MainActivity : FlutterActivity() {
    companion object {
        private const val AUDIO_CHANNEL = "org.gchouse.sieve/audio"
        private val PIANO_ANCHORS = listOf("C3", "G3", "C4", "E4", "C5", "A5", "C6")
    }

    private var soundPool: SoundPool? = null
    private val noteToSoundId = ConcurrentHashMap<String, Int>()
    private val loadedSoundIds = ConcurrentHashMap.newKeySet<Int>()
    private val activeStreams = ConcurrentHashMap<Int, Float>()
    private val mainHandler = Handler(Looper.getMainLooper())
    private var masterVolume: Float = 0.8f

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initSoundPool()

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUDIO_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "init" -> {
                        initSoundPool()
                        result.success(loadedSoundIds.isNotEmpty())
                    }
                    "isLoaded" -> {
                        result.success(loadedSoundIds.isNotEmpty())
                    }
                    "setVolume" -> {
                        val vol = (call.argument<Number>("volume")?.toFloat() ?: 0.8f)
                            .coerceIn(0f, 1f)
                        masterVolume = vol
                        val pool = soundPool
                        if (pool != null) {
                            for ((streamId, noteGain) in activeStreams) {
                                val effective = (noteGain * masterVolume * 0.70f).coerceIn(0f, 1f)
                                pool.setVolume(streamId, effective, effective)
                            }
                        }
                        result.success(null)
                    }
                    "playNotes" -> {
                        initSoundPool()
                        @Suppress("UNCHECKED_CAST")
                        val notes = call.argument<List<Map<String, Any>>>("notes") ?: emptyList()
                        playNotes(notes)
                        result.success(null)
                    }
                    "stopAll" -> {
                        stopAllStreams()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun initSoundPool() {
        if (soundPool != null) return

        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_GAME)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()

        val pool = SoundPool.Builder()
            .setMaxStreams(16)
            .setAudioAttributes(attrs)
            .build()

        pool.setOnLoadCompleteListener { _, sampleId, status ->
            if (status == 0) {
                loadedSoundIds.add(sampleId)
            }
        }

        soundPool = pool

        val loader = FlutterInjector.instance().flutterLoader()
        for (note in PIANO_ANCHORS) {
            try {
                val assetKey = loader.getLookupKeyForAsset("assets/audio/$note.mp3")
                assets.openFd(assetKey).use { afd ->
                    val soundId = pool.load(afd, 1)
                    if (soundId != 0) {
                        noteToSoundId[note] = soundId
                    }
                }
            } catch (_: Exception) {
                // Ignore missing individual anchor
            }
        }
    }

    private fun playNotes(notes: List<Map<String, Any>>) {
        val pool = soundPool ?: return
        if (masterVolume <= 0f) return

        for (note in notes) {
            val anchor = note["anchor"] as? String ?: continue
            val soundId = noteToSoundId[anchor] ?: continue
            if (!loadedSoundIds.contains(soundId)) continue

            val gain = (note["gain"] as? Number)?.toFloat() ?: 0.5f
            val rate = ((note["rate"] as? Number)?.toFloat() ?: 1.0f).coerceIn(0.5f, 2.0f)
            val durationMs = ((note["durationMs"] as? Number)?.toLong() ?: 1250L)
                .coerceIn(120L, 3000L)

            val effectiveVol = (gain * masterVolume * 0.70f).coerceIn(0f, 1f)
            if (effectiveVol <= 0f) continue

            val streamId = pool.play(soundId, effectiveVol, effectiveVol, 1, 0, rate)
            if (streamId != 0) {
                activeStreams[streamId] = gain
                val fadeDelay = (durationMs - 200L).coerceAtLeast(60L)
                mainHandler.postDelayed({
                    if (activeStreams.containsKey(streamId)) {
                        val currentGain = activeStreams[streamId] ?: gain
                        val faded = (currentGain * masterVolume * 0.70f * 0.35f).coerceIn(0f, 1f)
                        soundPool?.setVolume(streamId, faded, faded)
                    }
                }, fadeDelay)
                mainHandler.postDelayed({
                    if (activeStreams.remove(streamId) != null) {
                        soundPool?.stop(streamId)
                    }
                }, durationMs)
            }
        }
    }

    private fun stopAllStreams() {
        mainHandler.removeCallbacksAndMessages(null)
        val pool = soundPool
        if (pool != null) {
            for (streamId in activeStreams.keys) {
                pool.stop(streamId)
            }
        }
        activeStreams.clear()
    }

    override fun onDestroy() {
        stopAllStreams()
        soundPool?.release()
        soundPool = null
        noteToSoundId.clear()
        loadedSoundIds.clear()
        super.onDestroy()
    }
}
