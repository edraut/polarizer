chatroom = {
  RoomScroller: Class.extend({
    init: function($room){
      $room.scrollTop($room.prop("scrollHeight"))
      console.log('heyo boyo')
    }
  })
}