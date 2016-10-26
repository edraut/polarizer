ForeignOffice.config({
  bus: {
    klass: ForeignOffice::Busses::PubnubBus,
    publish_key:   ENV['PUBNUB_PUBLISH_KEY'],
    subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
    secret_key:    ENV['PUBNUB_SECRET_KEY']
  }
})