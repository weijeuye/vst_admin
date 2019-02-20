<form id="dataForm">
        <table class="p_table form-inline">
            <tbody>
				<tr>
                	<td class="p_label"><i class="cc1">*</i>区域级别：</td>
                    <td>
                    	<select name="attributionType" required=true>
                    	<#list attributionTypeList as attributionType>
                    		<option value="${attributionType.code!''}">${attributionType.cnName!''}</option>
                    	</#list>		
                    	</select>
                    </td>
					<td class="p_label"><i class="cc1">*</i>名称：</td>
                    <td>
                    	<input type="text" name="attributionName" maxlength="25" required=true />
                    </td>
                </tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="editButton">保存</button>

<script>
var districtSelectDialog;


//添加行政区
$("#editButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$("#editButton").hide();
	var msg = '确认保存吗 ？';	
	$.confirm(msg,function(){
		$.ajax({
			url : "/vst_admin/biz/attribution/addAttribution.do",
			type : "post",
			dataType:"json",
			async: false,
			data : $("#dataForm").serialize(),
			success : function(result) {
				if(result.code=="success"){
					$.alert(result.message,function(){
		   				addDialog.close();
		   				window.location.reload();
		   			});
				}else {
					$.alert(result.message);
		   		}
		   },
		   error : function(){
			   $("#editButton").show(); 
		   }
		});		
	},function(){
		$("#editButton").show(); 
	});
});
		
	
</script>
