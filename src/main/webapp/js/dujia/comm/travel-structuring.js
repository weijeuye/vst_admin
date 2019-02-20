/**
 * File:         index.js
 * Create:       2015-11-18
 * Last Update : 2015-11-18
 * Author:       江圣
 * Description:  行程内容结构化
 */

var $document = $(document);
var $template = $(".template");

//初始化
$(function () {

    if ($.browser.msie) {
        if ($.browser.version < 8) {
            jQuery.fx.off = true;
        }
    }

});

//天和模块
$(function () {

    /**
     * 全局变量 天
     */
    window.Days = {

        //每页显示数量
        PAGE_SIZE: 20,

        //标签宽度
        TAB_WIDTH: 35,
        TAB_ACTIVE_WIDTH: 100,

        //滚动最快最慢速度 毫秒
        SLOWEST: 1000,
        FASTEST: 100,

        //标签
        $titles: $(".JS_days_tabs"),

        //内容
        $contents: $(".JS_days_contents"),

        //下拉菜单
        $dayDropDown: $(".navigation-control"),

        //翻页按钮
        $prev: $(".navigation-prev"),
        $next: $(".navigation-next"),

        //当前页
        page: 0,

        //播放滚动动画中
        isScrollAnimate: false,

        $moduleDropDown: $(".day-module-add-content"),

        //初始化
        init: function () {
            this.bindEvent();
        },

        //绑定事件
        bindEvent: function () {

            /*天部分*/

            //上一页
            this.$prev.on("click", {self: this}, this.prevHandler);

            //下一页
            this.$next.on("click", {self: this}, this.nextHandler);

            //顶部添加一天
            $document.on("click", ".JS_tab_insert_day", {self: this}, this.titleAddDayHandler);
            $document.on("mouseenter", ".JS_tab_insert_day", {self: this}, this.titleAddDayEnterHandler);
            $document.on("mouseleave", ".JS_tab_insert_day", {self: this}, this.titleAddDayLeaveHandler);

            //导航添加一天
            $document.on("click", ".navigation-add", {self: this}, this.navAddDayHandler);

            //内容添加一天
            $document.on("click", ".JS_content_add_day", {self: this}, this.contentAddDayHandler);
            $document.on("mouseenter", ".JS_content_add_day", {self: this}, this.contentAddDayEnterHandler);
            $document.on("mouseleave", ".JS_content_add_day", {self: this}, this.contentAddDayLeaveHandler);

            //顶部删除一天
            //$document.on("click", ".JS_tab_delete_day", {self: this}, this.titleDelDayHandler);
            $document.on("mouseenter", ".JS_tab_delete_day,.JS_day_delete", {self: this}, this.titleDelDayEnterHandler);
            $document.on("mouseleave", ".JS_tab_delete_day,.JS_day_delete", {self: this}, this.titleDelDayLeaveHandler);

            //内容删除一天
            $document.on("click", ".JS_content_del_day", {self: this}, this.contentDelDayHandler);
            $document.on("mouseenter", ".JS_content_del_day", {self: this}, this.contentDelDayEnterHandler);
            $document.on("mouseleave", ".JS_content_del_day", {self: this}, this.contentDelDayLeaveHandler);

            //点击标签事件
            $document.on("click", ".navigation-item", {self: this}, this.clickTabHandler);

            //顶部下拉菜单
            $document.on("click", ".navigation-item>.box", {self: this}, this.showDayDropDownHandler);
            $document.on("click", {self: this}, this.hideDayDropDownHandler);

            //禁用用餐提醒
            $document.on("mouseenter", "[data-template=template-restaurant].disabled", {self: this}, this.showRestaurantTipHandler);
            $document.on("mouseleave", "[data-template=template-restaurant]", {self: this}, this.hideRestaurantTipHandler);

            this.bindScrollEvent();

            /*模块部分*/
            //添加模块
            $document.on("click", ".day-module-add-content>li", {self: this}, this.addModuleHandler);

            //删除模块
            //$document.on("click", ".JS_module_delete", {self: this}, this.delModuleHandler);
            $document.on("mouseenter", ".JS_module_delete", {self: this}, this.delEnterModuleHandler);
            $document.on("mouseleave", ".JS_module_delete", {self: this}, this.delLeaveModuleHandler);

            //模块下拉菜单
            $document.on("click", ".day-module-add-title", {self: this}, this.showModuleDropDownHandler);
            $document.on("click", {self: this}, this.hideModuleDropDownHandler);

        },
	
	//禁用用餐提醒
        showRestaurantTipHandler: function (event) {
            var $this = $(this);
            var top = $this.offset().top;
            var $tip = $(".tip-restaurant-no-add");
            $tip.css({
                "top": top + 30
            });
            $tip.show();
        },

        hideRestaurantTipHandler: function () {
            var $tip = $(".tip-restaurant-no-add");
            $tip.hide();
        },

        //滚动事件
        bindScrollEvent: function () {

            this.unbindScrollEvent();
            $(window).on("scroll", {self: this}, this.scrollHandler);

        },

        //解除绑定滚动事件
        unbindScrollEvent: function () {

            $(window).off("scroll", this.scrollHandler);

        },

        //顶部删除一天
        titleDelDayHandler: function (event) {

            var self = event.data.self;

            //无法删除最后一天
            if (self.getSize() === 1) {
                backstage.alert({
                    content: "无法删除最后一天"
                });
                return false;
            }

            //确认提示框
            backstage.confirm({
                width: 360,
                determineClass: "btn-danger",
                content: "该操作会清空当天的全部信息，确定操作？",
                determineCallback: function () {
                    var $dropDown = self.$dayDropDown;
                    var pos = $dropDown.data("index");
                    self.del(pos);
                  
                }
            });

        },

        //鼠标移入顶部删除按钮
        titleDelDayEnterHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = 0;
            if ($this.hasClass("JS_tab_delete_day")) {
                index = $this.parents(".navigation-control").data("index");
            } else if ($this.hasClass("JS_day_delete")) {
                index = parseInt($this.parents(".day-head").find("input[name='nDay']").val()) - 1;
            }
            self.$contents.children().eq(index).addClass("delete");
        },

        //鼠标移出顶部删除按钮
        titleDelDayLeaveHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = 0;
            if ($this.hasClass("JS_tab_delete_day")) {
                index = $this.parents(".navigation-control").data("index");
            } else if ($this.hasClass("JS_day_delete")) {
                index = parseInt($this.parents(".day-head").find("input[name='nDay']").val()) - 1;
            }
            self.$contents.children().eq(index).removeClass("delete");
        },

        //内容删除一天
        contentDelDayHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);

            //无法删除最后一天
            if (self.getSize() === 1) {
                backstage.alert({
                    content: "无法删除最后一天"
                });
                return false;
            }

            //确认提示框
            backstage.confirm({
                content: "该操作会清空当天的全部信息，确定操作？",
                determineCallback: function () {
                    var pos = $this.parents(".day").index();
                    self.del(pos);
                }
            });

        },

        //鼠标移入内容删除按钮
        contentDelDayEnterHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = $this.parents(".day").index();
            self.$contents.children().eq(index).addClass("delete");
        },

        //鼠标移出内容删除按钮
        contentDelDayLeaveHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = $this.parents(".day").index();
            self.$contents.children().eq(index).removeClass("delete");
        },

        //顶部添加一天事件
        titleAddDayHandler: function (event) {
            var self = event.data.self;
            var $dropDown = self.$dayDropDown;
            var pos = $dropDown.data("index");
            self.insert(pos);
        },

        //导航添加一天事件
        navAddDayHandler: function (event) {
            var self = event.data.self;
            var pos = self.getSize() - 1;
            self.insert(pos);
        },

        //鼠标移入内容添加按钮
        titleAddDayEnterHandler: function (event) {
            var self = event.data.self;
            var $dropDown = self.$dayDropDown;
            var pos = $dropDown.data("index");
            self.$contents.children().eq(pos).addClass("add");
        },

        //鼠标移出内容添加按钮
        titleAddDayLeaveHandler: function (event) {
            var self = event.data.self;
            var $dropDown = self.$dayDropDown;
            var pos = $dropDown.data("index");
            self.$contents.children().eq(pos).removeClass("add");
        },

        //内容添加一天事件
        contentAddDayHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var pos = $this.parents(".day").index();
            self.insert(pos);
        },

        //鼠标移入内容添加按钮
        contentAddDayEnterHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = $this.parents(".day").index();
            self.$contents.children().eq(index).addClass("add");
        },

        //鼠标移出内容添加按钮
        contentAddDayLeaveHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var index = $this.parents(".day").index();
            self.$contents.children().eq(index).removeClass("add");
        },

        //滚动事件
        scrollHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);

            var scrollTop = ($this.scrollTop());

            var $tabs = self.$titles.children();
            var $days = self.$contents.children();

            var top = 0;
            var i = 0;
            for (; i < $days.length; i++) {
                top = $days.eq(i).offset().top + $days.eq(i).height() - 40;
                if (top > scrollTop) {
                    break;
                }
            }
            if ($tabs.filter(".active").index() !== i) {
                self.$dayDropDown.hide();
            }
            self.show(i);

            var pageNum = Math.floor(i / self.PAGE_SIZE);
            self.showPage(pageNum);
        },

        //点击标签事件
        clickTabHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);

            //序号
            var index = $this.index();

            self.scroll(index);

        },

        //显示天下拉菜单
        showDayDropDownHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);
            var $parent = $this.parents(".navigation-item");

            //序号
            var index = $parent.index();

            //偏移
            var left = (index % self.PAGE_SIZE) * self.TAB_WIDTH;

            if (self.getSize() > self.PAGE_SIZE) {
                left += self.TAB_WIDTH;
            }

            //显示下拉
            var $dropDown = self.$dayDropDown;
            $dropDown.css({
                "left": left
            });
            $dropDown.show();
            $dropDown.data("index", index);

        },

        //隐藏天下拉菜单
        hideDayDropDownHandler: function (event) {
            var $target = $(event.target);
            var $list = $target.parents(".navigation-item>.box");
            if ($list.length > 0) {
                return false;
            }
            if ($target.is(".navigation-item>.box")) {
                return false;
            }
            var self = event.data.self;
            self.$dayDropDown.hide();
        },

        /**
         * 滚动
         * @param pos 滚动到的位置
         * @param isDisabledAnimate 是否禁用动画效果
         */
        scroll: function (pos, isDisabledAnimate) {

            var self = this;

            self.unbindScrollEvent();

            //边界
            if (pos >= this.getSize()) {
                pos = this.getSize() - 1;
            } else if (pos < 0) {
                pos = 0;
            }

            //获取高度
            var $content = this.$contents.children().eq(pos);
            var top = $content.offset().top;

            //计算速度
            var nowTop = $(window).scrollTop();
            var endTop = top - 50;
            var diffHeight = Math.abs(endTop - nowTop);

            var timeDelay = diffHeight / 4;
            if (timeDelay > this.SLOWEST) {
                timeDelay = this.SLOWEST;
            } else if (timeDelay < this.FASTEST) {
                timeDelay = this.FASTEST;
            }

            //滚动
            if (isDisabledAnimate) {

                $('html,body').stop(true, true).scrollTop(endTop);
                self.show(pos);

                setTimeout(function () {
                    self.bindScrollEvent();
                }, 0);

            } else {
                $('html,body')
                    .stop(true, true)
                    .animate({scrollTop: endTop}, timeDelay, function () {
                        self.show(pos);
                        self.bindScrollEvent();
                    });
            }

        },

        //滚动至模块
        scrollToModule: function ($module) {

            var self = this;

            var nowTop = $(window).scrollTop();
            var top = $module.offset().top;
            var endTop = top - 75;

            var diffHeight = Math.abs(endTop - nowTop);

            var timeDelay = diffHeight / 4;
            if (timeDelay > this.SLOWEST) {
                timeDelay = this.SLOWEST;
            } else if (timeDelay < this.FASTEST) {
                timeDelay = this.FASTEST;
            }

            //滚动
            $('html,body')
                .stop(true, true)
                .animate({scrollTop: endTop}, timeDelay, function () {
                    //self.show(pos);
                    self.bindScrollEvent();
                });

        },

        //上一页点击事件
        prevHandler: function (event) {
            var self = event.data.self;
            self.showPage(self.page - 1);
            var pos = self.$titles.children(".active").index();
            self.scroll(pos - self.PAGE_SIZE, true);
            self.refresh();
        },

        //下一页点击事件
        nextHandler: function (event) {
            var self = event.data.self;
            self.showPage(self.page + 1);
            var pos = self.$titles.children(".active").index();
            self.scroll(pos + self.PAGE_SIZE, true);
            self.refresh();
        },

        /**
         * 翻页
         * @param pageNum 页码
         */
        showPage: function (pageNum) {

            if (this.page === pageNum) {
                return false;
            }

            //边界检测
            var maxPageSize = Math.floor(this.getSize() / this.PAGE_SIZE);

            if (pageNum < 0) {
                pageNum = 0;
            } else if (pageNum > maxPageSize) {
                pageNum = maxPageSize;
            }

            //计算偏移
            var tabsOffset = -pageNum * this.TAB_WIDTH * (this.PAGE_SIZE);

            //翻页动画
            this.$titles.css({
                "left": tabsOffset
            });

            this.page = pageNum;

        },

        //获取天数
        getSize: function () {
            return this.$titles.find(".navigation-item").length;
        },

        //添加一天
        add: function () {

            //通过模板生成DOM
            var $title = $template.children(".navigation-item").clone();
            var $content = $template.children(".day").clone();

            //添加到页面中
            this.$titles.append($title);
            this.$contents.append($content);

            //设置属性
            var size = this.getSize();
            $title.find("b").html(size);
            $content.find("").data("state", "edit");
            $content.find("").html(size);

            this.scroll(size - 1, true);
            this.refresh();

        },

        /**
         * 在pos之后插入一天
         * @param pos 当前标签位置
         */
        insert: function (pos) {
            var self = this;

            //通过模板生成DOM
            var $title = $template.children(".navigation-item").clone();
            var $content = $template.children(".day").clone();
            $content.hide();

            //添加到页面中
            this.$titles.children().eq(pos).after($title);
            this.$contents.children().eq(pos).after($content);

            //设置属性
            var size = self.getSize();
            $title.find("b").html(size);
            $content.find(".mcd-head").addClass("edit");
            self.refresh();
            //下拉动画
            $content.slideDown(200, function () {

                //切换到新添加的页面
                self.scroll(pos + 1, false);
                var pageNum = Math.floor((pos + 1) / self.PAGE_SIZE);
                self.showPage(pageNum);
                self.refresh();

            });

        },

        /**
         * 删除某天
         * @param pos 要删除的序号
         */
        del: function (pos) {

            //不删除最后一天
            if (this.getSize() == 1) {
                return false;
            }

            //删除标签
            this.$titles.children().eq(pos).animate({
                "width": 0
            }, 200, function () {
                $(this).remove();
            });

            //删除内容
            var self = this;
            var $content = this.$contents.children().eq(pos);
            $content.slideUp(200, function () {
                $(this).remove();
                self.refresh();
                if (self.getSize() == pos) {
                    self.scroll(pos - 1, false);
                } else {
                    self.scroll(pos, false);
                }
                self.refresh();
            });
        },

        /**
         * 显示pos位置的标签
         * @param pos 标签位置
         */
        show: function (pos) {

            //边界
            if (pos >= this.getSize()) {
                pos = this.getSize() - 1;
            } else if (pos < 0) {
                pos = 0;
            }

            this.$titles.children().removeClass("active");
            this.$titles.children().eq(pos).addClass("active");
            this.$contents.children().removeClass("active");
            this.$contents.children().eq(pos).addClass("active");

            var page = Math.floor(pos / this.PAGE_SIZE);
            this.showPage(page);

        },

        //刷新
        refresh: function () {

            //计算总标签宽度
            var size = this.getSize();
            var width = (size - 1) * this.TAB_WIDTH + this.TAB_ACTIVE_WIDTH;
            this.$titles.css("width", width);

            //刷新天数数字
            for (var i = 0; i < this.getSize(); i++) {
                this.$titles.children().eq(i).find("b").html(i + 1);
                this.$contents.children().eq(i).find(".day-caption>b").html(i + 1);
                this.$contents.children().eq(i).find("[name=nDay]").val(i+1);
            }

            //翻页按钮
            if (size > 20) {
                this.$next.show();
                this.$prev.show();
            } else {
                this.$next.hide();
                this.$prev.hide();
            }

            //添加按钮定位
            var $navigation = this.$titles.parents(".navigation");
            var navigationWidth = (this.PAGE_SIZE - 1) * this.TAB_WIDTH + this.TAB_ACTIVE_WIDTH;

            var lastPage = Math.floor((size - 1) / this.PAGE_SIZE);
            if (this.page === lastPage) {
                navigationWidth = (size - 1) % this.PAGE_SIZE * this.TAB_WIDTH + this.TAB_ACTIVE_WIDTH
            }

            $navigation.css("width", navigationWidth);

        },

        /*模块部分*/

        //显示模块下拉菜单
        showModuleDropDownHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);

            //下拉框
            var $DropDown = self.$moduleDropDown;

            //保存索引
            var $day = $this.parents(".day");
            var dayIndex = $day.index();

            var $module = $this.parents(".module");
            var moduleIndex = null;
            if ($module.length > 0) {
                moduleIndex = $module.index();
            }
            $DropDown.data("dayIndex", dayIndex);
            $DropDown.data("moduleIndex", moduleIndex);

            //计算高度
            var top = $this.offset().top + 30;
            $DropDown.css({
                "top": top
            });

            //只能添加单个全天用餐
            var $moduleList = $day.find(".module");
            var $restaurantButton = $DropDown.find("[data-template=template-restaurant]");
            var $restaurant = $moduleList.filter(".template-restaurant");
            var hasRestaurantAllDay = false;
            for (var i = 0; i < $restaurant.length; i++) {
                var hourVal = $restaurant.eq(i).find(".JS_time_hour").val();
                if (hourVal === "全天") {
                    hasRestaurantAllDay = true;
                }
            }
            if (hasRestaurantAllDay) {
                $restaurantButton.addClass("disabled");
            } else {
                $restaurantButton.removeClass("disabled");
            }

            //显示
            $DropDown.show();

        },

        //隐藏模块下拉菜单
        hideModuleDropDownHandler: function (event) {

            var self = event.data.self;
            var $target = $(event.target);
            var $list = $target.parents(".day-module-add");
            if ($list.length > 0) {
                return false;
            }
            if ($target.is(".day-module-add")) {
                return false;
            }
            self.$moduleDropDown.hide();

        },

        //添加模块
        addModuleHandler: function (event) {

            var self = event.data.self;

            var $this = $(this);

            if ($this.is(".disabled")) {
                return false;
            }

            self.allSave(function () {

                $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");

                //添加行程信息
                var $dropDown = $this.parents(".day-module-add-content");
                //天索引（添加模块里放进去的）
                var dayIndex = $dropDown.data("dayIndex");
                //模块索引（添加模块里放进去的）
                var moduleIndex = $dropDown.data("moduleIndex");
                var $day = $(".day").eq(dayIndex);
                var $dayHeader = $day.find(".day-head");
                $dayHeader.removeClass("state-edit").addClass("state-view");
                var $modules = $day.find(".day-body");
                //新模块
                var templateName = $this.data("template");
                //自由活动与其他活动公用一个模板
                var tempTemplateName = templateName;
                if (templateName == "template-free-time" || templateName == "template-others") {
                    templateName = "template-activity";
                }

                var $newModule = $template.children("." + templateName).clone();

                if (tempTemplateName == "template-free-time") {
                    $newModule.find(".JS_title_row").remove();
                    $newModule.find(".module-title").html("自由活动");
                    $newModule.find("input[name='moduleType']").val("FREE_ACTIVITY");
                    $newModule.find("activity-item").removeClass("activity-item");
                    $newModule.find(".module-main .module-label").eq(0).html("活动时间：");
                    $newModule.find(".JS_visit_hour").attr("data-validate","{regular:true}");
                    $newModule.find(".JS_visit_minute").attr("data-validate","{regular:true}");
                } else if (tempTemplateName == "template-traffic") {
                	var totalDays = $(".day").size() -1;
                	var $pickUpDay = $newModule.find("[name='prodRouteDetailVehicleList[0].pickUpDay']");
                	$pickUpDay.empty();
                	for(var currentDay= dayIndex + 1; currentDay <=totalDays; currentDay ++ ){
                		$pickUpDay.append("<option value='" + currentDay+ "'>" + currentDay + "</option>");
                	}
                }
                var categoryId = $("#categoryId").val();
                var productType = $("#productType").val();
            	if(categoryId!=18 && productType!="FOREIGNLINE"){
            		if(tempTemplateName == "template-others"){//其他活动必填
            			$newModule.find(".module-main ").addClass("activity-item");
            			$newModule.find(".module-main .module-label").eq(1).html("<em>*</em>活动时间：");
                        $newModule.find(".JS_visit_hour").attr("data-validate","{required:true,regular:true}");
                        $newModule.find(".JS_visit_minute").attr("data-validate","{required:true,regular:true}");
            		}else if(tempTemplateName == "template-recommend"){//推荐项目必填
            			 $newModule.find(".require_time").html("<em style='color:#FF0000'>*</em> 项目时间 ：");
            			 $newModule.find(".require_time").next().find(".form-control").attr("data-validate","{required:true,regular:true}");
            		}
            	}

                $newModule.addClass("state-edit");

                //添加到页面
                if (moduleIndex !== null) {
                    $modules.children().eq(moduleIndex).after($newModule);
                } else {
                    $modules.prepend($newModule);
                }

                switch (templateName) {
                    case "template-view-spot":
                        self.viewSpotInit($newModule);
                        break;
                    case "template-hotel":
                        self.hotelInit($newModule);
                        break;
                    case "template-restaurant":
                        self.restaurantInit($newModule);
                        break;
                    case "template-shop":
                        self.shopInit($newModule);
                        break;
                }


            }, function() {}, $(this));

        },

        //删除模块
        delModuleHandler: function (event) {
            var self = event.data.self;
            var $this = $(this);
            var $module = $this.parents(".module");
            $module.slideUp(200, function () {
                $module.remove();
            });
        },
        delEnterModuleHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);
            var $module = $this.parents(".module");
            $module.addClass("delete");

        },
        delLeaveModuleHandler: function (event) {

            var self = event.data.self;
            var $this = $(this);
            var $module = $this.parents(".module");
            $module.removeClass("delete");

        },

        //购物初始化
        shopInit: function ($Module) {
            var $increase = $Module.find(".JS_shop_increase");
            $increase.click();
            $increase.hide();
        },

        //景点初始化
        viewSpotInit: function ($Module) {
            var $increase = $Module.find(".JS_view_spot_increase");
            $increase.click();
            $increase.hide();
        },

        //酒店初始化
        hotelInit: function ($Module) {
            var $increase = $Module.find(".JS_hotel_increase");
            $increase.click();
            $increase.hide();
        },

        //用餐初始化
        restaurantInit: function ($Module) {
            var $multipleSelect = $Module.find(".multiple-select");
            backstage.multipleSelect({
                $multipleSelect: $multipleSelect
            });

        }

    };

});

