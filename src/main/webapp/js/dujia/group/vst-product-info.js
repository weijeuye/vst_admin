 /**
 * Author：     yinhanchun
 * Date:        2015-08-20
 * Version:     1.0.0.0
 * Description: VST基本信息
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

$(function() {
	var product_name_version = "1.0";
    var $document = $(document);
    var $dialogs = $(".dialog");
    var $baseInfoBg = $(".baseInfo_bg");
    var $ltAddNameBtn = $(".lt-add-name-btn");//添加按钮
    var $ltDialogCloseBtn = $(".lt-dialog-close");
    var $ltAddFromBtn = $(".lt-add-from-btn");
    var $ltAddToBtn = $(".lt-add-to-btn");
    var $ltInfoTemplate = $(".lt-info-template");
    // 产品类型select
    var $ltCategory = $(".lt-category");
    // 产品类型提示
    var $ltCategoryNote1 = $(".info-category-note1");
    var $ltCategoryNote2 = $(".info-category-note2");
    // 产品名称显示区域
    var $ltProductNameDd = $(".lt-product-name-td");
    // 产品副标题显示区域
    var $ltProductSubNameDd = $(".lt-product-sub-name-td");
    
    // 目的地显示区域
    var $ltProductToDd = $(".lt-product-to-dd");

    // 删除产品名称
    $ltProductNameDd.on("click",".lt-pnv-delete",function(){
        $(this).parent().siblings("input").val("");
        $(this).parent().siblings("a").removeClass("lt-link-disabled");
        $(".JS_hidden_product_name_vo_div").find("input").attr("value","");
        $(this).parent().remove();
        $ltProductSubNameDd.find(".lt-product-name-view-sub").remove();
        
        $ltCategory.attr("disabled",false);
        $ltCategory.val("addName_default");
        $ltCategoryNote2.hide();
        $ltAddNameBtn.show();
        
         

         $(".lt-add-name-btn").addClass("lt-link-disabled");
         
        $(".lt-category").find("option").eq(0).attr("selected", true);
        var $addNameDialog = $(".addName_dialog");
        

        //清除数据
        $addNameDialog.find(".add-name-content").html("");
        $addNameDialog.find(":text").each(function() {
        	$(this).val("");
//            var $this = $(this);
//            $this.addClass("placeholder");
//            var text = $this.data("placeholder");
//            if(text) {
//                $this.val(text);
//            }

        });
        
//        $addNameDialog.find(":hidden").each(function() {
//        	$(this).val("");
//        });
        
        //清空hidden域的值
        $addNameDialog.find("input[type=hidden]").each(function() {
        	$(this).val("");
        });
        
        $addNameDialog.find("select").each(function() {
            var $this = $(this);
            $this.find("option").eq(0).attr("selected", true);
            $(".lt-add-name-btn").addClass("lt-link-disabled");
        });
    });
    // 修改产品名称
    $ltProductNameDd.on("click",".lt-pnv-modify",function(){
        var $currentDialog = $($(this).attr("data-dialog"));
        //填入弹出模态窗口中的inputs值
        copyValueFromPageToDialog($currentDialog);

        showDialog($currentDialog);
        
        var $dialog = $($(this).attr("data-dialog"));
        var $header = $dialog.find(".dialog-header");
        var headerText = $header.html();
        headerText = headerText.replace("添加", "修改");
        $header.html(headerText);
        $dialog.find(".add-name-content").html("");
//        $dialog.find(":text").each(function() {
//            var $this = $(this);
//            if( $this.val()=="") {
//                $this.val($this.data("placeholder"));
//            } else {
//                $this.removeClass("placeholder");
//            }
//        });
    });
    // 删除目的地
    $ltProductToDd.on("click",".lt-dnv-delete",function(){
        $(this).parent().remove();
    });

    // 产品类型切换判断
    $ltCategory.on("change",function(){
        var val = $(this).find(":selected").data("value");
        if (val !== "addName_default") {
            $(".lt-add-name-btn").removeClass("lt-link-disabled");
            $(".info-category-note1").show();
        } else {
            $(".lt-add-name-btn").addClass("lt-link-disabled");
            $(".info-category-note1").hide();
        }
    });

    //显示增加名称窗口
    $ltAddNameBtn.on("click", function(){
        if(!$(this).hasClass("lt-link-disabled")){
            //showDialog($("."+$ltCategory.val()));
            var $dialog = $("." + $(".lt-category").val());
            showDialog($dialog);
            var $header = $dialog.find(".dialog-header");
            var headerText = $header.html();
            headerText = headerText.replace("修改", "添加");
            $header.html(headerText);
        }
    });

    //显示添加目的地窗口
    $ltAddToBtn.on("click", function(){
        showDialog($(".addTo_dialog"));
    });

    //显示添加出发地窗口
    $ltAddFromBtn.on("click", function(){
        showDialog($(".addFrom_dialog"));
    });

    // 关闭窗口 
    $ltDialogCloseBtn.on("click", function(){
        closeDialog();
    });

    bindAddNameFuns($(".addName_dx_dialog"));
    bindAddNameFuns($(".addName_cx_dialog"));
    bindAddNameFuns($(".addName_cj_dialog"));
    bindAddNameFuns($(".addName_bjy_dialog"));

    //添加产品名称
    function bindAddNameFuns($dialog){
        var $helpTip = $dialog.find(".addName-help-tips");
        var $bzContent = $dialog.find(".bz-content");
        var $inputs = $dialog.find(".input-text");
        var $select = $dialog.find("select");
        var $viewNameBtn = $dialog.find(".name-view-btn");//名称预览btn
        var $addNameContent = $dialog.find(".add-name-content");//名称tips
        var $dialogConfirmBtn = $dialog.find(".lt-dialog-confirm");//名称确定btn
//        var illegalReg = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5]/;
        var illegalReg = /^[^\\\*\&\#\$\%\@\\^\!\~\+>\<\|\'\"\/]+$/;
        var illegalRegDH = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5、]/;
        var illegalRegTS = /[^\a-\z\A-\Z0-9\u4E00-\u9FA5，]/;
        
        var mainTitle='';//主标题拼接
		var subTitle = '';//副标题拼接
		var subTitle4Tnt = '';

        $inputs.focus(function(){
            $bzContent.html($(this).attr("data-tip"));
        });

        $inputs.blur(function(){
            $(this).removeClass("input-red");
        });

        $select.focus(function(){
            $bzContent.html("");
        });

        //前台预览
        // TODO: 开发时需要判断输入数据的准确性
        $viewNameBtn.on("click", function(){
            $addNameContent.html("");
            //var productType = $(".js_product_type").val();
            if(getFullProductName()){
            	$bzContent.html("");
            	var content = "主标题："+mainTitle;
            	content+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            	content+="副标题："+subTitle;
            	$addNameContent.html(content);
            }
        });
        //dialog 确定 按钮
        $dialogConfirmBtn.on("click", function(){
        	var productType = $(".js_product_type").val();
        	if(getFullProductName()){
        		//清除提示内容
                $bzContent.html("");
                // 先删除原来显示的名称!
                $ltProductNameDd.find(".lt-product-name-view-main").remove();
                $ltProductSubNameDd.find(".lt-product-name-view-sub").remove();
                // 增加名称按钮disabled
                $ltAddNameBtn.addClass("lt-link-disabled");
                /**复制主标题**/
                var $productNameMain = $ltInfoTemplate.find(".lt-product-name-view-main").clone();
                /**复制副标题**/
                var $productNameSub = $ltInfoTemplate.find(".lt-product-name-view-sub").clone();
                //如果是产品的编辑页面移掉删除按钮
                var productId = $("#productId").val();
                if(typeof(productId) != undefined && !!productId ){
                	$productNameMain.find('.lt-pnv-delete').remove();
                }

                //填入产品基础信息维护页面中的隐藏input
                copyValueFromDialogToPage($dialog);

                //主标题赋值
                $productNameMain.find(".lt-pnv-content-main").html('主标题：'+$dialog.find(".add-main-title").val());
                //副标题赋值
                $productNameSub.find(".lt-pnv-content-sub").html('副标题：'+$dialog.find(".add-sub-title").val());
                
