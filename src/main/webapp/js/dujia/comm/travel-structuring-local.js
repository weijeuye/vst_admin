    /**
     * 校验敏感词（array：要校验的jquery对象数组，isAsync：是否为异步）
     */
    function validateSensitiveWord(array, isAsync) {
        var hasSensitive = false;

        for (var i=0; i<array.length; i++) {
            var obj = $(array[i]);

            if ($.trim(obj.val())!="") {
                //如果是纯数字，不校验
                var number = /^[0-9]+$/;
                if(number.test($.trim(obj.val()))){
                    continue;
                }
                //如果是readonly或者disabled则不验证
                if((obj.is(":disabled") || (obj.attr("readonly")=='readonly'))&& !obj.is(".sensitive_validate")){
                    continue;
                }

                var reult = sendAjaxValidateSensitiveWord(obj, isAsync);
                if (reult) {
                    hasSensitive = true;
                }
            }
        }

        return hasSensitive;
    }

    /**
     * 用于发送敏感词验证请求
     */
    function sendAjaxValidateSensitiveWord($obj, isAsync) {
        //是否有敏感词变量
        var existSensitive = false;
        $.ajax({
            url : "/vst_admin/prod/product/sensitiveWord.do",
            type : "post",
            data : {word:$obj.val()},
            async : isAsync,
            success : function(result) {
                var $textaresBox = $obj.closest(".JS_textares_box");

                if(result.message!=""){
                    existSensitive = true;
                    var $module = $obj.closest(".module");

                    $textaresBox.find(".prohibited-words").remove();
                    $textaresBox.append('<p class="text-danger w500 prohibited-words JS-prohibited-tips" style="display: block;">有违禁词：'+result.message+'</p>');

                    var $item = "";
                    if ($module.hasClass("template-view-spot")) {
                        $item = $obj.closest(".view-spot-item");
                    } else if ($module.hasClass("template-shop")) {
                        $item = $obj.closest(".shop-item");
                    } else if ($module.hasClass("template-hotel")) {
                        $item = $obj.closest(".hotel-item");
                    }

                    var itemIndex = $item == "" ? 0 : $item.index();
                    var $postContent = $($module.find(".module-post-content").get(itemIndex));
                    if ($postContent.length > 0) {
                        $postContent.find(".prohibited-words").remove();
                        $postContent.append('<div class="tip-warning prohibited-words JS-prohibited-tips-view" style="display: block;">有违禁词：'+result.message+'</div>');
                    }

                } else {
                    $textaresBox.find(".prohibited-words").remove();
                }
            },
            error : function(){
                console.log("Call sendAjaxValidateSensitiveWord occurs error");
            }
        });

        return existSensitive;
    }

    //公共方法：为组及其下面的模块隐藏域赋值
    function assignInputValuesForForm($module) {
        assignInputValuesForGroup($module);//为group表对应的字段赋值
        assignInputValuesForModule($module);//为各个模块对应的字段赋值
    }

    //为group表对应的字段赋值
    function assignInputValuesForGroup($module) {
        var $form = $module.find("form");
        $formHiddenDiv = $form.find(".JS_group_form_hidden");
        //赋值productId
        $productIdInput = $formHiddenDiv.find("input[name='productId']");
        var productId = $("#prodLineRouteDiv [name=productId]").val();
        $productIdInput.val(productId);
        //赋值routeId
        $routeIdInput = $formHiddenDiv.find("input[name='routeId']");
        var routeId = $("#prodLineRouteDiv [name=lineRouteId]").val();
        $routeIdInput.val(routeId);
        //赋值detailId
        $detailIdInput = $formHiddenDiv.find("input[name='detailId']");
        var detailId = $module.parent().parent().find("input[name='detailId']").val();
        $detailIdInput.val(detailId);
        //赋值开始时间
        var $timeInput = $formHiddenDiv.find("input[name='startTime']");
        var $timeHour = $form.find(".JS_time_input>.JS_time_hour");
        var $timeMinute = $form.find(".JS_time_input>.JS_time_minute");

        var timeStr = "";
        var timeHour = $timeHour.val();
        var timeMinute = $timeMinute.val();
        if ($timeMinute.attr("disabled")=="disabled") {
            switch(timeHour) {
                case "早上":
                    timeStr = "MORNING";
                    break;
                case "中午":
                    timeStr = "MIDDAY";
                    break;
                case "下午":
                    timeStr = "AFTERNOON";
                    break;
                case "晚上":
                    timeStr = "EVENING";
                    break;
                case "全天":
                    timeStr = "ALL_DAY";
                    break;
                case "上午":
                    timeStr = "FORENOON";
                    break;
                case "早餐前":
                    timeStr = "BREAKFAST_FRONT";
                    break;
                case "早餐后":
                    timeStr = "BREAKFAST_BACK";
                    break;
                case "中餐后":
                    timeStr = "LUNCH_BACK";
                    break;
                case "晚餐后":
                    timeStr = "DINER_BACK";
                    break;
                default:
                  console.log("gourp's startTime format error, startTime is " + timeStr);
                  timeStr = "";
            }
        } else {
            timeStr = isEmpty(timeHour) && isEmpty(timeMinute) ? "" : (timeHour + ":" + timeMinute);
        }

        $timeInput.val(timeStr);

        //如果是新的模块，先更新sort_value
        var groupId = $form.find(".JS_group_form_hidden>[name=groupId]").val();
        if(!groupId) {
            var prevSortValue = $module.prev().find(".JS_group_form_hidden>[name=sortValue]").val();
            var $sortValue = $form.find(".JS_group_form_hidden>[name=sortValue]");
            if(!prevSortValue) {
                prevSortValue = 1;
            } else {
                prevSortValue = parseInt(prevSortValue) + 1;
            }
            $sortValue.val(prevSortValue);
        }
    }

    //为各个模块对应的字段赋值
    function assignInputValuesForModule($module) {
        var $form = $module.find("form");

        if($module.hasClass('template-activity')){//活动模块
            //活动时间与出行时间
            combinTwoFiledTOoneFile($module, [".JS_travel_hour", ".JS_travel_minute", ".JS_item_form_hidden>.hidden_travel_time"]);
            combinTwoFiledTOoneFile($module, [".JS_visit_hour", ".JS_visit_minute", ".JS_item_form_hidden>.hidden_visit_time"]);
        } else if ($module.hasClass('template-view-spot')) {//景点模块
            $viewSpotItems = $form.find(".view-spot-list>.view-spot-item");
            $.each($viewSpotItems, function(index, item){
                var $item = $(item);
                //为出行时间、游览时间赋值
                combinTwoFiledTOoneFile($item, [".JS_travel_hour", ".JS_travel_minute", ".JS_item_form_hidden>.hidden_travel_time"]);
                combinTwoFiledTOoneFile($item, [".JS_visit_hour", ".JS_visit_minute", ".JS_item_form_hidden>.hidden_visit_time"]);
                //为模板CODE赋值
                var templateCode = "";
                var sceneryExplain = $item.find(".JS_view_spot_include").val();
                if (!isEmpty(sceneryExplain)) {
                    templateCode = "CODE_" + sceneryExplain;
                }
                var $templateCode = $item.find(".JS_item_form_hidden>.hidden_template_code");
                $templateCode.val(templateCode);
                //为参考价格赋值（参考价格存储单位：分）
                var referencePrice = $item.find(".JS_view_spot_price").val();
                var priceValue = null;
                if (!isEmpty(referencePrice)) {
                    priceValue = parseFloat(referencePrice) * 100;
                }
                $item.find(".JS_item_form_hidden>.hidden_reference_price").val(priceValue);
            });
        } else if($module.hasClass('template-traffic')){
            //模块的开始时间及行驶时间
            combinTwoFiledTOoneFile($module, [".traffic-item.active .JS_vehicle_hour",
                                              ".traffic-item.active .JS_vehicle_minute", 
                                              ".JS_item_form_hidden>.hidden_vehicle_time"]);
        } else if($module.hasClass('template-restaurant')){//用餐模块
        	
            //用餐时间
            combinTwoFiledTOoneFile($module, [".JS_meal_hour", ".JS_meal_minute", ".JS_item_form_hidden>.hidden_meal_time"]);
            combinTwoFiledTOoneFile($module, [".JS_breakfast_meal_hour", ".JS_breakfast_meal_minute", ".JS_item_form_hidden>.hidden_breakfast_meal_time"]);
            combinTwoFiledTOoneFile($module, [".JS_lunch_meal_hour", ".JS_lunch_meal_minute", ".JS_item_form_hidden>.hidden_lunch_meal_time"]);
            combinTwoFiledTOoneFile($module, [".JS_dinner_meal_hour", ".JS_dinner_meal_minute", ".JS_item_form_hidden>.hidden_dinner_meal_time"]);
            //模板code
            var $templateCode = $module.find(".JS_item_form_hidden>.hidden_template_code");
            $templateCode.val($templateCode.val());
            //餐费标准转成分
            var mealPrice = $module.find(".JS_meal_price").val();
            var breakfastMealPrice = $module.find(".JS_breakfast_meal_price").val();
            var lunchMealPrice = $module.find(".JS_lunch_meal_price").val();
            var dinnerMealPrice = $module.find(".JS_dinner_meal_price").val();
            var currency = $module.find(".JS_meal_currency option:selected").val();
            var breakfastCurrency = $module.find(".JS_select_switch_breakfast option:selected").val();
            var lunchCurrency = $module.find(".JS_select_switch_lunch option:selected").val();
            var dinnerCurrency = $module.find(".JS_select_switch_dinner option:selected").val();
            if (!isEmpty(mealPrice)) {
                $module.find(".JS_item_form_hidden>.hidden_meal_price").val(parseFloat(mealPrice) * 100);
            }else{
            	$module.find(".JS_item_form_hidden>.hidden_meal_price").val("");
            }
            if (!isEmpty(breakfastMealPrice)) {
                $module.find(".JS_item_form_hidden>.hidden_breakfast_meal_price").val(parseFloat(breakfastMealPrice) * 100);
            }else{
            	if(!isEmpty(mealPrice)){
            		$module.find(".JS_item_form_hidden>.hidden_breakfast_meal_price").val(parseFloat(mealPrice) * 100);
            	}else{
            		$module.find(".JS_item_form_hidden>.hidden_breakfast_meal_price").val("");
            	}
            }
            if (!isEmpty(lunchMealPrice)) {
                $module.find(".JS_item_form_hidden>.hidden_lunch_meal_price").val(parseFloat(lunchMealPrice) * 100);
            }else{
            	if(!isEmpty(mealPrice)){
            		$module.find(".JS_item_form_hidden>.hidden_lunch_meal_price").val(parseFloat(mealPrice) * 100);
            	}else{
            		$module.find(".JS_item_form_hidden>.hidden_lunch_meal_price").val("");
            	}
            }
            if (!isEmpty(dinnerMealPrice)) {
                $module.find(".JS_item_form_hidden>.hidden_dinner_meal_price").val(parseFloat(dinnerMealPrice) * 100);
            }else{
            	if(!isEmpty(mealPrice)){
            		$module.find(".JS_item_form_hidden>.hidden_dinner_meal_price").val(parseFloat(mealPrice) * 100);
            	}else{
            		$module.find(".JS_item_form_hidden>.hidden_dinner_meal_price").val("");
            	}
            }
            
            //如果为“全天”，则清空不为“全天”的数据;或者不为“全天”，则清空为“全天”的数据
            var hours = "";
            //新增页面
            if($module.find(".JS_group_form_hidden input[name='startTime']").val()!=null){
            	hours = $module.find(".JS_group_form_hidden input[name='startTime']").val();
            }else{
            //编辑页面	
            	hours = $module.find(".module-post-left p").html();
            }
            if (hours === "全天" || hours ==="ALL_DAY") {
                 //清空 不为“全天”的 用餐时间  和餐费标准
                 $module.find(".JS_item_form_hidden>.hidden_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_meal_price").val("");
                 //先将老数据的货币种类 置于全天所有的货币种类
                 var currey = $module.find(".JS_item_form_hidden>.hidden_meal_currency").val();
                 console.log(currey);
                 //将下拉的货币种类传到后台
                 if(!isEmpty(breakfastCurrency)){
                	 $module.find(".JS_item_form_hidden>.hidden_breakfastMeal_currency").val(breakfastCurrency);
                 }else{
                	 if(!isEmpty(currey)){
                		 $module.find(".JS_item_form_hidden>.hidden_breakfastMeal_currency").val(currey);
                	 }else{
                		 $module.find(".JS_item_form_hidden>.hidden_breakfastMeal_currency").val("");
                	 }
                 }
                 if(!isEmpty(lunchCurrency)){
                	 $module.find(".JS_item_form_hidden>.hidden_lunchMeal_currency").val(lunchCurrency);
                 }else{
                	 if(!isEmpty(currey)){
                		 $module.find(".JS_item_form_hidden>.hidden_lunchMeal_currency").val(currey);
                	 }else{
                		 $module.find(".JS_item_form_hidden>.hidden_lunchMeal_currency").val("");
                	 }
                 }
                 if(!isEmpty(dinnerCurrency)){
                	 $module.find(".JS_item_form_hidden>.hidden_dinnerMeal_currency").val(dinnerCurrency);
                 }else{
                	 if(!isEmpty(currey)){
                		 $module.find(".JS_item_form_hidden>.hidden_dinnerMeal_currency").val(currey);
                	 }else{
                		 $module.find(".JS_item_form_hidden>.hidden_dinnerMeal_currency").val("");
                	 }
                 }
                 //再清空老数据的货币种类
                 $module.find(".JS_switch_noallday select option:selected").val("");
             } else {
            	 //将单餐的货币单位保存到隐藏域
            	 if(!isEmpty(currency)){
                	$module.find(".JS_item_form_hidden>.hidden_meal_currency").val(currency);
                 }else{
                	$module.find(".JS_item_form_hidden>.hidden_meal_currency").val("");
                 }
                 //清空 为“全天”的 用餐时间  和餐费标准
                 $module.find(".JS_item_form_hidden>.hidden_breakfast_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_lunch_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_dinner_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_breakfast_meal_price").val("");
                 $module.find(".JS_item_form_hidden>.hidden_lunch_meal_price").val("");
                 $module.find(".JS_item_form_hidden>.hidden_dinner_meal_price").val("");
                 $module.find(".JS_item_form_hidden>.hidden_breakfastMeal_currency").val("");
                 $module.find(".JS_item_form_hidden>.hidden_lunchMeal_currency").val("");
                 $module.find(".JS_item_form_hidden>.hidden_dinnerMeal_currency").val("");
            }
            //用餐类型
            var $type = $module.find(".JS_restaurant_type");
            var type = "state-single";
            if ($type.is(".state-multiple")) {
                type = "state-multiple";
            }
            var $select = null;
            if (type === "state-single") {
                $select = $module.find(".JS_restaurant_type_single select");
            } else if (type === "state-multiple") {
                $select = $module.find(".JS_restaurant_type_multiple select");
            }
            
            if ($select.val()) {
                var $mealType = $module.find(".JS_item_form_hidden>.hidden_meal_type");
                var mealTypes = $select.val();
                var mealType = "";
                if ($.isArray(mealTypes)) {
                    for (var i = 0; i < mealTypes.length; i++) {
                        mealType += mealTypes[i];
                        if (i < mealTypes.length - 1) {
                            mealType += "|";
                        }
                    }
                } else {
                    mealType = mealTypes;
                }
                $mealType.val(mealType);
             }
        } else if($module.hasClass('template-hotel')) {//酒店模块
            //酒店列表
            $hotelItems = $form.find(".hotel-list>.hotel-item");
            //获取 travelType,travelTime, distanceKM为每项赋值
            var travelAndKM = $form.find(".JS_travelType_travelTime_distanceKM");
            var useTemplateFlag = $form.find(".JS_use_template_flag").is(":checked");
            $hotelItems.each(function(index, item){
                //出行类型
                var $travelType = $(item).find(".JS_item_form_hidden>.hidden_travel_type");
                $travelType.val(travelAndKM.find("select option:selected").val());
                //出行时间
                var $travelTime = $(item).find(".JS_item_form_hidden>.hidden_travel_time");
                var $travelHour = travelAndKM.find(".JS_travel_hour");
                var $travelMinute = travelAndKM.find(".JS_travel_minute");
                if ($travelHour.length > 0 && $travelMinute.length > 0) {
                    if ($travelTime.length > 0) {
                        var tarvelTimeHour = $travelHour.val();
                        var tarvelTimeMinute = $travelMinute.val();
                        var travelTime = isEmpty(tarvelTimeHour) && isEmpty(tarvelTimeMinute) ? "" : (tarvelTimeHour+":"+tarvelTimeMinute);
                        $travelTime.val(travelTime);
                    }
                }
                //公里数
                var $distanceKM = $(item).find(".JS_item_form_hidden>.hidden_distanceKM");
                $distanceKM.val(travelAndKM.find(".JS_distanceKM").val());
                //是否使用模板
                var $useTemplateFlag = $(item).find(".JS_item_form_hidden>.hidden_useTemplateFlag");
                if(useTemplateFlag) {
                    $useTemplateFlag.val("Y");
                } else {
                    $useTemplateFlag.val("N");
                }
            });
        }else if($module.hasClass('template-shop')){//购物点模块
            var $shopItems = $form.find(".shop-list>.shop-item");
            $.each($shopItems, function(index, item){
                var $item = $(item);
                //为出行时间、游览时间赋值
                combinTwoFiledTOoneFile($item, [".JS_travel_hour", ".JS_travel_minute", ".JS_item_form_hidden>.hidden_travel_time"]);
                combinTwoFiledTOoneFile($item, [".JS_visit_hour", ".JS_visit_minute", ".JS_item_form_hidden>.hidden_visit_time"]);
            });
        } else if($module.hasClass('template-recommend')){//推荐模块
        	//参考价格转成分
            var price = $module.find(".JS_recommend_price").val();
            if (!isEmpty(price)) {
                $module.find(".JS_item_form_hidden>.hidden_recommend_price").val(parseFloat(price) * 100);
            }else{
            	$module.find(".JS_item_form_hidden>.hidden_recommend_price").val("");
            }
        }
    }

    //拼接页面中属于两个输入项但在数据库表中只存在一个字段的,比如活动模块的“活动时间”与“行使时间”
    function combinTwoFiledTOoneFile($item, arr){
        //出行时间
        var $travelHour = $item.find(arr[0]);
        var $travelMinute = $item.find(arr[1]);
        if ($travelHour.length > 0 && $travelMinute.length > 0) {
            var $travelTime = $item.find(arr[2]);
            if ($travelTime.length > 0) {
                var tarvelTimeHour = $travelHour.val();
                var tarvelTimeMinute = $travelMinute.val();
                var travelTime = isEmpty(tarvelTimeHour) && isEmpty(tarvelTimeMinute) ? "" : (tarvelTimeHour+":"+tarvelTimeMinute);
                $travelTime.val(travelTime);
            }
        }

    }

    //公共方法：判断参数为空
    function isEmpty(value) {
        if (typeof(value) == 'undefined' || value == null || value == "") {
            return true;
        } else {
            return false;
        }
    }

    //公共方法：对html转义
    function escapeHTML(value) {
        var $div = $("<div />");
        $div.text(value);
        return $div.html();
    }

    //发送ajax保存所有行程明细
    function saveDayHeader($dayHeaderForm) {
        var saveSuccess = true;
        var $dayHead = $dayHeaderForm.closest(".day-head");
        var data = wrapDayHeaderDate($dayHeaderForm);
        var $divEdit = $dayHeaderForm.find(".edit");
        $.ajax({
            url: "/vst_admin/dujia/comm/route/detail/saveDayHeader.do",
            data: data,
            async: false,
            type: "POST",
            dataType: "JSON",
            success: function(result) {
                if(result.code == "success") {
                    //将互斥的编辑框清理掉
                    if($divEdit.hasClass("state-location")) {
                        $divEdit.find(".title input").val("");
                        //校验时以disable来判断
                        $divEdit.find(".title input").prop("disabled", true);
                    } else {
                        $divEdit.find(".location-item").each(function(index, e){
                            if(index == 0 ) {
                                $(e).find("input").val("");
                            } else {
                                $(e).remove();
                            }
                        });
                    }
                    if(result.attributes.detailId != data.detailId) {
                        $divEdit.find("[name='detailId']").val(result.attributes.detailId);
                    }
                    $divEdit.siblings(".view").text(data.title);

                    //更新隐藏的detailId属性
                    $dayHeaderForm.parents(".day").attr("detailId", result.attributes.detailId);

                    $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
                    $dayHead.find(".JS_day_save").hide();
                } else {
                    saveSuccess = false;
                    backstage.floatAlert({ className: "float-alert-warning", content: result.message});
                }

                $dayHead.find(".JS_day_save").html("保存").removeClass("disabled");
            },
            error: function(result) {
                saveSuccess = false;
                $dayHead.find(".JS_day_save").html("保存").removeClass("disabled");
                backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试" });
                console.log("Call saveDayHeader method occurs error:" + result.message);
            }
        });

        return saveSuccess;
    }
    
    function wrapDayHeaderDate($dayHeaderForm) {
        var data = new Object();
        var $divEdit = $dayHeaderForm.find(".edit");
        if($divEdit.hasClass("state-location")) {
            var destination = "";
            $divEdit.find(".location-item input").each(function(index, e){
                if ($(this).val() != "") {
                    if(index == 0 ) {
                        destination = $(this).val();
                    } else {
                        destination = destination + "—" + $(this).val();
                    }
                }
            });
            data.title = destination;
        } else {
            var title = $divEdit.find(".title input").val();
            data.title = title;
        }
        data.nDay = $divEdit.find("[name='nDay']").val();
        data.routeId = $("#prodLineRouteDiv [name=lineRouteId]").val();
        data.detailId = $divEdit.find("[name='detailId']").val();
        return data;
    }

    //发送ajax保存所有行程明细
    function saveAllDaysData(){
        var saveSuccess = true;
        var data = new Object();
        //prodLineRoute.prodLineRouteDetailList[].prodRouteDetailGroupList[].prodRouteDetailActivityList[]
        data.productId = $("#prodLineRouteDiv [name=productId]").val();
        data.lineRouteId = $("#prodLineRouteDiv [name=lineRouteId]").val();
        //底部温馨提示
        data.warningText = $(".JS_warning_text").val();
        
        //只保存处于编辑状态的
        var $days = $(".JS_days_contents>.day");
        $days.each(function(index, e){
            //过滤掉没有改动的day
            var $day = $(e);
            if($day.find(".day-head.state-edit").size() <=0 &&
                    $day.find(".day-body>.module.state-edit").size()<=0) {
                return ;
            }
            var dayHeader = wrapDayHeaderDate($day.find(".day-head-form"));
            if(!dayHeader.nDay || !dayHeader.title){
                return;
            }
            var nDay_index = dayHeader.nDay -1;
            $.each(dayHeader, function(key, value){
                data["prodLineRouteDetailList[" + nDay_index + "]." + key] = value;
                data["prodLineRouteDetailList[" + nDay_index + "].productId"] = data.productId;
            });

            //处理每个组的值
            var $modules = $day.find(".day-body .module");
            processOneDay(nDay_index, $modules, data);
        });

         $.ajax({
            url: "/vst_admin/dujia/comm/route/detail/saveRouteDetail.do",
            data: data,
            async: false,
            type: "POST",
            dataType: "JSON",
            success: function(result) {
                if (result.code == "success") {
                    backstage.floatAlert({ className: "float-alert-success", content: "保存成功"});
                    window.location.reload();
                } else {
                    saveSuccess = false;
                    backstage.floatAlert({width:190, className: "float-alert-warning", content: result.message});
                }

                $(".JS_all_save").html("保存").removeClass("disabled");
            },
            error: function() {
                saveSuccess = false;
                $(".JS_all_save").html("保存").removeClass("disabled");
                backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试" });
            }
        });

        return saveSuccess;
    }
    
    //保存模块或天数移动
    function saveDayOrMoudlelMoveData(){
        var saveSuccess = true;
        var data = new Object();
        data.productId = $("#prodLineRouteDiv [name=productId]").val();
        data.lineRouteId = $("#prodLineRouteDiv [name=lineRouteId]").val();
        //只保存处于移动状态，非编辑状态的
        var $days =  $(".JS_days_contents>.day"); 
        //天模块移动标记
        data.dayMoveFlag = $(".JS_days_contents>.dayMove").size()>0;
        data.moudleMoveFlag = $days.find(".moduleMove").size()>0;
        
        if(data.dayMoveFlag){
        	$days =  $(".JS_days_contents>.dayMove"); 
        }
        $days.each(function(index, e){
        	
            var $day = $(e);
            if(($day.find(".day-head.state-edit").size()>0||
                    $day.find(".day-body>.module.state-edit").size()>0)
                    ||($day.find(".moduleMove").size()<=0)&&(!($day.hasClass("dayMove")))) {
                return ;
            }
            var dayHeader = wrapDayHeaderDate($day.find(".day-head-form"));
            if($day.find(".moduleMove").size()>0){
            if(!dayHeader.nDay || !dayHeader.title){
                return;
            }
            }else if($day.hasClass("dayMove")){
            	if(!dayHeader.nDay){
                    return;
                }
            }
            var nDay_index = index;
            $.each(dayHeader, function(key, value){
                data["prodLineRouteDetailList[" + nDay_index + "]." + key] = value;
                data["prodLineRouteDetailList[" + nDay_index + "].productId"] = data.productId;
            });
            //处理每个组的值
            var $modules = $day.find(".day-body .moduleMove");
            processOneDay(nDay_index, $modules, data);
        });
        $(".JS_days_contents>.moduleMove").removeClass("moduleMove");
        $(".JS_days_contents>.dayMove").removeClass("dayMove");
        
         $.ajax({
            url: "/vst_admin/dujia/comm/route/detail/saveDayOrMoudlelMove.do",
            data: data,
            async: false,
            type: "POST",
            dataType: "JSON",
            success: function(result) {
                if (result.code == "success") {
                    backstage.floatAlert({ className: "float-alert-success", content: "移动成功"});
                } else {
                    saveSuccess = false;
                    backstage.floatAlert({width:190, className: "float-alert-warning", content: result.message});
                }

                
            },
            error: function() {
                saveSuccess = false;
                
                backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试" });
            }
        });

        return saveSuccess;
    }
    
    function processOneDay(nDay_index, $modules, data){
        var keyPrefix = "prodLineRouteDetailList[" + nDay_index + "].";
        //对每个form 进行一次serialize,不然比如两个交通组内的元素的key是相同的
        $modules.each(function(module_index, module){
            //一个group对应一个form
            var $module = $(module);

            //预处理一天的相关域，比如时间，排序值
            assignInputValuesForForm($module);
            var serializedData = $module.find("form").serializeArray();

            $.each(serializedData, function(field_index, e) {
                    data[keyPrefix + "prodRouteDetailGroupList[" + module_index + "]." + e.name] = e.value;
            });
        });
    }

    //发送ajax保存组
    function saveGroupData($module) {
        var saveSuccess = true;
        var $form = $module.find("form");
        //生成组下对象的Inputs
        assignInputValuesForForm($module);

        var serializedData = $form.serialize();
        //传递产品类型参数
        serializedData = serializedData + "&productType=" + $("#productType").val()+ "&flightTimeValidate=" + $("#flightTimeValidate").val()+"&categoryId="+$("#categoryId").val();
        //传递行程明细天数参数
        var nDay = $module.parents(".day").find("[name=nDay]").val();
        if(nDay) {
            serializedData = serializedData + "&nDay=" + nDay;
        }

        $.ajax({
            url: "/vst_admin/dujia/comm/route/detail/saveRouteDetailGroup.do",
            data: serializedData,
            async: false,
            type: "POST",
            dataType: "JSON",
            success: function(result) {

                if (result.code == "success") {
                    //$module.replaceWith(result.attributes.html);

                    var $newModule = $(result.attributes.html);
                    $module.html($newModule.html());
                    var groupId = $newModule.attr("data-id");
                    if (groupId) {
                        $module.attr("data-id", groupId);
                    }

                    $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
                    $module.addClass("state-view").removeClass("state-edit");
                    $(".JS_day_save").hide();

                    //保存一个模块后更新后面模块的sortValue值
                    var $nextAllModules = $module.nextAll();
                    $.each($nextAllModules, function(index, module) {
                        var $sortValueInput = $(module).find(".JS_group_form_hidden>[name=sortValue]");
                        var sortValue = $sortValueInput.val();
                        $sortValueInput.val(parseInt(sortValue) + 1);
                    });

                    //发送异步请求校验敏感词
                    validateSensitiveWord($module.find("textarea"), true);

                    backstage.floatAlert({className: "float-alert-success", content: "保存成功"});
                } else {
                    saveSuccess = false;
                    backstage.floatAlert({width:190, className: "float-alert-warning", content: result.message });
                }

                $module.find(".btn-save").html("保存").removeClass("disabled");
            },
            error: function() {
                saveSuccess = false;
                $module.find(".btn-save").html("保存").removeClass("disabled");
                backstage.floatAlert({className: "float-alert-warning", content: "网络服务异常, 请稍后重试" });
                console.log("Call saveGroupData method occurs error");
            }
        });

        return saveSuccess;
    }

    //发送ajax保存行程上的是否提示
    function saveWarningFlag(routeId, warningFlag) {
        if (isEmpty(routeId) || isEmpty(warningFlag)) {
            return ;
        }

        $.ajax({
            url: "/vst_admin/dujia/comm/route/detail/saveWarningFlag.do",
            data: {routeId:routeId,warningFlag:warningFlag},
            type: "GET",
            dataType: "JSON",
            success: function(result) {

                if (result.code == "error") {
                    backstage.floatAlert({className: "float-alert-warning", content: "设置失败" });
                }

            },
            error: function() {
                backstage.floatAlert({className: "float-alert-warning", content: "网络服务异常, 请稍后重试" });
                console.log("Call saveWarningFlag method occurs error");
            }
        });

    }

