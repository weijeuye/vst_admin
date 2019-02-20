<!DOCTYPE html>
<html>
<head>
</head>
<body>
<div class="iframe_content mt10">
        <div class="p_box box_info">
<form action="/vst_admin/biz/seasoneffect/addOrUpdateSeason.do" method="post" id="dataForm" class="goodsForm">
		<input type="hidden" name="seasonId" id="seasonId" value="${seasonEffect.seasonId!''}"> 
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>季节名称：</td>
                	<td colspan=2>
                	    <input type="text" name="seasonName" id="seasonName" required=true value="${seasonEffect.seasonName!''}">
                	</td>
                </tr>
				<tr>
                	<td class="p_label"><i class="cc1">*</i>所属品类：</td>
                    <td colspan=2>
						<#if seasonEffect.seasonId??>
							<#if seasonEffect.subcategoryId??>
                        		<input type="checkbox" name="categoryIds" value="${seasonEffect.subcategoryId!''}" checked="checked" disabled="disabled"/>
                        		<#if seasonEffect.subcategoryId =="182" >自由行-机+酒</#if>
                        		<#if seasonEffect.subcategoryId =="183" >自由行-交通+服务</#if>
							<#else>
                        		<input type="checkbox" name="categoryIds" value="${seasonEffect.categoryId!''}" checked="checked"  disabled="disabled"/>
                        		<#if seasonEffect.categoryId =="15" >跟团游</#if>
                        		<#if seasonEffect.categoryId =="16" >当地游</#if>
							</#if>
						<#else>
							<input type="checkbox" name="categoryIds" value="15"/>跟团游&nbsp;
							<input type="checkbox" name="categoryIds" value="182"/>自由行-机+酒&nbsp;
							<input type="checkbox" name="categoryIds" value="16"/>当地游&nbsp;
							<input type="checkbox" name="categoryIds" value="183"/>自由行-交通+服务
						</#if>
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>节日时间：</td>
                    <td colspan=2>
                    	<input name="seasonBeginDate" id="seasonBeginDate" class="Wdate" id="d4321" onfocus="WdatePicker({readOnly:true})" type="text" readonly="" errorele="selectDate" value="${seasonBeginDateString!''}"> -
						<input name="seasonEndDate" id="seasonEndDate" class="Wdate" id="d4322" onfocus="WdatePicker({readOnly:true})" type="text" readonly="" errorele="selectDate" value="${seasonEndDateString!''}">
						<font color="#999999">产品团期表对应节日时间</font>
                    </td>
            </tr>
               	<tr>
					<td class="p_label"><i class="cc1">*</i>有效时间：</td>
					<td colspan=2>
						<input name="effectBeginDate" id="effectBeginDate" class="Wdate" id="d4321" onfocus="WdatePicker({readOnly:true})" type="text" readonly="" errorele="selectDate" value="${effectBeginDateString!''}"> -
						<input name="effectEndDate" id="effectEndDate" class="Wdate" id="d4322" onfocus="WdatePicker({readOnly:true})" type="text" readonly="" errorele="selectDate" value="${effectEndDateString!''}">
						<font color="#999999">产品展示季节标签时间	</font>
                   	</td>
                </tr>
                <tr>
					<td class="p_label">状态：</td>
					<td colspan=2>
						<select name="effectStatus" id="inputType" >
			                <option value="1"				
							${(seasonEffect.effectStatus=="1")?string("selected", "")}
							>有效</option>
			                <option value="0"				
							${(seasonEffect.effectStatus=="0")?string("selected", "")}
							>无效</option>
			            </select>
                   	</td>
                </tr>
                <tr>
					<td class="p_label">排序值：</td>
					<td colspan=2 class=" operate mt10">
						<input type="text" name="orderValue"  value="${seasonEffect.orderValue!''}" maxlength="4" onkeyup="this.value=this.value.replace(/[^\d]/g,'') " onafterpaste="this.value=this.value.replace(/[^\d]/g,'') ">
                   	</td>
                </tr>
                <tr>
					<td class="p_label"></td>
					<td colspan=2 class=" operate mt10">
						<div class="p_box box_info clearfix mb20">
						     <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc1" id="update">保存</a></div>
						     <div class="fl operate" style="margin-top:20px;"><a class="btn btn_cc2" id="update">取消</a></div>
						</div>
                   	</td>
                </tr>
            </tbody>
        </table>
</form>

 </div>
 </div>

</body>
</html>
<script>

var propId = $("#seasonId").val();
if(propId != ""){
	$("#seasonName").attr("disabled",true);
}

$("#update").bind("click",function(){
			if($("#seasonName").val()==""){
				pandora.alert("请输入季节名称！");
				return false;
			}	
			var categoryIds = $("input:checkbox[name='categoryIds']:checked").val();
			if(typeof(categoryIds) =="undefined"){
				pandora.alert("请选择所属品类！");
				return;
			}
			
			if($("#seasonBeginDate").val()==""){
				pandora.alert("请输入节日开始时间！");
				return false;
			}	
			if($("#seasonEndDate").val()==""){
				pandora.alert("请输入节日结束时间！");
				return false;
			}	
			if($("#seasonEndDate").val()<$("#seasonBeginDate").val()){
				pandora.alert("节日结束时间不能小于开始时间！");
				return false;
			}
			if($("#effectBeginDate").val()==""){
				pandora.alert("请输入有效开始时间！");
				return false;
			}	
			if($("#effectEndDate").val()==""){
				pandora.alert("请输入有效结束时间！");
				return false;
			}	
			if($("#effectEndDate").val()<$("#effectBeginDate").val()){
				pandora.alert("有效结束时间不能小于开始时间！");
				return false;
			}
			
			$.ajax({
					url : "/vst_admin/biz/seasoneffect/addOrUpdateSeason.do",
					type : "post",
					data : $(".dialog #dataForm").serialize(),
					success : function(result) {
						 if(result.code=="success"){
						    pandora.alert("操作成功！");
					        refreshDialog();
					     } else {
					     	pandora.alert(result.message);
					     }
						
					}
			});
			
		});
	
	$("a.btn_cc2").click(function(){
   		closeDialog(); 
	});
 
</script>


