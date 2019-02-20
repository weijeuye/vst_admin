<form id="dataForm">
	<input type="hidden" name="districtId" value="${district.districtId!''}">
	<input type="hidden" name="cancelFlag" value="${district.cancelFlag!''}">
	<input type="hidden" name="foreighFlag" id="foreighFlag" value="${district.foreighFlag!''}">
	<table class="p_table form-inline">
    <tbody>
        <tr>
        	<td class="p_label"><i class="cc1">*</i>区域名称：</td>
            <td><input type="text" name="districtName" value="${district.districtName!''}" required=true>
            <div id="districtNameError"></div>
            </td>
			<td class="p_label">上级区域：</td>
            <td>
            	<input type="text" id="parentName" readonly="raedonly" 
            	value="<#if district.parentDistrict??>${district.parentDistrict.districtName}</#if> ">
            	<input type="hidden" name="parentId" id="parentId" value="${district.parentId!''}">
            </td>
        </tr> 
		<tr>
        	<td class="p_label"><i class="cc1">*</i>区域级别：</td>
            <td>
            	<select name="districtType" value="${district.districtType!''}" required=true>
                	<#list districtTypeList as distType>
                		<#if district.districtType == distType.code>
                		<option value="${distType.code!''}" selected="selected">${distType.cnName!''}</option>
                		<#else>
                		<option value="${distType.code!''}">${distType.cnName!''}</option>
                		</#if>
                	</#list>
            	</select>
            </td>
			<td class="p_label"><i class="cc1">*</i>拼音：</td>
            <td>
            	<input type="text" name="pinyin" value="${district.pinyin!''}" required=true>
            </td>
        </tr>
        <tr>
            <td class="p_label"><i class="cc1">*</i>简拼：</td>
            <td>
            	<input type="text" name="shortPinyin" value="${district.shortPinyin!''}" required=true>
            </td>
             <td class="p_label">URL拼音：</td>
            <td>
            	${district.urlPinyin!''}
            	<input type="hidden" name="urlPinyin" value="${district.urlPinyin!''}" required=true>
            </td>
        </tr>
        <tr>
            <td class="p_label">英文名：</td>
            <td>
            	<input type="text" name="enName" value="${district.enName!''}">
            </td>
            <td class="p_label" name="foreighFlagId_label" id="foreighFlagId_label" >是否境外：</td>
            <td id="foreighFlagId_td">
        		<#if district.foreighFlag == 'Y'>是<#else>否</#if>
            </td>
        </tr>
        <tr>
        	 <td class="p_label">当地语言名：</td>
            <td colspan="3" >
            <textarea rows=2 style="width: 350px" maxlength=200 name="localLang" >${district.localLang!''}</textarea> 多个以逗号分隔
            </td>
        </tr>
         <tr>
            <td class="p_label">别名：</td>
            <td colspan="3">
            	<textarea name="districtAlias"  rows="3" maxlength="200" style="width:500px">${district.districtAlias!''}</textarea>
            	多个以“，”分开
            </td>
        </tr>
    </tbody>
	</table>
</form>

<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="editButton">保存</button>

<script>
var districtSelectDialog;

//选择行政区
function onSelectDistrict(params){
	if(params!=null){
		$("#parentName").val(params.districtName);
		$("#parentId").val(params.districtId);
	}
	districtSelectDialog.close();
}

//打开选择行政区窗口
$("#parentName").click(function(){
	var url = "/vst_admin/biz/district/selectDistrictList.do";
	districtSelectDialog = new xDialog(url,{},{title:"选择行政区",iframe:true,width:"1000",height:"600"});
});

//修改地理位置
$("#editButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$.confirm("确认修改吗 ？", function () {
	$.ajax({
		url : "/vst_admin/biz/district/updateDistrict.do",
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