$(function () {
    //删除模块
    window.Days.delModuleHandler = function (event) {
        var $this = $(this);
        var $module = $this.parents(".module");
        //确认提示框
        backstage.confirm({
            content: "确认删除该模块？",
            determineCallback: function () {
                var groupId = $module.find(".JS_group_form_hidden").find("input[name='groupId']").val();
                var productId = $("#prodLineRouteDiv [name=productId]").val();
                var nDay = $module.parents(".day").find("[name=nDay]").val();
                if(!isEmpty(groupId)){
                    $.ajax({
                        url: "/vst_admin/dujia/comm/route/detail/deleteRouteDetailGroup.do",
                        data: {"groupId":groupId, "productId":productId, "nDay":nDay},
                        success: function(result) {
                            if (result.code == "success") {
                                $module.slideUp(200, function () {
                                    $module.remove();
                                });
                                backstage.floatAlert({
                                     className: "float-alert-success",
                                     content: result.message
                                 });
                            }else{
                                backstage.floatAlert({
                                    className: "float-alert-warning",
                                    content: result.message
                                });
                            }
                        }
                    });
                }
                else{
                    $module.slideUp(200, function () {
                        $module.remove();
                    });
                }
             }
          });

    };

    //顶部删除一天
    window.Days.titleDelDayHandler=function (event) {

        var self = event.data.self;
        var $this = $(this);
        var pos = 0;
        if ($this.hasClass("JS_tab_delete_day")) {
            var $dropDown = self.$dayDropDown;
            pos = $dropDown.data("index");
        } else if ($this.hasClass("JS_day_delete")) {
            pos = parseInt($this.parents(".day-head").find("input[name='nDay']").val()) - 1;
        }

        var $content = self.$contents.children().eq(pos);

        //无法删除最后一天
        if (self.getSize() === 1) {
            backstage.alert({
                content: "无法删除最后一天"
            });
            return false;
        }

        //确认提示框
        backstage.confirm({
            content: "该天存在行程内容，确认删除？",
            determineCallback: function () {
               var detailId = $content.find("input[name='detailId']").val();
                if(!isEmpty(detailId)){
                    $.ajax({
                        url: "/vst_admin/dujia/comm/route/detail/deleteRouteDetail.do",
                        data: {"detailId":detailId},
                        success: function(result) {
                            if (result.code == "success") {
                                self.del(pos);
                            }else{
                                backstage.floatAlert({
                                    className: "float-alert-warning",
                                    content: result.message
                                });
                            }
                        }
                    });
                }
                else{
                    self.del(pos);
                }
            }
        });
    };
    /*模块，天数顺序移动开始*/
    window.Days.movePrevModuleHandler=function (event){
    	
    	var self = event.data.self;
        var $this = $(this);
        var $module = $this.parents(".module");
        var $body = $module.parent();
        var $modules = $body.children();
        var index = $module.index();
        var $contents = self.$contents;
        var $prevModule = $modules.eq(index - 1);
        if($contents.find(".state-edit").size()>0){
        	backstage.alert({
                title: "系统提示",
                content: "编辑状态不能移动顺序"
            });
        	return;
        }
        if (index === 0) {
            backstage.alert({
                title: "系统提示",
                content: "已经为第一个，并不对操作结果做改变"
            });
            return false;
        }
        
        $module.addClass("moduleMove");
        $prevModule.addClass("moduleMove");
        self.allSave(function() {
        	
        	var prevHeight = $prevModule.outerHeight();
            var thatHeight = $module.outerHeight();

            $prevModule.addClass("moving").css("top", 0);
            $module.addClass("moving").css("top", 0);

            $prevModule.stop(false, true).animate({
                "top": thatHeight
            }, 500, function () {
                $prevModule.removeClass("moving").css("top", 0);
            });
            $module.stop(false, true).animate({
                "top": -prevHeight
            }, 500, function () {
                $module.removeClass("moving").css("top", 0);
                $prevModule.before($module);
                //TODO 移动完成 开发在此添加代码
                $module.removeClass("moduleMove");
                $prevModule.removeClass("moduleMove");
            }); 
           
          
      }, function() {}, $this);
    };
    
    window.Days.moveNextModuleHandler=function (event){
    	
    	var self = event.data.self;
        var $this = $(this);
        var $module = $this.parents(".module");
        var $body = $module.parent();
        var $modules = $body.children();
        var index = $module.index();
        var $contents = self.$contents;
        var $nextModule = $modules.eq(index + 1);
        
        if($contents.find(".state-edit").size()>0){
        	backstage.alert({
                title: "系统提示",
                content: "编辑状态不能移动顺序"
            });
        	return;
        }
        if (index >= $modules.length - 1) {
            backstage.alert({
                title: "系统提示",
                content: "已经为最后一个，并不对操作结果做改变"
            });
            return false;
        }
        $module.addClass("moduleMove");
        $nextModule.addClass("moduleMove");
    
        
        self.allSave(function() {
              
              var nextHeight = $nextModule.outerHeight();
              var thatHeight = $module.outerHeight();
              
              $nextModule.addClass("moving").css("top", 0);
              $module.addClass("moving move-main").css("top", 0);

              $nextModule.stop(false, true).animate({
                  "top": -thatHeight
              }, 500, function () {
                  $nextModule.removeClass("moving").css("top", 0);
              });
              $module.stop(false, true).animate({
                  "top": nextHeight
              }, 500, function () {
                  $module.removeClass("moving move-main").css("top", 0);
                  $nextModule.after($module);
                  $module.removeClass("moduleMove");
                  $nextModule.removeClass("moduleMove");
              });
            
        }, function() {}, $this);
    };
    
    window.Days.dayMovePrevHandler=function (event){
    	
    	var self = event.data.self;
        var $dropDown = self.$dayDropDown;
        var pos = $dropDown.data("index");
        var $this = $(this);
        var $days = self.$contents.children();
        var $prevDay = $days.eq(pos - 1);
        var $thatDay = $days.eq(pos);
        var $contents = self.$contents;
        
        if($contents.find(".state-edit").size()>0){
        	backstage.alert({
                title: "系统提示",
                content: "编辑状态不能移动顺序"
            });
        	return;
        }
        if (pos === 0) {
            backstage.alert({
                title: "系统提示",
                content: "已经为第一个，并不对操作结果做改变"
            });
            return false;
        }
        
        //移动两天如果存在没保存的天数，提示保存后可移动
        if(isNotSaveDay($thatDay) || isNotSaveDay($prevDay)){
        	return false;
        }
        
        $prevDay.addClass("dayMove");
        $thatDay.addClass("dayMove");
        self.allSave(function() {
        	
        	var prevHeight = $prevDay.outerHeight();
    		var thatHeight = $thatDay.outerHeight();

    		$prevDay.addClass("moving").css("top", 0);
    		$thatDay.addClass("moving").css("top", 0);
    		$prevDay.stop(false, true).animate({
    			"top" : thatHeight
    		}, 500, function() {
    			$prevDay.removeClass("moving").css("top", 0);

    		});
    		$thatDay.stop(false, true).animate({
    			"top" : -prevHeight
    		}, 500, function() {
    			$thatDay.removeClass("moving").css("top", 0);
    			$prevDay.before($thatDay);
    			self.refresh();
    			self.scroll(pos - 1);
    			// TODO 移动完成 开发在此添加代码
    			$prevDay.removeClass("dayMove");
    			$thatDay.removeClass("dayMove");
    			
    		});
			
		}, function() {}, $this);
    	
        
		
       
    };
    
    window.Days.dayMoveNextHandler=function (event){
    	
    	var self = event.data.self;
        var $this = $(this);
        var $dropDown = self.$dayDropDown;
        var pos = $dropDown.data("index");
        var $days = self.$contents.children();
        var $contents = self.$contents;
        var $nextDay = $days.eq(pos + 1);
        var $thatDay = $days.eq(pos);
        
        if($contents.find(".state-edit").size()>0){
        	backstage.alert({
                title: "系统提示",
                content: "编辑状态不能移动顺序"
            });
        	return;
        }
        if (pos >= $days.length - 1) {
            backstage.alert({
                title: "系统提示",
                content: "已经为最后一个，并不对操作结果做改变"
            });
            return false;
        }
        
      //移动两天如果存在没保存的天数，提示保存后可移动
       if(isNotSaveDay($thatDay) || isNotSaveDay($nextDay)){
        	return false;
       }
        
     $thatDay.addClass("dayMove");
     $nextDay.addClass("dayMove");
     
     self.allSave(function() {
   	  
   	var nextHeight = $nextDay.outerHeight();
    var thatHeight = $thatDay.outerHeight();

    $nextDay.addClass("moving").css("top", 0);
    $thatDay.addClass("moving move-main").css("top", 0);
    $nextDay.stop(false, true).animate({
        "top": -thatHeight
    }, 500, function () {
        $nextDay.removeClass("moving").css("top", 0);
    });
    $thatDay.stop(false, true).animate({
        "top": nextHeight
    }, 500, function () {
        $thatDay.removeClass("moving move-main").css("top", 0);
        $nextDay.after($thatDay);
        self.refresh();
        self.scroll(pos + 1);
        //TODO 移动完成 开发在此添加代码
        $thatDay.removeClass("dayMove");
        $nextDay.removeClass("dayMove");
    });
   	  
   	  
	}, function() {}, $this);
   	 
        
        
        
       
    	
    };
    /*模块，天数顺序移动结束*/
    
    
});

    //通用
    $(function () {

        /**
         * 扩展全局变量 天
         */
        window.Days.bindEventExtend = function () {

            //保存一天
            $document.on("click", ".JS_day_save", {self: this}, this.daySaveHandler);

            //编辑一天
            $document.on("click", ".JS_day_edit", {self: this}, this.dayEditHandler);

            //删除一天
            $document.on("click", ".JS_tab_delete_day,.JS_day_delete", {self: this}, this.titleDelDayHandler);

            //开始一天
            $document.on("click", ".JS_day_start", {self: this}, this.dayStartHandler);

            //保存模块
            $document.on("click", ".JS_module_save", {self: this}, this.moduleSaveHandler);

            //编辑模块
            $document.on("click", ".JS_module_edit", {self: this}, this.moduleEditHandler);

            //删除模块
            $document.on("click", ".JS_module_delete", {self: this}, this.delModuleHandler);

            //全部保存
            $document.on("click", ".JS_all_save", {self: this}, this.allSaveHandler);
            
            //上移模块
            $document.on("click", ".JS_module_prev", {self: this}, this.movePrevModuleHandler);

            //下移模块
            $document.on("click", ".JS_module_next", {self: this}, this.moveNextModuleHandler);
            
            //前移一天
            $document.on("click", ".JS_tab_move_prev", {self: this}, this.dayMovePrevHandler);
            //后移一天
            $document.on("click", ".JS_tab_move_next", {self: this}, this.dayMoveNextHandler);

        };

        //保存行程上的是否提示信息
        $document.on("click", ".JS_warning_flag", function () {
            $this = $(this);
            var routeId = $("#prodLineRouteDiv [name=lineRouteId]").val();
            var checked =$this.is(":checked") ? "Y" : "N";
            if("Y"===checked){
            	$(".JS_warning_text").removeAttr("disabled","disabled");
            }else{
            	$(".JS_warning_text").attr("disabled","disabled");
            }
            //异步保存“是否可编辑”按钮
            saveWarningFlag(routeId, checked);
        });

        //绑定所有模块下描述输入框光标离开时校验敏感词
        $document.on("blur", ".JS_days_contents .JS_textares_box textarea", function () {
            validateSensitiveWord($(this), true);
        });

        //绑定景点模块的浏览时间小时和分钟输入框光标离开时校验是否填写其中一个-注释
        $document.on("blur", ".view-spot-item .JS_visit_hour, .view-spot-item .JS_visit_minute", function () {
            var productType = $("#productType").val();
            var isInnerline = false;
            if (productType == "INNERLINE" || productType == "INNERSHORTLINE" || productType == "INNERLONGLINE") {
                isInnerline = true;
            }

            var $this = $(this);
            var $otherInput = $this.siblings("input");

            //如果是国内产品品类
            if (isInnerline) {
                if (isEmpty($this.val()) && !isEmpty($otherInput.val())) {
                    $this.attr("data-validate", "{regular:仅支持输入数字}");
                    $this.removeClass("error");
                } else if (!isEmpty($this.val()) && isEmpty($otherInput.val())) {
                    $otherInput.attr("data-validate", "{regular:仅支持输入数字}");
                    $otherInput.removeClass("error");
                } else if (isEmpty($this.val()) && isEmpty($otherInput.val())) {
                    $this.attr("data-validate", "{required:true,regular:仅支持输入数字}");
                    $this.addClass("error");
                    $otherInput.attr("data-validate", "{required:true,regular:仅支持输入数字}");
                    $otherInput.addClass("error");
                }
            }

        });
        
      //绑定购物模块的参观时间时间小时和分钟输入框光标离开时校验是否填写其中一个-注释
        $document.on("blur", ".view-shop-item .JS_visit_hour, .view-shop-item .JS_visit_minute, .activity-item .JS_visit_hour, .activity-item .JS_visit_minute", function () {
            var $this = $(this);
            var $otherInput = $this.siblings("input");

            //如果是国内产品品类
            
            if (isEmpty($this.val()) && !isEmpty($otherInput.val())) {
            	$this.attr("data-validate", "{regular:仅支持输入数字}");
            	$this.removeClass("error");
         	} else if (!isEmpty($this.val()) && isEmpty($otherInput.val())) {
         		$otherInput.attr("data-validate", "{regular:仅支持输入数字}");
              	$otherInput.removeClass("error");
         	} else if (isEmpty($this.val()) && isEmpty($otherInput.val())) {
         		$this.attr("data-validate", "{required:true,regular:仅支持输入数字}");
              	$this.addClass("error");
             	$otherInput.attr("data-validate", "{required:true,regular:仅支持输入数字}");
              	$otherInput.addClass("error");
           	}
        });

        //绑定交通模块的浏览时间小时和分钟输入框光标离开时校验是否填写其中一个
        $document.on("blur", ".traffic-item .JS_vehicle_hour_blur, .traffic-item .JS_vehicle_minute_blur", function () {
            var flightTimeValidate = $("#flightTimeValidate").val();
            var $this = $(this);
            var $otherInput = $this.siblings("input");
            //如果是出境并且线路
            if (flightTimeValidate == 'Y') {
                if (isEmpty($this.val()) && !isEmpty($otherInput.val())) {
                    $this.attr("data-validate", "{regular:仅支持输入数字}");
                    $this.removeClass("error");
                } else if (!isEmpty($this.val()) && isEmpty($otherInput.val())) {
                    $otherInput.attr("data-validate", "{regular:仅支持输入数字}");
                    $otherInput.removeClass("error");
                } else if (isEmpty($this.val()) && isEmpty($otherInput.val())) {
                    $this.attr("data-validate", "{required:true,regular:仅支持输入数字}");
                    $this.addClass("error");
                    $otherInput.attr("data-validate", "{required:true,regular:仅支持输入数字}");
                    $otherInput.addClass("error");
                }
            }

        });
        
        $(".traffic-item .JS_vehicle_hour_blur, .traffic-item .JS_vehicle_minute_blur").each(function(){
        	$(this).trigger("blur");
        });
        
        /*天部分*/

        //保存一天事件
        window.Days.daySaveHandler = function (event) {

            var self = event.data.self;
            var $this = $(this);
            var $day = $this.parents(".day");

            $this.html("保存中...").addClass("disabled");

            self.allSave(function () {
                $this.siblings(".JS_day_edit").removeClass("link-edit");
            }, function() {
                $this.html("保存").removeClass("disabled");
            }, $this);

        };

        /*模块部分*/

        //编辑一天
        window.Days.dayEditHandler = function (event) {

            var self = event.data.self;
            var $this = $(this);

            self.allSave(function() {
                $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
                $(".JS_day_save").hide();

                var $dayHeader = $this.parents(".day-head");
                var $save = $dayHeader.find(".JS_day_save");
                $save.show();
                $dayHeader.removeClass("state-view").addClass("state-edit");
                $this.addClass("link-edit");
            }, function() {}, $this);

        };

        //触发一天
        window.Days.dayStartHandler = function (event) {

            var self = event.data.self;
            var $this = $(this);

            self.allSave(function() {
                $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
                $(".JS_day_save").hide();

                var $dayHeader = $this.parents(".day-head");
                var $add = $dayHeader.find(".day-module-add");
                $add.show();
                var $save = $dayHeader.find(".JS_day_save");
                $save.show();
                $dayHeader.removeClass("state-view").addClass("state-edit");
            }, function() {}, $this);

        };

        //保存模块事件
        window.Days.moduleSaveHandler = function (event) {

            var self = event.data.self;
            var $this = $(this);
            var $module = $this.parents(".module");

            $this.html("保存中...").addClass("disabled");

            self.allSave(function() {
            }, function () {
                $this.html("保存").removeClass("disabled");
            }, $this);

        };

        //编辑模块事件
        window.Days.moduleEditHandler = function (event) {
            var self = event.data.self;

            var $this = $(this);
            var $module = $this.parents(".module");
            if($module.find(".module-title").html()=="自由活动"){
            	$module.find(".module-main").removeClass("activity-item");
            	$module.find(".module-main .module-label").eq(0).html("活动时间：");
            	$module.find(".JS_visit_hour").attr("data-validate","{regular:true}");
            	$module.find(".JS_visit_minute").attr("data-validate","{regular:true}");
            }
            
            var hours = "";
            //新增页面
            if($module.find(".JS_group_form_hidden input[name='startTime']").val()!=null){
            	hours = $module.find(".JS_group_form_hidden input[name='startTime']").val();
            }else{
            //编辑页面	
            	hours = $module.find(".module-post-left p").html();
            }
            
            //将“开始时间” 更新设置
//            $module.find(".module-post-left p").html(hours);
            if (hours === "全天" || hours ==="ALL_DAY") {
            	 $module.find(".JS_switch_noallday").hide();
                 $module.find(".JS_switch_allday").show();
                 
                 //清空 不为“全天”的 用餐时间  和餐费标准
                 $module.find(".JS_item_form_hidden>.hidden_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_meal_price").val("");
                 $module.find(".JS_switch_noallday select option:selected").val("");
                 $module.find(".JS_switch_noallday").find(".JS_meal_price").attr("data-validate","{regular:true}");
             } else {
            	 $module.find(".JS_switch_noallday").show();
                 $module.find(".JS_switch_allday").hide();
                 //清空 为“全天”的 用餐时间  和餐费标准
                 $module.find(".JS_item_form_hidden>.hidden_breakfast_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_lunch_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_dinner_meal_time").val("");
                 $module.find(".JS_item_form_hidden>.hidden_breakfast_meal_price").val("");
                 $module.find(".JS_item_form_hidden>.hidden_lunch_meal_price").val("");
                 $module.find(".JS_item_form_hidden>.hidden_dinner_meal_price").val("");
                 $module.find(".JS_switch_allday select option:selected").val("");
                 $module.find(".JS_switch_allday").find(".JS_lunch_meal_price").attr("data-validate","{regular:true}");
                 $module.find(".JS_switch_allday").find(".JS_dinner_meal_price").attr("data-validate","{regular:true}");
            }

            //初始化textare输入框的展开状态
            initTextareaStatus($module);
            initMealmultiSelect();
            //触发景点的浏览时间输入框blur事件
            if ($module.hasClass("template-view-spot")) {
                var $items = $module.find(".view-spot-item");
                $.each($items, function(index, item) {
                    $(item).find(".JS_visit_hour").trigger("blur");
                });
            }

            self.allSave(function() {
                $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
                $(".JS_day_save").hide();
                $module.addClass("state-edit").removeClass("state-view");
            }, function() {}, $this);

        };

        //全部保存事件
        window.Days.allSaveHandler = function (event) {

            var $this = $(this);

            if ($this.is(".disabled")) {
                return false;
            }

            var self = event.data.self;
            
            var realSaveFunction = function() {
                var oldtext = $this.html();
                $this.html("保存中...").addClass("disabled");
	            setTimeout(function () {
	                self.allSave(function () {
	                    $(".module.state-edit,.day-head.state-edit").addClass("state-view").removeClass("state-edit");
	                    $(".JS_day_save").hide();
	
	                    $this.html(oldtext).removeClass("disabled");
	
	                    //保存提示
	                    if(!isDayFilledAsExepected()) {
	                    	$(".top-save-tip").show();
	                    }
	
	                    backstage.floatAlert({
	                        className: "float-alert-success",
	                        content: "保存成功"
	                    });
	                }, function () {
	                    $this.html(oldtext).removeClass("disabled");
	                }, $this);
	
	            }, 500);
            };
            
            var newStructureFlag = $("#prodLineRouteDiv [name=newStructureFlag]").val();
            if('N' == newStructureFlag) {
            	var msg = "由于系统升级已更新行程明细，请核对行程";
	            backstage.confirm({
	            	width: 360,
	                content: msg,
	                determineCallback:realSaveFunction
	            });
            } else {
            	realSaveFunction();
            }

        };

        //全部保存
        window.Days.allSave = function (successCallback, errorCallback, $this) {
            var $edit = this.$contents.find(".state-edit .edit");
            var firstError = true;

            //错误提示文本
            var errorText = "";

            //错误发生的区域
            var $errorEdit = null;

            //是否验证通过
            var isValidate = true;

            for (var i = 0; i < $edit.length; i++) {
                var validate = backstage.validate({
                    REQUIRED: "您还有未填写项",
                    $area: $edit,
                    showError: true,
                    $ERROR: $('<i class="error"></i>')
                });
                validate.test();
                validate.watch();

                if (!validate.getIsValidate()) {
                    isValidate = false;
                    if (firstError) {
                        errorText = validate.getErrorText();
                        $errorEdit = $edit.eq(i);
                        firstError = false;
                    }
                }
            }

            if (isValidate) {

               var saveSuccess = true;

                //如果点击保存所有
                if ($this.is(".JS_all_save")){
                    //发送ajax保存行程下所有明细信息
                    saveSuccess = saveAllDaysData();
                } else if($this.is(".JS_module_prev")
                		||$this.is(".JS_module_next")
                		||$this.is(".JS_tab_move_prev")
                		||$this.is(".JS_tab_move_next")){
                		//模块或天数移动
                	saveSuccess = saveDayOrMoudlelMoveData();
                }else{
                    for (var j = 0; j < $edit.length; j++) {

                        var $editJ = $edit.eq(j);

                        if ($editJ.is(".state-location") || $editJ.is(".state-title")) {
                            var $day = $editJ.closest(".day");
                            //发送ajax保存行程明细的title
                            saveSuccess = saveDayHeader($day.find(".day-head-form"));
                        }

                        var $moduleJ = $editJ.parents(".module");

                        if ($moduleJ.length > 0) {
                            //发送ajax保存行程明细组
                            saveSuccess = saveGroupData($moduleJ);
                        }

                    }

                }

                if (saveSuccess && successCallback) {
                    successCallback();
                }
            } else {
                $(window).scrollTop($errorEdit.offset().top - 100);
                backstage.floatAlert({
                    className: "float-alert-warning",
                    content: errorText
                });
                if (errorCallback) {
                    errorCallback();
                }
            }
        };

        init();

        //初始化
        function init() {
            window.Days.init();
            window.Days.bindEventExtend();
            var defaultDay = parseInt($("#defaultDay").val());
            for (var i = 0; i < defaultDay; i++) {
                this.Days.add();
            }
            window.Days.refresh();

            //初始化各个模块
            initModule();

            //发送异步请求校验敏感词
            validateSensitiveWord($(".JS_days_contents").find("textarea"), true);
        }

        //初始化模块
        function initModule() {
            //初始化textarea输入框的展开状态
            initTextareaStatus($(".JS_days_contents>.day"));
            //初始化用餐状态
            initMealmultiSelect();
        }

        //初始化textare输入框的展开状态
        function initTextareaStatus($object) {
            var $textaresBoxs = $object.find(".col.JS_textares_box");
            $.each($textaresBoxs, function(index, textaresBox) {
                var $textaresBox = $(textaresBox);
                var $textarea = $textaresBox.find("textarea");
                if ($textarea.text() != "") {
                    $textaresBox.find(".JS_textarea_expand").trigger("click");
                }
            });
        }

        //初始化用餐状态
        function initMealmultiSelect() {
            var $editModules = $(".JS_days_contents").find(".module.template-restaurant");
            $.each($editModules, function (index, editModule) {
                window.Days.restaurantInit($(editModule));
                $(editModule).find(".template-restaurant .JS_time_hour").trigger("change");
            });
        }

    });

   //景点相关JS START
    $(function () {

        //景点名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_view_spot_name",
                "fillData": fillData,
                "choice": choice
            });
            function fillData(self) {
                var url = "http://www.lvmama.com/lvyou/ajax/getPoiinfoByKeyword?q="+self.$input.val();
                self.loading();
                self.$menuLoading.html("查找中...");
                $.ajax({
                    url: url,
                    dataType: "JSONP",
                    type:"GET",
                    success: function (result) {
                        if (result.code==200) {
                            var json = result.data.list;
                            if (isEmpty(json)) {
                                json = {};
                            }
                            var $ul = self.$menu.find("ul");
                            $ul.empty();
                            for (var i = 0; i < json.length; i++) {
                                var $li = $('<li class="clearfix" data-id="' + json[i].dest_id + '">' +
                                        '<div class="pull-left w300 JS_autocomplete_name">' + json[i].dest_name + '</div>' +
                                        '<div class="pull-right w50">' + json[i].parent_name + '</div>' +
                                        '<div class="JS_scenic_intro" style="display:none;">' + json[i].intro + '</div>' +
                                        '</li>');
                                $ul.append($li);
                            }
                            $ul.children().eq(0).addClass("active");
                            self.loaded();
                        } else {
                            self.$menuLoading.html("无搜索结果");
                        }
                    },
                    error: function () {
                        self.$menuLoading.html("数据错误");
                    }
                });
            }

            function choice(self, $li) {

                var text = $li.find(".JS_autocomplete_name").html();
                self.$input.val(text).change();

                var id = $li.attr("data-id");
                var intro = $li.find(".JS_scenic_intro").html();
                var $item = self.$input.closest(".view-spot-item");
                var $itemFormHidden = $item.find(".JS_item_form_hidden");
                //赋值景点ID
                $itemFormHidden.find(".hidden_scenic_name_id").val(id);
                //赋值景点名称
                $itemFormHidden.find(".hidden_scenic_name").val(text);
                //赋值景点描述
                $item.find(".textarea-content").text(intro);
                //展开景点描述
                $item.find(".JS_textarea_expand").trigger("click");
            }
        });

        //预览
        $document.on("click", ".JS_view_sport_preview", viewSpotPreviewHandler);

        //添加景点
        $document.on("click", ".JS_view_spot_add", viewSpotAddHandler);

        //删除景点
        $document.on("click", ".JS_view_spot_del", viewSpotDeleteHandler);

        //预览
        function viewSpotPreviewHandler() {
            $this = $(this);

            var $item = $this.closest(".view-spot-item");
            var $module = $this.closest(".module");
            var $form = $this.closest("form");

            assignInputValuesForForm($module);

            var content = "";
            $.ajax({
                url: "/vst_admin/dujia/comm/route/detail/previewModuleTemplate.do",
                data: $form.serialize() + "&index=" + $item.attr("data-index"),
                async: false,
                type: "POST",
                dataType: "JSON",
                success: function (result) {
                    if (result.code == "success") {
                        content = result.attributes.templateText;
                    }
                }
            });

            content = content.replace(/\n/g,"<br/>");
            var $content = $('<div>' + content + '</div>');
            backstage.dialog({
                title: "驴妈妈前台展示效果",
                $content: $content,
                width: 400,
                height: 200,
                padding: 20
            });
        }

        //添加景点
        function viewSpotAddHandler() {

            var $this = $(this);
            var $module = $this.parents(".module");
            var $increase = $module.find(".JS_view_spot_increase");

            var $thatViewSpotItem = $this.parents(".view-spot-item");

            //景点名称
            var $viewSpotName = $thatViewSpotItem.find(".JS_view_spot_name");
            var viewSpotName = $viewSpotName.val();
            //景点逻辑关系
            var $selectLogic = $thatViewSpotItem.find(".JS_view_spot_and_or").find("select");
            var logicRelation = "";
            if ($selectLogic.length > 0) {
                logicRelation = $selectLogic.val();
            }

            var $viewSpotInitial = $thatViewSpotItem.find(".view-spot-initial");
            var $viewSpotForm = $thatViewSpotItem.find(".view-spot-form");

            if (viewSpotName !== "") {
            	if(/[【】\[\]［］<>＜＞《》]+/.test(viewSpotName)){
            		backstage.floatAlert({
                        className: "float-alert-warning",
                        content: "非法字符"
                    });
            		return false;
            	}
                $thatViewSpotItem.find(".JS_scenic_name").html(escapeHTML(viewSpotName));
                $viewSpotInitial.find(":input").prop("disabled", true);
                $viewSpotForm.find(":input").prop("disabled", false);
                $thatViewSpotItem.addClass("state-added");
                $increase.show();
                //为景点ID、景点名称和景点逻辑关系赋值
                var $scenicFormHiddenDiv = $thatViewSpotItem.find(".JS_item_form_hidden");
                var $scenicName = $scenicFormHiddenDiv.find(".hidden_scenic_name");
                //如果用户选中下拉名称后有修改，需要将设置的nameId清理掉
                if ($.trim($scenicName.val()) != $.trim(viewSpotName)) {
                    $scenicFormHiddenDiv.find(".hidden_scenic_name_id").val("");
                }
                $scenicName.val($.trim(viewSpotName));
                //为form中的逻辑select赋值
                if (logicRelation != "") {
                    $viewSpotForm.find(".view-spot-head>.JS_view_spot_and_or").find("option[value="+logicRelation+"]").attr("selected", true);
                }
                //为参考价格设置为无效（行程已含）
                $viewSpotForm.find(".JS_view_spot_price").attr("disabled", true);
                //出发景点描述敏感词校验
                $viewSpotForm.find(".JS_textares_box textarea").trigger("blur");
            } else {
                backstage.floatAlert({
                    className: "float-alert-warning",
                    content: "请输入景点名称"
                });
            }

        }

        //删除景点
        function viewSpotDeleteHandler() {
            var $this = $(this);

            var $thatViewSpotItem = $this.parents(".view-spot-item");
    
            var $viewSpotList = $this.parents(".view-spot-list");
    
            var $module = $this.parents(".module");
            var $increase = $module.find(".JS_view_spot_increase");

            var groupId = $module.attr("data-id");
            var scenicId = $thatViewSpotItem.find(".JS_item_form_hidden>.hidden_scenic_id").val();

            backstage.confirm({
                content: "确定删除当前信息么？",
                determineCallback: function () {
                    if(isEmpty(scenicId)) {
                        $thatViewSpotItem.remove();
                        $increase.show();

                        if ($viewSpotList.children().length == 0) {
                            $increase.trigger("click");
                        } else {
                            var $firstViewSport = $viewSpotList.children(":first");
                            $firstViewSport.find(".view-spot-head>.JS_view_spot_and_or").remove();
                        }
                        backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
                    } else {
                        var nDay = $module.parents(".day").find("[name=nDay]").val();
                        $.ajax({
                            url: "/vst_admin/dujia/comm/route/detail/deleteModule.do",
                            data: {groupId:groupId,moduleId:scenicId,nDay:nDay},
                            success: function(result) {
                                if (result.code == "success") {
                                    $thatViewSpotItem.remove();
                                    $increase.show();

                                    if ($viewSpotList.children().length == 0) {
                                        $increase.trigger("click");
                                    } else {
                                        var $firstViewSport = $viewSpotList.children(":first");
                                        $firstViewSport.find(".view-spot-head>.JS_view_spot_and_or").remove();
                                    }
                                    backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
                                } else {
                                    backstage.floatAlert({className: "float-alert-warning", content: result.message});
                                }
                            },
                            error: function() {
                                backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试"});
                                console.log("Call viewSpotDeleteHandler method occurs error");
                            }
                        });
                    }
                 }
              });

        }

    });
    //景点相关JS END

    //用餐
    $(function () {

        //预览
        $document.on("click", ".JS_restaurant_preview", restaurantPreviewHandler);
        
        $document.on("change", $(".JS_restaurant_type_single").find("select"), becomeRequire);
        $document.on("change", $(".JS_restaurant_type_multiple").find("select"), becomeRequireMultiple);
        
        function becomeRequire() {
        	var categoryId = $("#categoryId").val();
        	var productType = $("#productType").val();
        	if(categoryId!=18 && productType!="FOREIGNLINE"){
        		if($(".JS_switch_noallday").is(":visible")){
    	        	$(".JS_restaurant_type_single").each(function(){
    	        		if($(this).is(":visible")){
    	        			var type = $(this).find("select").val();
    	        			 if(type=="LUNCH"||type=="DINNER"){
    	        				 $(this).parent().parent().find(".JS_switch_noallday").find(".module-label").eq(1).html("<em>*</em>餐费标准：");
	        					 $(this).parent().parent().find(".JS_switch_noallday").find(".JS_meal_price").attr("data-validate","{required:true,regular:true}");
    	     			    }else{
    	     			    	$(this).parent().parent().find(".JS_switch_noallday").find(".module-label").eq(1).html("餐费标准：");
	     			    		$(this).parent().parent().find(".JS_switch_noallday").find(".JS_meal_price").attr("data-validate","{regular:true}");
    	     			    }
    	        		}
    	        	});
            	}
        	}
        }
        function becomeRequireMultiple() {
        	var categoryId = $("#categoryId").val();
        	var productType = $("#productType").val();
        	if(categoryId!=18 && productType!="FOREIGNLINE"){
	        	if($(".JS_switch_allday").is(":visible")){
	        		var mealTypes;
	        		$(".JS_restaurant_type_multiple").each(function(){
	        			if($(this).is(":visible")){
	        				mealTypes = $(this).find("select").val();
	        				var mealType = "";
	        	            if ($.isArray(mealTypes)) {
	        	            	for (var i = 0; i < mealTypes.length; i++) {
	        	                    mealType += mealTypes[i];
	        	                    if (i < mealTypes.length - 1) {
	        	                        mealType += "|";
	        	                    }
	        	                }
	        	            }
	    	            	
	    	            	if(mealType.indexOf("LUNCH")>=0 && mealType.indexOf("SELF_LUNCH")<0){
	    	            		$(this).parent().parent().find(".JS_switch_allday").find(".lunchname").html("<em style='color:#FF0000'>*</em>中餐");
    	            			$(this).parent().parent().find(".JS_switch_allday").find(".JS_lunch_meal_price").attr("data-validate","{required:true,regular:true}");
	    	            	}else {
	    	            		$(this).parent().parent().find(".JS_switch_allday").find(".lunchname").html("中餐");
    	            			$(this).parent().parent().find(".JS_switch_allday").find(".JS_lunch_meal_price").attr("data-validate","{regular:true}");
	    	            	}
	    	            	if(mealType.indexOf("DINNER")>=0 && mealType.indexOf("SELF_DINNER")<0){
	    	            		$(this).parent().parent().find(".JS_switch_allday").find(".dinnername").html("<em style='color:#FF0000'>*</em>晚餐");
    	            			$(this).parent().parent().find(".JS_switch_allday").find(".JS_dinner_meal_price").attr("data-validate","{required:true,regular:true}");
	    	            	}else {
	    	            		$(this).parent().parent().find(".JS_switch_allday").find(".dinnername").html("晚餐");
    	            			$(this).parent().parent().find(".JS_switch_allday").find(".JS_dinner_meal_price").attr("data-validate","{regular:true}");
	    	            	}
	        			}
	        		});
	        	}
        	}
        }
        //预览
        function restaurantPreviewHandler() {
            $this = $(this);
            var $module = $this.closest(".module");
            var $form = $this.closest("form");

            assignInputValuesForForm($module);
            var content = "";
            $.ajax({
                url: "/vst_admin/dujia/comm/route/detail/previewModuleTemplate.do",
                data: $form.serialize() + "&index=0",
                async: false,
                type: "POST",
                dataType: "JSON",
                success: function (result) {
                    if (result.code == "success") {
                        content = result.attributes.templateText;
                    }
                }
            });
            var $content = $('<div>' + content + '</div>');
            backstage.dialog({
                title: "驴妈妈前台展示效果",
                $content: content.replace(/\n/g,"<br/>"),
                width: 400,
                height: 200,
                padding: 20
            });
        
        }

    });

    //住宿酒店 START
    $(function () {
        //酒店名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_single_hotel_name",
                "fillData": fillData,
                "choice": choice,
                "click": true
            });
            function fillData(self) {
                var url = "/vst_admin/dujia/comm/route/detail/searchHotelList.do?hotelName="+self.$input.val();
                self.loading();
                self.$menuLoading.html("查找中...");
                
                //点击
                if($.trim(self.$input.val()) == "") {
                    url = "/vst_admin/dujia/comm/route/detail/findStarList.do";
                    $.ajax({
                        url: url,
                        success: function (result) {
                            var $ul = self.$menu.find("ul");
                            $ul.empty();
                            var data = result.attributes.data;
                            for (var i = 0; i < data.length; i++) {
                                var $li = $('<li class="clearfix" data-id="' + data[i].dictId + '">' +
                                        '<div class="pull-left w300 JS_autocomplete_name">' + data[i].dictName + '</div>' +
                                        '</li>');
                                $ul.append($li);
                            } 
                            $ul.children().eq(0).addClass("active");
                            self.loaded();
                        },
                        error: function () {
                            self.$menuLoading.html("数据错误");
                        }
                    });
                } else { //用户输入
                    $.ajax({
                        url: url,
                        success: function (result) {
                            var $ul = self.$menu.find("ul");
                            $ul.empty();
                            var data = result.attributes.data;
                            for (var i = 0; i < data.length; i++) {
                                var districtName = "";
                                if(!isEmpty(data[i].bizDistrict)) {
                                    if(!isEmpty(data[i].bizDistrict.districtName)) {
                                        districtName = data[i].bizDistrict.districtName;
                                    }
                                }
                                var $li = $('<li class="clearfix" data-id="' + data[i].productId + '">' +
                                        '<div class="pull-left w300 JS_autocomplete_name">' + data[i].productName + '</div>' +
                                        '<div class="pull-right w50">' + districtName + '</div>' +
                                        '</li>');
                                $ul.append($li);
                            } 
                            $ul.children().eq(0).addClass("active");
                            self.loaded();
                        },
                        error: function () {
                            self.$menuLoading.html("数据错误");
                        }
                    });
                }
            }

            function choice(self, $li) {
                var text = $li.find(".JS_autocomplete_name").html();
                var id = $li.attr("data-id");
                var $hidden = self.$input.parent().find(".JS_hotel_id");
                $hidden.val(id);
                //点击
                if($.trim(self.$input.val()) == "") {
                    self.$input.val(text);
                    $hidden.attr("mark", "star");
                } else { //用户输入
                    self.$input.val(text).change();
                    var $item = self.$input.closest(".hotel-item");
                    var $itemFormHidden = $item.find(".JS_item_form_hidden");
                    //赋值产品ID
                    $itemFormHidden.find(".hidden_productId").val(id);
                    //赋值酒店名称
                    $item.find(".JS_hotel_name>input:text").val(text);
                }
            }
        });

        //预览
        $document.on("click", ".JS_hotel_preview", hotelPreviewHandler);

        //添加酒店
        $document.on("click", ".JS_hotel_add", hotelAddHandler);
        
        //删除酒店
        $document.on("click", ".JS_hotel_del", hotelDeleteHandler);

        //选择房型时，设置房型名称
        $document.on("change", ".JS_hotel_roomTypeId", setRoomOrStarHandler);
        
        //选择星级时，设置星级名称
        $document.on("change", ".JS_hotel_starLevel", setRoomOrStarHandler);
        
        //预览
        function hotelPreviewHandler() {
            $this = $(this);
            var $item = $this.closest(".hotel-item");
            var $module = $this.closest(".module");
            var $form = $this.closest("form");

            assignInputValuesForForm($module);

            var content = "";
            $.ajax({
                url: "/vst_admin/dujia/comm/route/detail/previewModuleTemplate.do",
                data: $form.serialize() + "&index=0",
                async: false,
                type: "POST",
                dataType: "JSON",
                success: function (result) {
                    if (result.code == "success") {
                        content = result.attributes.templateText;
                    }
                }
            });

            var $content = $('<div>' + content + '</div>');
            backstage.dialog({
                title: "驴妈妈前台展示效果",
                $content: content.replace(/\n/g,"<br/>"),
                width: 400,
                height: 200,
                padding: 20
            });
        }
        
        //添加酒店
        function hotelAddHandler() {
            var $this = $(this);
            var $module = $this.parents(".module");
            var $thatHotelItem = $this.parents(".hotel-item");
            
            var $increase = $module.find(".JS_hotel_increase");
            
            var $hotelInitial = $thatHotelItem.find(".hotel-initial");
            var $hotelForm = $thatHotelItem.find(".hotel-form");
            
            //用户输入的酒店名称
            var $hotelName = $thatHotelItem.find(".JS_single_hotel_name");
            var hotelName = $hotelName.val();
            
            if(isEmpty(hotelName)) {
                backstage.floatAlert({
                    className: "float-alert-warning",
                    content: "请输入酒店名称"
                });
                return;
            }
            
            var hotelDiv = $thatHotelItem.find(".JS_hotel_id");
            var productId = hotelDiv.val();
            //星级标记
            var starLevelMark = hotelDiv.attr("mark");
            //处理星级下拉
            if(starLevelMark == "star") {
                processStarCase($thatHotelItem);
            } else if(!isEmpty(productId)) { //处理酒店产品
                processHotelCase($thatHotelItem);
            } else { //用户输入（非酒店产品）
                processCustomCase($thatHotelItem);
            }
            
            //单个酒店的隐藏域
            var $hotelFormHiddenDiv = $thatHotelItem.find(".JS_item_form_hidden");
            
            //或字处理
            //酒店逻辑关系
            var $selectLogic = $thatHotelItem.find(".JS_hotel_and_or").find("select");
            var logicRelation = "";
            if ($selectLogic.length > 0) {
                logicRelation = $selectLogic.val();
            }
            //为酒店名称和酒店逻辑关系赋值
            $hotelFormHiddenDiv.find(".hidden_logic_relation").val(logicRelation);
               $hotelForm.find(".hotel-and-or").find("option[value="+logicRelation+"]").attr("selected", true);
            
            //选择星级菜单时
            if(starLevelMark == "star") {
                hotelName = "未指定酒店";
            }
             
            //显示名称
            $thatHotelItem.find(".JS_hotel_name").prepend(escapeHTML(hotelName));
            //放入隐藏域
            $thatHotelItem.find(".JS_hotel_name").find("input:text").val(hotelName);
            
            $hotelInitial.find(":input").prop("disabled", true);
            $hotelForm.find(":input").prop("disabled", false);
            $thatHotelItem.addClass("state-added");
            $increase.show();
        }
        
        //处理星级下拉的情况
        function processStarCase(thatHotelItem) {
            //星级下拉项的ID
            var starLevelId = thatHotelItem.find(".JS_hotel_id").val();
            
            //星级
            var starLevelDiv = thatHotelItem.find(".div_hotel_starLevel");
            starLevelDiv.find(".JS_hotel_starLevel").eq(0).remove();
            var prodStarEle = starLevelDiv.find(".JS_hotel_starLevel").eq(0);
            var starOption = prodStarEle.find("option[value="+starLevelId+"]");
            if(starOption.length > 0) {
                starOption.attr("selected", true);
            } else {
                //取option第一项填充到hidden
                starOption = prodStarEle.find("option").eq(0);
            }
            prodStarEle.prev("input[type='hidden']").val(starOption.text());
            prodStarEle.show();
            
            //房型
            //房型DIV元素
            var divRoomType = thatHotelItem.find(".JS_div_hotel_roomType");
            //删除房型下拉菜单
            divRoomType.find("select").remove();
            //删除房型下拉隐藏域
            divRoomType.find("input[type='hidden']").remove();
            //显示房型输入框
            divRoomType.find("input:text").show();;
            
            //显示所在地
            thatHotelItem.find(".JS_hotel_belongToPlace").find("input:text").show();
        }
        
        //处理酒店产品情况
        function processHotelCase(thatHotelItem) {
            //取到输入的酒店名称
            var hotelName = thatHotelItem.find(".JS_single_hotel_name").val();
            //取得form隐藏域
            var hotelFormHiddenDiv = thatHotelItem.find(".JS_item_form_hidden");
            //酒店名称隐藏域（选择时设置的）
            var hiddenHotelName = thatHotelItem.find(".JS_hotel_name>input:text");
            //用户选择下拉名称后有修改，需要将设置的productId置空
            if ($.trim(hiddenHotelName.val()) != $.trim(hotelName)) {
                hotelFormHiddenDiv.find(".hidden_productId").val("");
                //选中的酒店产品ID置空
                thatHotelItem.find(".JS_hotel_id").val("");
            }
            hiddenHotelName.val($.trim(hotelName));
            
            //房型DIV元素
            var divRoomType = thatHotelItem.find(".JS_div_hotel_roomType");
            //星级DIV元素
            var starLevelDiv = thatHotelItem.find(".div_hotel_starLevel");
            //所在地
            var belongToPlace = thatHotelItem.find(".JS_hotel_belongToPlace");
            //房型下拉菜单
            var roomTypeSelect = divRoomType.find("select");
            //房型下拉隐藏域
            var hiddenRoomType = divRoomType.find("input[type='hidden']");
            //房型输入框
            var roomTypeInput = divRoomType.find("input:text");
            
            //产品ID
            var productId = thatHotelItem.find(".JS_hotel_id").val();
            
            $.ajax({
                url: "/vst_admin/dujia/comm/route/detail/loadProductById.do?productId="+productId,
                success: function (result) {
                    //产品
                    var pp = result.attributes.pp;
                    //房型
                    var roomTypeList = result.attributes.roomTypeList;
                    if (isEmpty(roomTypeList)) {
                        roomTypeList = {};
                    }
                    //产品找到
                    if (!isEmpty(pp)) {
                        //房型输入框删除
                        roomTypeInput.remove();
                        //显示房型下拉框
                        roomTypeSelect.show();
                        
                        //追加房型option
                        roomTypeSelect.append("<option value=''>不指定房型</option>");
                        for (var i = 0; i < roomTypeList.length; i++) {
                            roomTypeSelect.append("<option value="+roomTypeList[i].productBranchId+">"+roomTypeList[i].branchName+"</option>");
                        }
                        //所在地
                        var districtName = "";
                        if(!isEmpty(pp.bizDistrict)) {
                            if(!isEmpty(pp.bizDistrict.districtName)) {
                                districtName = pp.bizDistrict.districtName;
                            }
                        }
                        //显示名称
                        belongToPlace.prepend(districtName);
                        //放入隐藏域
                        belongToPlace.find("input:text").val(districtName);
                        //星级
                        var selDiv = starLevelDiv.find(".JS_hotel_starLevel").eq(0);
                        var dictId = result.attributes.startName;
                        //设置选中状态
                        if(!isEmpty(dictId)) {
                               var selEle = selDiv.find("option[value="+dictId+"]");
                            selEle.attr("selected", true);
                            selDiv.prev("input[type='hidden']").val(selEle.text());
                        }
                        selDiv.show();
                        starLevelDiv.find(".JS_hotel_starLevel").eq(1).remove();
                    }
                },
                error: function () {
                    backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试"});
                }
            });
        }
        
        //处理用户输入情况
        function processCustomCase(thatHotelItem) {
            //显示酒店名称输入框
            thatHotelItem.find(".JS_hotel_name").show();
            
            //房型DIV元素
            var divRoomType = thatHotelItem.find(".JS_div_hotel_roomType");
            //星级DIV元素
            var starLevelDiv = thatHotelItem.find(".div_hotel_starLevel");
            
            //删除房型下拉框
            divRoomType.find("select").remove();
            //删除房型隐藏域
            divRoomType.find("input[type='hidden']").remove();
            //显示房型输入框
            divRoomType.find("input:text").show();
            
            //显示所在地输入框
            thatHotelItem.find(".JS_hotel_belongToPlace").find("input:text").show();
            //星级
            starLevelDiv.find(".JS_hotel_starLevel").eq(0).remove();            
            var selDiv = starLevelDiv.find(".JS_hotel_starLevel").eq(0);
               var optnVal = selDiv.find("option:selected").val();
               selDiv.prev("input[type='hidden']").val(optnVal);
               selDiv.show();
        }
        
        //删除酒店
        function hotelDeleteHandler() {
            var $this = $(this);
            var $thatHotelItem = $this.parents(".hotel-item");
            var $hotelList = $this.parents(".hotel-list");
            var $module = $this.parents(".module");
            var $increase = $module.find(".JS_hotel_increase");
            //var $hotelInitial = $thatHotelItem.find(".hotel-initial");
            var $hotelForm = $thatHotelItem.find(".hotel-form");
            //组ID
            var groupId = $module.attr("data-id");
            var hotelId = $thatHotelItem.find(".JS_item_form_hidden>.hidden_hotel_id").val();
            backstage.confirm({
                content: "确定删除当前信息么？",
                determineCallback: function () {
                    if(isEmpty(hotelId)) {
                        $thatHotelItem.remove();
                        $increase.show();
        
                        if ($hotelList.children().length == 0) {
                            $increase.trigger("click");
                        } else {
                            $hotelList.children(":first").find(".hotel-head>.hotel-and-or").remove();
                        }
                        backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
                    } else {
                        var nDay = $module.parents(".day").find("[name=nDay]").val();
                        $.ajax({
                            url: "/vst_admin/dujia/comm/route/detail/deleteModule.do",
                            data: {groupId:groupId,moduleId:hotelId,nDay:nDay},
                            success: function(result) {
                                if (result.code == "success") {
                                    $thatHotelItem.remove();
                                    $increase.show();
    
                                    if ($hotelList.children().length == 0) {
                                        $increase.trigger("click");
                                    }else {
                                        $hotelList.children(":first").find(".hotel-head>.hotel-and-or").remove();
                                    }
                                    backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
                                } else {
                                    backstage.floatAlert({className: "float-alert-warning", content: result.message});
                                }
                            },
                            error: function() {
                                backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试"});
                                console.log("Call HotelDeleteHandler method occurs error");
                            }
                        });
                    }
                 }
              });
        }
        
        //选择房型/星级时，设置房型/星级名称
        function setRoomOrStarHandler() {
            var select = $(this);
            var option = select.find("option:selected");
            var roomOrStar = option.text();
            select.prev().val(roomOrStar);
        }

    });

     //购物
    $(function () {

        //购物名称自动完成
        $(function () {
            backstage.autocomplete({
                "query": ".JS_shop_name",
                "fillData": fillData,
                "choice": choice
            });
            function fillData(self) {
                var url = "/vst_admin/dujia/comm/route/detail/getDestList.do?destName="+self.$input.val();
                self.loading();
                self.$menuLoading.html("查找中...");
                $.ajax({
                    url: url,
                    success: function (result) {
                        if (result.code == "success") {
                            var json = result.attributes.bizDestList;
                            if (isEmpty(json)) {
                                json = {};
                            }
                            var $ul = self.$menu.find("ul");
                            $ul.empty();
                            for (var i = 0; i < json.length; i++) {
                                var parentDestName = json[i].parentDestName;
                                if(isEmpty(parentDestName)){
                                    parentDestName = '无';
                                }
                                var $li = $('<li class="clearfix" data-id="' + json[i].destId + '">' +
                                        '<div class="pull-left w300 JS_autocomplete_name">' + json[i].destName + '</div>' +
                                        '<div class="pull-right w50">' + parentDestName + '</div>' +
                                        '</li>');
                                $ul.append($li);
                            }
                            $ul.children().eq(0).addClass("active");
                            self.loaded();
                        } else {
                            self.$menuLoading.html("数据错误");
                        }
                    },
                    error: function () {
                        self.$menuLoading.html("数据错误");
                    }
                });
            }

            function choice(self, $li) {

                var text = $li.find(".JS_autocomplete_name").html();
                self.$input.val(text).change();

                var id = $li.attr("data-id");
                var $item = self.$input.closest(".shop-item");
                var $itemFormHidden = $item.find(".JS_item_form_hidden");
                //赋值购物点ID
                $itemFormHidden.find(".hidden_shopping_name_id").val(id);
                //赋值购物点名称
                $itemFormHidden.find(".hidden_shopping_name").val(text);
            }
        });
    
        //预览
        $document.on("click", ".JS_shop_preview", shopPreviewHandler);
    
        //添加购物
        $document.on("click", ".JS_shop_add", shopAddHandler);
    
        //删除购物
        $document.on("click", ".JS_shop_del", shopDelHandler);
    
        //预览
        function shopPreviewHandler() {
             $this = $(this);
    
            var $item = $this.closest(".shop-item");
            var $module = $this.closest(".module");
            var $form = $this.closest("form");
            
            assignInputValuesForForm($module);
    
            var content = "";
            $.ajax({
                url: "/vst_admin/dujia/comm/route/detail/previewModuleTemplate.do",
                data: $form.serialize() + "&index=" + $item.attr("data-index"),
                async: false,
                type: "POST",
                dataType: "JSON",
                success: function (result) {
                    if (result.code == "success") {
                        content = result.attributes.templateText;
                    }
                }
            });
    
            content = content.replace(/\n/g,"<br/>");
            var $content = $('<div>' + content + '</div>');
            backstage.dialog({
                title: "驴妈妈前台展示效果",
                $content: $content,
                width: 400,
                height: 200,
                padding: 20
            });
        }

        //添加购物
        function shopAddHandler() {
            var $this = $(this);
            var $module = $this.parents(".module");
            var $increase = $module.find(".JS_shop_increase");

            var $thatShopItem = $this.parents(".shop-item");
            var currentItemIndex = $thatShopItem.attr("data-index");
            var $shopName = $thatShopItem.find(".JS_shop_name");
            var shopName = $shopName.val();

            //购物逻辑关系
            var $selectLogic = $thatShopItem.find(".JS_shop_and_or").find("select");

            var logicRelation = "";
            if ($selectLogic.length > 0) {
                logicRelation = $selectLogic.val();
            }

            var $shopInitial = $thatShopItem.find(".shop-initial");
            var $shopForm = $thatShopItem.find(".shop-form");
    
            if (shopName !== "") {
            	if(/[【】\[\]［］（）\(\)<>＜＞《》]+/.test(shopName)){
            		backstage.floatAlert({
                        className: "float-alert-warning",
                        content: "非法字符"
                    });
            		return false;
            	}
                $thatShopItem.find(".JS_shop_name").html(escapeHTML(shopName));
                $shopInitial.find(":input").prop("disabled", true);
                $shopForm.find(":input").prop("disabled", false);
                $thatShopItem.addClass("state-added");
                $increase.show();
                //为购物点名称和购物点逻辑关系赋值
                $shopFormHiddenDiv = $thatShopItem.find(".JS_item_form_hidden");
                var $shoppingName = $shopFormHiddenDiv.find(".hidden_shopping_name");
                //如果用户选中下拉名称后有修改，需要将设置的nameId清理掉
                if ($.trim($shoppingName.val()) != $.trim(shopName)) {
                    $shopFormHiddenDiv.find(".hidden_shopping_name_id").val("");
                }
                $shoppingName.val($.trim(shopName));
                 //为form中的逻辑select赋值
                if (logicRelation != "") {
                    $shopForm.find(".shop-head>.JS_shop_and_or").find("option[value="+logicRelation+"]").attr("selected", true);
                }

                $.ajax({
                    url: "/vst_admin/dujia/comm/route/detail/getDest.do",
                    data: {"destId":$shopFormHiddenDiv.find(".hidden_shopping_name_id").val()},
                    success: function(result) {
                        if (result.code == "success") {
                            if(!isEmpty(result.attributes.poi) && !isEmpty(result.attributes.poi.address)){
                                $shopForm.find("input[name='prodRouteDetailShoppingList["+currentItemIndex+"].address']").val(result.attributes.poi.address);
                            }
                            if(!isEmpty(result.attributes.bizDestShop)){
                                $shopForm.find("input[name='prodRouteDetailShoppingList["+currentItemIndex+"].mainProducts']").val(result.attributes.bizDestShop.mainProducts);
                                $shopForm.find("input[name='prodRouteDetailShoppingList["+currentItemIndex+"].subjoinProducts']").val(result.attributes.bizDestShop.subjoinProducts);
                            }
                        }else{
                            backstage.floatAlert({
                                className: "float-alert-warning",
                                content: result.message
                            });
                        }
                    }
                });
            } else {
                backstage.floatAlert({
                    className: "float-alert-warning",
                    content: "请输入购物点名称"
                });
            }
            //购物点说明不为空，展开文本框
            if($(".shop-form  .textarea-content").text()!=""){
            	$(".JS_textarea_expand").trigger("click");
            }
            
        }

        //删除购物
        function shopDelHandler() {
            var $this = $(this);
    
            var $thatShopItem = $this.parents(".shop-item");
    
            var $shopList = $this.parents(".shop-list");
    
            var $module = $this.parents(".module");
            var $increase = $module.find(".JS_shop_increase");

            var $shopInitial = $thatShopItem.find(".shop-initial");
            var $shopForm = $thatShopItem.find(".shop-form");

            var groupId = $module.attr("data-id");
            var shoppingId = $thatShopItem.attr("data-id");

            if(isEmpty(shoppingId)) {
                $thatShopItem.remove();
                $increase.show();
                if ($shopList.children().length == 0) {
                    $increase.trigger("click");
                } else {
                    var $firstShop = $shopList.children(":first");
                    $firstShop.find(".shop-head>.JS_shop_and_or").remove();
                }
                backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
            } else {
            var nDay = $module.parents(".day").find("[name=nDay]").val();
            backstage.confirm({
                content: "确定删除当前信息么？",
                determineCallback: function () {
                    $.ajax({
                        url: "/vst_admin/dujia/comm/route/detail/deleteModule.do",
                        data: {groupId:groupId,moduleId:shoppingId,nDay:nDay},
                        success: function(result) {
                            if (result.code == "success") {
                                $thatShopItem.remove();
                                $increase.show();
                                if ($shopList.children().length == 0) {
                                    $increase.trigger("click");
                                } else {
                                    var $firstShop = $shopList.children(":first");
                                    $firstShop.find(".shop-head>.JS_shop_and_or").remove();
                                }
                                backstage.floatAlert({className: "float-alert-success", content: "删除成功"});
                            } else {
                                backstage.floatAlert({className: "float-alert-warning", content: result.message});
                            }
                        },
                        error: function() {
                            backstage.floatAlert({ className: "float-alert-warning", content: "网络服务异常, 请稍后重试"});
                            console.log("Call shopDelHandler method occurs error");
                        }
                    });
                 }
              });
            }

        }
    
    });

    //交通
    $(function () {

    });
    
    /**
     * 检查prod_line_route.route_num规定的天是否填写了
     */
    function isDayFilledAsExepected() {
    	var $days = $(".JS_days_contents>.day");
    	var allDayHeader = new Array();
    	 $days.each(function(index, e){
    		var $day = $(e);
    		var dayHeader = wrapDayHeaderDate($day.find(".day-head-form"));
    		allDayHeader.push(dayHeader);
    	 });

    	 var specifiedDays = $("#prodLineRouteDiv [name=route_num]").val();
    	 var allFilled = true;
    	 if(allDayHeader.length <parseInt(specifiedDays)){
    		 allFilled = false; 
    	 }else {
    		$.each(allDayHeader, function(index, e) {
	    		if(allFilled && parseInt(e.nDay) <= parseInt(specifiedDays)  && !e.title){
	    			allFilled = false;
	    	    }
    		});
    	 }
    	 return allFilled;
    }
    
    /**
     * 是否是没保存的天数
     */
    function isNotSaveDay(obj){
    	var flag = false;
    	var detailId = obj.attr("detailId");
    	if( (!detailId)||(detailId=="" )){
    		flag = true;
    		backstage.alert({
                title: "系统提示",
                content: "请先添加行程目的地或标题"
            });
    	}
    	return flag;
    }