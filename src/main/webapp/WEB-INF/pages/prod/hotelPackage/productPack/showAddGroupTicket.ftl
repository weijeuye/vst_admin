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
            
            <div class="box_content">
	            	<table class="e_table form-inline">
		             		<tbody>
		             		<tr >
		                	<td class="e_label" style="text-align: left;"><i class="cc1">*</i>产品品类</td>
		                    <td style="text-align: left;">
		                    	<select name="selectCategoryId" id="selectCategoryId" required=true>
		                    		<option value="">请选择</option>
		                    		<#if bizCategoryList??>
								  	<#list bizCategoryList as category>
					                 <option value="${category.categoryId}">${category.cnName}</option>
								  	</#list>
								  	</#if>
							  	</select>
		                    </td>
		                    <tr>
		             			<td class="e_label" style="text-align: left;"><i class="cc1">*</i>行程名称：</td>
		             			<td style="text-align: left;">
		             			<select name="lineRouteId" required=true>
		             			<option value="">请选择</option>
		             			<#if prodLineRouteList??>
		             			<#list prodLineRouteList as prodLineRoute >
		             			<option title="${prodLineRoute.routeNum}天${prodLineRoute.stayNum}晚" routeNum = "${prodLineRoute.routeNum}" value="${prodLineRoute.lineRouteId}" >${prodLineRoute.routeName}</option>
		             			</#list>
		             			</#if>
		             			</select>
		             			</td>
		             			</tr>
		                     </tr>
		             			 <tr >
		             			 	<input type="hidden"  name="stayDays" id="stayDays"  />
			             			<td class="e_label" style="text-align: left;"><i class="cc1">*</i>出游时间选择：</td>
			             			<td style="text-align: left;" id="startDayTD">
				                    </td>	
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


	var routeNum = $("select[name='lineRouteId']").find("option:selected").attr("routeNum");
	if(routeNum != null && routeNum != ''&&routeNum!=undefined){
		var str = "第"; 
		for(var index = 0 ; index < parseInt(routeNum); index ++){
			
			str += ("&nbsp;&nbsp;<input type='checkbox' class='w35' style='width:30px' required='true' name='startDayTD' value='" + (index + 1)+ "' />"+(index + 1));
		}
		str += "&nbsp;&nbsp;天<div class='e_error' id='startDayTDError'/>";
		$("#startDayTD").html(str.toString());
	}


});

$("#save").bind("click",function(){
	
	var startDays = '';
	$('input[name="startDayTD"]:checked').each(function(index,obj){
		if($(obj).val() != ''){
			startDays += $(obj).val() + ',';
		}
	});
	if(startDays != null && startDays.length > 0){
		$("#stayDays").val(startDays.substring(0,startDays.length - 1));
	}
	
	
	 //验证
	if(!$("#dataForm").validate({
		rules : {},
		messages : {}
	}).form()){
		return;
	}
	 
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