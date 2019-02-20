/**
 * Author：     yinhanchun
 * Date:        2015-08-20
 * Version:     1.0.0.0
 * Description: VST条款
 */

  /**
 * jQuery警示框插件saveAlert
 * Jiang Sheng
 * 2015-08-18
 */
(function ($) {

    var defaults = {
        "type": "success",
        "width": 100,
        "height": 30,
        "lineHeight": 30,
        "text": "警告内容",
        "hideTime": 1000,
        "callback": function () {
        }
    };

    $.saveAlert = function (options) {

        options = $.extend(defaults, options);

        var $body = $("body");

        var $alert = $('<div class="gi-alert"></div>');
        $alert.css({
            "width": options.width + "px",
            "height": options.height + "px",
            "lineHeight": options.lineHeight + "px",
            "marginLeft": -options.width / 2 + "px",
            "marginTop": -options.height / 2 + "px"
        });
        $alert.html(options.text);

        $body.append($alert);

        switch (options.type) {
            case "success":
                $alert.addClass("gi-alert-success");
                break;
            case "danger":
                $alert.addClass("gi-alert-danger");
                break;
        }

        //执行回调函数
        options.callback();

        //自动隐藏并销毁
        setTimeout(function () {
            $alert.fadeOut(500, function () {
                $alert.remove();
            });
        }, options.hideTime);

        //返回对象方便手动销毁
        return {
            "$alert": $alert,
            "destroy": function () {
                $alert.remove();
            }
        };
    };

})(jQuery);

$(function(){
    var $document = $(document);
	//复选框列表
 	var $lteCheckboxList = $(".lte_check_list");
	//添加条件的复选框
	var $lteCheckboxAdd = $(".lte_checkbox_add");
	//添加条件的输入框
	var $lteInputAdd = $(".lte_input_add");
	//添加条件的按钮
	var $lteBtnAdd = $(".lte_btn_add");
	//模板
	var $lteTemplate = $(".lte_template");
	
	//添加说明条款复选框操作
	$lteCheckboxAdd.on("change", function(){
		var isChecked = $(this).attr("checked") === "checked";
		$lteInputAdd.attr("disabled", !isChecked);
		$lteBtnAdd.attr("disabled", !isChecked);
	});
	//删除说明条款操作
	$lteCheckboxList.on("click", ".lte_detele_btn", function(){
		$(this).parents(".lte_check").remove();
	});

    //添加说明条款操作
    $lteBtnAdd.on("click", function(){
        var inputContent = $lteInputAdd.val();
        if($lteInputAdd.attr("disabled")!=="disabled" && inputContent !== "" && inputContent!==$lteInputAdd.attr("data-placeholder")){
            $lteInputAdd.val("");
            var $lteNewCheck = $lteTemplate.find(".lte_check").clone();
            $lteNewCheck.find("em").prepend(inputContent);
            $lteCheckboxList.append($lteNewCheck);
        }
    });

	 //占位字符 placeholder
    (function () {
        var $placeHolder = $("input[data-placeholder]");

        $document.on("focus", "input[data-placeholder]", placeholderFocusHandle);

        function placeholderFocusHandle() {
            var $this = $(this);
            var text = $this.data("placeholder");
            if ($this.val() === text) {
                $this.removeClass("placeholder");
                $this.val("");
            }

        }

        $document.on("blur", "input[data-placeholder]", placeholderBlurHandle);

        function placeholderBlurHandle() {
            var $this = $(this);
            var text = $this.data("placeholder");
            if ($this.val() === "") {
                $this.addClass("placeholder");
                $this.val(text);
            }

        }

        $placeHolder.blur();

    })();

});

/**
 * Author：     yinhanchun
 * Date:        2015-08-17
 * Version:     1.0.0.0
 * Description: EBK出行警示
 */