//标题和目的地
$(function () {
    //切换标题和目的地
    $document.on("change", ".JS_switch_title", switchTitleHandler);

    //添加目的地
    $document.on("click", ".JS_location_add", locationAddHandler);

    //删除目的地
    $document.on("mouseenter", ".location-item", locationItemEnterHandler);
    $document.on("mouseleave", ".location-item", locationItemLeaveHandler);
    $document.on("click", ".JS_location_del", locationDelHandler);

    //切换标题和目的地
    function switchTitleHandler() {
        var $this = $(this);
        var $formEdit = $this.parents(".edit");
        var $location = $formEdit.find(".location");
        var $title = $formEdit.find(".title");
        var type = $this.val();
        switch (type) {
            case "TITLE":
                $title.find(":input").prop("disabled", false);
                $location.find(":input").prop("disabled", true);
                $formEdit.removeClass("state-location").addClass("state-title");
                break;
            case "LOCATION":
                $location.find(":input").prop("disabled", false);
                $title.find(":input").prop("disabled", true);
                $formEdit.removeClass("state-title").addClass("state-location");
                break;
        }
    }

    //添加目的地
    function locationAddHandler() {

        var $this = $(this);
        var $location = $this.parents(".location");
        var $locationList = $location.find(".location-list");

        //数量上限
        if ($locationList.children().length >= 10) {
            backstage.floatAlert({
                className: "float-alert-warning",
                content: "最多添加10个"
            });
            return false;
        }

        var $newLocationItem = $template.children(".location-item").clone();

        $locationList.append($newLocationItem);

    }

    //删除目的地
    function locationItemEnterHandler() {
        var $this = $(this);
        var $delButton = $this.find(".location_del");
        $delButton.show();
    }

    function locationItemLeaveHandler() {
        var $this = $(this);
        var $delButton = $this.find(".location_del");
        $delButton.hide();
    }

    function locationDelHandler() {
        var $this = $(this);
        var $locationItem = $this.parents(".location-item");
        $locationItem.remove();
    }

});

