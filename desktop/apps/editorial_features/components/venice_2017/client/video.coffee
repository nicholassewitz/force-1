Backbone = require 'backbone'
sd = require('sharify').data
moment = require 'moment'
noUiSlider = require 'nouislider'

module.exports = class VeniceVideoView extends Backbone.View

  events:
    'click #toggleplay': 'onTogglePlay'

  initialize: ->
    @$playButton = $('#toggleplay')
    @setupVideo()

  setupVideo: ->
    @vrView = new VRView.Player '#vrvideo',
      video: "#{sd.APP_URL}/vanity/videos/scenic_mono_3.mp4",
      is_stereo: false,
      is_vr_off: false,
      width: '100%',
      height: '100%',
      loop: false
    @vrView.on 'ready', @onVRViewReady
    @vrView.on 'timeupdate', @updateTime

  updateTime: (e) =>
    @scrubber.set(e.currentTime)

  onVRViewReady: =>
    @vrView.pause()
    @scrubber = noUiSlider.create $('.venice-video__scrubber')[0],
      start: 0
      behaviour: 'snap'
      range:
        min: 0
        max: @vrView.getDuration()
    @scrubber.on 'change', (value) =>
      @vrView.setCurrentTime parseFloat(value[0])

  onTogglePlay: ->
    if @vrView.isPaused
      @vrView.play()
    else
      @vrView.pause()
    @$playButton.toggleClass 'paused'

  # Currently unused but will implement next
  formatTime: (time) ->
    minutes = Math.floor(time / 60) % 60
    seconds = Math.floor(time % 60)
    minutes = if minutes <= 0 then 0 else minutes
    seconds = if seconds <= 0 then 0 else seconds

    result = (if minutes < 10 then '0' + minutes else minutes) + ':'
    result += if seconds < 10 then '0' + seconds else seconds