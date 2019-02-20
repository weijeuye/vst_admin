<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/v4/modules/calendar.css" />
<script src="/vst_admin/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/v6/modules/pandora-calendar.js" type="text/javascript"></script>
<style>
*{ margin:0; padding:0;}
.set_price_box{ padding:10px 0; }
.set_calendar{ width:500px; height:330px; margin-top:10px;}
.set_calendar .ui-calendar .calmonth{ width:550px;}
.set_calendar .ui-calendar .calbox{ min-height:inherit;}
.set_calendar_week,.set_calendar_day{ padding:6px 0;margin-top:30px;}
.set_calendar_week{ overflow:hidden;}
.set_calendar_week label{ float:left; margin-right:20px;font-size:14px;}
.set_calendar .calmonth .caltable{ height:290px;}
.set_calendar .calmonth .today{ background:none; box-shadow:none;}
.set_calendar .today .calday{ color:#666;}
.set_calendar .today:hover{ background:#FEF2F9; opacity:0.7; filter:alpha(opacity=50);}
.set_calendar .calmonth .monthbg{ line-height:320px; color:#f1f1f1;}
.set_calendar .caldate{ cursor:default;}
.set_calendar .calprice{ color:#f60; font-size:16px; text-align:center; display:block; width:90%;}
.set_calendar .calinfo{ display:none; position:absolute; right:0; top:0; width:20px; height:20px; cursor:pointer; text-align:center; line-height:20px; color:#666;}
.set_calendar .calinfo:hover{ background:#ddd; color:#333;}
.set_calendar .caldate:hover .calinfo{ display:block;}
.set_profit{ margin-top:5px;}
.set_profit label{ margin-right:50px;style="font-size:14px;"}
.set_profit .input{ width:40px; height:20px; line-height:20px; padding:0px; text-align:center; margin-right:3px;}
.btn_c{ display:block; width:80px; height:26px; line-height:26px; text-align:center; font-size:14px; color:#333; border:#ccc solid 1px; cursor:pointer; margin:0 auto; background:#f3f3f3;}
.goods_lb span{max-width:360px;display:inline-block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
</style>
</head>
<body>
<form method="post" action='/vst_admin/productPack/line/deleteHotelGroupDetailAddPrice.do' id="dataForm">
	<input type="hidden" id="groupType" name="groupType" value="${groupType}"/>
	<input type="hidden" id="price" name="price" value="${price}"/>
	<input type="hidden" id="detailId" name="detailId" value="${detailIds}"/>
	<input type="hidden" id="productId" name="productId"/>
<div class="set_price_box">
    <div class="goodsDiv">
        <#if prodPackageDetailGoodsDataList?? && prodPackageDetailGoodsDataList?size gt 0>        
           <#assign index = 0>
           <table class="goods_lb">
           <#list prodPackageDetailGoodsDataList as prodPackageDetailGoodsData>
               <#if index%2 == 0><tr style="font-size:14px;"></#if>
               <td>
               <input type="checkbox" class="goods" name="goods_${prodPackageDetailGoodsData.suppGoodsId!''}" <#if index%2 == 0>style="margin-top:10px;"</#if> value="${prodPackageDetailGoodsData.suppGoodsId!''}" />
               <span>
               ${prodPackageDetailGoodsData.goodsName!''}[${prodPackageDetailGoodsData.suppGoodsId!''}]
               <#if prodPackageDetailGoodsData.payTarget?? && prodPackageDetailGoodsData.payTarget=="PREPAID">
               -[预付]
               <#elseif prodPackageDetailGoodsData.payTarget?? && prodPackageDetailGoodsData.payTarget=="PAY">
               -[现付]
               </#if>
               </span>
               </td>
               <#if index%2 == 1></tr></#if>
               <#assign index=(index+1)%2>
           </#list>
           </table>
        <#else>
           <i>暂无被打包商品</i>
        </#if>
    </div>
    <div class="set_calendar_day">
        <span style="font-size:14px;">时间范围</span>
    	<input type="text" class="js_calendar" value="" id="startDate" name="startDate" readonly="readonly" autocomplete="off" data-check="checkIn">
    	<span>—</span>
        <input type="text" class="js_calendar" data-range="true" id="endDate" name="endDate" value="" readonly="readonly" autocomplete="off" data-check="checkOut">
    </div>
    <div class="set_calendar_week">
    	<label><input type="checkbox" name="weekDayAll"/>全部</label>
        <label><input type="checkbox" name="weekDay" value="2">周一</label>
		<label><input type="checkbox" name="weekDay" value="3">周二</label>
		<label><input type="checkbox" name="weekDay" value="4">周三</label>
		<label><input type="checkbox" name="weekDay" value="5">周四</label>
		<label><input type="checkbox" name="weekDay" value="6">周五</label>
		<label><input type="checkbox" name="weekDay" value="7">周六</label>
		<label><input type="checkbox" name="weekDay" value="1">周日</label>
    </div>
    <span class="btn_c" style="margin-top:30px;"><a id="deleteteHotelPackDetailAddPrice">保存设置</a></span>
</div>
</form>
</body>
</html>
<script>
var calendar_t;
$(function(){
	//产品ID
	$("#productId").val($("#productId",window.parent.document).val());
	
	///日历区间选择
	pandora.calendar({
		template: "small", //日历型号
		trigger: ".js_calendar", //对话框触发点/触发事件对象
		triggerEvent: "click", //触发事件
		mos: 6,//可向后翻的月数
		isTodayClick: true, // 当天是否可点击
		isRange: true,//是否联动
		cascade: {
            days: 0, // 日历区间间隔天数
            trigger: ".js_calendar"
        },
        selectDateCallback:function(){
            if($("#startDate").val() != ""&& $("#endDate").val() != ""){
                $("input[type=checkbox][name=weekDayAll]").attr("checked","checked");
                $("input[type=checkbox][name=weekDay]").attr("checked","checked");
            }
        }
	});
	
	//设置week选择,全选
	$("input[type=checkbox][name=weekDayAll]").click(function(){
		if($(this).attr("checked")=="checked"){
			$("input[type=checkbox][name=weekDay]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=weekDay]").removeAttr("checked");
		}
	})
	
	//设置week选择,单个元素选择
	$("input[type=checkbox][name=weekDay]").click(function(){
		if($("input[type=checkbox][name=weekDay]").size()==$("input[type=checkbox][name=weekDay]:checked").size()){
			$("input[type=checkbox][name=weekDayAll]").attr("checked","checked");
		}else {
			$("input[type=checkbox][name=weekDayAll]").removeAttr("checked");
		}
	});
	
	//批量删除特殊加价
	$("#deleteteHotelPackDetailAddPrice").bind("click",function(){
	    var suppGoodsIds = "";
		$("input[class='goods']:checked").each(function(){
		   suppGoodsIds += $(this).val()+',';
		});
		if(suppGoodsIds == null || suppGoodsIds == ''){
		   alert("请选择选择具体商品");
		   return;
		} 
		
		if($('#startDate').val().length<=0){
			alert("请选择开始时间");
			return;
		}
		if($('#endDate').val().length<=0){
			alert("请选择结束时间");
			return;
		}
		if($("input[type=checkbox][name=weekDay]:checked").size()==0){
			alert("请选择适用日期");
			return;
		}
		var weeks = []; 
		$("input[type=checkbox][name=weekDay]:checked").each(function(){
			weeks.push($(this).val());
		});
		var startDate = $("#startDate").val();
		var endDate = $("#endDate").val();
		if(!validStartDate(startDate, endDate)){
		   alert("开始时间应该小于等于结束时间");
		   return;
		}
		if(!validWeekHasDate(startDate, endDate, weeks)){
			alert("适应日期中不存在可用日期");
			return;
		}
				 
		var loading = top.pandora.loading("正在删除中...");
		
		$.ajax({
			url : "/vst_admin/productPack/line/deleteHotelGroupDetailAddPrice.do",
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize()+"&suppGoodsIds="+suppGoodsIds,
			success : function(data) {
				loading.close();
				if(data.code == "success"){
					alert(data.message);		
			  }
			},
			error : function(data) {
				loading.close();
				alert(data.message);
			}
		});
	});
	
	//日期约束
	function validWeekHasDate(a,b,weeks){
		var dateA = new Date(a.split("-"));
		var dateB = new Date(b.split("-"));
		var days =  parseInt(Math.abs(dateB.getTime() - dateA.getTime()) / 1000 / 60 / 60 /24) ;		
		if(days<6){
			var hasDate = false;
			if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
					hasDate = true;
					return true;
			}
			if(!hasDate){
				for(var i = 1;i<=days;i++){
					var week = dateA.getDate()+1;
					dateA.setDate(week);
					if(weeks.indexOf((dateA.getDay()+1).toString()) !=-1){
						hasDate = true;
						return true;
					}
				}
			}
			if(hasDate){
				return true;
			}
		}else{
			return true;
		}
		return false;
	}
	
	function validStartDate(start,end){
	    var startDate = new Date(start.split("-"));
	    var endDate = new Date(end.split("-"));
	    var time = endDate.getTime() - startDate.getTime();
	    if(time < 0){
	       return false;
	    }
	    return true;
	}
	
});
</script>
