<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
<script type="text/javascript" src="/vst_admin/js/ckeditor/ckeditor.js"></script>
</head>
<body>
<div class="iframe_content mt10">
       <div class="p_box box_info p_line">
       <form action="/vst_admin/productPack/line/addGroup.do" method="post" id="dataForm">
       		<input type="hidden"  name="productId" id="productId"  value="${productId }"/>
       		<input type="hidden"  name="suppGoodsId" id="suppGoodsId"  value="${suppGoodsId}"/>
       		<input type="hidden"  name="categoryId" id="categoryId"  value="${bizCategory.categoryId !''}"/>
       		<input type="hidden"  name="selectCategoryId" id="selectCategoryId"  value="${bizCategory.categoryId !''}"/>
            <div class="box_content">
	            	<table class="e_table form-inline">
		             		<tbody>
		             			<tr>
		             			<td class="e_label" style="text-align: left;"><i class="cc1">*</i>行程名称：</td>
		             			<td style="text-align: left;">
		             			<select name="lineRouteId" required=true>
		             			<option value="">请选择</option>
		             			<#if prodLineRouteList??>
		             			<#list prodLineRouteList as prodLineRoute >
		             			<option title="${prodLineRoute.routeNum}天${prodLineRoute.stayNum}晚" stayNum = "${prodLineRoute.stayNum}" value="${prodLineRoute.lineRouteId}" >${prodLineRoute.routeName}</option>
		             			</#list>
		             			</#if>
		             			</select>
		             			</td>
		             			</tr>
		             			 <tr >
			             			<td class="e_label" style="text-align: left;"><i class="cc1">*</i>入住时间选择：</td>
			             			<td style="text-align: left;">
			             				<input type="hidden"  name="stayDays"  id="stayDays"/>
				                    		第<input type="text" class="w35" style="width:30px" name="startDay" id="startDay" number="true" required=true />
				                    		晚 —— 第
				                    		<input type="text" class="w35" style="width:30px" name="endDay" id="endDay" number="true" required=true />
				                    		晚
				                    	<div id="stayDaysError"></div>
				                    </td>	
			                   </tr>
			                    <tr>
			             			<td colspan="2" class="e_label" style="text-align: left;">备注信息，(注，用途，业务后台备忘录该组的一些特征使用，eg三亚的酒店)</td>
			             		</tr>
			             		<tr>
			             			<td colspan="2" style="text-align: left;">
				                    	<label>
				                    		<textarea class="w35 textWidth"  name="reMark" id="remark" maxlength="100" style="width:500px; height:80px"></textarea>
				                    	</label>
				                    </td>	
			                   </tr>
		             		</tbody>
		             	</table>
            </div>
            </form>
        </div>
        
        <div class="p_box box_info clearfix mb20">
            <div class="fl operate"><a class="btn btn_cc1" id="save">确认并保存</a></div>
        </div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>

<script>
$(function(){
	$(".textWidth[maxlength]").each(function(){
		var	maxlen = $(this).attr("maxlength");
		if(maxlen != null && maxlen != ''){
			var l = maxlen*12;
			if(l >= 700) {
				l = 700;
			} else if (l <= 200){
				l = 200;
			} else {
				l = 400;
			}
			$(this).width(l);
		}
		$(this).keyup(function() {
			vst_util.countLenth($(this));
		});
	});
});

$("select[name='lineRouteId']").change(function(){



})

$("#save").bind("click",function(){
	
	 //验证
	if(!$("#dataForm").validate({
		rules : {},
		messages : {}
	}).form()){
		return;
	}
	
	//填充入住时间
	var startDay = $("#startDay").val();
	var endDay = $("#endDay").val();
	if(startDay != null && endDay != null){
		var start = parseInt(startDay);
		var end = parseInt(endDay);
		if(start < 1 || end < 1 ){
			$.alert("输入入住晚数非法");
			return;
		}
		
		if(start > end){
			$.alert("入住截止时间不能大于入住时间");
			return;
		}
		
		var stayNum = $("select[name='lineRouteId']").find("option:selected").attr("stayNum");
		if(end > parseInt(stayNum)){
			$.alert("输入入住晚数不能大于产品入住晚数");
			return;
		}
	}
	
	var stayDays = "";
	if(startDay != null && endDay != null){
		for(var index = parseInt(startDay);index <= parseInt(endDay); index++){
			stayDays += index + ",";
		}
	}
	$("#stayDays").val(stayDays.substring(0,stayDays.length - 1));
	
	//设置附加属性的值
	$.confirm("确认保存吗 ？",function(){
		var loading = top.pandora.loading("正在努力保存中...");
		$.ajax({
		url : "/vst_admin/hotelCommbPackage/productPack/addGroup.do",
		type : "post",
		dataType : 'json',
		data : $("#dataForm").serialize(),
		success : function(result) {
			loading.close();
			if(result.code == "success"){
				$.alert(result.message);
				parent.onSavePackGroup();
			}else if(result.code == "error"){
				$.alert(result.message);
			}
		},
		error : function(result) {
			loading.close();
			$.alert(result.message);
		}
	}); 
});
	
	
	});

</script>