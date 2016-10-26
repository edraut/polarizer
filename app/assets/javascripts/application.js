// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require simple_inheritance
//= require thin_man
//= require foreign_office
//= require hooch
//= require anytime_manager
//= require foreign_office
$(document).ready(function(){
  pubnub_publish_key = $("[data-pubnub-publish-key]").data('pubnub-publish-key')
  pubnub_subscribe_key = $("[data-pubnub-subscribe-key]").data('pubnub-subscribe-key')
  foreign_office.config({
    bus_name: 'PubnubBus',
    publish_key: pubnub_publish_key,
    subscribe_key: pubnub_subscribe_key,
    ssl: true,
    disconnect_alert: 'You seem to have lost the connection to Polarizer. Please check your internet connection. Thanks, -Polarizer.',
    reconnect_alert: 'Your connection to the Polarizer site has been restored. All site info should now be available. Thanks, -Polarizer.'
  });
  foreign_office.bind_listeners()

})
