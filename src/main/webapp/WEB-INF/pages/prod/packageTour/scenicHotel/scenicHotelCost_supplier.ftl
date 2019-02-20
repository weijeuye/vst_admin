<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/ui-common.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/ui-components.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/iframe.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/dialog.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/easyui.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/button.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/base.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/normalize.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/calendar.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.jsonSuggest.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.ui.autocomplete.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/jquery.ui.theme.css" type="text/css">
<link rel="stylesheet" href="http://super.lvmama.com/vst_back/css/contentManage/kindEditorConf.css" type="text/css">
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/icons.css" type="text/css">
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/tips.css" type="text/css">

<style type="text/css">
body {
	padding-left:20px;
}
input{
width: 700px;
}

textarea {
resize: vertical;
width: 700px; height: 100px; margin-top: 0px; margin-bottom: 0px;
}
div.container {
	overflow:hidden;
	padding-left:20px;
}
.block_tittle {
	padding-top: 20px;
}
.block_tittle > p{
width:800px;
border-bottom: 1px solid #000000;
}
.block_tittle > p > span {
	font-weight:bold;
}

.multi_line {
padding-top:20px; overflow:hidden;
}
.multi_line_tips{
width:60px ; display:inline-block; margin-left: 10px;;
}

.multi_line_field{
display:inline-block;
}

.multi_line_extra {
margin: 5px 0px;
margin-left: 70px;
}
.multi_line_extra > span {
	width 20px; display:inline-block;
}

.single_line {
	margin-top:10px;
}
.single_line > div.multi_line_tips {
	width:60px;
}

.single_line > div {
	display:inline-block; 
	margin-left: 10px;
}
.single_line > input {
	width:700px;
}
.pkg_info {
	margin-left:635px;
	width:250px;
	margin-top:63px;
}
.pkg_info > div {
	padding: 10px 10px;
	border:1px solid  #cccccc; 
	vertical-align:top; 
	margin-top: 20px;
}
.pkg_info h3{
	display:inline-block;
}
.pkg_info dt{
	font-weight:bold;
}
.pkg_info .nova-tip-form {
	float : right;
}
.self_pay_item > div {
padding-top:5px;
display:inline-block; width:200px;
}

.supplement_area {
	margin-top:20px;
}
.supplement_area > div {
	display:inline-block; width: 70px;
}

</style>

</head>

<body>
<div class="iframe_header">
    <ul class="iframe_nav">
       <li><a href="#">自由行</a> &gt;</li>
        <li><a href="#">供应商打包</a> &gt;</li>
        <li><a href="#">产品维护</a> &gt;</li>
        <li class="active">行程</li>
    </ul>
</div>
<div class="iframe_content mt15" style="padding-bottom:0px;">
	<span style="font-weight:bold;font-size:15px;">行程展示：${lineRoute.routeName!''}</span>
</div>

