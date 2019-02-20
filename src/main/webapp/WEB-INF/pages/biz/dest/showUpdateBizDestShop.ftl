<form id="dataForm">
		<input type="hidden" name="destId" value="${bizDest.destId!''}">
        <table class="p_table form-inline">
            <tbody>
                <tr>
                	<td class="p_label" colspan="4" style="text-align:left;"><i class="cc1">*</i>目的地ID：${bizDest.destId!''}</td>
                </tr>
            	<tr>
                    <td class="p_label"><i class="cc1">*</i>主营产品：</td>
                    <td colspan="3" >
                    <textarea rows=2  style="width: 350px" maxlength=100 name="mainProducts" required=true><#if bizDest.bizDestShop??>${bizDest.bizDestShop.mainProducts!''}</#if></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="p_label">兼营产品：</td>
                    <td colspan="3" >
                    <textarea rows=2  style="width: 350px" maxlength=100 name="subjoinProducts"><#if bizDest.bizDestShop??>${bizDest.bizDestShop.subjoinProducts!''}</#if></textarea>
                    </td>
                </tr>
                <tr>
                	<td class="p_label"><i class="cc1">*</i>目的地名称：
                	</td>
                    <td>${bizDest.destName!''}</td>
                    <td class="p_label"><i class="cc1">*</i>拼音：</td>
                    <td>${bizDest.pinyin!''}</td>
				</tr>
				<tr>
                    <td class="p_label"><i class="cc1">*</i>简拼：</td>
                    <td>${bizDest.shortPinyin!''}</td>
                    <td class="p_label">英文名：</td>
                    <td>${bizDest.enName!''}</td>
                 </tr> 
				 <tr>
                	<td class="p_label"><i class="cc1">*</i>目的地类型：</td>
                    <td>
                    	<#list destTypeList as destType>
                    		<#if bizDest.destType == destType.code>${destType.cnName!''}</#if>
                    	</#list>
                    </td>
                    <td class="p_label"><i class="cc1">*</i>所属行政关系：</td>
                    <td>${bizDest.districtName!''}</td>
                 </tr>
                 <tr>
                    <td class="p_label">别名：</td>
                    <td colspan="3" >
                    <textarea rows=2  style="width: 350px" maxlength=200 readonly="readonly">${bizDest.destAlias!''}</textarea> 多个以逗号分隔
                    </td>
                </tr>
                <tr>
                <td class="p_label">当地语言名：</td>
                    <td colspan="3" >
                    <textarea rows=2 style="width: 350px" maxlength=200 readonly="readonly">${bizDest.localLang!''}</textarea> 多个以逗号分隔
                    </td>
                </tr>
                 <tr>
                    <td class="p_label">父级目的地(主)：</td>
                    <td><#if bizDest.parentDest??>${bizDest.parentDest.destName!''}</#if></td>
                    <td class="p_label">是否境外：</td>
                    <td>
                		<#if bizDest.foreighFlag == 'Y'>是<#else>否</#if>
                    </td>
                </tr>
                 <tr>
                    <td class="p_label">父级目的地(次)：</td>
                    <td colspan="3" >
	                    <div class="parentDestList" style="overflow-x:hide; overflow-y:scroll;height: 80px;" >
	                    <#list bizDest.parentDestList as parentDest>
	                     <span>${parentDest.destName}</span><br>
	                    </#list>
	                    </div>
                    </td>
                </tr>
		        <tr>
		    		<td class="p_label"><i class="cc1">*</i>目的地标识：</td>
				    <td>
		        	<#list destMarkList as destMark>
		        		  <#if bizDest.destMark == destMark.code>${destMark.cnName!''}</#if>
		        	</#list>
		        	</select>
		            </td>
		    	</tr>
            </tbody>
        </table>
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="editButton">保存</button>

<script>

//修改
$("#editButton").bind("click",function(){
	//验证
	if(!$("#dataForm").validate().form()){
		return;
	}
	$.confirm("确认修改吗 ？", function (){
	$.ajax({
	url : "/vst_admin/biz/bizDestShop/saveOrUpdateBizDestShop.do",
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