//时间编辑器
$(function () {

    //点击时间输入框
    $document.on("click", ".JS_time_hour", clickTimeHandler);
    $document.on("change keyup", ".JS_time_hour", changeHourHandler);
    $document.on("click", ".JS_time_minute", clickTimeHandler);
    $document.on("click", hideTimeHandler);
    $document.on("click", ".time-edit-hour .col", pickHourHandler);
    $document.on("click", ".time-edit-minute .col", pickMinuteHandler);

    //点击时间输入框事件
    function clickTimeHandler() {
        var $this = $(this);
        var top = $this.offset().top;

        var $input = $this.parents(".JS_time_input");
        var $hour = $input.find(".JS_time_hour");

        var $timeEdit = $(".main>.time-edit");

        $timeEdit.data("input", $input);
        $timeEdit.data("oldVal", $hour.val());

        $timeEdit.css({
            "top": top + 26
        });
        $timeEdit.show();
    }

    //隐藏时间输入框
    function hideTimeHandler(event) {

        var $target = $(event.target);
        var $input = $target.parents(".JS_time_input");
        var $this = $(this);

        if ($input.length > 0) {
            return false;
        }

        if ($target.parents(".time-edit-hour").length > 0 && $target.parents(".fragment").length === 0) {
            return false;
        }

        var $timeEdit = $(".main>.time-edit");
        $timeEdit.hide();
    }

    //选择小时事件
    function pickHourHandler(event) {

        var $this = $(this);
        var $fragment = $this.parents(".fragment");

        var isFragment = false;
        if ($fragment.length > 0) {
            isFragment = true;
        }
        var val = $this.html();

        var $timeEdit = $this.parents(".time-edit");
        var $input = $timeEdit.data("input");
        var $hour = $input.find(".JS_time_hour");
        var $minute = $input.find(".JS_time_minute");
        var $about = $input.find(".JS_time_about");

        $hour.val(val).change();
        $minute.focus();

        if (isFragment) {
            $about.hide();
        } else {
            $about.show();
        }

    }

    //选择分钟事件
    function pickMinuteHandler() {

        var $this = $(this);
        var val = $this.html();

        var $timeEdit = $this.parents(".time-edit");
        var $input = $timeEdit.data("input");
        var $minute = $input.find(".JS_time_minute");

        $minute.val(val).change();

    }

    //修改时间事件
    function changeHourHandler(event) {

        var $this = $(this);
        var $input = $this.parents(".JS_time_input");
        var $blank = $input.find(".JS_time_blank");
        var $minute = $input.find(".JS_time_minute");
        var val = $this.val();

        var chineseReg = /[\u2E80-\u9FFF]+/;
        var hasChinese = chineseReg.test(val);

        //是否包含中文
        if (hasChinese) {

            //如果是删除按键
            var keyCode = event.keyCode;
            if (keyCode == 46) {
                $this.val("");
                $blank.show();
                $minute.prop("disabled", false).show();
            } else {
                $blank.hide();
                $minute.prop("disabled", true).hide();
            }

        } else {
            $blank.show();
            $minute.prop("disabled", false).show();
        }

    }

});

