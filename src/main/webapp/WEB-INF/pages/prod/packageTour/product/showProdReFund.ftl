<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body style="position:relative">
<div class="iframe_header">
        <ul class="iframe_nav">
            <li>线路
            </li>
            <li>产品维护 </li>
            <li class="active">退改规则</li>
        </ul>
    </div>
<div class="iframe_content mt10">
<div class="tiptext tip-warning cc5"><span class="tip-icon tip-icon-warning"></span>友情提示：
        <p class="pl15">注：供应商打包的商品，此处设置的是产品对用户端的退改规则。且会将这个值赋值给到该产品的商品。</p>
        <p class="pl15">注：自主打包的产品，此处设置的是产品对用户端的退改规则。被打包的单项产品，其依旧有自己的独立退改规则，用于内部结算使用。</p>
        <p class="pl15">注：关联销售的产品，不参与这里的规则。</p>
    </div>
	<div id="timePriceDiv" class="time_price">
	</div>
 <div class="p_box box_info mt10" >
 	<div class="price_tab">
        <ul class="J_tab ui_tab">
            <li class="active" data="0"><a href="javascript:;">设置退改规则</a></li>
        </ul>
     </div>
     <div class="price_content">
     <div style="margin:-10px 0 0 20px">   
     <form id="timePriceForm">
     <input type="hidden" name="productId" id="productId" value="${productId}">
	 <div class="p_date">
	 	
            <ul class="cal_range" id="cal_range">
                <li><i class="cc1">*</i>日期范围:</li>
                <li><input type="text" name="startDate" errorEle="selectDate" class="Wdate" required=true id="d4321" onFocus="WdatePicker({readOnly:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'d4322\',{d:0});}'})" /></li>
                <li>-</li>
                <li><input type="text" name="endDate" errorEle="selectDate" class="Wdate" required=true id="d4322" onFocus="WdatePicker({maxDate:'#F{$dp.$D(\'d4321\',{y:2});}',readOnly:true,minDate:'#F{$dp.$D(\'d4321\',{d:0});}'})" /></li>
                <li class="cc3">仅可操作两年内的时间，同步商品退改不能选日期</li>
                <div id="selectDateError" style="display:inline"></div>
            </ul>
            <ul class="app_week">
                <li><i class="cc1">*</i>适用日期:</li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDayAll">全部</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="2">一</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="3">二</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="4">三</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="5">四</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="6">五</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="7">六</label></li>
                <li><label class="checkbox"><input type="checkbox" class="checkbox_top" name="weekDay" value="1">日</label></li>
            </ul>
    </div>
        <div class="J_con active" style="position:relative;">
      		  <ul class="cal_range">
                <li><i class="cc1">*</i>  退改类型：</li>
                <li><select name="cancelStrategy" id="cancelStrategy">
                	<#if !(LOCAL_BU_LVMAMA_INNER_JINGJIU?? && LOCAL_BU_LVMAMA_INNER_JINGJIU == 'true') >
                	<option value="MANUALCHANGE">人工退改</option>
                	</#if>
                	<option value="UNRETREATANDCHANGE">不退不改</option>
                	<#if isNeed?? && isNeed == 'true' && (product.subCategoryId?? && product.subCategoryId==181)>
                	<option value="RETREATANDCHANGE">可退改</option>
                	<option value="GOODSRETREATANDCHANGE">同步商品退改</option>
                	</#if>
                </select>
                &nbsp;&nbsp;&nbsp;&nbsp;<a id='addRuleRow' class="btn btn-w btn-blue" style="display:none; ">新增退改规则</a>
                </li>
            </ul>
            <div  id='changeType'></div>
		</div>
	    <div style="display:none; margin-top:5px;margin-bottom:5px;" id="refundOther" >
					<span><input type="checkbox" checked onclick="return false" id="dissatisfy" /> 不满足以上条件</span>
					&nbsp;&nbsp;用户申请<select id="applyType_other" data="other" style="width:90px"><option value="">请选择</option><option value="REFUND">退款</option><option value="CHANGE" disabled="disabled">改期</option></select>
					&nbsp;&nbsp;扣除套餐费用<select class="deductType" id="deductType_other" data="other" style="width:90px"><option value="PERCENT">百分比</option><option value="AMOUNT">固定金额</option></select>
					<input id="deductValue_other" style="width:50px; line-height: 23px;" /><span id="unit_other">%</span>
		</div>
		<div id="refundHide" style="display: none;"></div>
		<#--提前预定时间-->
		<#if isNeed>
		<div>
			<span><input type="checkbox" id="aheadBookTime"/>&nbsp;提前预定时间：</span>
			<select class="w10 mr10" style="width:65px" id="aheadBookTime_Day">
				<#list 0..180 as day>
				<option value="${day}" >${day}</option>
				</#list>
			</select>天
			<select class="w10 mr10" style="width:65px" id="aheadBookTime_Hour">
				<#list 0..23 as hour>
				<option value="${hour}" >${hour}</option>
				</#list>
			</select>时
			<select class="w10 mr10" style="width:65px" id="aheadBookTime_Minute">
				<#list 0..59 as minute>
				<option value="${minute}" >${minute}</option>
				</#list>
			</select>
			分
			<a title="相应规则取被打包商品设置中和产品团期维护中严格的设置