<div class="container">
	<div >
		<div class="block_tittle">
			<p >
			<span>费用包含说明</span>
			</p>
		</div>
		<form id="submitForm" action="/vst_admin/scenicHotel/saveCost.do" method='POST'>
			<!--费用包含对应的prodLineRouteDescription field-->
			<input type="hidden" name="prodLineRouteDescription.categoryId" value="${prodLineRouteDescription.categoryId}"/>
			<input type="hidden" name="prodLineRouteDescription.productId" value="${prodLineRouteDescription.productId}"/>
			<input type="hidden" name="prodLineRouteDescription.lineRouteId" value="${prodLineRouteDescription.lineRouteId}"/>
			<input type="hidden" name="prodLineRouteDescription.productType" value="${prodLineRouteDescription.productType}"/>
	
		<!--hotel-->
		<div class="single_line">
			<div class="multi_line_tips">
				<input type="checkbox"  class="js_switch js_main_switch " switch_type="hotel"/>
				<input type="hidden" value ="scenicHotelCostIncludeVo.hotel.content"/>
				<span>住宿：</span>
			</div>
			<div class="multi_line_field" >
					<input type="hidden" name="ticket.productIds" />
					<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.hotel??>
					<textarea  class="js_combine" name="scenicHotelCostIncludeVo.hotel.content">${scenicHotelCostIncludeVo.hotel.content?if_exists}</textarea>
					<#else>
					<textarea  class="js_combine" name="scenicHotelCostIncludeVo.hotel.content"></textarea>
					</#if>
			</div>
		</div>
				<div  class="multi_line_extra" >
					<span >
					<input type="checkbox"  class="js_switch js_sub_switch js_hotel"/>
					<input type="hidden" value ="scenicHotelCostIncludeVo.hotel._default"/>
					</span>
					<span>
					<#if scenicHotelCostIncludeVo?? &&scenicHotelCostIncludeVo.hotel??>
					<input type="text"  class="js_combine" name="scenicHotelCostIncludeVo.hotel._default" placeholder="酒店房型、间夜数以实际下单为准"  value="${scenicHotelCostIncludeVo.hotel._default?if_exists}"/>
					<#else>
					<input type="text"  class="js_combine" name="scenicHotelCostIncludeVo.hotel._default" placeholder="酒店房型、间夜数以实际下单为准"  value=""/>
					</#if>
					</span>
				</div>

		<!--ticket-->
		<div  class="single_line">
			<div class="multi_line_tips">
				<input type="checkbox"  class="js_switch js_main_switch " switch_type="ticket"/>
				<input type="hidden" value ="scenicHotelCostIncludeVo.ticket.content"/>
				<span>门票：</span>
			</div>
			<div class="multi_line_field">
					<input type="hidden" name="ticket.productIds" />
					<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.ticket??>
					<textarea class="js_combine" name="scenicHotelCostIncludeVo.ticket.content">${scenicHotelCostIncludeVo.ticket.content?if_exists}</textarea>
					<#else>
					<textarea class="js_combine" name="scenicHotelCostIncludeVo.ticket.content"></textarea>
					</#if>
			</div>
		</div>
				<div class="multi_line_extra" >
					<span style="">
					<input type="checkbox" class="js_switch js_sub_switch js_ticket"/>
					<input type="hidden" value="scenicHotelCostIncludeVo.ticket._default"/>
					</span>
					<span>
					<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.ticket??>
					<input type="text"  class="js_combine" name="scenicHotelCostIncludeVo.ticket._default" placeholder="门票数量、具体游玩日期以实际下单为准"  value ="${scenicHotelCostIncludeVo.ticket._default?if_exists}"/>
					<#else>
					<input type="text"  class="js_combine" name="scenicHotelCostIncludeVo.ticket._default" placeholder="门票数量、具体游玩日期以实际下单为准" value =""/>
					</#if>
					</span>
				</div>
		<!--entertainment-->
		<div class="single_line">
			<div >
			<input type="checkbox" class="js_switch"/>
			<input type="hidden" value="scenicHotelCostIncludeVo.entertainment"/>
			<span>娱乐：</span>
			</div>
			<div>
			<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.entertainment??>
			<input type="text" name="scenicHotelCostIncludeVo.entertainment" value="${scenicHotelCostIncludeVo.entertainment?if_exists}"/>
			<#else>
			<input type="text" name="scenicHotelCostIncludeVo.entertainment" value=""/>
			</#if>
			</div>
		</div>

		<div class="single_line">
			<div >
			<input type="checkbox" class="js_switch"/>
			<input type="hidden" value="scenicHotelCostIncludeVo.meal"/>
			<span>用餐：</span>
			</div>
			<div>
			<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.meal??>
			<input type="text" name="scenicHotelCostIncludeVo.meal" value ="${scenicHotelCostIncludeVo.meal?if_exists}"/>
			<#else>
			<input type="text" name="scenicHotelCostIncludeVo.meal" value =""/>
			</#if>
			</div>
		</div>
		<div class="single_line" >
			<div>
			<input type="checkbox" class="js_switch"/>
			<input type="hidden" value="scenicHotelCostIncludeVo.transport"/>
			<span>交通：</span>
			</div>
			<div>
			<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.transport??>
			<input type="text" name="scenicHotelCostIncludeVo.transport" value ="${scenicHotelCostIncludeVo.transport?if_exists}"/>
			<#else>
			<input type="text" name="scenicHotelCostIncludeVo.transport" value =""/>
			</#if>
			</div>
		</div>
		<div class="single_line">
			<div >
			<input type="checkbox" class="js_switch"/>
			<input type="hidden" value="scenicHotelCostIncludeVo.buyPresent"/>
			<span>赠送：</span>
			</div>
			<div>
			<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.buyPresent??>
			<input type="text" name="scenicHotelCostIncludeVo.buyPresent" value= "${scenicHotelCostIncludeVo.buyPresent?if_exists}"/>
			<#else>
			<input type="text" name="scenicHotelCostIncludeVo.buyPresent" value= ""/>
			</#if>
			</div>
		</div>

		<div class="single_line">
			<div >
			<input type="checkbox" class="js_switch"/>
			<input type="hidden" value="scenicHotelCostIncludeVo.supplement"/>
			<span>补充：</span>
			</div>
			<div>
			<#-- <input type="text" name="scenicHotelCostIncludeVo.supplement" value ="${scenicHotelCostIncludeVo.supplement}"/> -->
			<#if scenicHotelCostIncludeVo?? && scenicHotelCostIncludeVo.supplement??>
			<textarea name="scenicHotelCostIncludeVo.supplement" >${scenicHotelCostIncludeVo.supplement?if_exists}</textarea>
			<#else>
			<textarea name="scenicHotelCostIncludeVo.supplement" ></textarea>
			</#if>
			</div>
		</div>
		
		<div>
			<div class="block_tittle" >
				<p>
				<span>费用不包含说明</span>
				</p>
			</div>
			
			<div class="self_pay_item">
				<#if scenicHotelCostExcludeVo??>
				<div>
				<#if scenicHotelCostExcludeVo.selfPayItem??&&scenicHotelCostExcludeVo.selfPayItem=='Y'>
					<input type="checkbox"  name="scenicHotelCostExcludeVo.selfPayItem" value='Y' 
					<#if scenicHotelCostExcludeVo.selfPayItem??&&scenicHotelCostExcludeVo.selfPayItem=='Y'> checked="checked"</#if>/> <span title="以上“费用包含”中未提及的其他个人消费">自理项目</span>
				<#else>
					<input type="checkbox"  name="scenicHotelCostExcludeVo.selfPayItem" value='N'/> <span title="以上“费用包含”中未提及的其他个人消费">自理项目</span>
				</#if>
				</div>
				<div >
				<#if scenicHotelCostExcludeVo.presentItem??&&scenicHotelCostExcludeVo.presentItem=='Y'>
					<input type="checkbox" name="scenicHotelCostExcludeVo.presentItem" value='${scenicHotelCostExcludeVo.presentItem}' 
					<#if scenicHotelCostExcludeVo.presentItem??&&scenicHotelCostExcludeVo.presentItem=='Y'> checked="checked"</#if>/> <span title="所有行程内标明赠送项目，如不参加，视为自动放弃，不做退费处理">赠送项目</span>
					<#else>
					<input type="checkbox" name="scenicHotelCostExcludeVo.presentItem" value='N'/> <span title="所有行程内标明赠送项目，如不参加，视为自动放弃，不做退费处理">赠送项目</span>
					</#if>
				</div>
				<div >
				<#if scenicHotelCostExcludeVo.securityItem??&&scenicHotelCostExcludeVo.securityItem=='Y'>
					<input type="checkbox" name="scenicHotelCostExcludeVo.securityItem" value='${scenicHotelCostExcludeVo.securityItem}'
					 <#if scenicHotelCostExcludeVo.securityItem??&&scenicHotelCostExcludeVo.securityItem=='Y'> checked="checked"</#if>/> <span title="本产品不含旅游人身意外险,我们强烈建议游客购买。游客可在填写订单时勾选附加产品中的相关保险购买">保险</span>
					 <#else>
					 <input type="checkbox" name="scenicHotelCostExcludeVo.securityItem" value='N'/> <span title="本产品不含旅游人身意外险,我们强烈建议游客购买。游客可在填写订单时勾选附加产品中的相关保险购买">保险</span>
					 </#if>
				</div>
				<#else>
				<div>
					<input type="checkbox"  name="scenicHotelCostExcludeVo.selfPayItem" value='Y' checked="checked"/> <span title="以上“费用包含”中未提及的其他个人消费">自理项目</span>
				</div>
				<div>
					<input type="checkbox"  name="scenicHotelCostExcludeVo.presentItem" value='Y' checked="checked"/> <span title="所有行程内标明赠送项目，如不参加，视为自动放弃，不做退费处理">赠送项目</span>
				</div>
				<div>
					<input type="checkbox"  name="scenicHotelCostExcludeVo.securityItem" value='Y' checked="checked"/> <span title="本产品不含旅游人身意外险,我们强烈建议游客购买。游客可在填写订单时勾选附加产品中的相关保险购买">保险</span>
				</div>
				</#if>
			</div>
			<div class="single_line" >
				<div >
				<input type="checkbox" class="js_switch"/>
				<input type="hidden" value="scenicHotelCostExcludeVo.supplement"/>
				<span >补充：</span>
				</div>
				<div>
				<#if scenicHotelCostExcludeVo?? && scenicHotelCostExcludeVo.supplement??>
				<textarea name="scenicHotelCostExcludeVo.supplement">${scenicHotelCostExcludeVo.supplement?if_exists}</textarea>
				<#else>
				<textarea name="scenicHotelCostExcludeVo.supplement"></textarea>
				</#if>
				</div>
			</div>
		</div>

		<div class="fl operate" style="width:800px; margin-top:20px; text-align:center;">
			<a href="javascript:void(0)" class="btn btn_cc1" id ="saveCommit">保存</a>
		</div>
		</form>

	</div>