//文本框收起展开
$(function () {

    $document.on("click", ".JS_textarea_expand", textareaExpandHandler);
    $document.on("click", ".JS_textarea_shrink", textareaShrinkHandler);

    function textareaExpandHandler() {
        var $this = $(this);
        var $parent = $this.parents(".JS_textares_box");
        var $textarea = $parent.find(".textarea-content");
        var $expand = $parent.find(".JS_textarea_expand");
        var $shrink = $parent.find(".JS_textarea_shrink");
        $textarea.slideDown(200);
        var text = $expand.attr("data-text");
        if (text) {
            $expand.html(text);
        }
        $expand.hide();
        $shrink.show();
    }

    function textareaShrinkHandler() {
        var $this = $(this);
        var $parent = $this.parents(".JS_textares_box");
        var $textarea = $parent.find(".textarea-content");
        var $expand = $parent.find(".JS_textarea_expand");
        var $shrink = $parent.find(".JS_textarea_shrink");
        $textarea.slideUp(200);
        $expand.show();
        $shrink.hide();
    }

});

//保存提示
$(function () {
    $document.on("click", ".top-save-tip>.close", function () {
        var $this = $(this);
        var $tip = $this.parent();
        $tip.hide();
    })
});

//通用
$(function () {
    //提示框
    //TODO 删除 try
    try {
        backstage.poptip();
        //backstage.multipleSelect();
    } catch (e) {
        console.log(e);
    }

    //单选框控制disabled
    $(function () {
        var $document = $(document);
        $document.on("change", ".JS_radio_switch", radioSwitchHandler);
        function radioSwitchHandler() {
            var $this = $(this);
            var $group = $this.parents(".JS_radio_switch_group");
            var $box = $this.parents(".JS_radio_switch_box");
            var $groupDisabled = $group.find(".JS_radio_disabled");
            var $boxDisabled = $box.find(".JS_radio_disabled");
            var isChecked = $this.is(":checked");
            if (isChecked) {
                $groupDisabled.prop("disabled", true).change();
                $groupDisabled.val("");
                $boxDisabled.prop("disabled", false).change();
                $boxDisabled.focus();
            }
        }
    });
});


