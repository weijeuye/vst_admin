<form id="dataForm">
		<input type="hidden" value="${prodContractDetail.detailId!''}" name="detailId"  id="detailId"/>
		<input type="hidden" value="${prodContractDetail.productId!''}" name="productId"  id="productId"/>
		<input type="hidden" value="${prodContractDetail.detailType!''}" name="detailType"  id="detailType"/>
		<input type="hidden" value="${prodContractDetail.lineRouteId!''}" name="lineRouteId"  id="lineRouteId"/>
		<p>注：请在行程明细内修改当前<#if prodContractDetail.detailType == 'RECOMMEND'>推荐项目<#else>购物点</#if>内容，系统将同步更新</p>    
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>行程天数：</td>
                    <td>
                    <input type="text" name="nDays" value="${prodContractDetail.nDays!''}" maxlength="50" required=true disabled="disabled">
                    </td>
                </tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>地      点：</td>
                    <td>
                    	<input type="text" name="address" value="${prodContractDetail.address!''}" maxlength="50" required=true disabled="disabled">
                    </td>
                </tr>
                <tr>
		            <td class="p_label"><i class="cc1">*</i><#if prodContractDetail.detailType == 'RECOMMEND'>项目名称和内容：<#else>购物场所名称：</#if></td>
		            <td colspan="3">
		            	<textarea  name="detailName"  rows="3"  maxlength="1500"  style="width:300px" required=true  disabled="disabled">${prodContractDetail.detailName!''}</textarea>
		            </td>
		        </tr>
		        <tr>
                    <td class="p_label"><i class="cc1">*</i><#if prodContractDetail.detailType == 'RECOMMEND'>费    用：<#else>主要商品信息: </#if></td>
                    <td colspan="3">
                    	<input type="text"  name="detailValue" value="${prodContractDetail.detailValue!''}"  maxlength="500"  required=true disabled="disabled">
                    </td>
                </tr>
                <tr>
                    <td class="p_label"><i class="cc1">*</i><#if prodContractDetail.detailType == 'RECOMMEND'>项目时长(分钟)：<#else>最长停留时间(分钟): </#if></td>
                    <td colspan="3">
                    	<input type="text"  name="stay" value="${prodContractDetail.stay!''}" maxlength="10" number="true" required=true disabled="disabled">
                    </td>
                </tr>
                  <tr>
		            <td class="p_label">其他说明：</td>
		            <td colspan="3">
		            	<textarea  name="other"  rows="3"  maxlength="250" style="width:300px" disabled="disabled"><#if prodContractDetail.detailType == 'RECOMMEND'><#if prodContractDetail.other?length gt 0>${prodContractDetail.other!''}<#else>在行程游览过程中，导游可能会向您推荐如下自费项目，您可以根据您的自身情况，自愿选择参加自己喜欢的自费项目。</#if><#else><#if prodContractDetail.other?length gt 0>${prodContractDetail.other!''}<#else>  </#if></#if></textarea>
		            </td>
		        </tr>
            </tbody>
        </table>
</form>
		<!--<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton">保存</button>-->
<script>
//保存
$("#saveButton").bind("click",function(){
		showAddContractDetailDialog.close();
		return ;
});
refreshSensitiveWord($("input[type='text'],textarea"));
</script>
