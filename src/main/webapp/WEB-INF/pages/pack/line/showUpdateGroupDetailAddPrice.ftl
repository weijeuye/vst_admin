<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/v4/modules/calendar.css" />
<script src="/vst_admin/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/v6/modules/pandora-calendar.js" type="text/javascript"></script>
<style>
*{ margin:0; padding:0;}
.set_price_box{ padding:10px 0; }
.set_calendar{ width:500px; height:330px;}
.set_calendar .ui-calendar .calmonth{ width:550px;}
.set_calendar .ui-calendar .calbox{ min-height:inherit;}
.set_calendar_week,.set_calendar_day{ padding:6px 0;}
.set_calendar_week{ overflow:hidden;}
.set_calendar_week label{ float:left; margin-right:20px;}
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
.set_profit label{ margin-right:50px;}
.set_profit .input{ width:40px; height:20px; line-height:20px; padding:0px; text-align:center; margin-right:3px;}
.btn_c{ display:block; width:80px; height:26px; line-height:26px; text-align:center; font-size:14px; color:#333; border:#ccc solid 1px; cursor:pointer; margin:0 auto; background:#f3f3f3;}
</style>
</head>
<body>
<form method="post" action='/vst_admin/productPack/line/updateGroupDetailAddPrice.do' id="dataForm">
	<input type="hidden" id="groupType" name="groupType" value="${groupType}"/>
	<input type="hidden" id="price" name="price" value="${price}"/>
	<input type="hidden" id="detailId" name="detailId" value="${detailIds}"/>
	<input type="hidden" id="productId" name="productId"/>
	<#if isLineTicket?? && isLineTicket=='Y'>
		<div align="center">
			<font color="#FF0000" style="font-weight:bold">特殊价格仅对普通票有效，期票无效</font>	
		</div>
	</#if>
<div class="set_price_box">
	<div class="set_calendar" id="js_set_calendar"></div>
    <div class="set_calendar_day">
    	<input type="text" class="js_calendar" value="" id="startDate" name="startDate" readonly="readonly" autocomplete="off" data-check="checkIn">
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
    <div class="set_profit">
    <label>
	    <input type="radio" id="profit" name="priceType" value="MAKEUP_PRICE" checked="checked"/>基于商品利润设置，利润的：
	    <input type="text" class="input" id="makeUpPrice" name="makeUpPrice" number="true"  value="100"/>%
	</label>
    <label>
   		<input type="radio" id="fix" name="priceType" value="FIXED_PRICE"/>基于结算价恒定，加价：
    	<input type="text" class="input" id="fixPrice" name="fixPrice" number="true" />元
    </label>
    </div>
    <span class="btn_c"><a id="updatePackDetailAddPrice">保存设置</a></span>
</div>
</form>
</body>
</html>
<script>
$(function(){
	//产品ID
	$("#productId").val($("#productId",window.parent.document).val());
	
	///日历区间选择
	pandora.calendar({
		template: "small", //日历型号
		trigger: ".js_calendar", //对话框触发点/触发事件对象
		triggerEvent: "click", //触发事件
		mos: 12,//可向后翻的月数
		isTodayClick: true, // 当天是否可点击
		isRange: true,//是否联动
		cascade: {
            days: 0, // 日历区间间隔天数
            trigger: ".js_calendar"
        }
	});
	
	//大日历展示
	pandora.calendar({
		target: "#js_set_calendar",//渲染容器
		autoRender: true,//是否自动渲染
		frequent: true, // 单月显示
		mos: 12,
		isTodayClick: true, // 当天是否可点击
		classNames: {
            week: ["sun", "mon", "tue", "wed", "thu", "fri", "sat"],
            caldate: "caldate day_box",
            nodate: "nodate day_box", // 禁用和空
            today: "", // 今天
            hover: "hover", // 鼠标滑过效果
            festival: "calfest", // 节日
            monthPrev: "month-prev",
            monthNext: "month-next"
        },
		sourceFn: function(cal){
			var tdElement = cal.warp.find("td");
			var detailId = $('#detailId').val();
			$.post("/vst_admin/productPack/line/getLinePackDetailAddPrice.do",{detailId:detailId},function(data){
		  		if(data.success){
		  			$(data.attributes.addPriceList).each(function(i,e){
		  				$(tdElement).each(function(t,v){
		  					var specDate=e.specDateStr;
		  					var date = $(v).attr("date-map");
		  					if(typeof(date) != 'undefined'){
				  				if(date==specDate){
				  					//利润
				  					if(e.priceType == 'MAKEUP_PRICE'){
				  						$(v).find("div span[class='calprice']").html("+"+(e.price/100)+"%");
				  					}
				  					//加价
				  					if(e.priceType == 'FIXED_PRICE') {
				  						$(v).find("div span[class='calprice']").html("+"+(e.price/100));
				  					}
				  				}
		  					}
			  			});
		  			});
		  		}
		  	},"JSON");
		}, // 写入数据
		completeCallback:function(){
			
		},//数据加载完成并显示出日历后的回调函数
		template: {
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
                        '<span class="calinfo" title="删除">×</span>' +
                        '<span class="calprice"></span>' +
                    '</div>' +
                 '</td>'
        }
	});
	
	//删除单个
	$('.caltable td .calinfo').live('click',function(){
		if(!confirm("确认删除吗 ？")) {
			return;
		}
		var price = $(this).next();
		if(price.text() == null || price.text() == ''){
			alert("请选择删除项");
			return;
		}
		var date = $(this).parent().parent().attr('date-map');
		var detailId = $("#detailId").val();
		var productId = $("#productId").val();
		var groupType = $("#groupType").val();
		$.ajax({
			url : "/vst_admin/productPack/line/deletePackGroupDetailAddPrice.do",
			type : "post",
			dataType : 'json',
			data : {specDate:date, detailId:detailId, productId:productId, groupType: groupType},
			success : function(result) {
				if(result.code == "success"){
					alert("删除成功");
					$(price).empty();
				} else {
					alert("删除失败");
				}
			},
			error : function(result) {
				alert(result.message);
			}
		});
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
	
	//批量设置分段加价
	$("#updatePackDetailAddPrice").bind("click",function(){
		var profit = $("#profit").attr("checked");
		if(profit){
			var makeUpPrice = $("#makeUpPrice").val();
			if(makeUpPrice == null || makeUpPrice == ''){
				alert("必须设置商品利润率");
				return;
			} else{
				var integerReg = /^(0|-?[1-9]\d*)$/;
				if(!integerReg.test(parseFloat(makeUpPrice))){
					alert("设置商品利润率非法(整数)");
					return;
				}
			}
		}
		
		var profit = $("#fix").attr("checked");
		if(profit){
			var fixPrice = $("#fixPrice").val();
			if(fixPrice == null || fixPrice == '' ){
				alert("必须设置恒定加价");
				return;
			}
		}
		
		$("input[name=priceType]").each(function(index, obj){
			if($(this).attr("checked") == "checked"){
				var id = $(this).attr("id");
				if(id=='profit'){
					$("#price").val($("#makeUpPrice").val());
				}
				if(id=='fix'){
					$("#price").val($("#fixPrice").val());
				}
			}
		});
		
		if($("#price").val() == null || $("#price").val() == ''){
			alert("请设置价格规则");
			return;
		}
		
		$("#price").val(Math.round(parseFloat($("#price").val())*100)); 
		
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
		if(!validWeekHasDate(startDate, endDate, weeks)){
			alert("适应日期中不存在可用日期");
			return;
		}
				 
		var loading = top.pandora.loading("正在努力保存中...");
		
		$.ajax({
			url : "/vst_admin/productPack/line/updateGroupDetailAddPrice.do",
			type : "post",
			dataType : 'json',
			data : $("#dataForm").serialize(),
			success : function(result) {
				loading.close();
				if(result.code == "success"){
					parent.onUpdatePackGroupDetailAddPrice();
				}
			},
			error : function(result) {
				loading.close();
				alert(result.message);
			}
		});
	});
	
	//日期约束
	function validWeekHasDate(a,b,weeks){
		var dateA = new Date(a.split("-"));
		var dateB = new Date(b.split("-"));
		var days =  parseInt(Math.abs(dateB.getTime() - dateA.getTime()) / 1000 / 60 / 60 /24);		
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
});
</script>