/*景点模块 START*/
$(function () {

    //增加景点
    $document.on("click", ".JS_view_spot_increase", viewSpotIncreaseHandler);

    //删除景点
    //$document.on("click", ".JS_view_spot_del", viewSpotDelHandler);

    //切换行程包含
    $document.on("change", ".JS_view_spot_include", viewSpotIncludeHandler);


    //增加景点
    function viewSpotIncreaseHandler() {

        var $this = $(this);
        var $module = $this.parents(".module");

        var $viewSpotList = $module.find(".view-spot-list");
        var $newViewSpotItem = $template.children(".view-spot-item").clone();

        //获取list下最后一个item
        var $lastViewSpotItem = $viewSpotList.find(".view-spot-item:last");
        //获取当前index值
        var currentItemIndex = 0;
        if ($lastViewSpotItem.length > 0) {
            currentItemIndex = parseInt($lastViewSpotItem.attr("data-index"));
            currentItemIndex ++;
        }

        $newViewSpotItem.html($newViewSpotItem.html().replace(/{{index}}/g, currentItemIndex));
        $newViewSpotItem.attr("data-index", currentItemIndex);

        //判断是否是国内产品类型
        var productType = $("#productType").val();
        var isInnerLine = false;
        if (productType == "INNERLINE" || productType == "INNERSHORTLINE" || productType == "INNERLONGLINE") {
            isInnerLine = true;
        }

        //如果是国内线路产品，将游览时间设置为必填项
        if (isInnerLine) {
            var $visitTimeEm = $newViewSpotItem.find(".JS_visit_time_em");
            var $visitHourInput = $newViewSpotItem.find(".JS_visit_hour");
            var $visitMinuteInput = $newViewSpotItem.find(".JS_visit_minute");
            $visitTimeEm.html("*");
            $visitMinuteInput.attr("data-validate", "{required:true,regular:仅支持输入数字}");
            $visitHourInput.attr("data-validate", "{required:true,regular:仅支持输入数字}");
        }

        $viewSpotList.append($newViewSpotItem);

        var index = $newViewSpotItem.index();

        if (index === 0) {
            $newViewSpotItem.find(".view-spot-del-box").remove();
            $newViewSpotItem.find(".JS_view_spot_and_or").remove();
            //$newViewSpotItem.find(".JS_view_spot_del").remove();
        }

        $this.hide();

    }

    //删除景点
    function viewSpotDelHandler() {

        var $this = $(this);

        var $thatViewSpotItem = $this.parents(".view-spot-item");

        var $viewSpotList = $this.parents(".view-spot-list");

        var $module = $this.parents(".module");
        var $increase = $module.find(".JS_view_spot_increase");

        var $viewSpotInitial = $thatViewSpotItem.find(".view-spot-initial");
        var $viewSpotForm = $thatViewSpotItem.find(".view-spot-form");

        if ($thatViewSpotItem.index() == 0) {
            $viewSpotInitial.find(":input").prop("disabled", false);
            $viewSpotForm.find(":input").prop("disabled", true);
            $thatViewSpotItem.removeClass("state-added");
        } else {
            $thatViewSpotItem.remove();
        }

        var $viewSpotItem = $viewSpotList.children();
        if ($viewSpotItem.length === 1 && $viewSpotItem.eq(0).is(".state-added")) {
            $increase.show();
        }

    }


    //切换行程包含
    function viewSpotIncludeHandler() {

        var $this = $(this);
        var val = $this.val();

        var $form = $this.parents(".view-spot-form");

        var $label = $form.find(".JS_view_spot_price_label");


        var $price = $form.find(".JS_view_spot_price");

        if (val === "SELF_PAYING") {
            $price.attr("data-validate", "{required:true,regular:仅支持输入数字}");
            $label.show();
        }  else {
            $price.attr("data-validate", "{required:false,regular:仅支持输入数字}");
            $label.hide();
        }

        if (val === "ROUTE_INCLUDED" || val ==="GIVING") {
            $price.prop("disabled", true).val("");
        } else {
            $price.prop("disabled", false);
        }
    }


});
/*景点模块 END*/