产品团期维护设置提前定时间7天18小时10分钟。打包商品设置提前预定时间8天18小时20分钟，则取被打包商品设置8天18小时20分钟。
产品团期维护中提前定时间2天18小时59分钟。打包商品设置提前预定时间1天18小时59分钟，则取产品团期维护设置2天18小时59分钟。" href="#"  id="tag">（此处配置如与商品中冲突，已严格的为准显示及生效。）</a>
		</div>
		</#if>
		</form>
 </div>  
 </div>
 </div>
 <div class="p_box box_info clearfix mb20">
            <div class="fl operate">
	            <a class="btn btn_cc1" id="timePriceSaveButton">保存</a>
				<#if isNeed=='true'>
				<a class="btn btn_cc1" id="refreshGroupDateButton">刷新团期</a>
				</#if>
	            <a href="javascript:void(0);" style="margin-left:100px;" class="showLogDialog btn btn_cc1" param='objectId=${productId}&objectType=SUPP_GOODS_GOODS&sysName=VST'>操作日志</a>
            </div>
        </div>
 </div>
 </div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script src="/vst_admin/js/pandora-calendar.js"></script>

<script>

	var good = {};
	var globalIndex = 0,index=0,lastIndex=0;
	var specDate;
	$("#backToLastPageButton").click(function(){
		window.history.go(-1);
	});
	
	$("#tag").click(function(){
		var info="相应规则取被打包商品设置中和产品团期维护中严格的设置<br/><br/>"+
"产品团期维护设置提前定时间7天18小时10分钟。打包商品设置提前预定时间8天18小时20分钟，则取被打包商品设置8天18小时20分钟。"+
"产品团期维护中提前定时间2天18小时59分钟。打包商品设置提前预定时间1天18小时59分钟，则取产品团期维护设置2天18小时59分钟。"
		$.alert(info);
		
	});
	
	$("#refreshGroupDateButton").click(function(){
		var productId=$("#productId").val();
		var loading = top.pandora.loading("正在努力计算中...");
		$.ajax({
			url : "/vst_admin/prod/refund/refreshGroupDate.do",
			data : {productId:productId},
			dataType:'JSON',
			success : function(result){
				$.alert(result.message,function(){
					refresh();
				});
				loading.close();
			},
			error : function(){
				$.alert('服务器错误');
				loading.close();
			}
		});
	});
	
	$("#timePriceSaveButton").click(function(){
		if ($("#cancelStrategy").val() == 'GOODSRETREATANDCHANGE') {
			$(".Wdate").removeAttr("require");
			$(".Wdate").val("");
		} else {
			$(".Wdate").attr("require", "true");
			if ($("input[type=checkbox][name=weekDay]:checked").size() == 0) {
				alert("请选择适用日期！");
				return;
			}
		}
	    //验证日期
	    if(!$("#timePriceForm").validate().form()){
		    return;
	    }
	    //董宁波 2016年3月2日 14:56:33 可退改
	    if (!setProdRefundRule()) {
			return;
		}
		//设置提前预定时间
		setAheadBookTime();
		
	    //end
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
			url : "/vst_admin/prod/refund/editProductReFund.do",
			data : $("#timePriceForm").serialize(),
			dataType:'JSON',
			success : function(result){
				$.alert(result.message,function(){
					refresh();
				});
				loading.close();
			},
			error : function(){
				$.alert('服务器错误');
				loading.close();
			}
		});
	});
		//董宁波 2016年3月2日 14:53:48 start
	    //退改规则
		$("select[name=cancelStrategy]").live("change", function(){
			if ($(this).eq(0).val() == 'RETREATANDCHANGE') {
				$("#cal_range").show();
				$(".app_week").show();
				$('#addRuleRow').show();
				$('#refundOther').show();
				$('#cancelStrategyContent').show();
			} else if ($(this).eq(0).val() == 'GOODSRETREATANDCHANGE') {
				$('#addRuleRow').hide();
				$('#refundOther').hide();
				$('#cancelStrategyContent').hide();
				$("#cal_range").hide();
				$(".app_week").hide();
			} else {
				$("#cal_range").show();
				$(".app_week").show();
				$('#addRuleRow').hide();
				$('#refundOther').hide();
				$('#cancelStrategyContent').hide();
			}
		});
		function setProdRefundRule() {
			$("#refundHide").empty();
			if ($("#cancelStrategy").val() == 'GOODSRETREATANDCHANGE') {
				//是否同步单门票、酒店商品的退改规则？
				if (confirm("是否同步单门票、酒店商品的退改规则？")) {
					return true;
				} else {
					return false;
				}
			} else if ($("#cancelStrategy").val() == 'RETREATANDCHANGE'){
				if ($("#cancelStrategyContent").find("div").length == 0 && $("#dissatisfy")[0].checked == false) {
					alert("请创建退改规则！");
					return false;
				}
			} else {
				return true;
			}
			var i = 0, flag = true, productId=$("#productId").val();
            var timeStr = "";//时间拼接（用以判断是否有重复）
            var numStr = "";//退改金额拼接（用以判断金额是否重复）
			$("#cancelStrategyContent").find("div").each(function(){
				var index = $(this).attr('data');
				if(!index) {
					flag = false;
					return;
				}
				if(!productId) {
					alert("产品信息不存在！");
					flag = false;
					return  false;
				}
				var cancelTimeType = $("#cancelTimeType_"+index).val();
				if (!cancelTimeType) {
					alert("用户申请的退改类型不能为空！");
					$("#cancelTimeType_"+index).focus();
					flag = false;
					return false;
				}
				var deductType = $("#deductType_"+index).val();
				var deductValue = $("#deductValue_"+index).val();
				if (!deductValue) {
					alert("扣除费用不能为空！");
					flag = false;
					return false;
				}
				if (isNaN(deductValue)) {
					alert("扣除费用请输入数字！");
					flag = false;
					return false;
				}
				//固定金额的则扣款金额不能超过酒店套餐售价，最小为0。百分比从0%到100%
				if ((toDecimal(deductValue) < 0 || toDecimal(deductValue) > 100) && deductType == 'PERCENT') {
					alert("扣除费用百分比请在0-100之间！");
					flag = false;
					return false;
				}
				deductValue = accMul(deductValue,100);
				if (toDecimal(deductValue) < 0 && deductType != 'PERCENT') {
					alert("扣除费用不能大于销售价！");
					flag = false;
					return false;
				}
				var day = $("#latestCancelTime_Day_"+index).val();
				var hour = $("#latestCancelTime_Hour_"+index).val();
				var minute = $("#latestCancelTime_Minute_"+index).val();

                var time = day+"_"+hour+"_"+minute;
                if(timeStr.indexOf(time) > 0){
                    alert("提前时间重复");
                    flag = false;
                    return false;
                }
                timeStr = timeStr + "%" + time;

                var num = deductType+"_"+deductValue;
                if(numStr.indexOf(num) > 0){
                    alert("扣款值和扣款类型重复");
                    flag = false;
                    return false;
                }
                numStr = numStr + "%" + num;

				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].applyType' value='"+cancelTimeType+"'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].deductType' value='"+deductType+"'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].deductValue' value='"+deductValue+"'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].cancelTime' value='"+getTotalMinute(day, hour, minute)+"'/>");
				i++;
			});
			
			if( !flag ) {
				return flag;	
			}
			
			if ($("#dissatisfy")[0].checked == true) {
				var applyTypeOther = $("#applyType_other").val();
				if (!applyTypeOther) {
					alert("请选择具体的用户申请退改规则选项！");
					return false;
				}
				var deductTypeOther = $("#deductType_other").val();
				var deductValueOther = $("#deductValue_other").val();
				if (!deductValueOther) {
					alert("扣除费用不能为空！");
					return false;
				}
				if (isNaN(deductValueOther)) {
					alert("扣除费用请输入数字！");
					return false;
				}
				//固定金额的则扣款金额不能超过酒店套餐售价，最小为0。百分比从0%到100%
				if ((parseInt(deductValueOther) < 0 || parseInt(deductValueOther) > 100) && deductTypeOther == 'PERCENT') {
					alert("扣除费用百分比请在0-100之间！");
					return false;
				}
				deductValueOther = toDecimal(deductValueOther)*100;
				if ((toDecimal(deductValueOther) < 0) && deductTypeOther != 'PERCENT') {
					alert("扣除费用不能低于0元！");
					return false;
				}
                var num = deductTypeOther+"_"+deductValueOther;
                if(numStr.indexOf(num) > 0){
                    alert("扣款值和扣款类型重复");
                    flag = false;
                    return;
                }
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].cancelTimeType' value='OTHER'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].applyType' value='"+applyTypeOther+"'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].deductType' value='"+deductTypeOther+"'/>");
				$("#refundHide").append("<input type='hidden' name='prodRefundRules["+i+"].deductValue' value='"+ deductValueOther +"'/>");
				i++;
			}
			return flag;
		}
		
		/*
		*设置提前预定时间
		*/
		function setAheadBookTime() {
			if($("#aheadBookTime").size()<=0 || !$("#aheadBookTime")[0].checked) {
				return;
			}
			var day = $("#aheadBookTime_Day").val();
			var hour = $("#aheadBookTime_Hour").val();
			var minute = $("#aheadBookTime_Minute").val();
			$("#refundHide").append("<input type='hidden' name='aheadBookTime' value='"+getTotalMinute(day, hour, minute)+"'/>");
		}
		
		$("#addRuleRow").live('click', function(){
			if ($("#cancelStrategyContent").length == 0) {
				$("#changeType").after('<div id="cancelStrategyContent"></div>');
			}
			index++;
			lastIndex++;
			$("#cancelStrategyContent").append('<div style="margin-top:8px;margin-bottom:8px;" id="cancelStrategyDiv_'+index+'" data="'+index+'"></div>');
			$("#cancelStrategyDiv_"+index).append("<span id='index_"+index+"'>"+lastIndex+"</span>、提前");
			$("#cancelStrategyDiv_"+index).append(getDayHtml(index));
			$("#cancelStrategyDiv_"+index).append('，用户申请<select id="cancelTimeType_'+index+'" data="'+index+'" style="width:90px"><option value="">退改类型</option><option value="REFUND">退款</option><option value="CHANGE" disabled="disabled">改期</option></select>');
			$("#cancelStrategyDiv_"+index).append('，扣除套餐费用<select class="deductType" id="deductType_'+index+'" data="'+index+'" style="width:90px"><option value="PERCENT">百分比</option><option value="AMOUNT">固定金额</option></select>');
			$("#cancelStrategyDiv_"+index).append('&nbsp;<input id="deductValue_'+index+'" style="width:50px; line-height: 23px;" /><span id="unit_'+index+'">%</span>');
			$("#cancelStrategyDiv_"+index).append('&nbsp;&nbsp;&nbsp;&nbsp;');
			$("#cancelStrategyDiv_"+index).append('<a data="'+index+'" class="btn btn_cc1 delRule">删除</a>');
			
		});
