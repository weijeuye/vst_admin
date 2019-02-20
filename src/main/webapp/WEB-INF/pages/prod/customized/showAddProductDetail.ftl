<#if r?exists>
<#else>
	<#assign r = customizedProdDetail />
	<#assign r_index = 0/>
</#if> 
<tr>
	<td > 
		 <table style="margin-top: 5px;" class="e_table form-inline">
		<tr>
        	<td class="e_label"><span class="notnull">*</span>
        		详情描述 <span name="seq">${r_index+1}</span> ：标题：
        		<input type="hidden" class="seq" name="customizedProdDetailList[${r_index}].seq" value="${(r.seq??)?number(r.seq,r_index+1)}">
        	</td>
            <td>
            	<label><input type="text" class="w35 title customizedProdDetailName" style="width:700px" name="customizedProdDetailList[${r_index}].customizedProdDetailName"  value="${r.customizedProdDetailName}" required=true maxlength="250">&nbsp;</label>
            </td>
        </tr>
		<tr>
        	<td class="e_label"><span class="notnull">*</span>描   述：</td>
            <td>
            	<label> 
            		<textarea maxlength="2000" class="description"  required=true  name="customizedProdDetailList[${r_index}].description" rows="10" style="width:700px" >${r.description}</textarea>
            	</label> 
            	<div id="productNameError"></div>
            </td>
        </tr>
       	<tr style="border-bottom: dashed 1px #D9D9D9 ; ">
       		<td class="e_label"> </td>
			<td  style="float:right;">
				 <input type="button" onclick="delTr2($(this))" data1="${r.routeId}" data="${r.detailId}" name='delBtn'  value="删除">
				 <input type="button" onclick="addTr2('editTable', -4)" value="插入一天">
           	</td>
        </tr> 
        </table>
	</td>
</tr>