//                    $productName.find(".lt-pnv-content").html(proName);
                $productNameMain.find(".lt-pnv-modify").attr("data-dialog",$dialog.selector);
                $ltProductNameDd.prepend($productNameMain);
                $ltProductSubNameDd.prepend($productNameSub);
                //$ltCategory.attr("disabled",true);
                $ltCategoryNote1.hide();
                //$ltCategoryNote2.show();
                closeDialog();

                $ltAddNameBtn.hide();
            }
        });

        $ltCategory.on("click", function() {
        	//console.log("选择类别");
            var $view = $ltProductNameDd.find(".lt-product-name-view-main");
            if($view.length > 0 ) {
                $ltCategory.attr("disabled", true);
                $ltCategoryNote2.show();
            }

        });
        //产品名称  拼写全部名称
        function getFullProductName() {
        	//获取产品类型
        	var productType = $(".js_product_type").val();
        	//出境/港澳台
        	if(productType == "FOREIGNLINE"){
        		mainTitle='';//主标题拼接
        		subTitle = '';//副标题拼接
        		subTitle4Tnt = '';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $category = $dialog.find(".add-category");
        		//var category = $dialog.find(".add-category").find("option:selected").text();
        		/**副标题**/
        		var $yhhd = $dialog.find(".add-yhhd");
        		var $thct = $dialog.find(".add-thct");
        		var $hotel = $dialog.find(".add-hotel");//酒店信息
        		var $tsmd = $dialog.find(".add-tsmd");//特色卖点
        		var levelStar = $dialog.find(".add-levelStar").val();//星级
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
                if (dayCount !== "") {
                    mainTitle+=dayCount + "日";
                }
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }

        		if($category.val()!==""){
        			mainTitle+=$category.find("option:selected").text();
        		}
        		mainTitle+= "游";
//        		mainTitle+=category + "游";
        		/**副标题**/
        		if($yhhd.val()!==""&&!illegalReg.test($yhhd.val())){
        			$yhhd.addClass("input-red");
                    $bzContent.html($yhhd.attr("data-tip"));
                    return false;
        		}else if($yhhd.val()!==""){
        			subTitle+='['+$yhhd.val()+']';
        		}
        		if($thct.val()!==""&&!illegalReg.test($thct.val())){
        			$thct.addClass("input-red");
                    $bzContent.html($thct.attr("data-tip"));
                    return false;
        		}else if($thct.val()!==""){
        			subTitle+=$thct.val();
        			subTitle4Tnt +=$thct.val();
        		}
        		if($hotel.val()!==""&&!illegalReg.test($hotel.val())){
        			$hotel.addClass("input-red");
                    $bzContent.html($hotel.attr("data-tip"));
                    return false;
        		}else if($hotel.val()!==""){
        			if($thct.val()!==""){
        				subTitle+="，";
        				subTitle4Tnt+="，";
        			}
        			subTitle+=$hotel.val();
        			subTitle4Tnt+=$hotel.val();
        		}
        		if($tsmd.val()===""||!illegalReg.test($tsmd.val())){
        			$tsmd.addClass("input-red");
                    $bzContent.html($tsmd.attr("data-tip"));
                    return false;
        		}else{
        			if($thct.val()!==""||$hotel.val()!==""){
        				subTitle+="，";
        				subTitle4Tnt+="，";
        			}
        			subTitle+=$tsmd.val();
        			subTitle4Tnt+=$tsmd.val();
        		}
        		if(parseInt(levelStar)> 0 ){
            		//$dialog.find(".add-levelStar").attr("style","");
                	for(var i=0;i<parseInt(levelStar);i++){
                		subTitle += "★" ;
                		subTitle4Tnt+= "★" ;
                	}
            	}
        	}
        	else if(productType == "INNERSHORTLINE"||productType == "INNERLONGLINE"||productType == "INNER_BORDER_LINE"){
        		mainTitle='';//主标题拼接
        		subTitle = '';//副标题拼接
        		subTitle4Tnt = '';
        		/**主标题**/
        		var $mdd = $dialog.find(".add-mdd");//目的地
        		var nightCount = $dialog.find(".night-count").val();
        		var dayCount = $dialog.find(".day-count").val();
        		var $traffic = $dialog.find(".add-traffic");
        		var $playtype = $dialog.find(".add-playtype");
//        		var category = $dialog.find(".add-category").find("option:selected").text();
        		/**副标题**/
        		var $dxhd = $dialog.find(".add-dxhd");
        		var $yhhd = $dialog.find(".add-yhhd");
        		var $cpts = $dialog.find(".add-tsmd");
        		/**校验及主副标题拼接**/
        		/**主标题**/
        		if ($mdd.val() === "" || !illegalReg.test($mdd.val())) {
        			$mdd.addClass("input-red");
                    $bzContent.html($mdd.attr("data-tip"));
                    return false;
                } else {
                	mainTitle+=$mdd.val();
                }
        		if ($traffic.val()!==""&&!illegalReg.test($traffic.val())) {
        			$traffic.addClass("input-red");
                    $bzContent.html($traffic.attr("data-tip"));
                    return false;
                } else{
                	mainTitle+=$traffic.val();
                }
        		mainTitle+=dayCount + "日";
        		if (nightCount !== "") {
        			mainTitle+=nightCount + "晚";
                }
        		
        		if($playtype.val()!==""){
        			mainTitle+=$playtype.find("option:selected").text();
        		}
        		mainTitle+= "游";
        		/**副标题**/
        		if($dxhd.val()!==""&&!illegalReg.test($dxhd.val())){
        			$dxhd.addClass("input-red");
                    $bzContent.html($dxhd.attr("data-tip"));
                    return false;
        		}else if($dxhd.val()!==""){
        			subTitle+='['+$dxhd.val()+']';
        			subTitle4Tnt +='['+$dxhd.val()+']';
        		}
        		if($yhhd.val()!==""&&!illegalReg.test($yhhd.val())){
        			$yhhd.addClass("input-red");
                    $bzContent.html($yhhd.attr("data-tip"));
                    return false;
        		}else if($yhhd.val()!==""){
        			subTitle+=$yhhd.val();
        		}
        		if($cpts.val()===""||!illegalReg.test($cpts.val())){
        			$cpts.addClass("input-red");
                    $bzContent.html($cpts.attr("data-tip"));
                    return false;
        		}else if($cpts.val()!==""){
        			if($yhhd.val()!==""){
        				subTitle+="，"+$cpts.val();
        			}else{
        				subTitle+=$cpts.val();
        			}
        			subTitle4Tnt+=$cpts.val();
        		}
        		
        		var mddjtfs = $mdd.val()+$traffic.val();//目的地+交通方式
            	if(mddjtfs.length>20){
            		$bzContent.html('<i class="add-red">目的地+交通方式总和不能超过20个字（包含标点符号），请修改！</i>');
            		$mdd.addClass("input-red");
            		$traffic.addClass("input-red");
            		return false;
            	}
        	}
        	$dialog.find(".add-main-title").val(mainTitle);
        	$dialog.find(".add-sub-title").val(subTitle);
        	$dialog.find(".add-sub-title-4-tnt").val(subTitle4Tnt);
        	
        	var totalTitle = mainTitle+subTitle;
        	if(totalTitle.length>140){
        		$bzContent.html('<i class="add-red">名称总字数不超过140，请修改</i>');
        		return false;
        	}
        	return true;

        }

    }

    //获取产品基础页面中的关于名称的隐藏inputs
    function getBasePageInputs() {
        var $pageInputs = {};
        var $hiddenProductNameDiv = $(".JS_hidden_product_name_vo_div");

        //产品基础页面中隐藏输入框
        $pageInputs.mainProductName = $(".JS_hidden_main_product_name");
    	$pageInputs.mainTitle = $hiddenProductNameDiv.find(".JS_hidden_vo_main_title");
    	$pageInputs.subTitle = $hiddenProductNameDiv.find(".JS_hidden_vo_sub_title");
    	$pageInputs.subTitle4Tnt = $hiddenProductNameDiv.find(".JS_hidden_vo_sub_title_4_tnt");
    	
    	$pageInputs.destination = $hiddenProductNameDiv.find(".JS_hidden_vo_destination");
    	$pageInputs.nightNumber = $hiddenProductNameDiv.find(".JS_hidden_vo_night_number");
    	$pageInputs.dayNumber = $hiddenProductNameDiv.find(".JS_hidden_vo_day_number");
    	$pageInputs.playType = $hiddenProductNameDiv.find(".JS_hidden_vo_play_type");
    	$pageInputs.benefit = $hiddenProductNameDiv.find(".JS_hidden_vo_benefit");
    	$pageInputs.themeContent = $hiddenProductNameDiv.find(".JS_hidden_vo_theme_content");
    	$pageInputs.hotel = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel");
    	$pageInputs.mainFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_main_feature");
    	$pageInputs.levelStar = $hiddenProductNameDiv.find(".JS_hidden_vo_level_star");
    	$pageInputs.hotelOrFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_or_feature");
    	$pageInputs.flightFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_flight_feature");
    	$pageInputs.otherFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_other_feature");
    	$pageInputs.hotelPackage = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_package");
    	$pageInputs.hotelFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_hotel_feature");
    	$pageInputs.traffic = $hiddenProductNameDiv.find(".JS_hidden_vo_traffic");
    	$pageInputs.largeActivity = $hiddenProductNameDiv.find(".JS_hidden_vo_large_activity");
    	
    	$pageInputs.promotionOrHotel = $hiddenProductNameDiv.find(".JS_hidden_vo_promotion_or_hotel");
    	$pageInputs.productFeature = $hiddenProductNameDiv.find(".JS_hidden_vo_product_feature");
    	$pageInputs.productName = $hiddenProductNameDiv.find(".JS_hidden_vo_product_name");
    	
    	$pageInputs.version = $hiddenProductNameDiv.find(".JS_hidden_vo_version");
    	
        return $pageInputs;
    }

    //复制值从弹出页面到基础页面
    function copyValueFromDialogToPage($dialog) {
    	$pageInputs = getBasePageInputs();
    	//获取产品类型
    	var productType = $(".js_product_type").val();
    	//出境/港澳台
    	$pageInputs.mainProductName.val($dialog.find(".add-main-title").val()+'('+$dialog.find(".add-sub-title").val()+')');
		
    	if(productType == "FOREIGNLINE"){
    		
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.subTitle4Tnt.val($dialog.find(".add-sub-title-4-tnt").val());
    		
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.playType.val($dialog.find(".add-category").val());
    		$pageInputs.benefit.val($dialog.find(".add-yhhd").val());
    		$pageInputs.themeContent.val($dialog.find(".add-thct").val());
    		$pageInputs.hotel.val($dialog.find(".add-hotel").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-tsmd").val());
    		$pageInputs.levelStar.val($dialog.find(".add-levelStar").val());
    		//$pageInputs.hotelOrFeature.val($dialog.find(".add-levelStar").val());
    		
    	}
    	else if(productType=="INNERSHORTLINE"||productType=="INNERLONGLINE"||productType == "INNER_BORDER_LINE"){
    		
    		$pageInputs.mainTitle.val($dialog.find(".add-main-title").val());
    		$pageInputs.subTitle.val($dialog.find(".add-sub-title").val());
    		$pageInputs.subTitle4Tnt.val($dialog.find(".add-sub-title-4-tnt").val());
    		
    		$pageInputs.destination.val($dialog.find(".add-mdd").val());
    		$pageInputs.nightNumber.val($dialog.find(".night-count").val());
    		$pageInputs.dayNumber.val($dialog.find(".day-count").val());
    		$pageInputs.traffic.val($dialog.find(".add-traffic").val());
    		$pageInputs.playType.val($dialog.find(".add-playtype").val());
    		$pageInputs.largeActivity.val($dialog.find(".add-dxhd").val());
    		$pageInputs.benefit.val($dialog.find(".add-yhhd").val());
    		$pageInputs.mainFeature.val($dialog.find(".add-tsmd").val());
    	}
    	$pageInputs.version.val(product_name_version);
    }

    //复制值从弹出页面到基础页面
    function copyValueFromPageToDialog($dialog) {
    	var productType = $(".js_product_type").val();
    	$pageInputs = getBasePageInputs();
    	//出境/港澳台
    	if(productType == "FOREIGNLINE"){
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-sub-title-4-tnt").val($pageInputs.subTitle4Tnt.val());
    		
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-category").val($pageInputs.playType.val());
    		$dialog.find(".add-yhhd").val($pageInputs.benefit.val());
    		$dialog.find(".add-thct").val($pageInputs.themeContent.val());
    		$dialog.find(".add-hotel").val($pageInputs.hotel.val());
    		$dialog.find(".add-tsmd").val($pageInputs.mainFeature.val());
    		$dialog.find(".add-levelStar").val($pageInputs.levelStar.val());
    		//$dialog.find(".add-levelStar").val($pageInputs.hotelOrFeature.val());
    	}
    	else if(productType=="INNERSHORTLINE"||productType=="INNERLONGLINE"||productType == "INNER_BORDER_LINE"){
    		$dialog.find(".add-main-title").val($pageInputs.mainTitle.val());
    		$dialog.find(".add-sub-title").val($pageInputs.subTitle.val());
    		$dialog.find(".add-sub-title-4-tnt").val($pageInputs.subTitle4Tnt.val());
    		
    		$dialog.find(".add-mdd").val($pageInputs.destination.val());
    		$dialog.find(".night-count").val($pageInputs.nightNumber.val());
    		$dialog.find(".day-count").val($pageInputs.dayNumber.val());
    		$dialog.find(".add-traffic").val($pageInputs.traffic.val());
    		$dialog.find(".add-playtype").val($pageInputs.playType.val());
    		$dialog.find(".add-dxhd").val($pageInputs.largeActivity.val());
    		$dialog.find(".add-yhhd").val($pageInputs.benefit.val());
    		$dialog.find(".add-tsmd").val($pageInputs.mainFeature.val());
    	}
    }

    function closeDialog(){
        $dialogs.hide();
        $baseInfoBg.hide();
    }

    function showDialog($dialog) {
    	$dialog.show();
        $baseInfoBg.show();
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

    // 产品推荐 
    var $addOneTJ = $(".addOne_tj");
    var $ltAddTjBtn = $(".lt-add-tj-btn");
    
    $ltAddTjBtn.on("click",function(){
    	var $categoryId = $("#categoryId").val();
        var recoArray = $addOneTJ.find("input[name='productRecommends']");
        if($categoryId == 42) {
        	 if (recoArray.length > 9) {
                 $.alert("产品经理推荐最多10条");
                 return;
             }
        } else {
        	 if (recoArray.length > 3) {
                 $.alert("产品经理推荐最多4条");
                 return;
             }
        }
        var add_tj="<tr class='lt-tj'><td class='e_label' width='150'></td><td><input type='text' name='productRecommends' class='wl_300' style='width:400px;'  placeholder='输入产品推荐语，每句话最多输入30个汉字' data-validate=\"true\" required maxlength=\"30\"/><a class='lt-tj-delete-btn' href='javascript:;'>删除</a></td></tr>";
        var $addTj = $(add_tj);
        $addOneTJ.append($addTj);

        var $del = $addOneTJ.find(".lt-tj-delete-btn");

        $.each($del, function(index, item) {
            $(item).show();
        });
        
       $("input[name='productRecommends']").keyup(function() {
             valiateOldData(false, false);
        });



    });

    $addOneTJ.on("click",".lt-tj-delete-btn",function(){
        $(this).parents(".lt-tj").remove();

        var $del = $addOneTJ.find(".lt-tj-delete-btn");

        $.each($del, function(index, item) {
            $(item).show();
        });

      valiateOldData(false,false);
    });

});