<form  id="dataForm">
    <input type="hidden" value="${bizBrand.brandId!''}" name="brandId" />
    <table class="p_table form-inline">
    <tbody>
        <tr>
        	<td class="p_label">品牌状态：<span class="notnull">*</span></td>
            <td>
            	<select name="cancelFlag">
		            <option value="Y" <#if bizBrand.cancelFlag == 'Y'>selected="selected"</#if> >有效</option>
		            <option value="N" <#if bizBrand.cancelFlag == 'N'>selected="selected"</#if> >无效</option>
            	</select>
            </td>
		</tr>
        <tr>
        	<td class="p_label">品牌名称：<span class="notnull">*</span></td>
            <td><textarea name="brandName" maxlength="50" required=true >${bizBrand.brandName!''}</textarea></td>
		</tr>
        <tr>
        	<td class="p_label">全称：</td>
            <td><input type="text" name="brandFullName" maxlength="50" value="${bizBrand.brandFullName!''}" /></td>
		</tr>
        <tr>
        	<td class="p_label">简称：</td>
            <td><input type="text" name="brandShortName" maxlength="50" value="${bizBrand.brandShortName!''}" /></td>
		</tr>
        <tr>
        	<td class="p_label">首字母：</td>
            <td><input type="text" name="brandInitial" maxlength="50" value="${bizBrand.brandInitial!''}" /></td>
		</tr>
        <tr>
        	<td class="p_label">所属集团：</td>
            <td><input type="text" name="groupName" maxlength="50" value="${bizBrand.groupName!''}" /></td>
		</tr>
        <tr>
        	<td class="p_label">排序级别：</td>
            <td><input type="text" name="brandSeq" maxlength="2" number=true value="${bizBrand.brandSeq!''}" /></td>
		</tr>
    </tbody>
    </table>
</form>

<script>

</script>
