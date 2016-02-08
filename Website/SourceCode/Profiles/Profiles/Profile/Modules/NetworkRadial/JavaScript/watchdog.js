WatchdogTimer = function (timeout_ms, callback) {
    this.timer = setTimeout(callback, timeout_ms);
};

WatchdogTimer.prototype.cancel = function () {
    clearTimeout(this.timer);
};