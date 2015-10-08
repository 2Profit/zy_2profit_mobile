/// <reference path="zepto.min.js" />
/// <reference path="common.js" />

jc.uiExtend("nav", {
    close: function () {
        this.$item.removeClass("active");
    },
    init: function () {
        var _this = this;
        this.$item = this.$element.find(".n_item");
        this.$default = this.$element.find(".i_default");
        this.$menu = this.$element.find(".i_menu");

        this.$default.click(function () {
            _this.close();
            $(this).parent().addClass("active");

        });

        this.$menu.click(function () {
            _this.close();
        });


    }

});