//		$("#dissatisfy").live('click', function(){
//			if ($(this)[0].checked && $(this)[0].checked == true) {
//				$("#applyType_other").removeAttr("disabled");
//				$("#deductType_other").removeAttr("disabled");
//				$("#deductValue_other").removeAttr("readonly");
//			} else {
//				$("#applyType_other").attr("disabled", "disabled");
//				$("#deductType_other").attr("disabled", "disabled");
//				$("#deductValue_other").attr("readonly", "readonly");
//			}
//		});
		//删除
		$(".delRule").live('click', function(){
			if (!confirm("确认删除吗？")) return;
			var index = $(this).attr('data');
			if(!index) {
				return;
			}
			$("#cancelStrategyDiv_"+index).remove();
			//重新排序
			var i=0;
			$("#cancelStrategyContent").find("div").each(function(){
				i++;
				$(this).find("span").eq(0).html(i);
			});
			lastIndex--;
		});
		//单位
		$(".deductType").live('change', function(){
			var index = $(this).attr('data');
			if(!index) {
				return;
			}
			var deductType = $("#deductType_"+index).val();
			var unit = "%";
			if (deductType == "PERCENT") {
				unit = "%";
				$("#deductValue_"+index).validate();
			} else {
				unit = "元";
			}
			$("#unit_"+index).html(unit);
		});
	
	    //设置week选择,全选
		$("input[type=checkbox][name=weekDayAll]").click(function(){
			if($(this).attr("checked")=="checked"){
				$("input[type=checkbox][name=weekDay]").attr("checked","checked");
			}else {
				$("input[type=checkbox][name=weekDay]").removeAttr("checked");
			}
		});
		//保留两位小数   
	    //功能：将浮点数四舍五入，取小数点后2位  
	    function toDecimal(x) {  
	        var f = parseFloat(x);  
	        if (isNaN(f)) {  
	            return;  
	        }  
	        f = Math.round(accMul(x,100))/100;  
	        return f;  
	    }
		//end
		
		 //设置week选择,单个元素选择
		$("input[type=checkbox][name=weekDay]").click(function(){
			if($("input[type=checkbox][name=weekDay]").size()==$("input[type=checkbox][name=weekDay]:checked").size()){
				$("input[type=checkbox][name=weekDayAll]").attr("checked","checked");
			}else {
				$("input[type=checkbox][name=weekDayAll]").removeAttr("checked");
			}
		});
         
         	var template = {
                warp: '<div class="ui-calendar"></div>',
                calControl: '<span class="month-prev" {{stylePrev}} title="上一月">‹</span><span class="month-next" {{styleNext}} title="下一月">›</span>',
                calWarp: '<div class="calwarp clearfix">{{content}}</div>',
                calMonth: '<div class="calmonth">{{content}}</div>',
                calTitle: '<div class="caltitle"><span class="mtitle">{{month}}</span></div>',
                calBody: '<div class="calbox">' +
                            '<i class="monthbg">{{month}}</i>' +
                            '<table cellspacing="0" cellpadding="0" border="0" class="caltable">' +
                                '<thead>' +
                                    '<tr>' +
                                        '<th class="sun">日</th>' +
                                        '<th class="mon">一</th>' +
                                        '<th class="tue">二</th>' +
                                        '<th class="wed">三</th>' +
                                        '<th class="thu">四</th>' +
                                        '<th class="fri">五</th>' +
                                        '<th class="sat">六</th>' +
                                    '</tr>' +
                                '</thead>' +
                                '<tbody>' +
                                    '{{date}}' +
                                '</tbody>' +
                            '</table>' +
                        '</div>',
                weekWarp: '<tr>{{week}}</tr>',
                day: '<td {{week}} {{dateMap}} >' +
                        '<div {{className}}>' +
                            '<span class="calday">{{day}}</span>' +
                            '<span class="calinfo"></span>' +
                            '<div class="fill_data"></div>' +
                        '</div>' +
                     '</td>'
            };
         
           	// 填充日历数据
            function fillData() {
                var that = this,
                    url = "/vst_admin/prod/refund/findProductReFund.do";
				
				
                var month = that.options.date.getMonth();
                var year = that.options.date.getFullYear();
                var day = that.options.date.getDate();
                
                specDate = year+"-"+(month+1)+"-"+day;
                
                function setData(data) {
                
                    if (data === undefined) {
                        return;
                    }
                    data.forEach(function (arr) {
                        var $td = that.warp.find("td[date-map=" + arr.specDateStr + "]");
                        var liArray = [];
                        var cancelStrategy = "";
                        if(arr.cancelStrategy=='MANUALCHANGE'){
                        	cancelStrategy = '人工退改';
                        }else if(arr.cancelStrategy=='UNRETREATANDCHANGE'){
                        	cancelStrategy = '不退不改';
                        }else if(arr.cancelStrategy=='RETREATANDCHANGE'){
                        	cancelStrategy = '可退改';
                        	cancelStrategy += "<br/>"+getRefundRules(arr);
                        }else if(arr.cancelStrategy=='GOODSRETREATANDCHANGE'){
                        	cancelStrategy = '同步商品退改';
                        	cancelStrategy += "<br/>"+getGoodsRefundRules(arr);
                        }
						liArray.push('<li>'+cancelStrategy+'</li>');
						if(arr.aheadBookTimeStr) {
							liArray.push('<li>'+"<br/>提前预订时间：<br/>"+arr.aheadBookTimeStr+'</li>');
						}
						if(arr.lowestSaledPriceStr) {
							liArray.push('<li>'+"<br/>起价："+arr.lowestSaledPriceStr+'</li>');
						}
                        $td.find("div.fill_data").append("<ul>"+liArray.join('')+"</ul>");
                    });

                }
                
                //将分钟数转换为天/时/分
                function minutesToDate(time){
                	var time = parseInt(time);
					var day=0;
					var hour=0;
					var minute=0;
					if(time >  0){
						day = Math.ceil(time/1440);
						if(time%1440==0){
							hour = 0;
							minute = 0;
						}else {
							hour = parseInt((1440 - time%1440)/60);
							minute = parseInt((1440 - time%1440)%60);
						}
						
					}else if(time < 0 ){
						time = -time;
						hour = parseInt(time/60);
						minute = parseInt(time%60);
					}
					if(hour<10)
						hour = "0"+hour;
					if(minute<10)
						minute = "0"+minute;
					return day+"天"+hour+"点"+minute+"分";
                }           
                
                $.ajax({
                    url: url,
                    type: "POST",
                    dataType: "JSON",
                    data : {"productId" : $("#productId").val(),"specDate" : specDate},
                    success: function (json) {
                       setData(json);
                    },
                    error: function () { }
                });

            }
         
         function refresh(){
         	
                pandora.calendar({
                    sourceFn: fillData,
                    autoRender: true,
                    frequent: true,
                    showNext: true,
                    mos :0,
                    template: template,
                    target: $("#timePriceDiv")
                });
        }
         
        refresh();
		
        function getRefundRules(refund) {
        	var rules = "";
        	if (!refund) {
				return rules;
			}
        	var ruleList = refund.prodRefundRules;
        	if (!ruleList || ruleList.length == 0) {
        		return rules;
        	}
        	for ( var i = 0; i < ruleList.length; i++) {
				var rule = ruleList[i];
				var cancelTimeTypeStr = rule.applyType == "REFUND" ? "退款" : "改期";
				var deductTypeStr = rule.deductType == "PERCENT" ? "百分比" : "固定金额";
				var unit = rule.deductType == "PERCENT" ? "%" : "元";
				//不满足条件的默认规则
				if (rule.cancelTimeType == "OTHER") {
					rules += "<br/>不满足以上条件，扣除套餐费用"+deductTypeStr+rule.deductValueYuan+unit;
				} else {
					rules += "<br/>"+(i+1)+"、"+rule.lastTime+"，用户申请"+cancelTimeTypeStr+"，扣除套餐费用"+deductTypeStr+rule.deductValueYuan+unit;
				}
				
			}
        	return rules;
        }
        function getGoodsRefundRules(refund) {
        	var rules = "";
        	if (!refund) {
				return rules;
			}
        	var goodsRefundRules = refund.goodsRefundRules;
        	if (!goodsRefundRules || goodsRefundRules.length == 0) {
        		return rules;
        	}
        	for ( var i = 0; i < goodsRefundRules.length; i++) {
				if (!goodsRefundRules[i] || goodsRefundRules[i].length == 0) {
					continue;
				}
				rules += "<br/><br/>【"+goodsRefundRules[i].type+"】<br/>"+goodsRefundRules[i].content;
			}
        	return rules;
        }
       	//获得：2天23点59分
     	function getDayHtml(index) {
     		var temp = "";
     		temp += '<select class="w10 mr10" style="width:65px" id="latestCancelTime_Day_'+index+'">';
     		for (var i = 0; i < 181; i++) {
     			var selected = "";
     			if (i == 0) {
     				selected = "selected='selected'"
     			}
     			temp += '<option value="'+i+'" '+selected+'>'+i+'</option>';
     		}
     		temp += '</select>天';
     		temp += '<select class="w10 mr10" style="width:60px" id="latestCancelTime_Hour_'+index+'">';
     		for (var i = 0; i < 24; i++) {
     			var selected = "";
     			if (i == 0) {
     				selected = "selected='selected'"
     			}
     			temp += '<option value="'+i+'" '+selected+'>'+i+'</option>';
     		}
     		temp += '</select>点';
     		temp += '<select class="w10 mr10" style="width:60px" id="latestCancelTime_Minute_'+index+'">';
     		for (var i = 0; i < 60; i++) {
     			var selected = "";
     			if (i == 0) {
     				selected = "selected='selected'"
     			}
     			temp += '<option value="'+i+'" '+selected+'>'+i+'</option>';
     		}
     		temp += '</select>分';
     		return temp;
     	}
     	//天时分转化为分钟
    	function getTotalMinute(day,hour,minute){
    		if(day == -1){
    			day =0;
    		}
    		if(hour == -1){
    			hour =0;
    		}
    		if(minute == -1){
    			minute =0;
    		}
    		return (day*24*60-hour*60-parseInt(minute));	
    	}
    	//乘法函数，用来得到精确的乘法结果  
    	//说明：javascript的乘法结果会有误差，在两个浮点数相乘的时候会比较明显。这个函数返回较为精确的乘法结果。  
    	//调用：accMul(arg1,arg2)  
    	//返回值：arg1乘以arg2的精确结果  
    	function accMul(arg1,arg2) {  
	    	var m=0,s1=arg1.toString(),s2=arg2.toString();  
	    	try{m+=s1.split(".")[1].length;}catch(e){}  
	    	try{m+=s2.split(".")[1].length;}catch(e){}  
	    	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m);  
	    } 
</script>
