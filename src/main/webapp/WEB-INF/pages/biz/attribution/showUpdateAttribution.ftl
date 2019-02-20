<form id="dataForm">
	<input type="hidden" name="attributionId" value="${attribution.attributionId!''}">
	<table class="p_table form-inline">
    <tbody>
	    <tr>
			<td class="p_label"><i class="cc1">*</i>区域级别：</td>
		    <td>
		    	<select name="attributionType" required=true>
		    	<#list attributionTypeList as attributionType>
		    		<option value="${attributionType.code!''}" <#if attribution.attributionType!=null && attribution.attributionType==attributionType.code>selected</#if>  >${attributionType.cnName!''}</option>
		    	</#list>		
		    	</select>
		    </td>
			<td class="p_label"><i class="cc1">*</i>名称：</td>
		    <td>
		    	<input type="text" name="attributionName"  value="${attribution.attributionName!''}" required=true maxlength="25" />
		    </td>
		</tr>
    </tbody>
	</table>
</form>

<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="editButton">保存</button>

<script>
var districtSelectDialog;


//修改地理位置
$("#editButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$.confirm("确认修改吗 ？", function () {
	$.ajax({
		url : "/vst_admin/biz/attribution/updateAttribution.do",
		type : "post",
		dataType:"json",
		async: false,
		data : $("#dataForm").serialize(),
			success : function(result) {
			   if(result.code=="success"){
					$.alert(result.message,function(){
				   		updateDialog.close();
				   		window.location.reload();
		   			});
				}else {
					$.alert(result.message);
			   	}
		   }
		});
	});						
});

</script>