/*交通模块 START*/
$(function () {

    //切换交通方式事件
    $document.on("click", ".traffic-tab", switchTrafficWayHandler);

    //切换交通方式事件
    function switchTrafficWayHandler() {

        //变量
        var $this = $(this);
        var $parent = $this.parents(".traffic-module-main");
        var $otherDetails = $parent.find(".JS_traffic_other_details");

        //标签
        var $tab = $parent.find(".traffic-tab");

        //内容
        var $item = $parent.find(".traffic-item");

        //标签索引
        var tabIndex = $tab.index($this);

        //当前内容
        var $itemActive = $parent.find(".traffic-item.active");

        //当前内容索引
        var itemIndex = $item.index($itemActive);

        //切换交通方式
        function switchTrafficWay() {
            $itemActive.removeClass("active");
            $item.eq(tabIndex).addClass("active");
            //将其他tab下的元素disable掉，这样当serializeArray的时候才不会提交该元素
            $item.eq(tabIndex).find(".form-control").prop("disabled", false);
            $item.not($item.get(tabIndex)).find(".form-control").prop("disabled", true);

            if (tabIndex === 5) {
                $otherDetails.prop("disabled", false);
            } else {
                $otherDetails.prop("disabled", true);
            }

            //还原表单状态
            $itemActive.find(":input").val("");
            $otherDetails.val("");

            //还原文本框
            $itemActive.find(".JS_textarea_expand")
                .show()
                .html('添加交通说明<i class="triangle"></i>');
            $itemActive.find(".textarea-content").hide();
            $itemActive.find(".JS_textarea_shrink").hide();

        }

        //还原交通方式
        function restoreTrafficWay() {
            $tab.eq(itemIndex).prop("checked", true);
        }

        //当前选择标签与显示内容不同，则提示清除数据
        if (tabIndex !== itemIndex) {

            if (itemIndex !== -1) {
                backstage.confirm({
                    width: 400,
                    title: "警告",
                    content: "原交通内容将被清空，确认修改交通类型？",
                    determineCallback: function () {
                        switchTrafficWay();
                    },
                    cancelCallback: function () {
                        restoreTrafficWay();
                    },
                    closeCallback: function () {
                        restoreTrafficWay();
                    }
                })
            } else {
                switchTrafficWay();
            }

        }
       
        var flightTimeValidate = $("#flightTimeValidate").val();
        //如果是出境并且线路
        if (flightTimeValidate == 'Y') {
        	$(".traffic-item .JS_vehicle_hour_blur, .traffic-item .JS_vehicle_minute_blur").each(function(){
        		$(this).trigger("blur");
        	});        
        }
    }

});
/*交通模块 END*/

