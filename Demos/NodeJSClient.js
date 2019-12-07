var io = require('socket.io-client');
var socket = io("http://127.0.0.1:5050", {
    transports: ['websocket']
});

socket.on('connect',
    function () {
        socket.emit('GetWebConn', 'QQ号', (data) => {
            console.log(data);
        });
    });
// socket.on('OnCheckLoginQrcode',
//     function (data) {
//         //48未扫描 53已扫码 17 49 过期了
//         console.log(data);
//     });
// socket.on('OnLoginSuccess',
//     function (data) {

//     });
//统一事件管理如好友进群事件 好友请求事件 退群等事件集合
socket.on('OnEvents', function (data) {
    console.log("收到相关事件");
    console.log(JSON.stringify(data));

});
//收到好友消息的回调事件
socket.on('OnFriendMsgs', function (data) {
    console.log("收到好友消息");
    console.log(data);
    console.log(JSON.stringify(data))
});
//收到群消息的回调事件
socket.on('OnGroupMsgs', function (data) {
    console.log("收到群消息");
    console.log(data);
    console.log(JSON.stringify(data))
});