<div style="margin-bottom:50px;">
</div>
<#include "/base/foot.ftl"/>
</body>
<script type="text/javascript"/>
$(function(){

	//只要联合元素下所有的元素都没值才不选中
	$(".js_main_switch").each(function(i, e){
		var $this = $(this);
		var switchType = $this.attr("switch_type");
		var extraSwitchSelector = $(".js_" + switchType);
		var mainValue = $this.closest("div.single_line").find("textarea").val();
		var extraValue = extraSwitchSelector.closest("div").find(":text").val();
		
		if(mainValue || extraValue ) {
			$this.attr("checked", "checked");
		} else {
			$(this).removeAttr("checked");
		}
		if(extraValue) {
			extraSwitchSelector.attr("checked", "checked");
			extraSwitchSelector.closest("div").find(":text").removeAttr("disabled");
		}else {
			extraSwitchSelector.removeAttr("checked");
			extraSwitchSelector.closest("div").find(":text").attr("disabled", true);
		}
		
		//只要有一个输入项， 那么文本框激活状态， 不然没法输入了
		if(mainValue || extraValue ) {
			 $this.closest("div.single_line").find("textarea").removeAttr("disabled");
		}else {
			 $this.closest("div.single_line").find("textarea").attr("disabled", true);
		}
		
	});
	
	$.each($(":text:not(.js_combine)"),function(){
		var text = $(this).val();
		if($.trim(text)!=""){
		   var name =$(this).parent().prev().find("input[type=checkbox]").next().val();
		   $(this).attr("name",name);
		   $(this).parent().prev().find("input[type=checkbox]").attr("checked", "true");
		   $(this).removeAttr("disabled");
		}else{
		  $(this).removeAttr("name");
			$(this).parent().prev().find("input[type=checkbox]").removeAttr("checked");
			$(this).attr("disabled", true);
		}
	});
	
	$.each($("textarea:not(.js_combine)"),function(){
		var text = $(this).val();
		if(text.length!=0){
		  var name =$(this).parent().prev().find("input[type=checkbox]").next().val();
		  $(this).attr("name",name);
		   $(this).parent().prev().find("input[type=checkbox]").attr("checked", "true");
		   $(this).removeAttr("disabled");
		}else{
			$(this).removeAttr("name");
			$(this).parent().prev().find("input[type=checkbox]").removeAttr("checked");
			$(this).attr("disabled", true);
		}
	});
	
	$('.js_switch').on("change", function(){
		var $input = $(this).parent().next().find(":text,textarea");
		//如果主开关无效， 那么子开关也无效
		var switchType = $(this).attr("switch_type");
		if(switchType && $(this).attr("checked") != "checked" ) {
			//已经选中， 触发一次点击进行取消选择，然后disable
			if( $(".js_" + switchType).attr("checked") == "checked" ) {
				$(".js_" + switchType).trigger("click");
			}
			$(".js_" + switchType).attr("disabled", true);
		} else {
			$(".js_" + switchType).removeAttr("disabled");
		}
		
		if ($(this).attr("checked") == "checked") { 
			   var name = $(this).next().val();
			   var placeholder = $input.attr("placeholder");
			   var currValue = $input.val();
			   $input.val(currValue?currValue :placeholder);
			   $input.attr("name",name);
			   $input.removeAttr("disabled");
		}else{
		    $input.removeAttr("name");
            $input.attr("disabled", true);
		}
	}); 
	
	
	refreshSensitiveWord($("textarea,input[type=\"text\"]"));
})