/*用餐模块 START*/
$(function () {
	
    //开始时间切换
    $document.on("change", ".template-restaurant .JS_time_hour", switchRestaurantType);

    //开始时间切换
    function switchRestaurantType() {
        var $this = $(this);
        var $module = $this.parents(".module");
        var $type = $module.find(".JS_restaurant_type");
        var $tip = $module.find(".JS_restaurant_all_day_tip");

        var hours = $this.val();
        var type = "state-single";
        if ($type.is(".state-multiple")) {
            type = "state-multiple";
        }

        var $timeEdit = $(".main>.time-edit");
        var oldVal = $timeEdit.data("oldVal");

        //修改状态
        function changeData() {
            if (hours === "全天") {
                $type.removeClass("state-single").addClass("state-multiple");
                $tip.show();

                $type.find(".JS_restaurant_type_single :input").prop("disabled", true).val("");
                $type.find(".JS_restaurant_type_multiple :input").prop("disabled", false);
                
                var categoryId = $("#categoryId").val();
                var productType = $("#productType").val();
            	if(categoryId!=18 && productType!="FOREIGNLINE"){
	                var mealTypes = $type.find(".JS_restaurant_type_multiple :input").val();
	                $(mealTypes).each(function(index,value){
	                    if("LUNCH"==value){
	                    	$module.find(".JS_switch_allday").find(".lunchname").html("<em style='color:#FF0000'>*</em>中餐");
                    		$module.find(".JS_switch_allday").find(".JS_lunch_meal_price").attr("data-validate","{required:true,regular:true}");
	                    }else if("DINNER"==value){
	                    	$module.find(".JS_switch_allday").find(".dinnername").html("<em style='color:#FF0000'>*</em>晚餐");
                    		$module.find(".JS_switch_allday").find(".JS_dinner_meal_price").attr("data-validate","{required:true,regular:true}");
	                    }
	                });
	                $module.find(".JS_switch_noallday").find(".module-label").eq(1).html("餐费标准：");
                	$module.find(".JS_switch_noallday").find(".JS_meal_price").attr("data-validate","{regular:true}");
	            	
            	}
                $module.find(".JS_switch_noallday").hide();
                $module.find(".JS_switch_allday").show();
                
                //清空 不为“全天”的 用餐时间  和餐费标准
                //清空所有输入框
        		$module.find(".JS_switch_noallday :input").val("");
        		//清空所有下拉框
        		$module.find(".JS_meal_currency").val("");
        		//清空全天模式下的所有输入框
        		$module.find(".JS_switch_allday :input").val("");
        		//清空全天模式下的所有下拉框
        		$module.find(".JS_select_switch_breakfast").val("");
        		$module.find(".JS_select_switch_lunch").val("");
        		$module.find(".JS_select_switch_dinner").val("");
            } else {
                $type.removeClass("state-multiple").addClass("state-single");
                $tip.hide();

                $type.find(".JS_restaurant_type_single :input").prop("disabled", false);
                $type.find(".JS_restaurant_type_multiple :input").prop("disabled", true).val("");
                
                var categoryId = $("#categoryId").val();
                var productType = $("#productType").val();
            	if(categoryId!=18 &&productType!="FOREIGNLINE"){
	                $module.find(".JS_switch_allday").find(".lunchname").html("中餐");
                	$module.find(".JS_switch_allday").find(".JS_lunch_meal_price").attr("data-validate","{regular:true}");
	                $module.find(".JS_switch_allday").find(".dinnername").html("晚餐");
                	$module.find(".JS_switch_allday").find(".JS_dinner_meal_price").attr("data-validate","{regular:true}");
            	}
                $module.find(".JS_switch_noallday").show();
                $module.find(".JS_switch_allday").hide();
                
                //清空 为“全天”的 用餐时间  和餐费标准
                //清空所有输入框
        		$module.find(".JS_switch_noallday :input").val("");
        		//清空所有下拉框
        		$module.find(".JS_meal_currency").val("");
                //清空全天模式下的所有输入框
        		$module.find(".JS_switch_allday :input").val("");
        		//清空全天模式下的所有下拉框
        		$module.find(".JS_select_switch_breakfast").val("");
        		$module.find(".JS_select_switch_lunch").val("");
        		$module.find(".JS_select_switch_dinner").val("");
            }
            //清空表单
            backstage.multipleSelect({
                $multipleSelect: $type.find(".multiple-select")
            });
        }

        //还原数据
        function restoreData() {
            $this.val(oldVal).change();
        }

        //如果类型相对应
        if ((hours === "全天" && type === "state-multiple") || (hours !== "全天" && type === "state-single")) {
            //Do nothing
        } else {

            var $select = null;
            if (type === "state-single") {
                $select = $module.find(".JS_restaurant_type_single select");
            } else if (type === "state-multiple") {
                $select = $module.find(".JS_restaurant_type_multiple select");
            }

            if ($select.val() === "" || $select.val() === null) {
                changeData();
            } else {
                backstage.confirm({
                    content: '修改时间后，现有用餐类型将会清空并修改，' +
                    '<span class="text-danger">是否确定修改时间？</span>',
                    determineCallback: function () {
                        changeData();
                    },
                    cancelCallback: function () {
                        restoreData();
                    }
                });
            }

        }

    }

});
/*用餐模块 END*/

