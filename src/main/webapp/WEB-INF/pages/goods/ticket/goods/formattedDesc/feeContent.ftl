<div class="pb5">
<input type="text" maxlength="200" name="feeContents.feeContents[${fee_index}].detail" class="w260" <#if fee?? && fee != "">value="${fee.detail}"</#if>/>+<#t>
<input type="text" maxlength="5" style="width:20px; " name="feeContents.feeContents[${fee_index}].quantity" value ="<#if fee?? && fee != "">${fee.quantity}<#else>1</#if>" required/>+<#t>
<input type="text" maxlength="5" style="width:30px; " name="feeContents.feeContents[${fee_index}].quantifier" value="<#if fee?? && fee != "">${fee.quantifier}<#else>张</#if>" required/> <#t>
( <input type="text" maxlength="400" class="w260" name="feeContents.feeContents[${fee_index}].remark" placeholder="无，可不填" <#if fee?? && fee != "">value="${fee.remark}"</#if>/> )<#t>
<a class="fee_add addBtn btn" style="cursor: pointer" data="${fee_index}">增加</a><#t>
<a class="fee_delete deleteBtn btn" style="cursor: pointer" data="${fee_index}">删除</a><#t>
</div>