$(function(){
var $document = $(document);
    $(document).on('click','#saveCommit',function(){
    var message = "确认保存?";
    if (refreshSensitiveWord($("textarea,input[type=\"text\"]"))) {
                    message = "存在敏感词，继续保存？";
                    //此处不修改标识产品是否包含敏感词；
                }
                //获取checkbox中所有选中的值
                 $.each($('.self_pay_item input[type=checkbox]:checked'),function(){
                   $(this).val("Y");
            	 });
            	 //获取checkbox中所有未选中的值
            	  $.each($('.self_pay_item input[type=checkbox]:not(:checked)'),function(){
                    $(this).val("N");
            	 });
            	 
            	 //限制字数
            	 var array = 0;
            	 $.each($("textarea"),function(){
	            	var number1 =$(this).val();
	            	var yy = number1.length;
	            	array=parseInt(array)+parseInt(yy);
            	 });
            	  $.each($(":text"),function(){
	            	var number1 =$(this).val();
	            	var yy = number1.length;
	            	array=parseInt(array)+parseInt(yy);
            	 });
            	 
            	 //限制在2000字之内
            	 if(array<=2000){
                $.confirm(message, function () {
                        $.ajax({
                            url : "/vst_admin/scenicHotel/saveCost.do",
                            type : "post",
                            dataType : 'json',
                            data : $("#submitForm").serialize(),
                            success : function(result) {
                                pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
                                      $("#saveRouteFlag",window.parent.document).val('true');
                                      $("#route",parent.document).parent("li").trigger("click");
                                }});
                            },
                            error : function(result) {
                                $.alert(result.message);
                            }
                        });
                });
                }else{
                	pandora.dialog("总字数需限制在2000字以内!");
                }
			  });
});
</script>


</html>