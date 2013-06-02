//The A Team
(function (root, factory) {
    if (typeof exports === "object" && exports) {
        module.exports = factory; // CommonJS
    } else if (typeof define === "function" && define.amd) {
        define(factory); // AMD
    } else {
        root.TheATeam = factory; // <script>
    }
}(this, (function () {
    var exports = {};	

    exports.name = "the-a-team";
    exports.version = "0.0.1";

    function WebSite() {
    }

    WebSite.prototype = {
        init: function () {
            $.ajax({
                type: 'POST',
                url: 'http://www.unleashed2013.org:81/trusted',
                data: { 'username' : 'unleashed' },
                dataType: 'JSON'
            })
                .done(function(data) {
                    $('.dashboard').html(data);
                })
                .fail(function(data){
                    var t = 1;
                });
        }
    };

    //Global Events
    $(document).ready(function () {
        exports.website.init();
    });
    
    exports.website = new WebSite();
    
    return exports;
}())));