$(function() {
    var $document = $(document);

    //模板内嵌套模板
    var $templateInner = $(".JS_template_inner");

    var $modalOverlay = $(".gi-modal-overlay"); //模态窗口遮罩

    //行前须知条款部分
    (function() {
        var NOTICE_STATUS = []; // 用于存储"查看编辑范围"内的checkbox已保存的状态
        var $giNoticeModal = $(".gi-modal-notice");
        var $giNoticeStatus = $(".gi-notice-status");
        var $giNoticeShowModalBtn = $(".gi-notice-show-modal-btn");
        bindModalFuns(NOTICE_STATUS, $giNoticeModal, $giNoticeStatus, $giNoticeShowModalBtn, $(".gi-notice-checkbox"));
    })();

    //出行说明条款部分
    (function() {
        var EXPLANATION_STATUS = [];
        var $giExplanationModal = $(".gi-modal-explanation");
        var $giExplanationStatus = $(".gi-explanation-status");
        var $giExplanationShowModalBtn = $(".gi-explanation-show-modal-btn");
        bindModalFuns(EXPLANATION_STATUS, $giExplanationModal, $giExplanationStatus, $giExplanationShowModalBtn, $(".gi-explanation-checkbox"));
    })();

    //海岛游条款部分
    (function() {
        var HD_STATUS = [];
        var $giHdModal = $(".gi-modal-hd");
        var $giHdStatus = $(".gi-hd-status");
        var $giHdShowModalBtn = $(".gi-hd-show-modal-btn");
        bindModalFuns(HD_STATUS, $giHdModal, $giHdStatus, $giHdShowModalBtn, $(".gi-hd-checkbox"));
    })();

    //欧洲游条款部分
    (function() {
        var OZ_STATUS = [];
        var $giOzModal = $(".gi-modal-oz");
        var $giOzStatus = $(".gi-oz-status");
        var $giOzShowModalBtn = $(".gi-oz-show-modal-btn");
        bindModalFuns(OZ_STATUS, $giOzModal, $giOzStatus, $giOzShowModalBtn, $(".gi-oz-checkbox"));
    })();

    //日本游条款部分
    (function() {
        var RB_STATUS = [];
        var $giRbModal = $(".gi-modal-rb");
        var $giRbStatus = $(".gi-rb-status");
        var $giRbShowModalBtn = $(".gi-rb-show-modal-btn");
        bindModalFuns(RB_STATUS, $giRbModal, $giRbStatus, $giRbShowModalBtn, $(".gi-rb-checkbox"));
    })();

    //泰国游条款部分
    (function() {
        var TG_STATUS = [];
        var $giTgModal = $(".gi-modal-tg");
        var $giTgStatus = $(".gi-tg-status");
        var $giTgShowModalBtn = $(".gi-tg-show-modal-btn");
        bindModalFuns(TG_STATUS, $giTgModal, $giTgStatus, $giTgShowModalBtn, $(".gi-tg-checkbox"));
    })();

    //美国游条款部分
    (function() {
        var MG_STATUS = [];
        var $giMgModal = $(".gi-modal-mg");
        var $giMgStatus = $(".gi-mg-status");
        var $giMgShowModalBtn = $(".gi-mg-show-modal-btn");
        bindModalFuns(MG_STATUS, $giMgModal, $giMgStatus, $giMgShowModalBtn, $(".gi-mg-checkbox"));
    })();

    //中东非游条款部分
    (function() {
        var ZDF_STATUS = [];
        var $giZdfModal = $(".gi-modal-zdf");
        var $giZdfStatus = $(".gi-zdf-status");
        var $giZdfShowModalBtn = $(".gi-zdf-show-modal-btn");
        bindModalFuns(ZDF_STATUS, $giZdfModal, $giZdfStatus, $giZdfShowModalBtn, $(".gi-zdf-checkbox"));
    })();

    //迪拜游条款部分
    (function() {
        var DB_STATUS = [];
        var $giDbModal = $(".gi-modal-db");
        var $giDbStatus = $(".gi-db-status");
        var $giDbShowModalBtn = $(".gi-db-show-modal-btn");
        bindModalFuns(DB_STATUS, $giDbModal, $giDbStatus, $giDbShowModalBtn, $(".gi-db-checkbox"));
    })();

    //南亚游条款部分
    (function() {
        var NY_STATUS = [];
        var $giNyModal = $(".gi-modal-ny");
        var $giNyStatus = $(".gi-ny-status");
        var $giNyShowModalBtn = $(".gi-ny-show-modal-btn");
        bindModalFuns(NY_STATUS, $giNyModal, $giNyStatus, $giNyShowModalBtn, $(".gi-ny-checkbox"));
    })();

    //关岛游条款部分
    (function() {
        var GD_STATUS = [];
        var $giGdModal = $(".gi-modal-gd");
        var $giGdStatus = $(".gi-gd-status");
        var $giGdShowModalBtn = $(".gi-gd-show-modal-btn");
        bindModalFuns(GD_STATUS, $giGdModal, $giGdStatus, $giGdShowModalBtn, $(".gi-gd-checkbox"));
    })();

    //马尔代夫游条款部分
    (function() {
        var MEDF_STATUS = [];
        var $giMedfModal = $(".gi-modal-medf");
        var $giMedfStatus = $(".gi-medf-status");
        var $giMedfShowModalBtn = $(".gi-medf-show-modal-btn");
        bindModalFuns(MEDF_STATUS, $giMedfModal, $giMedfStatus, $giMedfShowModalBtn, $(".gi-medf-checkbox"));
    })();


    // 绑定 复选框转态改变后 input框状态变化 
	updateInputStatus($(".js-checkbox-group"));

	// 绑定 “特殊接待限制”中含子复选框的元素事件
	$(".gi-cc-outer-group :checkbox").on("change", function(){
		var isChecked = $(this).attr("checked")==="checked";
		var $innerLabel = $(this).parents(".gi-checkbox-combination").find(".gi-cc-inner-group");
		if (isChecked) {
			$innerLabel.show();
		} else {
			$innerLabel.hide();
		}
	});

	// “最晚收材料日” radio转态改变后 input框状态变化 
	$(".gi-last-radio").on("change", function(){
		var $input = $(".gi-last-radio-group input[type='text']");
        var $select = $(".gi-last-radio-group select");
		var isDisabled = true;
		if($(this).val() === "false") {
			isDisabled = false;
		}
		$input.attr("disabled",isDisabled);
        $select.attr("disabled",!isDisabled);
	});


    // 绑定模态窗内各种方法
    function bindModalFuns(arr, $modal, $giStatus, $giShowModalBtn, $giCheck) {
        var $giSaveBtn = $modal.find(".gi-save-btn");
        var $giCheckAll = $modal.find(".gi-check-all");
        var $giCancelBtn = $modal.find(".gi-cancel-btn");
        var $giModalClose = $modal.find(".gi-modal-close");
        var $giCheckBoxes = $modal.find(".gi-checkbox-group input");

        // 存储"查看编辑范围"内的checkbox的初始转态
        saveCheckBoxStatus(arr, $giCheckBoxes);

        // 显示模态窗口
        $giShowModalBtn.on("click", function() {
            showModal($modal);
        });

        // 全选
        $giCheckAll.on("click", function() {
            var isCheckAll = false;
            if ($(this).attr("checked")) {
                isCheckAll = true;
            }
            checkAll($giCheckBoxes, isCheckAll);
        });

        // 修改
        $giCheckBoxes.on("change", function() {
            $giCheckAll.attr("checked", isAllChecked($giCheckBoxes));
        });

        // 保存
        $giSaveBtn.on("click", function() {
            showCheckBoxesStatus($giStatus, isAllChecked($giCheckBoxes));
            saveCheckBoxStatus(arr, $giCheckBoxes);
            hideModal($modal);
            if(isAllNotChecked($giCheckBoxes)) {
                $giCheck.removeAttr("checked");
                $giShowModalBtn.hide();
            }
        });

        // 取消（还原checkBox状态）
        $giCancelBtn.on("click", function() {
            updateCheckBoxStatus(arr, $giCheckBoxes, $giCheckAll);
            hideModal($modal);
        });

        // 关闭模态窗口（还原checkBox状态）
        $giModalClose.on("click", function() {
            updateCheckBoxStatus(arr, $giCheckBoxes, $giCheckAll);
            hideModal($modal);
        });

    }

    // 全选/全不选
    function checkAll($element, isCheckAll) {
        $element.attr("checked", isCheckAll);
    }

    // 检查是否已全选
    function isAllChecked($element) {
        for (var i = 0; i < $element.length; i++) {
            if (!$element.eq(i).attr("checked")) {
                return false;
            }
        }
        return true;
    }

    // 显式是否已全选
    function showCheckBoxesStatus($element, isAllChecked) {
        if (isAllChecked) {
            $element.find(".gi-color-green").show();
            $element.find(".gi-color-red").hide();
        } else {
            $element.find(".gi-color-green").hide();
            $element.find(".gi-color-red").show();
        }
    }

    // 检查是否全未选
    function isAllNotChecked($element) {
        for (var i = 0; i < $element.length; i++) {
            if ($element.eq(i).attr("checked")) {
                return false;
            }
        }
        return true;
    }

    // 显示模态窗口
    function showModal($modal) {
        $modalOverlay.show();
        $modal.show();
        if (parseInt($modal.css("height")) > $(window).height()) {
            $modal.css({
                "position": "absolute",
                "top": $(document).scrollTop()
            });
        }
    }

    // 关闭模态窗口
    function hideModal($modal) {
        $modalOverlay.hide();
        $modal.hide();
    }

    // 存储"查看编辑范围"内的checkbox的转态
    function saveCheckBoxStatus(arr, $element) {
        for (var i = 0; i < $element.length; i++) {
            if ($element.eq(i).attr("checked")) {
                arr[i] = true;
            } else {
                arr[i] = false;
            }
        }
    }

    // 更新页面上"查看编辑范围"内的checkbox的转态
    function updateCheckBoxStatus(arr, $checkBoxes, $checkAll) {
        for (var i = 0; i < $checkBoxes.length; i++) {
            $checkBoxes.eq(i).attr("checked", arr[i]);
        }
        $checkAll.attr("checked", isAllChecked($checkBoxes));
    }

    // 复选框转态改变后 input框状态变化
    function updateInputStatus($element) {
        var $labels = $element.find("label");
        for (var i = 0; i <= $labels.length; i++) {
            if ($labels.eq(i).find(".js-input").length !== 0) {
            	(function(){
	            	var $inputs = $labels.eq(i).find(".js-input");
	                $labels.eq(i).on("change", "input[type='checkbox']", function() {
	                    $inputs.attr("disabled", $(this).attr("checked") !== "checked");
	                });
            	})();
            }
        }
    }

     //占位字符 placeholder
    (function () {
        var $placeHolder = $("input[data-placeholder]");

        $document.on("focus", "input[data-placeholder]", placeholderFocusHandle);

        function placeholderFocusHandle() {
            var $this = $(this);
            var text = $this.data("placeholder");
            if ($this.val() === text) {
                $this.removeClass("placeholder");
                $this.val("");
            }

        }

        $document.on("blur", "input[data-placeholder]", placeholderBlurHandle);

        function placeholderBlurHandle() {
            var $this = $(this);
            var text = $this.data("placeholder");
            if ($this.val() === "") {
                $this.addClass("placeholder");
                $this.val(text);
            }

        }

        $placeHolder.blur();

    })();

    //复选框控制表单可用性
    $document.on("change", ".JS_checkbox_switch", checkboxSwitchHandle);
    function checkboxSwitchHandle() {
        var $this = $(this);

        var $box = $this.parents(".JS_checkbox_switch_box");
        var $disabled = $box.find(".JS_checkbox_disabled");
        var $hidden = $box.find(".JS_checkbox_hidden");

        if ($this.is(":checked")) {
            $disabled.attr("disabled", false);
            $hidden.show();
        } else {
            $disabled.attr("disabled", true);
            $hidden.hide();
        }

    }

    //通用列表
    function generalList(parameter) {

        //添加
        $document.on("click", parameter.addBtn, function () {

            var $this = $(this);
            var $area = $this.parents(parameter.area);

            if(parameter.isJudged && $area.find(parameter.judgeCtrl).attr("checked")!="checked"){
                return;
            }

            var $parent = $area.find(parameter.parent);
            var $add = $area.find(parameter.add);
            var $destination = $templateInner.find(parameter.itemTemplate).clone();

            //$destination.find('input[type="text"]').val("");

            if (parameter.parentAdd) {

                $parent.append($destination);
            } else {

                $add.before($destination);
            }

            if (parameter.hiddenDelBtn) {
                $destination.on("mouseenter", function (e) {
                    var $this = $(this);
                    var $del = $this.find(parameter.delBtn);

                    $del.css({
                        "left": 0,
                        "top": 30
                    });
                    $del.show();
                });

                $destination.on("mouseleave", function () {
                    var $this = $(this);
                    var $del = $this.find(parameter.delBtn);
                    $del.hide();
                });
            }

            //隐藏最后的
            if (parameter.hiddenLastQuery) {
                var $visit = $area.find(parameter.item).find(parameter.hiddenLastQuery);
                $visit.show();

                var $hidden = $destination.find(parameter.hiddenLastQuery);
                $hidden.hide();

            }

        });

        //删除
        $document.on("click", parameter.delBtn, function () {
            var $this = $(this);
            var $item = $this.parents(parameter.item);
            $item.slideUp(200, function () {

                $item.remove();
            });

        });

    }

    //费用包含 其他 添加
    generalList({
        "area": ".JS_ta_limit_other_area",
        "parent": ".JS_ta_limit_other_group",
        "item": ".JS_ta_limit_other",
        "add": ".JS_ta_limit_other_add_box",
        "addBtn": ".JS_ta_limit_other_add",
        "delBtn": ".JS_ta_limit_other_del",
        "itemTemplate": ".JS_ta_limit_other",
        "isJudged": true,
        "judgeCtrl": ".JS_ta_limit_judge_ctrl"
    });

    //费用包含 其他 添加
    generalList({
        "area": ".JS_ta_reception_other_area",
        "parent": ".JS_ta_reception_other_group",
        "item": ".JS_ta_reception_other",
        "add": ".JS_ta_reception_other_add_box",
        "addBtn": ".JS_ta_reception_other_add",
        "delBtn": ".JS_ta_reception_other_del",
        "itemTemplate": ".JS_ta_reception_other",
        "isJudged": true,
        "judgeCtrl": ".JS_ta_reception_judge_ctrl"
    });

    //费用包含 其他 添加
    generalList({
        "area": ".gi-other-box",
        "parent": ".gi-others",
        "item": ".gi-other",
        "add": ".gi-other-add",
        "addBtn": ".JS_other_add_btn",
        "delBtn": ".gi-other-del",
        "itemTemplate": ".gi-other",
        "isJudged": true,
        "judgeCtrl": ".JS_other_judge_ctrl"
    });
    
    //费用包含 其他 添加
    generalList({
        "area": ".gi-otherTravel-box",
        "parent": ".gi-otherTravel-others",
        "item": ".gi-otherTravel",
        "add": ".gi-otherTravel-add",
        "addBtn": ".JS_otherTravel_add_btn",
        "delBtn": ".gi-otherTravel-del",
        "itemTemplate": ".gi-otherTravel",
        "isJudged": true,
        "judgeCtrl": ".JS_otherTravel_judge_ctrl"
    });
});