/*购物模块 START*/
$(function () {

    //增加购物
    $document.on("click", ".JS_shop_increase", shopIncreaseHandler);

    //删除购物
    //$document.on("click", ".JS_shop_del", shopDelHandler);

    //增加购物
    function shopIncreaseHandler() {

        var $this = $(this);
        var $module = $this.parents(".module");

        var $shopList = $module.find(".shop-list");
        var $newshopItem = $template.children(".shop-item").clone();

        //获取list下最后一个item
        var $lastShopItem = $shopList.find(".shop-item:last");
        //获取当前index值
        var currentItemIndex = 0;
        if ($lastShopItem.length > 0) {
            currentItemIndex = parseInt($lastShopItem.attr("data-index"));
            currentItemIndex ++;
        }

        $newshopItem.html($newshopItem.html().replace(/{{index}}/g, currentItemIndex));
        $newshopItem.attr("data-index", currentItemIndex);
        $shopList.append($newshopItem);

        var index = $newshopItem.index();

        if (index === 0) {
            $newshopItem.find(".shop-del-box").remove();
            $newshopItem.find(".JS_shop_and_or").remove();
            //$newshopItem.find(".JS_shop_del").remove();
        }

        $this.hide();

    }

    //删除购物
    function shopDelHandler() {

        var $this = $(this);

        var $thatshopItem = $this.parents(".shop-item");

        var $shopList = $this.parents(".shop-list");

        var $module = $this.parents(".module");
        var $increase = $module.find(".JS_shop_increase");

        var $shopInitial = $thatshopItem.find(".shop-initial");
        var $shopForm = $thatshopItem.find(".shop-form");

        if ($thatshopItem.index() == 0) {
            $shopInitial.find(":input").prop("disabled", false);
            $shopForm.find(":input").prop("disabled", true);
            $thatshopItem.removeClass("state-added")
        } else {
            $thatshopItem.remove();
        }

        var $shopItem = $shopList.children();
        if ($shopItem.length === 1 && $shopItem.eq(0).is(".state-added")) {
            $increase.show();
        }

    }

});
/*购物模块 END*/

/*自由活动 其他活动 START*/
$(function () {

    $document.on("change", ".JS_activity_time", changeActivityDistanceHandler);
    function changeActivityDistanceHandler() {
        var $this = $(this);
        var $module = $this.parents(".module");
        var $distance = $this.parent().parent().find(".JS_activity_distance");
        switch ($this.val()) {
            case "DRIVE":
            	$distance.html("行驶距离");
                break;
            case "WALK":
            	$distance.html("徒步距离");
                break;
        }
    }

});
/*自由活动 其他活动 END*/

/*酒店模块 START*/
$(function () {
    //增加酒店
    $document.on("click", ".JS_hotel_increase", hotelIncreaseHandler);
    //删除酒店
    //$document.on("click", ".JS_hotel_del", hotelDelHandler);
    //增加酒店
    function hotelIncreaseHandler() {
        var $this = $(this);
        //获取当前模块（酒店）
        var $module = $this.parents(".module");
        //酒店列表
        var $hotelList = $module.find(".hotel-list");
        //通过template clone一份
        var $newHotelItem = $template.children(".hotel-item").clone();
        //获取list下最后一个item
        var $lastHotelItem = $hotelList.find(".hotel-item:last");
        //获取当前index值
        var currentItemIndex = 0;
	    if ($lastHotelItem.length > 0) {
	        currentItemIndex = parseInt($lastHotelItem.attr("data-index"));
	        currentItemIndex ++;
	    }
	    $newHotelItem.html($newHotelItem.html().replace(/{{index}}/g, currentItemIndex));
	    $newHotelItem.attr("data-index", currentItemIndex);
	    $hotelList.append($newHotelItem);
        var index = $newHotelItem.index();
        if (index === 0) {
            $newHotelItem.find(".hotel-del-box").remove();
            $newHotelItem.find(".JS_hotel_and_or").remove();
            //$newHotelItem.find(".JS_hotel_del").remove();
            $newHotelItem.find(".hotel-and-or").remove();
        }
        $this.hide();
    }

    //删除酒店
    function hotelDelHandler() {
        var $this = $(this);
        var $thatHotelItem = $this.parents(".hotel-item");
        var $hotelList = $this.parents(".hotel-list");
        var $module = $this.parents(".module");
        var $increase = $module.find(".JS_hotel_increase");
        var $hotelInitial = $thatHotelItem.find(".hotel-initial");
        var $hotelForm = $thatHotelItem.find(".hotel-form");
        if ($thatHotelItem.index() == 0) {
            $hotelInitial.find(":input").prop("disabled", false);
            $hotelForm.find(":input").prop("disabled", true);
            $thatHotelItem.removeClass("state-added");
        } else {
            $thatHotelItem.remove();
        }
        var $hotelItem = $hotelList.children();
        if ($hotelItem.length === 1 && $hotelItem.eq(0).is(".state-added")) {
            $increase.show();
        }
    }
    
});
/*酒店模块 END*/










