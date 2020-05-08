import $ from "jquery";

function broadcastNotify(data) {
    localStorage.setItem('broadcast_notify', data);
    localStorage.removeItem('broadcast_notify');
}

function broadcastNotifyCallback(callback) {
    $(window).on('storage', function (event) {
        if (event.originalEvent.key != 'broadcast_notify') return;

        var data = event.originalEvent.newValue;
        if (!data) return;

        callback(data);
    });
}