<form  id="dataForm">
    <input type="hidden" value="${bizKeyword.keywordId!''}" name="keywordId" />
    <table class="p_table form-inline">
    <tbody>
        <tr>
        	<td class="p_label">关键词：<span class="notnull">*</span></td>
            <td><input autocomplete="off" type="text" name="keywordName" maxlength="10" required=true value="${bizKeyword.keywordName!''}" /></td>
		</tr>
        <tr>
			<td class="p_label">关联行政区：<span class="notnull">*</span></td>
			<td>
            	<input type="text" id="districtName" name="districtName" readonly="readonly" required=true value="${bizKeyword.districtName!''}" />
                <input type="hidden" name="districtId" id="districtId" value="${bizKeyword.districtId!''}"/>
			</td>
		</tr>
        <tr>
        	<td class="p_label">状态：<span class="notnull">*</span></td>
            <td><input autocomplete="off" type="hidden" name="cancelFlag"  required=true value="${bizKeyword.cancelFlag!'Y'}" />
            	<#if bizKeyword.cancelFlag=='' || bizKeyword.cancelFlag == 'Y'>
					<span style="color:green" class="cancelProp">有效</span>
				<#else>
					<span style="color:red" class="cancelProp">无效</span>
				</#if> 
            </td>
		</tr>
    </tbody>
    </table>
</form>

<script>
var districtSelectDialog;
//选择行政区
function onSelectDistrict(params){
	if(params!=null){
		$("#districtName").val(params.districtName);
		$("#districtId").val(params.districtId);
	}
	districtSelectDialog.close();
}

//打开选择行政区窗口
$("#districtName").click(function(){
	districtSelectDialog = new xDialog("/vst_admin/biz/district/selectDistrictList.do?type=main&districtTypeForKeyword=keyword",{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
});
</script>
