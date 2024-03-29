<form id="dataForm">
        <table class="p_table form-inline">
            <tbody>
            		<input type="hidden" name="seoType" value="${bizSeoFriendLink.seoType}">
            		<input type="hidden" name="bizSeoFriendLinkId" value="${bizSeoFriendLink.bizSeoFriendLinkId}">
                <tr>
                	<td class="p_label"><i class="cc1">*</i>编号ID：
                	</td>
                    <td><input type="text" name="objectId" value="${bizSeoFriendLink.objectId}" number=true required=true>
                    	<div id="objectIdError"></div>
                    </td>
                </tr> 
				<tr>
                	 <td class="p_label"><i class="cc1">*</i>友链锚文：</td>
                    <td>
                   	    <input type="text" name="linkName" value="${bizSeoFriendLink.linkName}" required=true>
                    	<div id="linkNameError"></div>
                    </td>
                </tr>
                <tr>
					<td class="p_label"><i class="cc1">*</i>友情地址：</td>
                    <td>
                    	<input type="text" name="linkUrl" value="${bizSeoFriendLink.linkUrl}" required=true>
                    	<div id="linkUrlError"></div>
                    </td>
                </tr>
                <tr>
                    <td class="p_label">备注：</td>
                    <td>
                    	<input type="text" name="remark" value="${bizSeoFriendLink.remark}">
                    </td>
                </tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="updateButton">保存</button>

<script>
 
//添加行政区
$("#updateButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$.ajax({
		url : "/vst_admin/biz/seoLink/doAddUpdateSeoLink.do",
		type : "post",
		dataType:"json",
		async: false,
		data : $("#dataForm").serialize(),
		success : function(result) {
		   if(result.code=="success"){
		   		pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",ok:function(){
			 		updateDialog.close();
				    var url = "/vst_admin/biz/seoLink/findSeoLinkList.do";
				    $("#searchForm").attr("action",url);
		  			$("#searchForm").submit();
				}});
			}else {
				$.alert(result.message);
	   		}
		   }
	});				
});
		
</script>
