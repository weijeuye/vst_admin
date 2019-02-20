<#if r?exists>
<#else>
	<#assign r = customizedProdLineInfo />
	<#assign r_index = 0/>
</#if> 
<tr>
	<td > 
		 <table style="margin-top: 5px;" class="e_table form-inline">
		<tr>
        	<td class="e_label"><span class="notnull">*</span>
        		第 <span name="nDay">${r_index+1}</span> 天 ：行程标题：
        		<input type="hidden" class="nDay" name="customizedProdLineInfoList[${r_index}].nDay" value="${(r.nDay??)?string(r.nDay,r_index+1)}">
        	</td>
            <td>
            	<label><input type="text" class="w35 title prodLineInfoName" style="width:700px" name="customizedProdLineInfoList[${r_index}].prodLineInfoName"  value="${r.prodLineInfoName}" required=true maxlength="250">&nbsp;</label>
            </td>
        </tr>
		<tr>
        	<td class="e_label"><span class="notnull">*</span>行程描述：</td>
            <td>
            	<label> 
            		<textarea maxlength="2000" class="description"  required=true  name="customizedProdLineInfoList[${r_index}].description" rows="10" style="width:700px" >${r.description}</textarea>
            	</label> 
            	<div id="productNameError"></div>
            </td>
        </tr>
    	<tr>
		<td class="e_label">用   餐：</td>
		<td>
			 <input type="checkbox" ${(r.breakfastFlag =='Y')?string('checked=\"checked\"','')} class="breakfastFlag" value="Y" name="customizedProdLineInfoList[${r_index}].breakfastFlag"/>
			  早餐
			  <input type="checkbox" ${(r.lunchFlag =='Y')?string('checked=\"checked\"','')}  class="lunchFlag"  value="Y" name="customizedProdLineInfoList[${r_index}].lunchFlag"/>
			  中餐
			  <input type="checkbox" ${(r.dinnerFlag =='Y')?string('checked=\"checked\"','')}  class="dinnerFlag"  value="Y" name="customizedProdLineInfoList[${r_index}].dinnerFlag"/>
			  晚餐
           	</td>
        </tr>
        <tr>
        	<td>
        	</td>
        	<td>
           		<input type="text"  class="dinnerDesc"  value="${r.dinnerDesc}" maxlength="250" name="customizedProdLineInfoList[${r_index}].dinnerDesc">
           	</td>
        </tr>
        <tr>
		<td class="e_label">交   通：去程：</td>
		<td>
		<#list trafficList as t>
				 <input class="trafficType" ${(r.trafficType??&&r.trafficType?index_of(t.code)!=-1)?string('checked=\"checked\"','')}  type="checkbox" name="customizedProdLineInfoList[${r_index}].trafficType"  value='${t.code}'/>${t.cnName}&nbsp;
		</#list>
           	</td>
        </tr>
        <tr>
        	<td>
        	</td>
        	<td>
           		<input  type="text"  class="trafficDesc"  value="${r.trafficDesc}" maxlength="250" name="customizedProdLineInfoList[${r_index}].trafficDesc">
           	</td>
        </tr>
       	<tr>
			<td class="e_label">住   宿：</td>
			<td> 
					<input type="radio" <#if r.stayFlag == 'Y'>checked</#if> value="Y" class="stayFlag" name="customizedProdLineInfoList[${r_index}].stayFlag"/>含住宿
					<input type="radio" <#if r.stayFlag == 'N'>checked</#if> value="N" class="stayFlag" name="customizedProdLineInfoList[${r_index}].stayFlag"/>不含住宿				
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
           		<input  type="text"  class="stayDesc"  value="${r.stayDesc}" maxlength="250" name="customizedProdLineInfoList[${r_index}].stayDesc">
           	</td>
        </tr>
       	<tr style="border-bottom: dashed 1px #D9D9D9 ; ">
       		<td class="e_label"> </td>
			<td  style="float:right;">
				 <input type="button" onclick="delTr2($(this))" data1="${r.routeId}" data="${r.detailId}" name='delBtn'  value="删除">
				 <input type="button" onclick="addTr2('editTable', -10)" value="插入一天">
           	</td>
        </tr> 
        </table>
	</td>
</tr>